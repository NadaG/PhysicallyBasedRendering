#include "Octree.cuh"
#include <algorithm>

using std::min;
using std::max;

__global__ void BuildOctreeD(Triangle* triangles, int triangleNum)
{
}

OctreeNode* HostToDevice(OctreeNode* root)
{
	OctreeNode *h_root, *d_root;
	h_root = new OctreeNode[1];

	memcpy(h_root, root, sizeof(OctreeNode));

	for (int i = 0; i < 8; i++)
	{
		cudaMalloc(&(h_root[0].children[i]), sizeof(OctreeNode));
		cudaMemcpy(h_root[0].children[i], root[0].children[i], sizeof(OctreeNode), cudaMemcpyHostToDevice);
	}

	cudaMalloc((void**)&d_root, sizeof(OctreeNode));
	cudaMemcpy(d_root, h_root, sizeof(OctreeNode), cudaMemcpyHostToDevice);

	return d_root;
}

// host memory의 triangle을 이용해 octree를 build하고 
// build한 octree를 device memory로 옮겨 return하는 함수
OctreeNode* BuildOctree(const vector<Triangle>& triangles)
{	
	OctreeNode* root;
	root = new OctreeNode;
	for (int i = 0; i < 8; i++)
	{
		root->children[i] = new OctreeNode;
	}

	root->bnd.bounds[0] = glm::vec3(0.0f, -1.0f, -1.0f);
	root->bnd.bounds[1] = glm::vec3(1.0f, 1.0f, 1.0f);

	return HostToDevice(root);
}

bool IsInNode(OctreeNode* node, Triangle triangle)
{
	AABB triangleAABB;

	triangleAABB.bounds[0].x = min(min(triangle.v0.x, triangle.v1.x), triangle.v2.x);
	triangleAABB.bounds[0].y = min(min(triangle.v0.y, triangle.v1.y), triangle.v2.y);
	triangleAABB.bounds[0].z = min(min(triangle.v0.z, triangle.v1.z), triangle.v2.z);

	triangleAABB.bounds[1].x = max(max(triangle.v0.x, triangle.v1.x), triangle.v2.x);
	triangleAABB.bounds[1].y = max(max(triangle.v0.y, triangle.v1.y), triangle.v2.y);
	triangleAABB.bounds[1].z = max(max(triangle.v0.z, triangle.v1.z), triangle.v2.z);

	if (triangleAABB.bounds[0].x > node->bnd.bounds[1].x) return false;
	if (triangleAABB.bounds[1].x < node->bnd.bounds[0].x) return false;
	if (triangleAABB.bounds[0].y > node->bnd.bounds[1].y) return false;
	if (triangleAABB.bounds[1].y < node->bnd.bounds[0].y) return false;
	if (triangleAABB.bounds[0].z > node->bnd.bounds[1].z) return false;
	if (triangleAABB.bounds[1].z < node->bnd.bounds[0].z) return false;

	return true;
}