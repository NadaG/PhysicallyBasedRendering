#include "RayTracer.cuh"
#include "Octree.cuh"
#include <cuda.h>
#include <cuda_runtime.h>
#include <glm\glm.hpp>
#include <glm\gtx\component_wise.hpp>
#include <stdio.h>
#include <glm\gtc\matrix_transform.hpp>
#include <math_constants.h>
#include <math.h>
#include <thrust\device_vector.h>
#include <queue>
#include <curand.h>
#include <curand_kernel.h>

struct Ray
{
	// Ray의 원점
	vec3 origin;
	// Ray의 방향
	vec3 dir;
	// 0: primary, 1: reflect, 2: refract
	int rayType;

	float decay;
};

const int WINDOW_HEIGHT = 1024;
const int WINDOW_WIDTH = 1024;

const int RAY_X_NUM = 256;
const int RAY_Y_NUM = 256;

const int QUEUE_SIZE = 8;

using std::cout;
using std::endl;


__device__ vec3 CastRay(vec3 P, vec3 N) 
{
	curandState localState;
	curand_init(0, 0, 0, &localState);
	for (int n = 0; n < 100; ++n) 
	{
		float theta = (curand_uniform(&localState) - 0.5f)*glm::pi<float>();
		float phi = (curand_uniform(&localState) - 0.5f)*glm::pi<float>();

	}
}

__device__ vec3 Interpolation(Triangle triangle, vec3 position, vec3& N, vec2& uv)
{
	vec3 v0 = triangle.v1 - triangle.v0;
	vec3 v1 = triangle.v2 - triangle.v0;
	vec3 v2 = position - triangle.v0;

	float d00 = dot(v0, v0);
	float d01 = dot(v0, v1);
	float d11 = dot(v1, v1);
	float d20 = dot(v2, v0);
	float d21 = dot(v2, v1);
	float denom = d00*d11 - d01*d01;

	float v = (d11*d20 - d01*d21) / denom;
	float w = (d00*d21 - d01*d20) / denom;
	float u = 1.0f - v - w;

	N = u * triangle.v0normal + v * triangle.v1normal + w * triangle.v2normal;
	uv = u * triangle.v0uv + v * triangle.v1uv + w * triangle.v2uv;
}

// ray와 sphere가 intersect하는지 검사하는 함수
__device__ bool RaySphereIntersect(Ray ray, Sphere sphere, float& dist)
{
	glm::vec3 s = ray.origin - sphere.origin;
	float minDist = 0.001f;

	float a = dot(ray.dir, ray.dir);
	float bPrime = dot(s, ray.dir);
	float c = dot(s, s) - sphere.radius * sphere.radius;

	float D = bPrime * bPrime - a * c;
	if (D >= 0 && bPrime <= 0)
	{
		float t1 = (-bPrime + sqrt(D)) / a;
		float t2 = (-bPrime - sqrt(D)) / a;
		dist = t1 > t2 ? t2 : t1;
		return dist > minDist;
	}
	else
		return false;
}

// ray와 triangle이 intersect하는지 검사하는 함수
__device__ bool RayTriangleIntersect(Ray ray, Triangle triangle, float& dist)
{
	glm::vec3 v0v1 = triangle.v1 - triangle.v0;
	glm::vec3 v0v2 = triangle.v2 - triangle.v0;
	glm::vec3 pvec = glm::cross(ray.dir, v0v2);

	float det = dot(v0v1, pvec);

	// back face culling
	if (det < 0.01f)
		return false;

	if (fabsf(det) < 0.01f)
		return false;

	float invDet = 1 / det;

	glm::vec3 tvec = ray.origin - triangle.v0;
	float u = glm::dot(tvec, pvec) * invDet;
	if (u < 0 || u > 1)
		return false;

	glm::vec3 qvec = cross(tvec, v0v1);
	float v = dot(ray.dir, qvec) * invDet;
	if (v < 0 || u + v > 1)
		return false;

	dist = dot(v0v2, qvec) * invDet;

	return true;
}

