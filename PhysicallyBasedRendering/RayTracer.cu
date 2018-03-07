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

struct RayNode
{
	Ray ray;
	int depth = 1;
};

struct Sphere
{
	glm::vec3 origin;
	float radius;
};

const int WINDOW_HEIGHT = 1024;
const int WINDOW_WIDTH = 1024;

using std::queue;

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

__device__ Ray GenerateCameraRay(int y, int x, glm::mat4 view)
{
	Ray ray;

	float NDCy = (y + 0.5f) / WINDOW_HEIGHT;
	float NDCx = (x + 0.5f) / WINDOW_WIDTH;

	float aspectRatio = WINDOW_WIDTH / WINDOW_HEIGHT;

	float fov = 45.0f;

	float xx = ((NDCx) * 2.0f - 1.0f) * tan(fov *0.5f * 3.141592653f / 180.0f) * aspectRatio;
	float yy = (1.0f - NDCy * 2.0f) * tan(fov * 0.5f * 3.141592653f / 180.0f);

	// -1 ~ 1
	ray.origin = glm::vec3(-view * glm::vec4(0.0f, 0.0f, 0.0f, 1.0f));
	ray.dir = normalize(vec3(view * vec4(glm::vec3(xx, yy, -1.0), 0.0f)));

	return ray;
}

__device__ vec3 GenerateRayQueue(
	Ray ray, 
	RayNode* rayQueue, 
	Triangle* triangles, 
	int triangleNum, 
	Light* lights, 
	int lightNum, 
	int depth)
{
	vec3 color = vec3(0.0f);
	int front = 0, rear = 0;

	// 첫 번째 ray를 node로 하는 queue 생성
	RayNode rayNode;
	rayNode.ray = ray;
	rayNode.depth = 1;

	rayQueue[front] = rayNode;
	front++;

	// 총 7 (1 + 2 + 4)개의 ray가 나옴
	for (int d = 0; d < depth; d++)
	{
		int target = front;

		while (rear < target)
		{
			Ray nowRay = rayQueue[rear].ray;
			const int nowDepth = rayQueue[rear].depth;
			rear++;

			float distToTriangle;
			float minDistToTriangle = 99999999.0f;
			glm::vec3 minColor = glm::vec3(0, 0, 0);

			for (int i = 0; i < triangleNum; i++)
			{
				// intersect 할 경우
				// reflect ray와 refract ray 생성
				if (RayTriangleIntersect(nowRay, triangles[i], distToTriangle))
				{
					if (distToTriangle < 1.0f) {
						continue;
					}

					// 가장 앞에 있는 픽셀만 그리기
					if (distToTriangle < minDistToTriangle)
					{
						minDistToTriangle = distToTriangle;

						for (int j = 0; j < lightNum; j++)
						{
							glm::vec3 hitPoint = nowRay.origin + nowRay.dir * distToTriangle;

							Ray shadowRay;
							shadowRay.origin = hitPoint;
							shadowRay.dir = normalize(lights[j].pos - hitPoint);

							bool isLighted = true;
							float tmp;
							for (int k = 0; k < triangleNum; k++)
							{
								if (i != k)
									if (RayTriangleIntersect(shadowRay, triangles[k], tmp))
										// 앞쪽의 dir만 봄
										if (tmp > 0.0f)
											isLighted = false;
							}

							if (!isLighted)
							{
								//color = glm::vec3(0.1f, 0.1f, 0.1f);
								continue;
							}

							glm::vec3 L = glm::normalize(lights[j].pos - hitPoint);
							glm::vec3 N = normalize(triangles[i].normal);
							glm::vec3 V = -nowRay.dir;

							glm::vec3 ambient = glm::vec3(0.2, 0.2, 0.2) * lights[j].color;
							glm::vec3 diffuse = glm::vec3(0.3, 0.3, 0.3) * lights[j].color * glm::max(0.0f, dot(N, L));
							glm::vec3 specular = glm::vec3(0.1, 0.8, 0.2) * lights[j].color * glm::max(0.0f, pow(glm::max(dot(normalize(reflect(-L, N)), V), 0.0f), 16));

							glm::vec3 col = ambient + diffuse + specular;

							//float s = (float)glm::floor(glm::log((float)nowDepth) / glm::log(2.0f));
							//color += col * pow(0.2f, s);
							minColor = col;

							Ray reflectRay;
							reflectRay.origin = hitPoint;
							reflectRay.dir = normalize(reflect(-L, N));

							rayQueue[front].depth = nowDepth + 1;
							rayQueue[front].ray = reflectRay;
							front++;

							Ray refractRay;
							refractRay.origin = hitPoint;
							refractRay.dir = normalize(refract(-L, N, 2.0f));

							rayQueue[front].depth = nowDepth + 1;
							rayQueue[front].ray = refractRay;
							front++;

							//data = i*scalingfactor*color;
						}
					}
				}
			}
			
			float s = (float)glm::floor(glm::log((float)nowDepth) / glm::log(2.0f));
			color += minColor * pow(0.2f, s);
		}
	}

	// 나오지 못한 queue들 나오게 하기
	while (rear < front)
	{
		rear++;
		// color 계산
	}

	return color;
}

