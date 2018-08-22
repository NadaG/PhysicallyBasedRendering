#pragma once

#define DLLExport extern "C" __declspec( dllexport )

#include <glm\glm.hpp>
#include <cuda_runtime.h>
#include <glm\gtc\matrix_transform.hpp>
#include <vector>
#include <curand_kernel.h>
#include "Texture2D.h"

#include <thrust/functional.h>
#include <thrust/sort.h>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <glm\common.hpp>

#define GPUKDTREETHRESHOLD 128
#define GPUKDTREEMAXSTACK 128

using glm::vec2;
using glm::vec3;
using glm::vec4;

using glm::dvec2;

using glm::normalize;
using glm::cross;
using glm::dot;
using std::vector;

struct OctreeNode;


struct Ray
{
	// Ray의 원점
	vec3 origin;
	// Ray의 방향
	vec3 dir;

	int depth;

	float decay;
	//float 
};

struct AABB
{
	vec3 bounds[2];

	/*AABB(vec3 min, vec3 max)
	{
		bounds[0] = min;
		bounds[1] = max;
	}*/
};

struct Triangle
{
	vec3 v0;
	vec3 v1;
	vec3 v2;

	vec3 normal;

	vec3 v0normal;
	vec3 v1normal;
	vec3 v2normal;

	vec3 tangent;
	vec3 bitangent;

	vec2 v0uv;
	vec2 v1uv;
	vec2 v2uv;

	//AABB tbb;

	int tag;

	int materialId;
	int meshId;

	Triangle()
	{
		v0 = vec3();
		v1 = vec3();
		v2 = vec3();

		normal = vec3();

		materialId = 0;
		meshId = 0;

		tag = 0;

		//tbb.bounds[0] = vec3(0.0f);
		//tbb.bounds[1] = vec3(0.0f);
	}

	Triangle(vec3 v0, vec3 v1, vec3 v2)
	{
		this->v0 = v0;
		this->v1 = v0;
		this->v2 = v0;

		normal = vec3();

		materialId = 0;
		meshId = 0;
	}
};

struct Sphere
{
	vec3 origin;
	float radius;

	int materialId;
};

struct Light
{
	vec3 pos;
	vec3 color;
};

//struct Rect
//{
//	vec3  center;
//	vec3  dirx;
//	vec3  diry;
//	float halfx;
//	float halfy;
//
//	vec4  plane;
//};

struct Material
{
	vec3 albedo;
	vec3 emission;
	
	float ambient;
	float roughness;
	float metallic;

	float refractiveIndex;

	int texId;

	Material()
	{
		albedo = vec3(0.0f);
		emission = vec3(0.0f);
		
		ambient = 0.0f;
		roughness = 0.0f;
		metallic = 0.0f;

		// ±¼Àý ¾ÈÇÏ´Â ¹°Ã¼µé
		refractiveIndex = 0.0f;

		texId = -1;
	}
};






struct gpukdtreeNode {
	__device__ __host__ gpukdtreeNode(int l = -1, int r = -1, int sa = -1, int ti = 0, int tn = 0, float sp = 0)
	{
		leftChild = l; rightChild = r; splitAxis = sa; triangleIndex = ti; triangleNumber = tn; splitPos = sp;
	}
	__device__ __host__ gpukdtreeNode(const gpukdtreeNode& g)
	{
		leftChild = g.leftChild; rightChild = g.rightChild; splitAxis = g.splitAxis; triangleIndex = g.triangleIndex;
		triangleNumber = g.triangleNumber; splitPos = g.splitPos; nodeAABB = g.nodeAABB;
	}
	int leftChild;
	int rightChild;
	int splitAxis;
	int triangleIndex;
	int triangleNumber;
	float splitPos;
	AABB nodeAABB;
};

