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
<<<<<<< HEAD
	Ovector(int initSize = 2)
=======
		Ovector(int initSize = 2)
>>>>>>> 75f980fb391e4045d90d82579a06b61f1bc0076b
	{
		data = new int[initSize];
		capacity = initSize;
		sz = 0;
		for (int i = 0; i < initSize; i++) data[i] = 0;
	}
	__host__ __device__
<<<<<<< HEAD
	~Ovector()
=======
		~Ovector()
>>>>>>> 75f980fb391e4045d90d82579a06b61f1bc0076b
	{
		delete[] data;
	}
	__host__ __device__
<<<<<<< HEAD
	int &operator[](int i) { return data[i]; }
	__host__ __device__
	void push_back(int value)
=======
		int &operator[](int i) { return data[i]; }
	__host__ __device__
		void push_back(int value)
>>>>>>> 75f980fb391e4045d90d82579a06b61f1bc0076b
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
<<<<<<< HEAD
	int size() { return sz; }
	__host__ __device__
	bool empty() { return !sz; }
	__host__ __device__
	bool full() { return capacity == sz; }
=======
		int size() { return sz; }
	__host__ __device__
		bool empty() { return !sz; }
	__host__ __device__
		bool full() { return capacity == sz; }
>>>>>>> 75f980fb391e4045d90d82579a06b61f1bc0076b
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

