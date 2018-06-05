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
#include <algorithm>
#include <stdio.h>

texture<float4, 2, cudaReadModeElementType> albedoTex;
texture<float4, 2, cudaReadModeElementType> normalTex;
texture<float4, 2, cudaReadModeElementType> aoTex;
texture<float4, 2, cudaReadModeElementType> metallicTex;
texture<float4, 2, cudaReadModeElementType> roughnessTex;

texture<float4, 2, cudaReadModeElementType> backgroundTex;

struct Ray
{
	// Ray의 원점
	vec3 origin;
	// Ray의 방향
	vec3 dir;
	
	float decay;
};

const int WINDOW_HEIGHT = 1024;
const int WINDOW_WIDTH = 1024;

const int RAY_X_NUM = 64;
const int RAY_Y_NUM = 64;

const int QUEUE_SIZE = 30;

const int DEPTH = 2;

const int SAMPLE_NUM = 1;

using std::cout;
using std::endl;
using std::max;
using std::min;

// TODO LIST
// 1. 에너지 보존 for reflect and refract 
// 2. path tracing
// ggx distribution이라고 외우자
__device__ float DistributionGGX(vec3 N, vec3 H, float roughness)
{
	float a = roughness * roughness;
	float a2 = a * a;
	float NdotH = max(dot(N, H), 0.0f);
	float NdotH2 = NdotH * NdotH;

	float nominator = a2;
	float denominator = (NdotH2 * (a2 - 1.0) + 1.0);
	denominator = glm::pi<float>() * denominator * denominator;

	return nominator / denominator;
}

__device__ float GeometrySchlickGGX(float NdotV, float roughness)
{
	float r = (roughness + 1.0);
	float k = (r * r) / 8.0;

	float nominator = NdotV;
	float denominator = NdotV * (1.0 - k) + k;

	return nominator / denominator;
}

// smith geometry라고 외우자
// geometry shadowing 빛이 어떤 표면으로 갈 때 다른 표면에 막혀 가지 못하는 경우
// geometry obstruction 빛이 어떤 표면에서 눈으로 갈 때 다른 표면에 막혀 가지 못하는 경우
// 이 두가지를 모두 고려해야 해서 ggx1 * ggx2
// 0.8이 안 막히고, 0.8이 안 막힌다면 결국은 0.8 * 0.8
__device__ float GeometrySmith(vec3 N, vec3 V, vec3 L, float roughness)
{
	float NdotV = max(dot(N, V), 0.0f);
	float NdotL = max(dot(N, L), 0.0f);

	float ggx2 = GeometrySchlickGGX(NdotV, roughness);
	float ggx1 = GeometrySchlickGGX(NdotL, roughness);

	return ggx1 * ggx2;
}

// cosTheta가 작을 수록 큰 값이 들어간다
// 즉 90도에 가까운 곳에서 볼 수록 빛이 쎄진다는 것이다.
// 90이면 그냥 1임
// 각도가 높아지면 점점 약해지고 F0값에 가까워짐
__device__ vec3 fresnelSchlick(float cosTheta, vec3 F0)
{
	return F0 + (1.0f - F0) * pow(1.0f - cosTheta, 5.0f);
}