template<class T>
class DeviceStack {
public:
	__device__  DeviceStack() {
		ptr = 0;
		//cudaMalloc((void**)&data, sizeof(T)*GPUKDTREEMAXSTACK);
	}
	__device__  ~DeviceStack() {}//cudaFree(data);}
	__inline__ __device__  void push(const T& t) { data[ptr++] = t; if (ptr>GPUKDTREEMAXSTACK)printf("stack over flow!"); }
	__inline__ __device__  T pop() { return data[--ptr]; }
	__inline__ __device__  bool empty() { return ptr <= 0; }
public:
	unsigned int ptr;
	T data[GPUKDTREEMAXSTACK];
};

template<class T>
class DeviceVector {
public:
	DeviceVector() {}
	~DeviceVector() {
		cudaFree(data);
		cudaFree(d_size);
		cudaFree(d_ptr);
	}
	void allocateMemory(unsigned int n) {
		h_size = n;
		h_ptr = 0;
		cudaMalloc((void**)&d_size, sizeof(unsigned int));
		cudaMalloc((void**)&d_ptr, sizeof(unsigned int));
		cudaMemcpy(d_size, &h_size, sizeof(unsigned int), cudaMemcpyHostToDevice);
		cudaMemcpy(d_ptr, &h_ptr, sizeof(unsigned int), cudaMemcpyHostToDevice);
		cudaMalloc((void**)&data, sizeof(T)*n);
		thrustPtr = thrust::device_ptr<T>(data);
	}
	void CopyToHost(T* dist) {
		cudaMemcpy(&h_ptr, d_ptr, sizeof(unsigned int), cudaMemcpyDeviceToHost);
		cudaMemcpy(dist, data, sizeof(T)*h_ptr, cudaMemcpyDeviceToHost);
	}
	unsigned int size() {
		cudaMemcpy(&h_ptr, d_ptr, sizeof(unsigned int), cudaMemcpyDeviceToHost);
		return h_ptr;
	}

	__inline__ __device__ static unsigned int push_back(T* d, unsigned int* ptr, T& t) {
		unsigned int i = atomicAdd(ptr, 1);
		d[i] = t;
		return i;
	}
	__inline__ __device__ static void pop(T* d, unsigned int* ptr, T& t) {
		unsigned int i = atomicAdd(ptr, -1);
		t = d[i - 1];
	}
	__inline__ __device__ static bool empty(unsigned int* ptr) {
		if (*ptr <= 0)
			return true;
		return false;
	}
	__host__ bool h_empty() {
		cudaMemcpy(&h_ptr, d_ptr, sizeof(unsigned int), cudaMemcpyDeviceToHost);
		if (h_ptr <= 0)
			return true;
		return false;
	}
	__host__ void h_clear() {
		h_ptr = 0;
		cudaMemcpy(d_ptr, &h_ptr, sizeof(unsigned int), cudaMemcpyHostToDevice);
	}
	__inline__ __device__ static void clear(unsigned int* ptr) {
		*ptr = 0;
	}
	__host__ __device__
		T &operator[](int i) { return data[i]; }

	//__inline__ __device__ static T& operator [](T* d, unsigned int index){ // left operator
	//	return d[index];
	//}
	//__inline__ __device__ static T operator[](T* d, unsigned int index) const{ // right operator
	//	return d[index];
	//}
public:
	unsigned int h_size;
	unsigned int h_ptr;
	unsigned int* d_size; // memory size
	unsigned int* d_ptr; // data size
	T* data;
	thrust::device_ptr<T> thrustPtr; // in order to use thrust lib algorithms
};



class gpukdtree {
public:
	gpukdtree(Triangle* tri, int n, AABB rootaabb);
	~gpukdtree();
	void create();
	void IntersectRay(const Ray* r, int n, float* dist, int* iid);
private:
	void allocateMemory();
	void freeMemory();

	AABB CalculateRootAABB();
	void MidSplit();
	void SAHSplit();
public:
	AABB rootAABB;
	int nTriangle;
	Triangle* d_Triangles;
	Triangle* h_Triangles;
	AABB* d_AABB;

	/*DeviceVector<int> leftChild;
	DeviceVector<int> rightChild;
	DeviceVector<int> splitAxis;
	DeviceVector<int> triangleIndex;
	DeviceVector<int> triangleNumber;
	DeviceVector<float> splitPos;
	DeviceVector<AABB> nodeAABB;*/
	DeviceVector<gpukdtreeNode> nodes;

