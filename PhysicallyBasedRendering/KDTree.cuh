#pragma once
#include "RayTracer.cuh"
#include <glm\common.hpp>


#define CHUNKSIZE 256

using glm::vec3;
using glm::vec4;


struct KDTreeNode
{
	KDTreeNode* leftChild;
	KDTreeNode* rightChild;

	AABB bnd;
	AABB tbb;

	int firstTriangle;
	int triangleNum;

	int chunkSize;

	KDTreeNode()
	{
		firstTriangle = -1;
		triangleNum = -1;
		chunkSize = 0;

		bnd.bounds[0] = vec3(999999.0f);
		bnd.bounds[1] = vec3(-999999.0f);

		tbb.bounds[0] = vec3(999999.0f);
		tbb.bounds[1] = vec3(-999999.0f);

		leftChild = nullptr;
		rightChild = nullptr;
	}

};


class Nvector
{
public:
	int *nodeTriangleList;
	KDTreeNode *data;
	int capacity, sz;

	__host__ __device__
		Nvector(int initSize = 2)
	{
		data = new KDTreeNode[initSize];
		capacity = initSize;
		sz = 0;
	}
	__host__ __device__

		~Nvector()
	{
		delete[] nodeTriangleList;
		delete[] data;
	}
	__host__ __device__
		KDTreeNode &operator[](int i) { return data[i]; }
	__host__ __device__
		void push_back(KDTreeNode value)
	{
		if (full())
		{
			KDTreeNode *temp = new KDTreeNode[capacity];
			for (int i = 0; i < sz; i++)
				temp[i] = data[i];
			delete[] data;
			capacity *= 2;
			data = new KDTreeNode[capacity];
			for (int i = 0; i < sz; i++) data[i] = temp[i];
			delete[] temp;
		}
		data[sz++] = value;
	}
	__host__ __device__
		int size() { return sz; }
	__host__ __device__
		bool empty() { return !sz; }
	__host__ __device__
		bool full() { return capacity == sz; }

	__host__ __device__
		void append(Nvector* nvector)
	{
		for (int i = 0; i < nvector->size(); i++)
		{
			this->push_back(nvector->operator[](i));
		}
	}
};

struct ChunkNode
{
	KDTreeNode* node;
	int firstTriangle;
	int triangleNum;
	AABB cbb;


	__host__ __device__
	ChunkNode()
	{
		node = nullptr;
		firstTriangle = -1;
		triangleNum = 0;
		cbb.bounds[0] = vec3(99999.0f);
		cbb.bounds[1] = vec3(-99999.0f);
	}
};

class ChunkList
{
public:
	ChunkNode *data;
	int capacity, sz;

	__host__ __device__
		ChunkList(int initSize = 2)
	{
		data = new ChunkNode[initSize];
		capacity = initSize;
		sz = 0;
		for (int i = 0; i < initSize; i++) data[i] = ChunkNode();
	}
	__host__ __device__

		~ChunkList()
	{
		delete[] data;
	}
	__host__ __device__
		ChunkNode &operator[](int i) { return data[i]; }
	__host__ __device__
		void push_back(ChunkNode value)
	{
		if (full())
		{
			ChunkNode *temp = new ChunkNode[capacity];
			for (int i = 0; i < sz; i++)
				temp[i] = data[i];
			delete[] data;
			capacity *= 2;
			data = new ChunkNode[capacity];
			for (int i = 0; i < sz; i++) data[i] = temp[i];
			delete[] temp;
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

KDTreeNode* BuildKDTree(const vector<Triangle>& triangles);

void ProcessLargeNodes(Nvector* activeList, Nvector* smallList, Nvector* nextList, Triangle* T, int triangleNum);





//void SpaceDivision(OctreeNode* root, Triangle* triangles, Ovector* idx, int limit);
////void SpaceDivision(OctreeNode* root, vector<Triangle> triangles, int limit);
//
//OctreeNode* BuildOctree(Triangle* triangles, int numTriangles, int limit, vec3 min, vec3 max);
////OctreeNode* BuildOctree(vector<Triangle>  triangles, int limit, vec3 min, vec3 max);
//
//OctreeNode* OTHostToDevice(OctreeNode* root);
//
//void Subdivide(OctreeNode* root);
//
//bool TriangleExist(OctreeNode* node, Triangle triangle);
//
//void DeleteOctree(OctreeNode *root);