//__device__ vec3 RayTraceColor(Ray ray, Triangle* triangles, int triangleNum, Light* lights, int lightNum, int depth)
//{
//	if (depth <= 0)
//		return vec3(0.0f);
//
//	vec3 color = vec3(0.0f);
//
//	float distToTriangle;
//	float minDistToTriangle = 99999999.0f;
//
//	for (int i = 0; i < triangleNum; i++)
//	{
//		if (RayTriangleIntersect(ray, triangles[i], distToTriangle))
//		{
//			// 가장 앞에 있는 픽셀만 그리기
//			if (distToTriangle < minDistToTriangle)
//			{
//				minDistToTriangle = distToTriangle;
//
//				for (int j = 0; j < lightNum; j++)
//				{
//					glm::vec3 hitPoint = ray.origin + ray.dir * distToTriangle;
//
//					Ray shadowRay;
//					shadowRay.origin = hitPoint;
//					shadowRay.dir = normalize(lights[j].pos - hitPoint);
//
//					bool isLighted = true;
//					float tmp;
//					for (int k = 0; k < triangleNum; k++)
//					{
//						if (i != k)
//							if (RayTriangleIntersect(shadowRay, triangles[k], tmp))
//								// 앞쪽의 dir만 봄
//								if (tmp > 0.0f)
//									isLighted = false;
//					}
//
//					if (!isLighted)
//					{
//						color = glm::vec3(0.1f, 0.1f, 0.1f);
//						continue;
//					}
//
//					glm::vec3 L = glm::normalize(lights[j].pos - hitPoint);
//					glm::vec3 N = normalize(triangles[i].normal);
//					glm::vec3 V = -ray.dir;
//
//					glm::vec3 ambient = glm::vec3(0.2, 0.2, 0.2) * lights[j].color;
//					glm::vec3 diffuse = glm::vec3(0.3, 0.3, 0.3) * lights[j].color * glm::max(0.0f, dot(N, L));
//					glm::vec3 specular = glm::vec3(0.1, 0.8, 0.2) * lights[j].color * glm::max(0.0f, pow(glm::max(dot(normalize(reflect(-L, N)), V), 0.0f), 16));
//
//					glm::vec3 col = ambient + diffuse + specular;
//
//					color = col;
//
//					if (depth > 1)
//					{
//						Ray reflectRay;
//						reflectRay.origin = hitPoint;
//						reflectRay.dir = normalize(reflect(-L, N));
//
//						//glm::vec3 C1 = RayTraceColor(reflectRay, triangles, triangleNum, lights, lightNum, depth - 1) * 0.0002f;
//						////////////////////////////////////////////////////////////////////////////////////
//
//						// 굴절률이 높다는 것은 더 휘어져서 들어간다는 것, (normal 방향으로 휘어짐)
//						Ray refractRay;
//						refractRay.origin = hitPoint;
//						refractRay.dir = normalize(refract(-L, N, 2.0f));
//
//						///////////////// Naive Algorithm without Recursion ////////////////////////////////
//						//
//
//						//color += RayTraceColor(refractRay, triangles, triangleNum, lights, lightNum, depth - 1) * 0.0002f;
//						//glm::vec3 C2 = RayTraceColor(refractRay, triangles, triangleNum, lights, lightNum, depth - 1) * 0.0002f;
//
//						////////////////////////////////////////////////////////////////////////////////////
//					}
//				}
//			}
//		}
//	}
//
//	return color;
//}

// TODO view matrix를 점검할 것
__global__ void RayTraceD(
	glm::vec4* data,
	glm::mat4 view,
	Triangle* triangles, int triangleNum,
	Light* lights, int lightNum,
	RayNode* rayQueue, int queueSize)
{
	unsigned int x = blockIdx.x * blockDim.x + threadIdx.x;

	Ray ray = GenerateCameraRay(blockIdx.x, threadIdx.x, view);

	rayQueue = new RayNode[1+2+4];

	// ray들을 생성하고 queue에 넣는 과정
	vec3 color = GenerateRayQueue(ray, rayQueue, triangles, triangleNum, lights, lightNum, 2);

	delete[] rayQueue;

	// ray들을 queue에서 꺼내면서 color를 정하는 과정

	//vec3 color = RayTraceColor(ray, triangles, triangleNum, lights, lightNum, 1);

	data[x] = glm::vec4(color, 1.0f);
}

//void RayTrace(glm::vec4* data, glm::mat4 view, Triangle* triangles, int triangleNum)
void RayTrace(glm::vec4* data, glm::mat4 view, const vector<Triangle> &triangles, const vector<Light>& lights)
{
	thrust::device_vector<Triangle> t = triangles;
	thrust::device_vector<Light> l = lights;

	std::vector<RayNode> hQueue;
	hQueue.resize(7);

	thrust::device_vector<RayNode> dQueue = hQueue;

	size_t size;
	cudaDeviceSetLimit(cudaLimitMallocHeapSize, 100000000 * sizeof(float));
	cudaDeviceGetLimit(&size, cudaLimitMallocHeapSize);


	RayTraceD << <WINDOW_HEIGHT, WINDOW_WIDTH >> > (
		data,
		view,
		t.data().get(),
		t.size(),
		l.data().get(),
		l.size(),
		dQueue.data().get(),
		dQueue.size());
}