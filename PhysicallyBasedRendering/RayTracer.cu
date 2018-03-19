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

// TODO LIST
// 1. per line draw to eliminate kernel time out problem
// 2. octree acceleration
// 3. mtl file load
// 4. texture mapping with interpolation
// 5. monte calro path tracer

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

// back face culling�� ����Ǿ� ����
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

// ���� ����� triangle�� id�� ��ȯ�ϰ� �ش� �������� dist�� �����´�
__device__ int FindNearestTriangleIdx(Ray ray, Triangle* triangles, int triangleNum, float& dist)
{
	const float rayThreshold = 0.001f;
	float minDist = 9999999.0f;
	int minIdx = -1;
	float tmpDist;

	// �״�� dist�� �����ͼ� ����ϴϱ� �̻�����
	for (int i = 0; i < triangleNum; ++i)
	{
		// intersect �� ���
		if (RayTriangleIntersect(ray, triangles[i], tmpDist))
		{
			// �� ã�� ���, �ٽ� ã�� �ʱ�
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
	float NDCy = (y + 0.5f) / WINDOW_HEIGHT;
	float NDCx = (x + 0.5f) / WINDOW_WIDTH;

	float aspectRatio = WINDOW_WIDTH / WINDOW_HEIGHT;

	float fov = 45.0f;

	// -1 ~ 1
	// tan(halfRadian)
	float xx = (NDCx * 2.0f - 1.0f) * tan(fov * 0.5f * 3.141592653f / 180.0f) * aspectRatio;
	float yy = (NDCy * 2.0f - 1.0f) * tan(fov * 0.5f * 3.141592653f / 180.0f);

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

// hit point, selected light, all triangles, nearestTriangleIdx
__device__ vec3 RayCastColor(
	vec3 V,
	vec3 hitPoint, 
	Light light, 
	Triangle* triangles, 
	const int triangleNum, 
	Material* materials,
	const int nearestTriangleIdx)
{
	vec3 color = glm::vec3(0.0f, 0.0f, 0.0f);

	Ray shadowRay;
	shadowRay.origin = hitPoint;
	shadowRay.dir = normalize(light.pos - hitPoint);

	bool isLighted = true;
	float tmp;
	for (int k = 0; k < triangleNum; k++)
	{
		if (nearestTriangleIdx != k)
			if (RayTriangleIntersect(shadowRay, triangles[k], tmp))
				// ������ dir�� ��
				if (tmp > 0.0001f)
					isLighted = false;
	}

	if (isLighted)
	{
		Triangle nearestTriangle = triangles[nearestTriangleIdx];

		glm::vec3 N = nearestTriangle.normal;
		glm::vec3 L = glm::normalize(light.pos - hitPoint);

		glm::vec3 matAmbient = materials[nearestTriangle.matrialId].ambient;
		glm::vec3 matDiffuse = materials[nearestTriangle.matrialId].diffuse;
		glm::vec3 matSpecular = materials[nearestTriangle.matrialId].specular;

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

		color = glm::vec4(glm::vec3(ambient + diffuse + specular), 1.0f);
	}

	return color;
}

__device__ vec4 RayTraceColor(
	Ray ray,
	Ray* rayQueue,
	Triangle* triangles,
	int triangleNum,
	Light* lights,
	int lightNum,
	Material* materials,
	int matNum,
	int depth)
{
	vec4 color = vec4(0.0f);
	int front = 0, rear = 0;

	// ù ��° ray�� node�� �ϴ� queue ����
	Enqueue(rayQueue, ray, rear);

	int nowDepth = 1;

	// �� 7 (1 + 2 + 4)���� ray�� ����
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
			
			// �� ã�Ұų� ���ʿ� �ִٸ�
			if (nearestTriangleIdx == -1 || distToTriangle < 0.0f)
				continue;

			Triangle nearestTriangle = triangles[nearestTriangleIdx];
			glm::vec3 N = glm::normalize(nearestTriangle.normal);

			glm::vec4 lightedColor = glm::vec4(0.0f);
			glm::vec3 hitPoint = nowRay.origin + nowRay.dir * distToTriangle;

			for (int k = 0; k < lightNum; k++)
			{
				lightedColor += glm::vec4(
					RayCastColor(-nowRay.dir, hitPoint, lights[k], triangles, triangleNum, materials, nearestTriangleIdx)
					, 1.0f);
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
			color += lightedColor * pow(0.2f, s);
		}

		nowDepth++;
	}

	// ������ ���� queue�� ������ �ϱ�
	while (!IsQueueEmpty(front, rear))
	{
		Ray nowRay;
		nowRay = GetQueueFront(rayQueue, front);
		Dequeue(rayQueue, front);

		float distToTriangle;
		int nearestTriangleIdx = FindNearestTriangleIdx(nowRay, triangles, triangleNum, distToTriangle);
		
		// �� ã�Ұų� ���ʿ� �ִٸ�
		if (nearestTriangleIdx == -1 || distToTriangle < 0.0f)
			continue;

		Triangle nearestTriangle = triangles[nearestTriangleIdx];
		glm::vec3 N = normalize(nearestTriangle.normal);

		glm::vec4 lightedColor = glm::vec4(0.0f);
		glm::vec3 hitPoint = nowRay.origin + nowRay.dir * distToTriangle;

		for (int k = 0; k < lightNum; k++)
		{
			lightedColor += glm::vec4(
				RayCastColor(-nowRay.dir, hitPoint, lights[k], triangles, triangleNum, materials, nearestTriangleIdx)
				, 1.0f);
		}

		float s = (float)glm::floor(glm::log((float)nowDepth) / glm::log(2.0f));
		color += lightedColor * pow(0.2f, s);
	}

	return color;
}

// TODO view matrix�� ������ ��
__global__ void RayTraceD(
	glm::vec4* data,
	glm::mat4 view,
	Triangle* triangles, int triangleNum,
	Light* lights, int lightNum,
	Material* materials, int matNum)
{
	unsigned int x = blockIdx.x * blockDim.x + threadIdx.x;

	Ray ray = GenerateCameraRay(blockIdx.x, threadIdx.x, view);

	Ray rayQueue[QUEUE_SIZE];

	// y, x�� ����
	// 0, 0 ��ǥ�� ���ϴ�
	vec4 color = RayTraceColor(ray, rayQueue, triangles, triangleNum, lights, lightNum, materials, matNum, 2);

	data[x] = color;
}

void RayTrace(
	glm::vec4* data, 
	glm::mat4 view, 
	const vector<Triangle> &triangles, 
	const vector<Light>& lights,
	const vector<Material>& materials)
{
	thrust::device_vector<Triangle> t = triangles;
	thrust::device_vector<Light> l = lights;
	thrust::device_vector<Material> m = materials;

	size_t size;
	cudaDeviceSetLimit(cudaLimitMallocHeapSize, 10000000 * sizeof(float));
	cudaDeviceGetLimit(&size, cudaLimitMallocHeapSize);

	RayTraceD << <WINDOW_HEIGHT, WINDOW_WIDTH >> > (
		data,
		view,
		t.data().get(),
		t.size(),
		l.data().get(),
		l.size(),
		m.data().get(),
		m.size()
		);
}