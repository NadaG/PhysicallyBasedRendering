#include "RayTracer.cuh"
#include "Octree.cuh"
#include <cuda.h>
#include <cuda_runtime.h>
#include <glm\glm.hpp>
#include <stdio.h>
#include <glm\gtc\matrix_transform.hpp>
#include <math_constants.h>
#include <math.h>
#include <thrust\device_vector.h>
#include <queue>

// TODO LIST
// 1. per line draw to eliminate kernel time out problem
// 2. octree acceleration
// 3. mtl file load
// 4. texture mapping with interpolation
// 5. monte calro path tracer

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

const int QUEUE_SIZE = 3;

using std::cout;
using std::endl;

__device__ bool RaySphereIntersect(Ray ray, Sphere sphere, float& dist)
{
	glm::vec3 s = ray.origin - sphere.origin;

	float a = dot(ray.dir, ray.dir);
	float bPrime = dot(s, ray.dir);
	float c = dot(s, s) - sphere.radius * sphere.radius;

	float D = bPrime * bPrime - a * c;
	if (D >= 0 && bPrime <= 0)
	{
		float t1 = (-bPrime + sqrt(D)) / a;
		float t2 = (-bPrime - sqrt(D)) / a;
		dist = t1 > t2 ? t2 : t1;
		return true;
	}
	else
		return false;
}

