#include "RayTracer.cuh"
#include <cuda.h>
#include <cuda_runtime.h>
#include <glm\glm.hpp>
#include <stdio.h>
#include <glm\gtc\matrix_transform.hpp>
#include <math_constants.h>
#include <math.h>

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

	float t = dot(v0v2, qvec) * invDet;

	return true;
}

// Camera functions
///////////////////
__device__ Ray GenerateCameraRay(int y, int x, glm::mat4 view)
{
	Ray ray;

	float NDCy = (y + 0.5f) / WINDOW_HEIGHT;
	float NDCx = (x + 0.5f) / WINDOW_WIDTH;

	float aspectRatio = WINDOW_WIDTH / WINDOW_HEIGHT;

	float fov = 45.0f;

	float xx = (((float)(x + 0.5f) / (float)WINDOW_WIDTH) * 2.0f - 1.0f) * tan(fov *0.5f * 3.141592653f / 180.0f) * aspectRatio;
	float yy = (1.0f - ((float)(y + 0.5f) / (float)WINDOW_HEIGHT) * 2.0f) * tan(fov * 0.5f * 3.141592653f / 180.0f);

	//// -1 ~ 1
	ray.origin = glm::vec3(-view * glm::vec4(0.0f, 0.0f, 0.0f, 1.0f));
	ray.dir = normalize(vec3(view * vec4(glm::vec3(xx, yy, -1.0), 0.0f)));

	//// view matrix의 translate 성분만 가져옴
	//ray.origin = (-view*vec4(vec3(0.0), 1)).xyz;
	//// view matrix의 rotate 성분을 가져옴
	//ray.dir = normalize((view*vec4(ray.dir, 0)).xyz);
	//// view matrix는 camera 기준의 x, y, z축을 column으로 두기 때문에(normalize됨) scale 성분이 의미가 없음 

	return ray;
}

__global__ void RayTraceD(glm::vec4* data, glm::mat4 view, Triangle* triangles)
{
	unsigned int x = blockIdx.x * blockDim.x + threadIdx.x;

	Ray ray = GenerateCameraRay(blockIdx.x, threadIdx.x, view);

	Sphere sphere;
	sphere.origin = glm::vec3(0.0f, 0.0f, -20.0f);
	sphere.radius = 2.0f;

	Sphere sphere2;
	sphere2.origin = glm::vec3(3.0f, 0.0f, -20.0f);
	sphere2.radius = 2.0f;

	Triangle triangle;
	triangle.v0 = glm::vec3(0.0f, 0.0f, -5.0f);
	triangle.v1 = glm::vec3(1.0f, 0.0f, -5.0f);
	triangle.v2 = glm::vec3(1.0f, 1.0f, -5.0f);

	float distToSphere, distToTriangle;

	glm::vec3 lightPos = glm::vec3(10.0f, 0.0f, 0.0f);

	if (RaySphereIntersect(ray, sphere, distToSphere))
	{
		glm::vec3 hitPoint = ray.origin + ray.dir * distToSphere;
		glm::vec3 L = glm::normalize(lightPos - hitPoint);
		glm::vec3 N = normalize(hitPoint - sphere.origin);

		glm::vec3 ambient = glm::vec3(0.2, 0.2, 0.2);

		glm::vec3 diffuse = glm::vec3(0.1, 0.4, 0.2) * glm::max(0.0f, dot(N, L));

		glm::vec3 V = -ray.dir;

		glm::vec3 specular = glm::vec3(0.1, 0.4, 0.2) * glm::max(0.0f, pow(glm::max(dot(normalize(reflect(-L, N)), V), 0.0f), 16));

		glm::vec3 col = ambient + diffuse + specular;

		data[x] = glm::vec4(col.x, col.y, col.z, 1.0f);
	}
	else if (RaySphereIntersect(ray, sphere2, distToSphere))
	{
		glm::vec3 hitPoint = ray.origin + ray.dir * distToSphere;
		glm::vec3 L = normalize(lightPos - hitPoint);
		glm::vec3 N = normalize(hitPoint - sphere2.origin);

		glm::vec3 ambient = glm::vec3(0.2, 0.2, 0.2);

		glm::vec3 diffuse = glm::vec3(0.1, 0.4, 0.2) * glm::max(0.0f, dot(N, L));

		glm::vec3 V = -ray.dir;

		glm::vec3 specular = glm::vec3(0.1, 0.4, 0.2) * glm::max(0.0f, pow(glm::max(dot(normalize(reflect(-L, N)), V), 0.0f), 16));

		glm::vec3 col = ambient + diffuse + specular;

		data[x] = glm::vec4(col.x, col.y, col.z, 1.0f);
	}
	else if (RayTriangleIntersect(ray, triangle, distToTriangle))
	{
		data[x] = glm::vec4(1.0f, 0.0f, 0.0f, 1.0f);
	}
	else
	{
		data[x] = glm::vec4(0.0f, 0.0f, 0.0f, 1.0f);
	}
}

void RayTrace(glm::vec4* data, glm::mat4 view, Triangle* triangles)
{
	RayTraceD << <WINDOW_HEIGHT, WINDOW_WIDTH >> > (data, view, triangles);
}