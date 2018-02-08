#include "RayTracer.cuh"
#include <cuda.h>
#include <cuda_runtime.h>
#include <stdio.h>

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

__device__ bool RaySphereIntersect(Ray ray, Sphere sphere, float* t)
{
	//float3 s = ray.origin - sphere.origin;
	return true;

	/*float a = dot(ray.dir, ray.dir);
	float bPrime = dot(s, ray.dir);
	float c = dot(s, s) - sphere.radius * sphere.radius;

	float D = bPrime * bPrime - a * c;
	if (D >= 0 && bPrime <= 0)
	{
		float t1 = (-bPrime + sqrt(D)) / a;
		float t2 = (-bPrime - sqrt(D)) / a;
		t = t1 > t2 ? t2 : t1;
		return true;
	}
	else
		return false;*/
}

// Camera functions
///////////////////
__device__ Ray GenerateCameraRay()
{
	Ray ray;
	//// -1 ~ 1
	//float x = (outUV.x - 0.5) * 2.0;
	//float y = (outUV.y - 0.5) * 2.0;
	//ray.dir = normalize(vec3(x, y, -1.0));

	//ray.origin = vec3(0.0);

	//// view matrix�� translate ���и� ������
	//ray.origin = (-view*vec4(vec3(0.0), 1)).xyz;
	//// view matrix�� rotate ������ ������
	//ray.dir = normalize((view*vec4(ray.dir, 0)).xyz);
	//// view matrix�� camera ������ x, y, z���� column���� �α� ������(normalize��) scale ������ �ǹ̰� ���� 

	return ray;
}

__global__ void RayTraceD(float4* data)
{
	unsigned int x = blockIdx.x * blockDim.x + threadIdx.x;

	float yy = ((float)blockIdx.x / (float)blockDim.x - 0.5f) * 2.0f;
	float xx = ((float)threadIdx.x / (float)blockDim.x - 0.5f) * 2.0f;

	if (xx > 0.0f)
	{
		data[x].x = 1.0f;
		data[x].y = 0.0f;
		data[x].z = 0.0f;
		data[x].w = 1.0f;
	}
	else if (xx < 0.0f && yy > 0.0f)
	{
		data[x].x = 1.0f;
		data[x].y = 1.0f;
		data[x].z = 1.0f;
		data[x].w = 1.0f;
	}
	else
	{
		data[x].x = 0.0f;
		data[x].y = 1.0f;
		data[x].z = 0.0f;
		data[x].w = 1.0f;
	}
}

void RayTrace(float4* data)
{
	RayTraceD << <1024, 1024 >> > (data);
}