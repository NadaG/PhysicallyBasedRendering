#include "RayTracer.cuh"
#include <cuda.h>
#include <cuda_runtime.h>
#include <glm\glm.hpp>
#include <stdio.h>
#include <glm\gtc\matrix_transform.hpp>
#include <math_constants.h>
#include <math.h>
#include <thrust\device_vector.h>
#include <queue>

struct Ray
{
	glm::vec3 origin;
	glm::vec3 dir;
};

struct Sphere
{
	glm::vec3 origin;
	float radius;
};

const int WINDOW_HEIGHT = 1024;
const int WINDOW_WIDTH = 1024;

const int QUEUE_SIZE = 3;

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

__device__ Ray GenerateCameraRay(int y, int x, glm::mat4 view)
{
	Ray ray;

	float NDCy = (y + 0.5f) / WINDOW_HEIGHT;
	float NDCx = (x + 0.5f) / WINDOW_WIDTH;

	float aspectRatio = WINDOW_WIDTH / WINDOW_HEIGHT;

	float fov = 45.0f;

	float xx = ((NDCx) * 2.0f - 1.0f) * tan(fov * 0.5f * 3.141592653f / 180.0f) * aspectRatio;
	float yy = (1.0f - NDCy * 2.0f) * tan(fov * 0.5f * 3.141592653f / 180.0f);

	// -1 ~ 1
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

__device__ vec3 GenerateRayQueue(
	Ray ray,
	Ray* rayQueue,
	Triangle* triangles,
	int triangleNum,
	Light* lights,
	int lightNum,
	int depth)
{
	vec3 color = vec3(0.0f);
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

			float distToTriangle;
			int nearestTriangleIdx = FindNearestTriangleIdx(nowRay, triangles, triangleNum, distToTriangle);
			if (nearestTriangleIdx == -1 || distToTriangle < 0.0f)
			{
				color += vec3(0.0f, 0.0f, 0.0f);
				continue;
			}

			Triangle nearestTriangle = triangles[nearestTriangleIdx];
			glm::vec3 N = normalize(nearestTriangle.normal);

			glm::vec3 col = glm::vec3(0, 0, 0);
			glm::vec3 hitPoint = nowRay.origin + nowRay.dir * distToTriangle;

			for (int k = 0; k < lightNum; k++)
			{
				Ray shadowRay;
				shadowRay.origin = hitPoint;
				shadowRay.dir = normalize(lights[k].pos - hitPoint);

				bool isLighted = true;
				float tmp;
				for (int k = 0; k < triangleNum; k++)
				{
					if (nearestTriangleIdx != k)
						if (RayTriangleIntersect(shadowRay, triangles[k], tmp))
							// 앞쪽의 dir만 봄
							if (tmp > 0.0001f)
								isLighted = false;
				}

				if (!isLighted)
					continue;

				glm::vec3 L = glm::normalize(lights[k].pos - hitPoint);
				glm::vec3 V = -nowRay.dir;

				glm::vec3 ambient = glm::vec3(0.2, 0.2, 0.2) * lights[k].color;
				glm::vec3 diffuse = glm::vec3(0.3, 0.3, 0.3) * lights[k].color * glm::max(0.0f, dot(N, L));
				glm::vec3 specular = glm::vec3(0.1, 0.8, 0.2) * lights[k].color * glm::max(0.0f, pow(glm::max(dot(normalize(reflect(-L, N)), V), 0.0f), 16));

				col = ambient + diffuse + specular;
			}

			Ray reflectRay;
			reflectRay.origin = hitPoint;
			reflectRay.dir = normalize(reflect(nowRay.dir, N));

			Ray refractRay;
			refractRay.origin = hitPoint;
			refractRay.dir = normalize(refract(nowRay.dir, N, 1.2f));

			Enqueue(rayQueue, reflectRay, rear);
			Enqueue(rayQueue, refractRay, rear);

			float s = (float)glm::floor(glm::log((float)nowDepth) / glm::log(2.0f));
			color += col * pow(0.2f, s);

			color = col;
		}

		nowDepth++;
	}

	//int num = 1;
	// 나오지 못한 queue들 나오게 하기
	while (!IsQueueEmpty(front, rear))
	{
		Ray nowRay;
		nowRay = GetQueueFront(rayQueue, front);
		Dequeue(rayQueue, front);

		float distToTriangle;
		int nearestTriangleIdx = FindNearestTriangleIdx(nowRay, triangles, triangleNum, distToTriangle);
		if (nearestTriangleIdx == -1 || distToTriangle < 0.0f)
		{
			continue;
		}

		Triangle nearestTriangle = triangles[nearestTriangleIdx];
		glm::vec3 N = normalize(nearestTriangle.normal);

		glm::vec3 col = glm::vec3(0, 0, 0);
		glm::vec3 hitPoint = nowRay.origin + nowRay.dir * distToTriangle;

		for (int k = 0; k < lightNum; k++)
		{
			Ray shadowRay;
			shadowRay.origin = hitPoint;
			shadowRay.dir = normalize(lights[k].pos - hitPoint);

			bool isLighted = true;
			float tmp;
			for (int k = 0; k < triangleNum; k++)
			{
				if (nearestTriangleIdx != k)
					if (RayTriangleIntersect(shadowRay, triangles[k], tmp))
						// 앞쪽의 dir만 봄
						if (tmp > 0.0001f)
							isLighted = false;
			}

			if (!isLighted)
				continue;

			glm::vec3 L = glm::normalize(lights[k].pos - hitPoint);
			glm::vec3 V = -nowRay.dir;

			glm::vec3 ambient = glm::vec3(0.2, 0.2, 0.2) * lights[k].color;
			glm::vec3 diffuse = glm::vec3(0.3, 0.3, 0.3) * lights[k].color * glm::max(0.0f, dot(N, L));
			glm::vec3 specular = glm::vec3(0.1, 0.8, 0.2) * lights[k].color * glm::max(0.0f, pow(glm::max(dot(normalize(reflect(-L, N)), V), 0.0f), 16));

			col = ambient + diffuse + specular;
		}

		float s = (float)glm::floor(glm::log((float)nowDepth) / glm::log(2.0f));
		color += col * pow(0.2f, s);

		//////////////////////////////////////////////////////
		//Ray nowRay;

		//nowRay = GetQueueFront(rayQueue, front);
		//Dequeue(rayQueue, front);

		//float distToTriangle;
		//float minDistToTriangle = 99999999.0f;
		//glm::vec3 minColor = glm::vec3(0, 0, 0);

		//for (int i = 0; i < triangleNum; i++)
		//{
		//	// intersect 할 경우
		//	// reflect ray와 refract ray 생성
		//	if (RayTriangleIntersect(nowRay, triangles[i], distToTriangle))
		//	{
		//		if (distToTriangle < 0.0f) {
		//			continue;
		//		}

		//		// 가장 앞에 있는 픽셀만 그리기
		//		if (distToTriangle < minDistToTriangle)
		//		{
		//			minDistToTriangle = distToTriangle;

		//			for (int j = 0; j < lightNum; j++)
		//			{
		//				glm::vec3 hitPoint = nowRay.origin + nowRay.dir * distToTriangle;

		//				Ray shadowRay;
		//				shadowRay.origin = hitPoint;
		//				shadowRay.dir = normalize(lights[j].pos - hitPoint);

		//				bool isLighted = true;
		//				float tmp;
		//				for (int k = 0; k < triangleNum; k++)
		//				{
		//					if (i != k)
		//						if (RayTriangleIntersect(shadowRay, triangles[k], tmp))
		//							// 앞쪽의 dir만 봄
		//							if (tmp > 0.0f)
		//								isLighted = false;
		//				}

		//				if (!isLighted)
		//				{
		//					continue;
		//				}

		//				glm::vec3 L = glm::normalize(lights[j].pos - hitPoint);
		//				glm::vec3 N = normalize(triangles[i].normal);
		//				glm::vec3 V = -nowRay.dir;

		//				glm::vec3 ambient = glm::vec3(0.2, 0.2, 0.2) * lights[j].color;
		//				glm::vec3 diffuse = glm::vec3(0.3, 0.3, 0.3) * lights[j].color * glm::max(0.0f, dot(N, L));
		//				glm::vec3 specular = glm::vec3(0.1, 0.8, 0.2) * lights[j].color * glm::max(0.0f, pow(glm::max(dot(normalize(reflect(-L, N)), V), 0.0f), 16));

		//				glm::vec3 col = ambient + diffuse + specular;

		//				minColor = col;
		//			}
		//		}
		//	}
		//}

		//float s = (float)glm::floor(glm::log((float)nowDepth) / glm::log(2.0f));
		//color += minColor * 0.1f;
	}

	return color;
}

