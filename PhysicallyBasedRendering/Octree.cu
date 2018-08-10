#include "Octree.cuh"
#include "Model.h"
#include <algorithm>

using std::min;
using std::max;

void tmpfunc()
{
	Model model;
	model.Load("Obj/torus.obj");

	vector<Triangle> triangles = model.GetTriangles();
	for (int i = 0; i < triangles.size(); i++)
	{
		cout << triangles[i].v0.x << endl;
	}

}

const int OTSize = sizeof(OctreeNode);

OctreeNode* OTHostToDevice(OctreeNode* root)
{
	if (root == nullptr)
		return nullptr;

	for (int i = 0; i < 8; i++)
		root->children[i] = OTHostToDevice(root->children[i]);

	int* gtriangleIdxData;
	cudaMalloc((void**)&gtriangleIdxData, sizeof(int)*root->triangleIdx.size());
	cudaMemcpy(gtriangleIdxData, root->triangleIdx.data, sizeof(int)*root->triangleIdx.size(), cudaMemcpyHostToDevice);

	root->triangleIdx.data = gtriangleIdxData;

	OctreeNode* gnode;
	cudaMalloc((void**)&gnode, OTSize);
	cudaMemcpy(gnode, root, OTSize, cudaMemcpyHostToDevice);

	//gnode->triangleIdx.data = gtriangleIdxData;

	return gnode;
}

void Subdivide(OctreeNode* root)
{
	for (int i = 0; i < 8; i++)
		root->children[i] = new OctreeNode;

	//	left top back
	root->children[0]->bnd.bounds[0].x = root->bnd.bounds[0].x;
	root->children[0]->bnd.bounds[1].x = (root->bnd.bounds[0].x + root->bnd.bounds[1].x) / 2;
	root->children[0]->bnd.bounds[0].y = (root->bnd.bounds[0].y + root->bnd.bounds[1].y) / 2;
	root->children[0]->bnd.bounds[1].y = root->bnd.bounds[1].y;
	root->children[0]->bnd.bounds[0].z = root->bnd.bounds[0].z;
	root->children[0]->bnd.bounds[1].z = (root->bnd.bounds[0].z + root->bnd.bounds[1].z) / 2;
	//	right top back
	root->children[1]->bnd.bounds[0].x = (root->bnd.bounds[0].x + root->bnd.bounds[1].x) / 2;
	root->children[1]->bnd.bounds[1].x = root->bnd.bounds[1].x; 
	root->children[1]->bnd.bounds[0].y = (root->bnd.bounds[0].y + root->bnd.bounds[1].y) / 2;
	root->children[1]->bnd.bounds[1].y = root->bnd.bounds[1].y;
	root->children[1]->bnd.bounds[0].z = root->bnd.bounds[0].z;
	root->children[1]->bnd.bounds[1].z = (root->bnd.bounds[0].z + root->bnd.bounds[1].z) / 2;
	//	left bottom back
	root->children[2]->bnd.bounds[0].x = root->bnd.bounds[0].x;
	root->children[2]->bnd.bounds[1].x = (root->bnd.bounds[0].x + root->bnd.bounds[1].x) / 2;
	root->children[2]->bnd.bounds[0].y = root->bnd.bounds[0].y;
	root->children[2]->bnd.bounds[1].y = (root->bnd.bounds[0].y + root->bnd.bounds[1].y) / 2;
	root->children[2]->bnd.bounds[0].z = root->bnd.bounds[0].z;
	root->children[2]->bnd.bounds[1].z = (root->bnd.bounds[0].z + root->bnd.bounds[1].z) / 2;
	//	right bottom back
	root->children[3]->bnd.bounds[0].x = (root->bnd.bounds[0].x + root->bnd.bounds[1].x) / 2;
	root->children[3]->bnd.bounds[1].x = root->bnd.bounds[1].x;
	root->children[3]->bnd.bounds[0].y = root->bnd.bounds[0].y; 
	root->children[3]->bnd.bounds[1].y = (root->bnd.bounds[0].y + root->bnd.bounds[1].y) / 2;
	root->children[3]->bnd.bounds[0].z = root->bnd.bounds[0].z;
	root->children[3]->bnd.bounds[1].z = (root->bnd.bounds[0].z + root->bnd.bounds[1].z) / 2;
 

	//	left top front
	root->children[4]->bnd.bounds[0].x = root->bnd.bounds[0].x;
	root->children[4]->bnd.bounds[1].x = (root->bnd.bounds[0].x + root->bnd.bounds[1].x) / 2;
	root->children[4]->bnd.bounds[0].y = (root->bnd.bounds[0].y + root->bnd.bounds[1].y) / 2;
	root->children[4]->bnd.bounds[1].y = root->bnd.bounds[1].y;
	root->children[4]->bnd.bounds[0].z = (root->bnd.bounds[0].z + root->bnd.bounds[1].z) / 2;
	root->children[4]->bnd.bounds[1].z = root->bnd.bounds[1].z; 
	//	right top front
	root->children[5]->bnd.bounds[0].x = (root->bnd.bounds[0].x + root->bnd.bounds[1].x) / 2;
	root->children[5]->bnd.bounds[1].x = root->bnd.bounds[1].x;
	root->children[5]->bnd.bounds[0].y = (root->bnd.bounds[0].y + root->bnd.bounds[1].y) / 2;
	root->children[5]->bnd.bounds[1].y = root->bnd.bounds[1].y;
	root->children[5]->bnd.bounds[0].z = (root->bnd.bounds[0].z + root->bnd.bounds[1].z) / 2;
	root->children[5]->bnd.bounds[1].z = root->bnd.bounds[1].z; 
	//	left bottom front
	root->children[6]->bnd.bounds[0].x = root->bnd.bounds[0].x;
	root->children[6]->bnd.bounds[1].x = (root->bnd.bounds[0].x + root->bnd.bounds[1].x) / 2;
	root->children[6]->bnd.bounds[0].y = root->bnd.bounds[0].y;
	root->children[6]->bnd.bounds[1].y = (root->bnd.bounds[0].y + root->bnd.bounds[1].y) / 2;
	root->children[6]->bnd.bounds[0].z = (root->bnd.bounds[0].z + root->bnd.bounds[1].z) / 2;
	root->children[6]->bnd.bounds[1].z = root->bnd.bounds[1].z; 
	//	right bottom front
	root->children[7]->bnd.bounds[0].x = (root->bnd.bounds[0].x + root->bnd.bounds[1].x) / 2;
	root->children[7]->bnd.bounds[1].x = root->bnd.bounds[1].x;
	root->children[7]->bnd.bounds[0].y = root->bnd.bounds[0].y;
	root->children[7]->bnd.bounds[1].y = (root->bnd.bounds[0].y + root->bnd.bounds[1].y) / 2;
	root->children[7]->bnd.bounds[0].z = (root->bnd.bounds[0].z + root->bnd.bounds[1].z) / 2;
	root->children[7]->bnd.bounds[1].z = root->bnd.bounds[1].z; 
}