//bool RayPlaneIntersect(Ray ray, vec4 plane, float& t)
//{
//	t = -dot(plane, vec4(ray.origin, 1.0)) / glm::dot(glm::vec3(plane), ray.dir);
//	return t > 0.0;
//}
//
//bool RayRectIntersect(Ray ray, Rect rect, float& t)
//{
//	bool intersect = RayPlaneIntersect(ray, rect.plane, t);
//	if (intersect)
//	{
//		vec3 pos = ray.origin + ray.dir*t;
//		vec3 lpos = pos - rect.center;
//
//		float x = dot(lpos, rect.dirx);
//		float y = dot(lpos, rect.diry);
//
//		if (abs(x) > rect.halfx || abs(y) > rect.halfy)
//			intersect = false;
//	}
//
//	return intersect;
//}

__device__ bool RayAABBIntersect(Ray ray, AABB box)
{
	float tmin, tmax, tymin, tymax, tzmin, tzmax;

	glm::vec3 invdir = 1.0f / ray.dir;
	int sign[3];
	sign[0] = invdir.x < 0;
	sign[1] = invdir.y < 0;
	sign[2] = invdir.z < 0;

	tmin = (box.bounds[sign[0]].x - ray.origin.x) * invdir.x;
	tmax = (box.bounds[1 - sign[0]].x - ray.origin.x) * invdir.x;
	tymin = (box.bounds[sign[1]].y - ray.origin.y) * invdir.y;
	tymax = (box.bounds[1 - sign[1]].y - ray.origin.y) * invdir.y;

	if ((tmin > tymax) || (tymin > tmax))
		return false;

	if (tymin > tmin)
		tmin = tymin;
	if (tymax < tmax)
		tmax = tymax;

	tzmin = (box.bounds[sign[2]].z - ray.origin.z) * invdir.z;
	tzmax = (box.bounds[1 - sign[2]].z - ray.origin.z) * invdir.z;

	if ((tmin > tzmax) || (tzmin > tmax))
		return false;

	return true;
}

__device__ bool RayAABBsIntersect(Ray ray, AABB* boxes, int boxNum)
{
	bool isIntersect = false;

	for (int it = 0; it < boxNum; it++)
	{
		if (RayAABBIntersect(ray, boxes[it]))
			isIntersect = true;
	}
	return isIntersect;
}

// ray의 원점과 가장 가까운 곳에서 intersect하는 triangle의 id를 가져오는 함수
__device__ int FindNearestTriangleIdx(Ray ray, Triangle* triangles, int triangleNum, float& dist)
{
	const float rayThreshold = 0.0001f;
	float minDist = 9999999.0f;
	int minIdx = -1;
	float tmpDist;

	for (int i = 0; i < triangleNum; ++i)
	{
		if (RayTriangleIntersect(ray, triangles[i], tmpDist))
		{
			if (tmpDist > rayThreshold && tmpDist < minDist)
			{
				minDist = tmpDist;
				minIdx = i;
			}
		}
	}

	dist = minDist;
	return minIdx;
}

// ray의 원점과 가장 가까운 곳에서 intersect하는 sphere의 id를 가져오는 함수
__device__ int FindNearestSphereIdx(Ray ray, Sphere* spheres, int sphereNum, float& dist)
{
	const float rayThreshold = 0.0001f;
	float minDist = 9999999.0f;
	int minIdx = -1;
	float tmpDist;

	for (int i = 0; i < sphereNum; ++i)
	{
		if (RaySphereIntersect(ray, spheres[i], tmpDist))
		{
			if (tmpDist > rayThreshold && tmpDist < minDist)
			{
				minDist = tmpDist;
				minIdx = i;
			}
		}
	}

	dist = minDist;
	return minIdx;
}

// window의 픽셀의 위치가 각각 x, y로 입력됨
__device__ Ray GenerateCameraRay(int y, int x, glm::mat4 cameraModelMatrix)
{
	Ray ray;

	// 각 픽셀의 중앙을 가르키는 값 생성, 0~1의 값으로 Normalizing
	float NDCy = (y + 0.5f) / WINDOW_HEIGHT;
	float NDCx = (x + 0.5f) / WINDOW_WIDTH;

	// window 종횡비
	float aspectRatio = WINDOW_WIDTH / WINDOW_HEIGHT;

	// 시야각 설정
	float fov = 45.0f;

	// unProject
	float xx = (NDCx * 2.0f - 1.0f) * tan(fov * 0.5f * 3.141592653f / 180.0f) * aspectRatio;
	float yy = (NDCy * 2.0f - 1.0f) * tan(fov * 0.5f * 3.141592653f / 180.0f);

	// world space에서의 ray 정보를 계산
	ray.origin = glm::vec3(cameraModelMatrix * glm::vec4(0.0f, 0.0f, 0.0f, 1.0f));
	ray.dir = normalize(vec3(cameraModelMatrix * vec4(glm::vec3(xx, yy, -1.0), 0.0f)));

	// 만들어진 ray를 return
	return ray;
}