// back face culling이 적용되어 있음
__device__ bool RayTriangleIntersect(Ray ray, Triangle triangle, float& dist)
{
	glm::vec3 v0v1 = triangle.v1 - triangle.v0;
	glm::vec3 v0v2 = triangle.v2 - triangle.v0;
	glm::vec3 pvec = glm::cross(ray.dir, v0v2);

	float det = dot(v0v1, pvec);

	float epsilon = 0.0001f;

	if (det < epsilon)
		return false;

	if (fabs(det) < epsilon)
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

// 가장 가까운 triangle의 id를 반환하고 해당 점까지의 dist를 가져온다
__device__ int FindNearestTriangleIdx(Ray ray, Triangle* triangles, int triangleNum, float& dist)
{
	const float rayThreshold = 0.001f;
	float minDist = 9999999.0f;
	int minIdx = -1;
	float tmpDist;

	// 그대로 dist를 가져와서 사용하니까 이상해짐
	for (int i = 0; i < triangleNum; ++i)
	{
		if (dot(triangles[i].normal, ray.dir) > 0.0f)
			continue;
		// intersect 할 경우
		if (RayTriangleIntersect(ray, triangles[i], tmpDist))
		{
			// 잘 찾은 경우, 다시 찾지 않기
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

__device__ int FindNearestSphereIdx(Ray ray, Sphere* spheres, int sphereNum, float& dist)
{
	const float rayThreshold = 0.001f;
	float minDist = 9999999.0f;
	int minIdx = -1;
	float tmpDist;

	// 그대로 dist를 가져와서 사용하니까 이상해짐
	for (int i = 0; i < sphereNum; ++i)
	{
		// intersect 할 경우
		if (RaySphereIntersect(ray, spheres[i], tmpDist))
		{
			if (dot(ray.dir, ray.origin + ray.dir * tmpDist - spheres[i].origin) > 0.0f)
				continue;

			// 잘 찾은 경우, 다시 찾지 않기
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

__device__ Ray GenerateCameraRay(int y, int x, glm::mat4 view)
{
	Ray ray;

	// 0~1
	// world 좌표로 ray를 쏨, 옆으로 긴 window일수록 옆으로 많은 ray를 쏨
	// 값을 NDC 좌표로 변환함
	float NDCy = (y + 0.5f) / WINDOW_HEIGHT;
	float NDCx = (x + 0.5f) / WINDOW_WIDTH;

	float aspectRatio = WINDOW_WIDTH / WINDOW_HEIGHT;

	float fov = 45.0f;

	// NDC 좌표를 -1 ~ 1로 변환
	// tan(halfRadian)
	// world 좌표에서 z축 방향이 1이기 때문에 곱하지 않음
	float xx = (NDCx * 2.0f - 1.0f) * tan(fov * 0.5f * 3.141592653f / 180.0f) * aspectRatio;
	float yy = (NDCy * 2.0f - 1.0f) * tan(fov * 0.5f * 3.141592653f / 180.0f);

	// ray들의 world 방향이 정해짐

	ray.origin = glm::vec3(-view * glm::vec4(0.0f, 0.0f, 0.0f, 1.0f));
	ray.dir = normalize(vec3(view * vec4(glm::vec3(xx, yy, -1.0), 0.0f)));

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

__device__ bool IsQueueFull(const int front, const int rear)
{
	return front == (rear + 1) % QUEUE_SIZE;
}

__device__ bool IsQueueEmpty(const int front, const int rear)
{
	return front == rear;
}

__device__ bool IsLighted(
	vec3 hitPoint,
	Light light,
	Material *materials,
	Triangle* triangles,
	const int triangleNum,
	const int nearestTriangleIdx,
	Sphere* spheres,
	const int sphereNum,
	const int nearestSphereIdx)
{
	Ray shadowRay;
	shadowRay.origin = hitPoint;
	shadowRay.dir = normalize(light.pos - hitPoint);

	float tmp;
	for (int k = 0; k < triangleNum; ++k)
	{
		if (nearestTriangleIdx != k)
			if (RayTriangleIntersect(shadowRay, triangles[k], tmp)) {
				// 앞쪽의 dir만 봄
				if (materials[triangles[k].materialId].refractivity == 0) {
					if (tmp > 0.0001f)
						return false;
				}
			}
	}

	for (int k = 0; k < sphereNum; ++k)
	{
		if (nearestSphereIdx != k)
			if (RaySphereIntersect(shadowRay, spheres[k], tmp))
				// 앞쪽의 dir만 봄
				if (tmp > 0.0001f)
					return false;
	}

	return true;
}

__device__ vec3 RayCastColor(
	vec3 N,
	vec3 L,
	vec3 V,
	int rayType,
	Material material,
	Light light)
{
	vec3 color = glm::vec3(0.0f, 0.0f, 0.0f);
	
	glm::vec3 matAmbient = material.ambient;
	glm::vec3 matDiffuse = material.diffuse;
	glm::vec3 matSpecular = material.specular;

	glm::vec3 ambient = glm::vec3(
		matAmbient.r * light.color.r,
		matAmbient.g * light.color.g,
		matAmbient.b * light.color.b);

	glm::vec3 diffuse = glm::vec3(
		matDiffuse.r * light.color.r,
		matDiffuse.g * light.color.g,
		matDiffuse.b * light.color.b) *
		glm::clamp(dot(N, L), 0.0f, 1.0f);

	glm::vec3 specular = glm::vec3(
		matSpecular.r * light.color.r,
		matSpecular.g * light.color.g,
		matSpecular.b * light.color.b) *
		glm::max(0.0f, pow(glm::max(dot(normalize(reflect(-L, N)), V), 0.0f), 16));

	//switch (rayType)
	//{
	//case 0:
	//	color = glm::vec4(glm::vec3(ambient + diffuse + specular), 1.0f);
	//	break;
	//case 1: // reflect
	//	color = glm::vec4(glm::vec3(ambient + diffuse + specular), 1.0f) * material.reflectivity;
	//	break;
	//case 2: //refract
	//	color = glm::vec4(glm::vec3(ambient + diffuse + specular), 1.0f) * material.refractivity;
	//	break;
	//default:
	//	break;
	//}
	color = glm::vec4(glm::vec3(ambient + diffuse + specular), 1.0f);

	return color;
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
	int depth)
{
	vec4 color = vec4(0.0f);
	int front = 0, rear = 0;

	// 첫 번째 ray를 node로 하는 queue 생성
	Enqueue(rayQueue, ray, rear);

	int nowDepth = 1;

	// 총 7 (1 + 2 + 4)개의 ray가 나옴
	for (int i = 1; i < depth; ++i)
	{
		int target = rear;

		while (!IsQueueEmpty(target, front))
		{
			Ray nowRay;
			nowRay = GetQueueFront(rayQueue, front);
			Dequeue(rayQueue, front);

			/*if (!RayAABBsIntersect(nowRay, objects, objNum))
				continue;*/

			float distToTriangle, distToSphere;
			int nearestTriangleIdx = FindNearestTriangleIdx(nowRay, triangles, triangleNum, distToTriangle);
			int nearestSphereIdx = FindNearestSphereIdx(nowRay, spheres, sphereNum, distToSphere);

			// 아무곳도 intersect를 못했다거나 뒤쪽에 있다면
			if ((nearestTriangleIdx == -1 || distToTriangle < 0.0f) && 
				(nearestSphereIdx == -1 || distToSphere < 0.0f))
				continue;
			// 어디 하나라도 intersect 했다면
			else
			{
				vec4 lightedColor = glm::vec4(0.0f);
				vec3 hitPoint = glm::vec3(0.0f);
				int materialId = 0;
				vec3 N = glm::vec4(0.0f);
				vec3 V = -ray.dir;

				if (distToSphere > distToTriangle)
				{
					Triangle nearestTriangle = triangles[nearestTriangleIdx];
					hitPoint = nowRay.origin + nowRay.dir * distToTriangle;
					materialId = nearestTriangle.materialId;
					N = glm::normalize(nearestTriangle.normal);
				}
				else
				{
					Sphere nearestSphere = spheres[nearestSphereIdx];
					hitPoint = nowRay.origin + nowRay.dir * distToSphere;
					materialId = nearestSphere.materialId;
					N = glm::normalize(hitPoint - nearestSphere.origin);
				}

				for (int k = 0; k < lightNum; k++)
				{
					vec3 L = glm::normalize(lights[k].pos - hitPoint);

					if (IsLighted(
						hitPoint,
						lights[k],
						materials,
						triangles, triangleNum, nearestTriangleIdx,
						spheres, sphereNum, nearestSphereIdx))
					{
						lightedColor += glm::vec4(RayCastColor(
							N, L, V, nowRay.rayType, materials[materialId], lights[k]),
							1.0f);
					}
				}

				Ray reflectRay;
				reflectRay.origin = hitPoint;
				reflectRay.dir = normalize(reflect(nowRay.dir, N));
				reflectRay.rayType = 1;
				reflectRay.decay = nowRay.decay * materials[materialId].reflectivity;

				Ray refractRay;
				refractRay.origin = hitPoint;
				refractRay.dir = normalize(refract(nowRay.dir, N, 1.2f));
				refractRay.rayType = 2;
				refractRay.decay = nowRay.decay * materials[materialId].refractivity;

				if (reflectRay.decay > 0) {
					Enqueue(rayQueue, reflectRay, rear);
				}

				if (refractRay.decay > 0) {
					Enqueue(rayQueue, refractRay, rear);
				}

				color += lightedColor * nowRay.decay;
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

		float distToTriangle, distToSphere;
		int nearestTriangleIdx = FindNearestTriangleIdx(nowRay, triangles, triangleNum, distToTriangle);
		int nearestSphereIdx = FindNearestSphereIdx(nowRay, spheres, sphereNum, distToSphere);
		
		// 아무곳도 intersect를 못했다거나 뒤쪽에 있다면
		if ((nearestTriangleIdx == -1 || distToTriangle < 0.0f) &&
			(nearestSphereIdx == -1 || distToSphere < 0.0f))
			continue;
		// 어디 하나라도 intersect 했다면
		else
		{
			vec4 lightedColor = glm::vec4(0.0f);
			vec3 hitPoint = glm::vec3(0.0f);
			int materialId = 0;
			vec3 N = glm::vec4(0.0f);
			vec3 V = -ray.dir;

			if (distToSphere > distToTriangle)
			{
				Triangle nearestTriangle = triangles[nearestTriangleIdx];
				hitPoint = nowRay.origin + nowRay.dir * distToTriangle;
				materialId = nearestTriangle.materialId;
				N = glm::normalize(nearestTriangle.normal);
			}
			else
			{
				Sphere nearestSphere = spheres[nearestSphereIdx];
				hitPoint = nowRay.origin + nowRay.dir * distToSphere;
				materialId = nearestSphere.materialId;
				N = glm::normalize(hitPoint - nearestSphere.origin);
			}

			for (int k = 0; k < lightNum; k++)
			{
				vec3 L = glm::normalize(lights[k].pos - hitPoint);

				if (IsLighted(
					hitPoint,
					lights[k],
					materials,
					triangles, triangleNum, nearestTriangleIdx,
					spheres, sphereNum, nearestSphereIdx))
				{
					lightedColor += glm::vec4(RayCastColor(
						N, L, V, nowRay.rayType, materials[materialId], lights[k]),
						1.0f);
				}
			}

			/*Ray reflectRay;
			reflectRay.origin = hitPoint;
			reflectRay.dir = normalize(reflect(nowRay.dir, N));
			reflectRay.rayType = 1;
			reflectRay.decay = nowRay.decay * materials[materialId].reflectivity;

			Ray refractRay;
			refractRay.origin = hitPoint;
			refractRay.dir = normalize(refract(nowRay.dir, N, 1.2f));
			refractRay.rayType = 2;
			refractRay.decay = nowRay.decay * materials[materialId].refractivity;*/

			//if (reflectRay.decay > 0) {
			//	Enqueue(rayQueue, reflectRay, rear);
			//}

			//if (refractRay.decay > 0) {
			//	Enqueue(rayQueue, refractRay, rear);
			//}

			color += lightedColor * nowRay.decay;
		}
	}

	return color;
}

__global__ void RayTraceD(
	glm::vec4* data,
	glm::mat4 view,
	OctreeNode* root,
	AABB* boundingboxes, int boxNum,
	Triangle* triangles, int triangleNum,
	Sphere* spheres, int sphereNum,
	Light* lights, int lightNum,
	Material* materials, int matNum)
{
	unsigned int x = blockIdx.x * blockDim.x + threadIdx.x;

	Ray ray = GenerateCameraRay(blockIdx.x, threadIdx.x, view);
	ray.rayType = 0;
	ray.decay = 1.0f;

	Ray rayQueue[QUEUE_SIZE];
	// NOTICE for문을 돌릴 때 iter를 변수로 하니까 검은 화면이 나옴
	// y, x로 들어가고
	// 0, 0 좌표는 좌하단

	/*if (ray.dir.x < root->bndMin.x)
	{
		data[x] = glm::vec4(1.0f, 0.0f, 0.0f, 1.0f);
		return;
	}*/

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
		2);
}

void RayTrace(
	glm::vec4* data,
	glm::mat4 view,
	OctreeNode* root,
	const vector<AABB>& boundingboxes,
	const vector<Triangle>& triangles,
	const vector<Sphere>& spheres,
	const vector<Light>& lights,
	const vector<Material>& materials)
{
	thrust::device_vector<AABB> b = boundingboxes;
	thrust::device_vector<Triangle> t = triangles;
	thrust::device_vector<Sphere> s = spheres;
	thrust::device_vector<Light> l = lights;
	thrust::device_vector<Material> m = materials;

	cudaDeviceSetLimit(cudaLimitMallocHeapSize, 500000000 * sizeof(float));

	vector<Triangle> tss;
	OctreeNode* d_root = BuildOctree(tss);

	RayTraceD << <WINDOW_HEIGHT, WINDOW_WIDTH >> > (
		data,
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
		m.size()
	);
}