	DeviceVector<int> triangleNodeAssociation;
	DeviceVector<int> triangleNodeAssociationHelper;
	DeviceVector<int> activeList;
	DeviceVector<int> nextList;
	DeviceVector<int> smallList;
};

namespace dkdtree {
	__inline__ __device__ void AABBMin(vec3* x, vec3* y, vec3* z, vec3* dist);
	__inline__ __device__ void AABBMax(vec3* x, vec3* y, vec3* z, vec3* dist);
	// building algorithms
	__global__ void cu_create_AABB(int n, Triangle* tri, AABB* aabb);
	__global__ void MidSplitNode(Triangle* tri,
		AABB* aabb,
		int nTri,
		gpukdtreeNode* nodes,
		unsigned int* nodesPtr,
		int* activeList,
		unsigned int* activeListPtr,
		int* nextList,
		unsigned int* nextListPtr,
		int* smallList,
		unsigned int* smallListPtr,
		int* tna,
		unsigned int* tnaPtr,
		int* tnahelper,
		unsigned int* tnahelperPtr,
		unsigned int tnaStartPtr);
	__global__ void SAHSplitNode(Triangle* tri,
		AABB* aabb,
		int nTri,
		gpukdtreeNode* nodes,
		unsigned int* nodesPtr,
		int* smallList,
		unsigned int* smallListPtr,
		int* nextList,
		unsigned int* nextListPtr,
		int* tna,
		unsigned int* tnaPtr,
		int* tnahelper,
		unsigned int* tnahelperPtr,
		unsigned int tnaStartPtr);
	__global__ void InitRoot(int nTri,
		gpukdtreeNode* nodes,
		unsigned int* nodesPtr,
		int* activeList,
		unsigned int* activeListPtr,
		unsigned int* nextListPtr,
		unsigned int* smallListPtr,
		unsigned int* tnaPtr,
		AABB aabb);
	__global__ void CalculateTriangleIndex(int start, int end, int base, gpukdtreeNode* nodes);
	__global__ void CopyTriangle(int* tna, int n);
	// travelsal algorithms
	__global__ void IntersectRay(const Ray* r, int n, float* dist, int* iid, gpukdtreeNode* nodes, Triangle* tri, int* tna);
	
	__device__ bool Intersect_nodeTriangles_Ray(const Ray& r, int id, float& dist, int& iid, gpukdtreeNode* nodes, Triangle* tri, int* tna);

	struct MaxX
	{
		__host__ __device__ float operator()(AABB const& x)const {
			return x.bounds[1].x;
		}
	};
	struct MaxY
	{
		__host__ __device__ float operator()(AABB const& x)const {
			return x.bounds[1].y;
		}
	};
	struct MaxZ
	{
		__host__ __device__ float operator()(AABB const& x)const {
			return x.bounds[1].z;
		}
	};
	struct MinX
	{
		__host__ __device__ float operator()(AABB const& x)const {
			return x.bounds[0].x;
		}
	};
	struct MinY
	{
		__host__ __device__ float operator()(AABB const& x)const {
			return x.bounds[0].y;
		}
	};
	struct MinZ
	{
		__host__ __device__ float operator()(AABB const& x)const {
			return x.bounds[0].z;
		}
	};
}


DLLExport
void RayTrace(
	glm::vec4* data,
	const int gridX,
	const int gridY,
	glm::mat4 view,
	const vector<Triangle>& triangles,
	const vector<Sphere>& spheres,
	const vector<Light>& lights,
	const vector<Material>& materials,
	const vector<float>& randomThetaPi,
	OctreeNode* root,
	gpukdtree* kdroot
);

void LoadCudaTextures();

__device__ bool RayTriangleIntersect(Ray ray, Triangle triangle, float& dist);

__device__ bool Intersect_nodeAABB_Ray(const Ray& r, int id, gpukdtreeNode* nodes);