__device__ void Enqueue(Ray* rayQueue, Ray ray, int& rear)
{
	rear = (rear + 1) % QUEUE_SIZE;
	rayQueue[rear] = ray;
}

__device__ void Dequeue(Ray* rayQueue, int& front)
{
	Ray ray = rayQueue[front];
	front = (front + 1) % QUEUE_SIZE;
}

__device__ Ray GetQueueFront(Ray* rayQueue, const int front)
{
	return rayQueue[(front + 1) % QUEUE_SIZE];
}

__device__ bool IsQueueEmpty(const int front, const int rear)
{
	return front == rear;
}

__device__ float Radiance(
	vec3 hitPoint,
	Light light,
	Material* materials,
	Triangle* triangles,
	const int triangleNum,
	const int nearestTriangleIdx,
	Sphere* spheres,
	const int sphereNum,
	const int nearestSphereIdx)
{
	float radiance = 3000.0f;

	// shadow ray 생성, origin은 hit point, 방향은 hit point부터 광원까지의 방향
	Ray shadowRay;
	shadowRay.origin = hitPoint;
	shadowRay.dir = normalize(light.pos - hitPoint);
	float distance = glm::distance(light.pos, hitPoint);

	float distToTriangle;

	for (int t_i = 0; t_i < triangleNum; ++t_i)
	{
		// 처음 hit한 triangle은 제외
		if (nearestTriangleIdx != t_i)
		{
			// shadow
			if (RayTriangleIntersect(shadowRay, triangles[t_i], distToTriangle))
			{
				// 앞쪽의 dir만 봄
				if (distToTriangle > 0.01f && distToTriangle < glm::distance(light.pos, hitPoint))
				{
					radiance *= glm::clamp(materials[triangles[t_i].materialId].refractivity, 0.0f, 1.0f);
				}
			}
		}
	}

	float distToSphere;

	for (int s_i = 0; s_i < sphereNum; ++s_i)
	{
		// 광원은 0임, 광원을 제외한 경우에만 그림자 생김
		if (nearestSphereIdx != s_i && s_i != 0)
		{
			if (RaySphereIntersect(shadowRay, spheres[s_i], distToSphere))
			{
				// 앞쪽의 dir만 봄
				if (distToSphere > 0.01f && distToSphere < glm::distance(light.pos, hitPoint))
				{
					radiance *= glm::clamp(materials[triangles[s_i].materialId].refractivity, 0.0f, 1.0f);
				}
			}
		}
	}

	radiance /= (distance*distance);

	return radiance;
}

// ray가 hit 했다면 true를 리턴하고 hit한 곳의 정보를 가져오는 함수
__device__ bool GetHitPointInfo(
	Ray nowRay,
	Triangle* triangles,
	int triangleNum,
	int& nearestTriangleIdx,
	Sphere* spheres,
	int sphereNum,
	int& nearestSphereIdx,
	vec3& hitPoint, 
	int& materialId, 
	vec3& N,
	vec2& uv)
{
	float distToTriangle, distToSphere, distToAreaLight = 0.0f;
	nearestTriangleIdx = FindNearestTriangleIdx(nowRay, triangles, triangleNum, distToTriangle);
	nearestSphereIdx = FindNearestSphereIdx(nowRay, spheres, sphereNum, distToSphere);

	// 아무곳도 intersect를 못했다거나 뒤쪽에 있다면
	if ((nearestTriangleIdx == -1 || distToTriangle < 0.0f) &&
		(nearestSphereIdx == -1 || distToSphere < 0.0f) &&
		(distToAreaLight <= 0.0f))
		return false;

	if (distToSphere > distToTriangle)
	{
		Triangle nearestTriangle = triangles[nearestTriangleIdx];
		hitPoint = nowRay.origin + nowRay.dir * distToTriangle;
		materialId = nearestTriangle.materialId;
		Interpolation(nearestTriangle, hitPoint, N, uv);
	}
	else
	{
		Sphere nearestSphere = spheres[nearestSphereIdx];
		hitPoint = nowRay.origin + nowRay.dir * distToSphere;
		materialId = nearestSphere.materialId;
		N = glm::normalize(hitPoint - nearestSphere.origin);
		// no uv...
	}

	return true;
}

