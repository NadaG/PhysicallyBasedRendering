#include "RayTracer.cuh"
#include <cuda.h>
#include <cuda_runtime.h>
#include <stdio.h>

#include <math.h>

struct Ray
{
	float3 origin;
	float3 dir;
};

struct Sphere
{
	float3 origin;
	float radius;
};

struct Triangle
{
	float3 v0;
	float3 v1;
	float3 v2;
};

__device__ float3 operator+(const float3& a, const float3& b)
{
	return make_float3(a.x + b.x, a.y + b.y, a.z + b.z);
}

__device__ float3 operator-(const float3& a, const float3& b)
{
	return make_float3(a.x - b.x, a.y - b.y, a.z - b.z);
}

__device__ float3 operator-(const float3& a)
{
	return make_float3(-a.x, -a.y, -a.z);
}

__device__ float3 operator*(const float3& a, const float& b)
{
	return make_float3(a.x * b, a.y * b, a.z * b);
}

__device__ float3 operator*(const float& a, const float3& b)
{
	return b * a;
}

__device__ float mymax(const float x, const float y)
{
	return x > y ? x : y;
}

__device__ float dot(const float3& a, const float3& b)
{
	return a.x*b.x + a.y*b.y + a.z*b.z;
}

__device__ float3 cross(const float3& a, const float3& b)
{
	return make_float3(a.y*b.z - a.z*b.y, -(a.x*b.z - a.z*b.x), a.x*b.y - a.y*b.x);
}

__device__ float3 reflect(const float3& i, const float3& n)
{
	return i - 2.0f * dot(n, i) * n;
}

__device__ float3 normalize(float3 v)
{
	float3 normalizedV;
	float length = (float)sqrt(dot(v, v));
	normalizedV.x = v.x / length;
	normalizedV.y = v.y / length;
	normalizedV.z = v.z / length;
	return normalizedV;
}

__device__ bool RaySphereIntersect(Ray ray, Sphere sphere, float& dist)
{
	float3 s = ray.origin - sphere.origin;

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
	float3 v0v1 = triangle.v1 - triangle.v0;
	float3 v0v2 = triangle.v2 - triangle.v0;
	float3 pvec = cross(ray.dir, v0v2);

	float det = dot(v0v1, pvec);

	float epsilon = 0.0001f;

	if (det < epsilon) 
		return false;
	
	if (fabs(det) < epsilon)
		return false;

	float invDet = 1 / det;

	float3 tvec = ray.origin - triangle.v0;
	float u = dot(tvec, pvec) * invDet;
	if (u < 0 || u > 1)
		return false;

	float3 qvec = cross(tvec, v0v1);
	float v = dot(ray.dir, qvec) * invDet;
	if (v < 0 || u + v > 1)
		return false;

	float t = dot(v0v2, qvec) * invDet;

	return true;
}

// Camera functions
///////////////////
__device__ Ray GenerateCameraRay(int y, int x)
{
	Ray ray;

	float yy = ((float)y / (float)1024 - 0.5f) * 2.0f;
	float xx = ((float)x / (float)1024 - 0.5f) * 2.0f;

	//// -1 ~ 1
	ray.origin = make_float3(0.0f, 0.0f, 0.0f);
	ray.dir = normalize(make_float3(xx, -yy, -1.0));

	//// view matrix의 translate 성분만 가져옴
	//ray.origin = (-view*vec4(vec3(0.0), 1)).xyz;
	//// view matrix의 rotate 성분을 가져옴
	//ray.dir = normalize((view*vec4(ray.dir, 0)).xyz);
	//// view matrix는 camera 기준의 x, y, z축을 column으로 두기 때문에(normalize됨) scale 성분이 의미가 없음 

	return ray;
}

__global__ void RayTraceD(float4* data)
{
	unsigned int x = blockIdx.x * blockDim.x + threadIdx.x;

	Ray ray = GenerateCameraRay(blockIdx.x, threadIdx.x);

	Sphere sphere;
	sphere.origin = make_float3(0.0f, 0.0f, -5.0f);
	sphere.radius = 0.1f;

	Triangle triangle;
	triangle.v0 = make_float3(0.0f, 0.0f, -5.0f);
	triangle.v1 = make_float3(3.0f, 0.0f, -5.0f);
	triangle.v2 = make_float3(1.0f, 3.0f, -5.0f);

	float distToSphere, distToTriangle;

	float3 lightPos = make_float3(10.0f, 0.0f, 0.0f);

	if (RaySphereIntersect(ray, sphere, distToSphere))
	{
		float3 hitPoint = ray.origin + ray.dir * distToSphere;
		float3 L = normalize(lightPos - hitPoint);
		float3 N = normalize(hitPoint - sphere.origin);

		float3 ambient = make_float3(0.2, 0.2, 0.2);

		float3 diffuse = make_float3(0.1, 0.4, 0.2) * mymax(0, dot(N, L));

		float3 V = -ray.dir;

		float3 specular = make_float3(0.1, 0.4, 0.2) * mymax(0, pow(mymax(dot(normalize(reflect(-L, N)), V), 0.0), 16));

		float3 col = ambient + diffuse + specular;

		data[x].x = col.x;
		data[x].y = col.y;
		data[x].z = col.z;
	}
	else if (RayTriangleIntersect(ray, triangle, distToTriangle))
	{
		data[x].x = 1.0f;
		data[x].y = 0.0f;
		data[x].z = 0.0f;
	}
	else
	{
		data[x].x = 0.0f;
		data[x].y = 0.0f;
		data[x].z = 0.0f;
	}
	
	data[x].w = 1.0f;
}

void RayTrace(float4* data)
{
	RayTraceD << <1024, 1024 >> > (data);
}