__device__ vec3 calculateEta(float refractiveIndex)
{
	return vec3(powf(1.0f - (1.0f / refractiveIndex), 2.0f) / powf(1.0f + (1.0f / refractiveIndex), 2.0f));
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

	/*if (fabsf(det) < 0.01f)
		return false;*/

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
	const float rayThreshold = 0.01f;
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
__device__ Ray GenerateCameraRay(int y, int x, glm::mat4 cameraModelMatrix, int rayX, int rayY)
{
	Ray ray;

	// 각 픽셀의 중앙을 가르키는 값 생성, 0~1의 값으로 Normalizing
	// antialiasing
	float NDCy = (y + 0.33333f + 0.33333f*rayY) / WINDOW_HEIGHT;
	float NDCx = (x + 0.33333f + 0.33333f*rayX) / WINDOW_WIDTH;

	/*float NDCy = (y + 0.5f) / WINDOW_HEIGHT;
	float NDCx = (x + 0.5f) / WINDOW_WIDTH;*/

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

__device__ bool IsLighted(
	vec3 hitPoint,
	Light light,
	Triangle* triangles,
	const int triangleNum,
	const int nearestTriangleIdx,
	Sphere* spheres,
	const int sphereNum,
	const int nearestSphereIdx)
{
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
					return false;
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
					return false;
				}
			}
		}
	}

	return true;
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
	float* randomNums,
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

				// ∫Ω(kd c / π + ks DFG / 4(ωo⋅n)(ωi⋅n)) Li(p,ωi) n⋅ωi dωi
				// radiance * (1.0f * textureColor/pi + 0.0f) * lightcolor * NdotL
				vec3 albedo;
				vec3 emission;
				vec3 F0;
				float4 texNormal;
				float ao;
				float metallic;
				float roughness;

				vec3 kS;
				vec3 kD;

				if (materials[materialId].texId == 0)
				{
					float4 texRGBA;
					texRGBA = tex2D(albedoTex, uv.x, uv.y);
					albedo = glm::pow(glm::vec3(texRGBA.x, texRGBA.y, texRGBA.z), vec3(2.2));

					texNormal = tex2D(normalTex, uv.x, uv.y);
					ao = tex2D(aoTex, uv.x, uv.y).x;
					metallic = tex2D(metallicTex, uv.x, uv.y).x;
					roughness = tex2D(roughnessTex, uv.x, uv.y).x;

					glm::vec3 texNormalVec = glm::vec3(
						texNormal.x * 2.0f - 1.0f,
						texNormal.y * 2.0f - 1.0f,
						texNormal.z * 2.0f - 1.0f);

					glm::mat3 TBN = glm::mat3(
						triangles[nearestTriangleIdx].tangent,
						triangles[nearestTriangleIdx].bitangent,
						N);

					// TBN의 inverse
					N = glm::normalize(texNormalVec);

					N = TBN * N;
				}
				else if (materials[materialId].texId == 1)
				{
					float4 texRGBA;
					texRGBA = tex2D(backgroundTex, uv.x, uv.y);
					albedo = glm::pow(glm::vec3(texRGBA.x, texRGBA.y, texRGBA.z), vec3(2.2));

					ao = materials[materialId].ambient;
					metallic = materials[materialId].metallic;
					roughness = materials[materialId].roughness;
					emission = materials[materialId].emission;
				}
				else
				{
					albedo = materials[materialId].albedo;
					ao = materials[materialId].ambient;
					metallic = materials[materialId].metallic;
					roughness = materials[materialId].roughness;
					emission = materials[materialId].emission;
				}

				if (materials[materialId].refractiveIndex != 0.0f)
				{
					F0 = calculateEta(materials[materialId].refractiveIndex);
				}
				else
				{
					F0 = glm::mix(vec3(0.04f), albedo, metallic);
				}

				vec3 Lo = vec3(0.0f);
				for (int k = 0; k < lightNum; k++)
				{
					if (!IsLighted(hitPoint, lights[k], triangles, triangleNum, nearestTriangleIdx,
						spheres, sphereNum, nearestSphereIdx))
					{
						continue;
					}

					vec3 L = glm::normalize(lights[k].pos - hitPoint);
					vec3 H = glm::normalize(V + L);

					float distance = glm::distance(lights[k].pos, hitPoint);
					float attenuation = 1.0 / (distance*distance);

					vec3 radiance = lights[k].color * attenuation;

					float NDF = DistributionGGX(N, H, roughness);
					float G = GeometrySmith(N, V, L, roughness);
					vec3 F = fresnelSchlick(glm::max(glm::dot(H, V), 0.0f), F0);

					vec3 nominator = NDF * G * F;
					float denominator = 4 * glm::max(glm::dot(N, V), 0.0f) * glm::max(glm::dot(N, L), 0.0f) + 0.001f;
					vec3 specular = nominator / denominator;

					kS = F;
					kD = vec3(1.0) - kS;
					kD *= 1.0f - metallic;

					float NdotL = glm::clamp(glm::dot(N, L), 0.0f, 1.0f);

					Lo += (kD*albedo / glm::pi<float>() + specular) * radiance * NdotL;
				}

				vec3 ambient = vec3(0.03) * albedo * ao;

				vec3 tmpColor = ambient + Lo + emission;

				// hdr
				tmpColor = tmpColor / (tmpColor + vec3(1.0));
				// gamma correction
				tmpColor = glm::pow(tmpColor, vec3(1.0 / 2.2));

				lightedColor += glm::vec4(tmpColor, 1.0f);

				color += lightedColor * nowRay.decay;

				//////////////////////////////////////////////////////////////////////////////////////////분리선

				for (int j = 0; j < SAMPLE_NUM; ++j)
				{
					// theta, phi
					vec3 randomVec = vec3(
						cosf(randomNums[j * 2])*sinf(randomNums[j * 2 + 1]),
						sinf(randomNums[j * 2]),
						cosf(randomNums[j * 2])*cosf(randomNums[j * 2 + 1]));
					
					glm::mat3 TNB = glm::mat3(
						triangles[nearestTriangleIdx].tangent,
						N,
						triangles[nearestTriangleIdx].bitangent);
					randomVec = randomVec * TNB;


					Ray reflectRay;
					// reflect ray의 시작점은 hit point
					reflectRay.origin = hitPoint;
					//reflectRay.dir = normalize(randomVec);
					reflectRay.dir = normalize(reflect(nowRay.dir, N));

					// 현재 빛의 감쇠 정도와 물체의 재질에 따라 reflect ray의 감쇠 정도가 정해짐 
					reflectRay.decay = kS.r * ray.decay / SAMPLE_NUM;

					Enqueue(rayQueue, reflectRay, rear);
				}

				// refract는 ray tracing
				Ray refractRay;
				// refract ray의 시작점은 hit point
				refractRay.origin = hitPoint;
				refractRay.dir = normalize(refract(nowRay.dir, N, 1.0f / materials[materialId].refractiveIndex));
				// 현재 빛의 감쇠 정도와 물체의 재질에 따라 refract ray의 감쇠 정도가 정해짐
				refractRay.decay = kD.r * ray.decay;

				Enqueue(rayQueue, refractRay, rear);
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
			vec3 albedo;
			vec3 emission;
			vec3 F0;
			float4 texNormal;
			float ao;
			float metallic;
			float roughness;

			vec3 kS;
			vec3 kD;

			if (materials[materialId].texId == 0)
			{
				float4 texRGBA;
				texRGBA = tex2D(albedoTex, uv.x, uv.y);
				albedo = glm::pow(glm::vec3(texRGBA.x, texRGBA.y, texRGBA.z), vec3(2.2));

				texNormal = tex2D(normalTex, uv.x, uv.y);
				ao = tex2D(aoTex, uv.x, uv.y).x;
				metallic = tex2D(metallicTex, uv.x, uv.y).x;
				roughness = tex2D(roughnessTex, uv.x, uv.y).x;

				glm::vec3 texNormalVec = glm::vec3(
					texNormal.x * 2.0f - 1.0f,
					texNormal.y * 2.0f - 1.0f,
					texNormal.z * 2.0f - 1.0f);

				glm::mat3 TBN = glm::mat3(
					triangles[nearestTriangleIdx].tangent,
					triangles[nearestTriangleIdx].bitangent,
					N);

				// TBN의 inverse
				N = glm::normalize(texNormalVec);

				N = TBN * N;
			}
			else if (materials[materialId].texId == 1)
			{
				float4 texRGBA;
				texRGBA = tex2D(backgroundTex, uv.x, uv.y);
				albedo = glm::pow(glm::vec3(texRGBA.x, texRGBA.y, texRGBA.z), vec3(2.2));

				ao = materials[materialId].ambient;
				metallic = materials[materialId].metallic;
				roughness = materials[materialId].roughness;
				emission = materials[materialId].emission;
			}
			else
			{
				albedo = materials[materialId].albedo;
				ao = materials[materialId].ambient;
				metallic = materials[materialId].metallic;
				roughness = materials[materialId].roughness;
				emission = materials[materialId].emission;
			}

			if (materials[materialId].refractiveIndex != 0.0f)
			{
				F0 = calculateEta(materials[materialId].refractiveIndex);
			}
			else
			{
				F0 = glm::mix(vec3(0.04f), albedo, metallic);
			}

			vec3 Lo = vec3(0.0f);
			for (int k = 0; k < lightNum; k++)
			{
				if (!IsLighted(hitPoint, lights[k], triangles, triangleNum, nearestTriangleIdx,
					spheres, sphereNum, nearestSphereIdx))
				{
					continue;
				}

				vec3 L = glm::normalize(lights[k].pos - hitPoint);
				vec3 H = glm::normalize(V + L);

				float distance = glm::distance(lights[k].pos, hitPoint);
				float attenuation = 1.0 / (distance*distance);

				vec3 radiance = lights[k].color * attenuation;

				float NDF = DistributionGGX(N, H, roughness);
				float G = GeometrySmith(N, V, L, roughness);
				vec3 F = fresnelSchlick(glm::max(glm::dot(H, V), 0.0f), F0);

				vec3 nominator = NDF*G*F;
				float denominator = 4 * glm::max(glm::dot(N, V), 0.0f) * glm::max(glm::dot(N, L), 0.0f) + 0.001f;
				vec3 specular = nominator / denominator;

				kS = F;
				kD = vec3(1.0) - kS;
				kD *= (1.0f - metallic);

				float NdotL = glm::clamp(glm::dot(N, L), 0.0f, 1.0f);

				Lo += (kD*albedo / glm::pi<float>() + specular) * radiance * NdotL;
			}

			vec3 ambient = vec3(0.03) * albedo * ao;

			vec3 tmpColor = ambient + Lo + emission;

			// hdr
			tmpColor = tmpColor / (tmpColor + vec3(1.0));
			// gamma correction
			tmpColor = glm::pow(tmpColor, vec3(1.0 / 2.2));

			lightedColor += glm::vec4(tmpColor, 1.0f);

			color += lightedColor * nowRay.decay;
		}
	}

	return color;
}