__device__ vec4 RayTraceColor(
	Ray ray,
	Ray* rayQueue,
	AABB* objects,
	int objNum,
	Triangle* triangles,
	int triangleNum,
	Sphere* spheres,
	int sphereNum,
	Light* lights,
	int lightNum,
	Material* materials,
	int matNum,
	float* textures,
	int texSize,
	int depth)
{
	vec4 color = vec4(0.0f);
	int front = 0, rear = 0;

	Enqueue(rayQueue, ray, rear);

	int nowDepth = 1;
	vec3 V = -ray.dir;

	for (int i = 1; i < depth; ++i)
	{
		int target = rear;

		while (!IsQueueEmpty(target, front))
		{
			Ray nowRay;
			nowRay = GetQueueFront(rayQueue, front);
			Dequeue(rayQueue, front);

			if (!RayAABBsIntersect(nowRay, objects, objNum))
				continue;

			vec4 lightedColor = glm::vec4(0.0f);
			vec3 hitPoint = glm::vec3(0.0f);
			// hit한 object의 material id
			int materialId = 0;
			// normal vector
			vec3 N = glm::vec3(0.0f);
			vec2 uv = glm::vec2(0.0f);
			int nearestTriangleIdx = 0;
			int nearestSphereIdx = 0;

			// hit point의 정보를 가져옴
			if (GetHitPointInfo(
				nowRay, 
				triangles, 
				triangleNum, 
				nearestTriangleIdx, 
				spheres, 
				sphereNum, 
				nearestSphereIdx, 
				hitPoint, 
				materialId, 
				N,
				uv))
			{
				for (int k = 0; k < lightNum; k++)
				{
					// ∫Ω(kd c / π + ks DFG / 4(ωo⋅n)(ωi⋅n)) Li(p,ωi) n⋅ωi dωi

					// radiance * (1.0f * textureColor/pi + 0.0f) * lightcolor * NdotL

					float kd = 1.0f;
					vec3 L = glm::normalize(lights[k].pos - hitPoint);
					float NdotL = glm::clamp(glm::dot(N, L), 0.0f, 1.0f);

					float radiance = Radiance(hitPoint,
						lights[k],
						materials,
						triangles, triangleNum, nearestTriangleIdx,
						spheres, sphereNum, nearestSphereIdx);

					vec3 ambientColor = materials[materialId].ambient;
					vec3 diffuseColor;

					if (materials[materialId].texWidth == 0)
						diffuseColor = materials[materialId].diffuse;
					else
					{
						float u = uv.x * 2048.0f - 0.5f;
						float v = uv.y * 2048.0f - 0.5f;
						int uu = floor(u);
						int vv = floor(v);
						float uRatio = u - uu;
						float vRatio = v - vv;
						float uOpposite = 1 - uRatio;
						float vOpposite = 1 - vRatio;
						
						int uu0 = uu * 2048;
						int uu1 = glm::clamp(uu + 1, 0, 2047) * 2048;

						int vv0 = 2047 - vv;
						int vv1 = 2047 - glm::clamp(vv + 1, 0, 2047);

						float texR =
							(textures[(uu0 + vv0) * 4 + 0] * uOpposite +
								textures[(uu1 + vv0) * 4 + 0] * uRatio) * vOpposite +
								(textures[(uu0 + vv1) * 4 + 0] * uOpposite +
									textures[(uu1 + vv1) * 4 + 0] * uRatio)*vRatio;

						float texG =
							(textures[(uu0 + vv0) * 4 + 1] * uOpposite +
								textures[(uu1 + vv0) * 4 + 1] * uRatio) * vOpposite +
								(textures[(uu0 + vv1) * 4 + 1] * uOpposite +
									textures[(uu1 + vv1) * 4 + 1] * uRatio)*vRatio;

						float texB =
							(textures[(uu0 + vv0) * 4 + 2] * uOpposite +
								textures[(uu1 + vv0) * 4 + 2] * uRatio) * vOpposite +
								(textures[(uu0 + vv1) * 4 + 2] * uOpposite +
									textures[(uu1 + vv1) * 4 + 2] * uRatio)*vRatio;

						diffuseColor = glm::vec3(texR, texG, texB);
					}

					diffuseColor *= kd / glm::pi<float>();
					diffuseColor = vec3(
						diffuseColor.r * lights[k].color.r,
						diffuseColor.g * lights[k].color.g,
						diffuseColor.b * lights[k].color.b);
					lightedColor += glm::vec4(ambientColor + radiance * NdotL * diffuseColor, 1.0f);
				}

				color += lightedColor * nowRay.decay;

				Ray reflectRay;
				// reflect ray의 시작점은 hit point
				reflectRay.origin = hitPoint;
				reflectRay.dir = normalize(reflect(nowRay.dir, N));
				// reflect ray
				reflectRay.rayType = 1;
				// 현재 빛의 감쇠 정도와 물체의 재질에 따라 reflect ray의 감쇠 정도가 정해짐 
				reflectRay.decay = nowRay.decay * materials[materialId].reflectivity;

				Ray refractRay;
				// refract ray의 시작점은 hit point
				refractRay.origin = hitPoint;
				refractRay.dir = normalize(refract(nowRay.dir, N, 0.95f));
				// refract ray
				refractRay.rayType = 2;
				// 현재 빛의 감쇠 정도와 물체의 재질에 따라 refract ray의 감쇠 정도가 정해짐
				refractRay.decay = nowRay.decay * materials[materialId].refractivity;

				if (reflectRay.decay > 0)
				{
					Enqueue(rayQueue, reflectRay, rear);
				}

				if (refractRay.decay > 0)
				{
					Enqueue(rayQueue, refractRay, rear);
				}
			}
		}

		nowDepth++;
	}

	// 나오지 못한 queue들 나오게 하기
	while (!IsQueueEmpty(front, rear))
	{
		Ray nowRay;
		nowRay = GetQueueFront(rayQueue, front);
		Dequeue(rayQueue, front);

		if (!RayAABBsIntersect(nowRay, objects, objNum))
			continue;

		vec4 lightedColor = glm::vec4(0.0f);
		vec3 hitPoint = glm::vec3(0.0f);
		int materialId = 0;
		vec3 N = glm::vec3(0.0f);
		vec2 uv = glm::vec2(0.0f);
		int nearestTriangleIdx = 0;
		int nearestSphereIdx = 0;

		if (GetHitPointInfo(
			nowRay,
			triangles,
			triangleNum,
			nearestTriangleIdx,
			spheres,
			sphereNum,
			nearestSphereIdx,
			hitPoint,
			materialId,
			N,
			uv))
		{
			for (int k = 0; k < lightNum; k++)
			{
				float kd = 1.0f;
				vec3 L = glm::normalize(lights[k].pos - hitPoint);
				float NdotL = glm::clamp(glm::dot(N, L), 0.0f, 1.0f);

				float radiance = Radiance(hitPoint,
					lights[k],
					materials,
					triangles, triangleNum, nearestTriangleIdx,
					spheres, sphereNum, nearestSphereIdx);

				vec3 ambientColor = materials[materialId].ambient;
				vec3 diffuseColor;

				if (materials[materialId].texWidth == 0)
					diffuseColor = materials[materialId].diffuse;
				else
				{
					float u = uv.x * 2048.0f - 0.5f;
					float v = uv.y * 2048.0f - 0.5f;
					int uu = floor(u);
					int vv = floor(v);
					float uRatio = u - uu;
					float vRatio = v - vv;
					float uOpposite = 1 - uRatio;
					float vOpposite = 1 - vRatio;

					int uu0 = uu * 2048;
					int uu1 = glm::clamp(uu + 1, 0, 2047) * 2048;

					int vv0 = 2047 - vv;
					int vv1 = 2047 - glm::clamp(vv + 1, 0, 2047);

					float texR =
						(textures[(uu0 + vv0) * 4 + 0] * uOpposite +
							textures[(uu1 + vv0) * 4 + 0] * uRatio) * vOpposite +
							(textures[(uu0 + vv1) * 4 + 0] * uOpposite +
								textures[(uu1 + vv1) * 4 + 0] * uRatio)*vRatio;

					float texG =
						(textures[(uu0 + vv0) * 4 + 1] * uOpposite +
							textures[(uu1 + vv0) * 4 + 1] * uRatio) * vOpposite +
							(textures[(uu0 + vv1) * 4 + 1] * uOpposite +
								textures[(uu1 + vv1) * 4 + 1] * uRatio)*vRatio;

					float texB =
						(textures[(uu0 + vv0) * 4 + 2] * uOpposite +
							textures[(uu1 + vv0) * 4 + 2] * uRatio) * vOpposite +
							(textures[(uu0 + vv1) * 4 + 2] * uOpposite +
								textures[(uu1 + vv1) * 4 + 2] * uRatio)*vRatio;

					diffuseColor = glm::vec3(texR, texG, texB);
				}

				diffuseColor *= kd / glm::pi<float>();
				diffuseColor = vec3(
					diffuseColor.r * lights[k].color.r,
					diffuseColor.g * lights[k].color.g,
					diffuseColor.b * lights[k].color.b);
				lightedColor += glm::vec4(ambientColor + radiance * NdotL * diffuseColor, 1.0f);
			}

			color += lightedColor * nowRay.decay;
		}
	}

	return color;
}

