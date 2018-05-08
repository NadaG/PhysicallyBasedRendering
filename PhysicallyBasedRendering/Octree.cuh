#pragma once

#include <glm\common.hpp>

#include "RayTracer.cuh"

using glm::vec3;
using glm::vec4;

struct OctreeNode
{
	OctreeNode* children[8];
	Triangle* triangles;
	AABB bnd;

	OctreeNode()
	{
		for (int i = 0; i < 8; i++)
			children[i] = nullptr;
	}
};

// 이미 메모리가 할당된 root가 들어옴
OctreeNode* HostToDevice(OctreeNode* root);

OctreeNode* BuildOctree(const vector<Triangle>& triangles);

bool IsInNode(OctreeNode* node, Triangle triangle);