__global__ void RayTraceD(
	glm::vec4* data,
	float* randomNums,
	const int gridX,
	const int gridY,
	glm::mat4 view,
	OctreeNode* root,
	AABB* boundingboxes, int boxNum,
	Triangle* triangles, int triangleNum,
	Sphere* spheres, int sphereNum,
	Light* lights, int lightNum,
	Material* materials, int matNum)
{
	//unsigned int x = blockIdx.x * blockDim.x + threadIdx.x;
	unsigned int x = (blockIdx.x + gridY * RAY_Y_NUM) * WINDOW_HEIGHT + (threadIdx.x + gridX * RAY_X_NUM);
	glm::vec4 color = glm::vec4(0.0f);

	Ray rayQueue[QUEUE_SIZE];
	
	for (int i = 0; i < 2; i++)
	{
		for (int j = 0; j < 2; j++)
		{
			Ray ray = GenerateCameraRay(blockIdx.x + gridY * RAY_Y_NUM, threadIdx.x + gridX * RAY_X_NUM, view, i, j);

			ray.decay = 1.0f;

			// NOTICE for문을 돌릴 때 iter를 변수로 하니까 검은 화면이 나옴
			// y, x로 들어가고
			// 0, 0 좌표는 좌하단
			color += RayTraceColor(
				ray,
				rayQueue,
				randomNums,
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
				DEPTH);
		}
	}
	data[x] = color / 4.0f;
}