__global__ void RayTraceD(
	glm::vec4* data,
	const int gridX,
	const int gridY,
	glm::mat4 view,
	OctreeNode* root,
	AABB* boundingboxes, int boxNum,
	Triangle* triangles, int triangleNum,
	Sphere* spheres, int sphereNum,
	Light* lights, int lightNum,
	Material* materials, int matNum,
	float* textures, int texSize)
{
	//unsigned int x = blockIdx.x * blockDim.x + threadIdx.x;
	unsigned int x = (blockIdx.x + gridY * RAY_Y_NUM) * WINDOW_HEIGHT + (threadIdx.x + gridX * RAY_X_NUM);

	Ray ray = GenerateCameraRay(blockIdx.x + gridY * RAY_Y_NUM, threadIdx.x + gridX * RAY_X_NUM, view);
	ray.rayType = 0;
	ray.decay = 1.0f;

	Ray rayQueue[QUEUE_SIZE];
	// NOTICE for문을 돌릴 때 iter를 변수로 하니까 검은 화면이 나옴
	// y, x로 들어가고
	// 0, 0 좌표는 좌하단
	data[x] = RayTraceColor(
		ray,
		rayQueue,
		boundingboxes,
		boxNum,
		triangles,
		triangleNum,
		spheres,
		sphereNum,
		lights,
		lightNum,
		materials,
		matNum, 
		textures,
		texSize,
		1);
}