// TODO view matrix를 점검할 것
__global__ void RayTraceD(
	glm::vec4* data,
	glm::mat4 view,
	Triangle* triangles, int triangleNum,
	Light* lights, int lightNum)
{
	unsigned int x = blockIdx.x * blockDim.x + threadIdx.x;

	Ray ray = GenerateCameraRay(blockIdx.x, threadIdx.x, view);

	Ray rayQueue[3];

	vec3 color = GenerateRayQueue(ray, rayQueue, triangles, triangleNum, lights, lightNum, 2);

	data[x] = glm::vec4(color, 1.0f);
}

//void RayTrace(glm::vec4* data, glm::mat4 view, Triangle* triangles, int triangleNum)
void RayTrace(glm::vec4* data, glm::mat4 view, const vector<Triangle> &triangles, const vector<Light>& lights)
{
	thrust::device_vector<Triangle> t = triangles;
	thrust::device_vector<Light> l = lights;

	size_t size;
	cudaDeviceSetLimit(cudaLimitMallocHeapSize, 10000 * sizeof(float));
	cudaDeviceGetLimit(&size, cudaLimitMallocHeapSize);

	RayTraceD << <WINDOW_HEIGHT, WINDOW_WIDTH >> > (
		data,
		view,
		t.data().get(),
		t.size(),
		l.data().get(),
		l.size()
		);
}