__global__ void random(float* result)
{
	unsigned int x = blockIdx.x * blockDim.x + threadIdx.x;

	curandState_t state;
	const int randomMax = 10000;

	curand_init(0, 0, 0, &state);
	int randNum = curand(&state) % randomMax;

	// theta 범위는 0 ~ 6.28
	if (x % 2 == 0)
		result[x] = (float)randNum / (float)randomMax * glm::pi<float>() * 2;
	// phi 범위는 0 ~ 3.14
	else
		result[x] = (float)randNum / (float)randomMax * glm::pi<float>();
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
	const vector<Material>& materials)
{
	thrust::device_vector<AABB> b = boundingboxes;
	thrust::device_vector<Triangle> t = triangles;
	thrust::device_vector<Sphere> s = spheres;
	thrust::device_vector<Light> l = lights;
	thrust::device_vector<Material> m = materials;

	cudaDeviceSetLimit(cudaLimitMallocHeapSize, 5000000000 * sizeof(float));

	float* randomThetaPi;
	// 엄밀히 말하면 sample^depth개의 random variable이 필요하지만 sample의 제곱으로 함
	cudaMalloc((void**)&randomThetaPi, sizeof(float) * SAMPLE_NUM * SAMPLE_NUM);

	random << <SAMPLE_NUM, SAMPLE_NUM>> > (randomThetaPi);

	vector<Triangle> tss;
	OctreeNode* d_root = BuildOctree(tss);

	RayTraceD << <RAY_Y_NUM, RAY_X_NUM >> > (
		data,
		randomThetaPi,
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
		m.size()
	);

	cudaFree(randomThetaPi);
}