void DeleteOctree(OctreeNode *root)
{
	for (int i = 0; i < 8; i++)
	{
		if (root->children[i] != nullptr)
			Subdivide(root->children[i]);
	}

	delete root;
}

bool TriangleExist(OctreeNode* node, Triangle triangle)
{
	vec3 o;		//	삼각형의 중심
	o.x = (triangle.v0.x + triangle.v1.x + triangle.v2.x) / 3;
	o.y = (triangle.v0.y + triangle.v1.y + triangle.v2.y) / 3;
	o.z = (triangle.v0.z + triangle.v1.z + triangle.v2.z) / 3;

	float a = length(o - triangle.v0);
	float b = length(o - triangle.v1);
	float c = length(o - triangle.v2);

	//	중심과 꼭지점과의 거리 중 가장 큰 것을 bounding sphere의 반지름으로 계산한다
	float rad = std::max(a, b);
	rad = std::max(rad, c);

	vec3 bo;	//	node의 중심
	bo.x = (node->bnd.bounds[0].x + node->bnd.bounds[1].x) / 2;
	bo.y = (node->bnd.bounds[0].y + node->bnd.bounds[1].y) / 2;
	bo.z = (node->bnd.bounds[0].z + node->bnd.bounds[1].z) / 2;

	if (length(bo - o) > rad + length(node->bnd.bounds[1] - bo) + 0.001f)
		return false;
	else
		return true;

	if (node->bnd.bounds[1].x < triangle.tbb.bounds[0].x || node->bnd.bounds[0].x > triangle.tbb.bounds[1].x) return false;
	if (node->bnd.bounds[1].y < triangle.tbb.bounds[0].y || node->bnd.bounds[0].y > triangle.tbb.bounds[1].y) return false;
	if (node->bnd.bounds[1].z < triangle.tbb.bounds[0].z || node->bnd.bounds[0].z > triangle.tbb.bounds[1].z) return false;
	return true;

}

void SpaceDivision(OctreeNode* root, Triangle* triangles, Ovector* idx, int limit)
{
	Ovector *newIdx = new Ovector;

	for (int i = 0; i < idx->size(); i++)
	{
		if (TriangleExist(root, triangles[idx->operator[](i)]))
			newIdx->push_back(idx->operator[](i));
	}

	if (newIdx->size() > limit)
	{
		//cout << newIdx->size() << endl;
		Subdivide(root);

		for (int i = 0; i < 8; i++)
			SpaceDivision(root->children[i], triangles, newIdx, limit);
	}
	else if (newIdx->size() > 0)
	{
		root->triangleIdx = *newIdx;
	}
}


//void SpaceDivision(OctreeNode* root, vector<Triangle> triangles, int limit)
//{
//	vector<Triangle> *newTri = new vector<Triangle>();
//
//	for (int i = 0; i < triangles.size(); i++)
//	{
//		if (TriangleExist(root, triangles[i]))
//			newTri->push_back(triangles[i]);
//	}
//
//	if (newTri->size() > limit)
//	{
//		Subdivide(root);
//
//		for (int i = 0; i < 8; i++)
//			SpaceDivision(root->children[i], *newTri, limit);
//	}
//	else if (newTri->size() > 0)
//	{
//		root->triangles = *newTri;
//	}
//}

//void SpaceDivision(OctreeNode* root, Triangle* triangles, int numTriangles, int maxTriangles)
//{
//	Triangle* tri = (Triangle*)malloc(sizeof(Triangle) * numTriangles);
//
//	int index = 0;
//	for (int i = 0; i < numTriangles; i++)
//	{
//		if (TriangleExist(root, triangles[i]))
//		{
//			tri[index] = triangles[i];
//			index++;
//		}
//	}
//
//	if (index> maxTriangles)
//	{
//		Subdivide(root);
//
//		for (int i = 0; i < 8; i++)
//			SpaceDivision(root->children[i], *newTri, maxTriangles);
//	}
//	else if (newTri->size() > 0)
//	{
//		root->triangles = *newTri;
//	}
//}


OctreeNode* BuildOctree(Triangle* triangles, int numTriangles, int limit, vec3 min, vec3 max)
{
	OctreeNode* root = new OctreeNode;
	Ovector* idx = new Ovector;

	for (int i = 0; i < numTriangles; i++)
	{
		idx->push_back(i);
	}

	root->bnd.bounds[0] = min;
	root->bnd.bounds[1] = max;

	SpaceDivision(root, triangles, idx, limit);
	cout << "end" << endl;

	return root;
}