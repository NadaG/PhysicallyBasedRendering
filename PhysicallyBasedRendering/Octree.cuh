#pragma once
#include "RayTracer.cuh"
#include <glm\common.hpp>

using glm::vec3;
using glm::vec4;

class Ovector
{
public:
	int *data;
	int capacity, sz;

	__host__ __device__
	Ovector(int initSize = 2)
	{
		data = new int[initSize];
		capacity = initSize;
		sz = 0;
		for (int i = 0; i < initSize; i++) data[i] = 0;
	}
	__host__ __device__
	
		~Ovector()
	{
		delete[] data;
	}
	__host__ __device__
	int &operator[](int i) { return data[i]; }
	__host__ __device__
	void push_back(int value)
	{
		if (full())
		{
			int *temp = new int[capacity];
			for (int i = 0; i < sz; i++)
				temp[i] = data[i];
			delete[]data;
			capacity *= 2;
			data = new int[capacity];
			for (int i = 0; i < sz; i++) data[i] = temp[i];
			delete[]temp;
		}
		data[sz++] = value;
	}
	__host__ __device__
	int size() { return sz; }
	__host__ __device__
	bool empty() { return !sz; }
	__host__ __device__
	bool full() { return capacity == sz; }
};


struct OctreeNode
{
	OctreeNode* children[8];
	//vector<Triangle> triangles;
	Ovector triangleIdx;
	AABB bnd;
	OctreeNode()
	{
		for (int i = 0; i < 8; i++)
			children[i] = nullptr;
	}
};


void tmpfunc();

void SpaceDivision(OctreeNode* root, Triangle* triangles, Ovector* idx, int limit);
//void SpaceDivision(OctreeNode* root, vector<Triangle> triangles, int limit);

OctreeNode* BuildOctree(Triangle* triangles, int numTriangles, int limit, vec3 min, vec3 max);
//OctreeNode* BuildOctree(vector<Triangle>  triangles, int limit, vec3 min, vec3 max);

OctreeNode* OTHostToDevice(OctreeNode* root);

void Subdivide(OctreeNode* root);

bool TriangleExist(OctreeNode* node, Triangle triangle);

void DeleteOctree(OctreeNode *root);