void LoadCudaTextures()
{
	Texture2D texFile;
	texFile.LoadFixedTexture("Texture/RustedIron/albedo.png");
	texFile.SetParameters(GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE, GL_LINEAR, GL_LINEAR);
	float* texArray = texFile.GetTexImage(GL_RGBA);

	unsigned int size = 2048 * 2048 * 4 * sizeof(float);

	cudaChannelFormatDesc channelDesc = cudaCreateChannelDesc(32, 32, 32, 32, cudaChannelFormatKindFloat);
	cudaArray* cuArray;
	cudaMallocArray(&cuArray, &channelDesc, 2048, 2048);

	cudaMemcpyToArray(cuArray, 0, 0, texArray, size, cudaMemcpyHostToDevice);

	albedoTex.addressMode[0] = cudaAddressModeWrap;
	albedoTex.addressMode[1] = cudaAddressModeWrap;
	albedoTex.filterMode = cudaFilterModeLinear;
	albedoTex.normalized = true;

	cudaBindTextureToArray(albedoTex, cuArray, channelDesc);
	delete texArray;

	//////////////////////////////////////////////////////////////////////////////

	texFile.LoadFixedTexture("Texture/RustedIron/normal.png");
	texFile.SetParameters(GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE, GL_LINEAR, GL_LINEAR);
	texArray = texFile.GetTexImage(GL_RGBA);

	size = 2048 * 2048 * 4 * sizeof(float);

	cuArray;
	cudaMallocArray(&cuArray, &channelDesc, 2048, 2048);

	cudaMemcpyToArray(cuArray, 0, 0, texArray, size, cudaMemcpyHostToDevice);

	normalTex.addressMode[0] = cudaAddressModeWrap;
	normalTex.addressMode[1] = cudaAddressModeWrap;
	normalTex.filterMode = cudaFilterModeLinear;
	normalTex.normalized = true;

	cudaBindTextureToArray(normalTex, cuArray, channelDesc);
	delete texArray;

	//////////////////////////////////////////////////////////////////////////////
	//channelDesc = cudaCreateChannelDesc(32, 0, 0, 0, cudaChannelFormatKindFloat);

	texFile.LoadFixedTexture("Texture/RustedIron/ao.png");
	texFile.SetParameters(GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE, GL_LINEAR, GL_LINEAR);
	texArray = texFile.GetTexImage(GL_RGBA);

	size = 2048 * 2048 * 4 * sizeof(float);

	cuArray;
	cudaMallocArray(&cuArray, &channelDesc, 2048, 2048);

	cudaMemcpyToArray(cuArray, 0, 0, texArray, size, cudaMemcpyHostToDevice);

	aoTex.addressMode[0] = cudaAddressModeWrap;
	aoTex.addressMode[1] = cudaAddressModeWrap;
	aoTex.filterMode = cudaFilterModeLinear;
	aoTex.normalized = true;

	cudaBindTextureToArray(aoTex, cuArray, channelDesc);
	delete texArray;

	//////////////////////////////////////////////////////////////////////////////

	texFile.LoadFixedTexture("Texture/RustedIron/metallic.png");
	texFile.SetParameters(GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE, GL_LINEAR, GL_LINEAR);
	texArray = texFile.GetTexImage(GL_RGBA);

	size = 2048 * 2048 * 4 * sizeof(float);

	cuArray;
	cudaMallocArray(&cuArray, &channelDesc, 2048, 2048);

	cudaMemcpyToArray(cuArray, 0, 0, texArray, size, cudaMemcpyHostToDevice);

	metallicTex.addressMode[0] = cudaAddressModeWrap;
	metallicTex.addressMode[1] = cudaAddressModeWrap;
	metallicTex.filterMode = cudaFilterModeLinear;
	metallicTex.normalized = true;

	cudaBindTextureToArray(metallicTex, cuArray, channelDesc);
	delete texArray;

	//////////////////////////////////////////////////////////////////////////////

	texFile.LoadFixedTexture("Texture/RustedIron/roughness.png");
	texFile.SetParameters(GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE, GL_LINEAR, GL_LINEAR);
	texArray = texFile.GetTexImage(GL_RGBA);

	size = 2048 * 2048 * 4 * sizeof(float);

	cuArray;
	cudaMallocArray(&cuArray, &channelDesc, 2048, 2048);

	cudaMemcpyToArray(cuArray, 0, 0, texArray, size, cudaMemcpyHostToDevice);

	roughnessTex.addressMode[0] = cudaAddressModeWrap;
	roughnessTex.addressMode[1] = cudaAddressModeWrap;
	roughnessTex.filterMode = cudaFilterModeLinear;
	roughnessTex.normalized = true;

	cudaBindTextureToArray(roughnessTex, cuArray, channelDesc);
	delete texArray;

	//////////////////////////////////////////////////////////////////////////////

	texFile.LoadFixedTexture("Texture/Background/stripe.png");
	texFile.SetParameters(GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE, GL_LINEAR, GL_LINEAR);
	texArray = texFile.GetTexImage(GL_RGBA);

	size = 2048 * 2048 * 4 * sizeof(float);

	cuArray;
	cudaMallocArray(&cuArray, &channelDesc, 2048, 2048);

	cudaMemcpyToArray(cuArray, 0, 0, texArray, size, cudaMemcpyHostToDevice);

	backgroundTex.addressMode[0] = cudaAddressModeWrap;
	backgroundTex.addressMode[1] = cudaAddressModeWrap;
	backgroundTex.filterMode = cudaFilterModeLinear;
	backgroundTex.normalized = true;

	cudaBindTextureToArray(backgroundTex, cuArray, channelDesc);
	delete texArray;
}