void RayTrace(
	glm::vec4* data,
	const int gridX,
	const int gridY,
	glm::mat4 view,
	OctreeNode* root,
	const vector<AABB>& boundingboxes,
	const vector<Triangle>& triangles,
	const vector<Sphere>& spheres,
	const vector<Light>& lights,
	const vector<Material>& materials,
	const vector<float>& textures)
{
	thrust::device_vector<AABB> b = boundingboxes;
	thrust::device_vector<Triangle> t = triangles;
	thrust::device_vector<Sphere> s = spheres;
	thrust::device_vector<Light> l = lights;
	thrust::device_vector<Material> m = materials;
	thrust::device_vector<float> tex = textures;

	cudaDeviceSetLimit(cudaLimitMallocHeapSize, 5000000000 * sizeof(float));

	vector<Triangle> tss;
	OctreeNode* d_root = BuildOctree(tss);

	RayTraceD << <RAY_Y_NUM, RAY_X_NUM >> > (
		data,
		gridX,
		gridY,
		view,
		d_root,
		b.data().get(),
		b.size(),
		t.data().get(),
		t.size(),
		s.data().get(),
		s.size(),
		l.data().get(),
		l.size(),
		m.data().get(),
		m.size(),
		tex.data().get(),
		tex.size()
	);
}