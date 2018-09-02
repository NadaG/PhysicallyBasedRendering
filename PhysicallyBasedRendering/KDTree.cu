#include "KDTree.cuh"
#include <cuda.h>
#include <cuda_runtime.h>
#include <glm\glm.hpp>
#include <glm\gtx\component_wise.hpp>
#include <stdio.h>
#include <glm\gtc\matrix_transform.hpp>
#include <math_constants.h>
#include <math.h>
#include <thrust\device_vector.h>
#include <queue>
#include <curand.h>
#include <curand_kernel.h>
#include <algorithm>
#include <ctime>
#include <stdio.h>

//#pragma region old version
//__global__ void ComputeAABB(Triangle* T, int triangleNum)
//{
//	unsigned int idx = blockDim.x * blockIdx.x + threadIdx.x;
//	if (idx >= triangleNum)
//		return;
//
//	T[idx].tbb.bounds[0].x = glm::min(T[idx].v2.x, glm::min(T[idx].v0.x, T[idx].v1.x));
//	T[idx].tbb.bounds[1].x = glm::max(T[idx].v2.x, glm::max(T[idx].v0.x, T[idx].v1.x));
//
//	T[idx].tbb.bounds[0].y = glm::min(T[idx].v2.y, glm::min(T[idx].v0.y, T[idx].v1.y));
//	T[idx].tbb.bounds[1].y = glm::max(T[idx].v2.y, glm::max(T[idx].v0.y, T[idx].v1.y));
//
//	T[idx].tbb.bounds[0].z = glm::min(T[idx].v2.z, glm::min(T[idx].v0.z, T[idx].v1.z));
//	T[idx].tbb.bounds[1].z = glm::max(T[idx].v2.z, glm::max(T[idx].v0.z, T[idx].v1.z));
//}
//
//KDTreeNode* BuildKDTree(const vector<Triangle>& T)
//{
//	thrust::device_vector<Triangle> t = T;
//	int block = t.size() / 1024 + 1;
//
//	ComputeAABB << < block, 1024 >> > (t.data().get(), t.size());
//	cout << "Compute Tri AABB" << endl;
//
//	//// node list
//	//Nvector* nodeList = new Nvector();
//	//cudaMalloc((void**)&(nodeList->nodeTriangleList), sizeof(int)*t.size());
//
//	//Nvector* deviceNodeList;
//	//cudaMalloc((void**)&deviceNodeList, sizeof(Nvector));
//	//cudaMemcpy(deviceNodeList, nodeList, sizeof(Nvector), cudaMemcpyHostToDevice);
//
//	//// active list
//	//Nvector* activeList = new Nvector();
//	//cudaMalloc((void**)&(activeList->nodeTriangleList), sizeof(int)*t.size());
//
//	//Nvector* deviceActiveList;
//	//cudaMalloc((void**)&deviceActiveList, sizeof(Nvector));
//	//cudaMemcpy(deviceActiveList, activeList, sizeof(Nvector), cudaMemcpyHostToDevice);
//
//	//// small list
//	//Nvector* smallList = new Nvector();
//	//cudaMalloc((void**)&(smallList->nodeTriangleList), sizeof(int)*t.size());
//
//	//Nvector* deviceSmallList;
//	//cudaMalloc((void**)&deviceSmallList, sizeof(Nvector));
//	//cudaMemcpy(deviceSmallList, smallList, sizeof(Nvector), cudaMemcpyHostToDevice);
//
//	//// next list
//	//Nvector* nextList = new Nvector();
//	//cudaMalloc((void**)&(nextList->nodeTriangleList), sizeof(int)*t.size());
//
//	//Nvector* deviceNextList;
//	//cudaMalloc((void**)&deviceNextList, sizeof(Nvector));
//	//cudaMemcpy(deviceNextList, nextList, sizeof(Nvector), cudaMemcpyHostToDevice);
//
//
//	//KDTreeNode* root;
//	//cudaMalloc((void**)&root, sizeof(KDTreeNode));
//	
//	Nvector* nodeList = new Nvector();
//	nodeList->nodeTriangleList = new int[t.size()];
//
//	Nvector* activeList = new Nvector();
//	activeList->nodeTriangleList = new int[t.size()];
//
//	Nvector* smallList = new Nvector();
//	smallList->nodeTriangleList = new int[t.size()];
//
//	Nvector* nextList = new Nvector();
//	nextList->nodeTriangleList = new int[t.size()];
//
//	KDTreeNode* root = new KDTreeNode();
//	root->firstTriangle = 0;
//	root->triangleNum = t.size();
//	root->bnd.bounds[0] = vec3(-60, -60, -60);
//	root->bnd.bounds[1] = vec3(60, 60, 60);
//	root->chunkSize = t.size() / CHUNKSIZE + 1;
//
//	activeList->push_back(*root);
//	for (int i = 0; i < t.size(); i++)
//	{
//		activeList->nodeTriangleList[i] = i;
//	}
//
//	// Large node stage
//	int aa = 1;
//	while (!activeList->empty() && aa == 1)
//	{
//		nodeList->append(activeList);
//		delete nextList;
//		nextList = new Nvector();
//
//		ProcessLargeNodes(activeList, smallList, nextList, t.data().get(), t.size());
//
//		/*Nvector* tmp = activeList;
//		activeList = nextList;
//		nextList = tmp;*/
//
//		aa = 0;
//	}
//	
//
//	cout << "KDend\n" << endl;
//	
//	delete nodeList;
//	delete activeList;
//	delete smallList;
//	delete nextList;
//	delete root;
//
//
//	return nullptr;
//}
//
//__global__ void ChunkingTriangle(Nvector* activeList, ChunkNode* chunkList)
//{
//	unsigned int idx = blockDim.x * blockIdx.x + threadIdx.x;
//
//	if (idx < activeList->size())
//	{
//		int size = activeList->operator[](idx).chunkSize;
//
//		for (int i = 0; i < size; i++)
//		{
//			ChunkNode newChunk;
//			newChunk.node = &activeList->operator[](idx);
//			newChunk.firstTriangle = activeList->operator[](idx).firstTriangle + i*CHUNKSIZE;
//			//newChunk.firstTriangle = 100;
//
//			if (i == size - 1)
//				newChunk.triangleNum = activeList->operator[](idx).triangleNum - CHUNKSIZE*i;
//			else
//				newChunk.triangleNum = CHUNKSIZE;
//
//			// 자신보다 index가 앞인 노드들의 chunk 수를 모두 더해서 chunk list에서 현재 노드의 시작 위치를 알아낸다.
//			int startIdx = 0;
//			for (int j = 0; j < idx; j++)
//			{
//				startIdx += activeList->operator[](j).chunkSize;
//			}
//
//			chunkList[startIdx + i] = newChunk;
//	
//			//chunkList[0].triangleNum = size;
//		}
//	}
//}
//
//
//__global__ void ComputeChunkAABB(ChunkNode* chunkList, int chunkNum, Triangle* T)
//{
//	unsigned int idx = blockDim.x * blockIdx.x + threadIdx.x;
//
//	if (idx < chunkNum)
//	{
//		vec3 max = { -99999,-99999,-99999 };
//		vec3 min = { 99999,99999,99999 };
//
//		for (int i = 0; i < CHUNKSIZE; i++)
//		{
//			chunkList[idx].cbb.bounds[0].x = thrust::min(min.x, T[chunkList[idx].firstTriangle + i].tbb.bounds[0].x);
//			chunkList[idx].cbb.bounds[0].y = thrust::min(min.y, T[chunkList[idx].firstTriangle + i].tbb.bounds[0].y);
//			chunkList[idx].cbb.bounds[0].z = thrust::min(min.z, T[chunkList[idx].firstTriangle + i].tbb.bounds[0].z);
//
//			chunkList[idx].cbb.bounds[1].x = thrust::max(max.x, T[chunkList[idx].firstTriangle + i].tbb.bounds[1].x);
//			chunkList[idx].cbb.bounds[1].y = thrust::max(max.y, T[chunkList[idx].firstTriangle + i].tbb.bounds[1].y);
//			chunkList[idx].cbb.bounds[1].z = thrust::max(max.z, T[chunkList[idx].firstTriangle + i].tbb.bounds[1].z);
//
//			min.x = chunkList[idx].cbb.bounds[0].x;
//			min.y = chunkList[idx].cbb.bounds[0].y;
//			min.z = chunkList[idx].cbb.bounds[0].z;
//
//			max.x = chunkList[idx].cbb.bounds[1].x;
//			max.y = chunkList[idx].cbb.bounds[1].y;
//			max.z = chunkList[idx].cbb.bounds[1].z;
//
//		}	
//	}
//}
//
//
//__global__ void SegmentedReduction(ChunkNode* chunkList, int gap, int cnum)
//{
//	unsigned int idx = blockDim.x * blockIdx.x + threadIdx.x;
//
//	if (idx*gap * 2 > cnum - 1 || idx*gap * 2 + gap > cnum-1)
//		return;
//
//	if (chunkList[idx*gap * 2].node == chunkList[idx*gap * 2 + gap].node)
//	{
//		chunkList[idx*gap * 2].cbb.bounds[0].x = thrust::min(chunkList[idx*gap * 2].cbb.bounds[0].x, chunkList[idx*gap * 2 + gap].cbb.bounds[0].x);
//		chunkList[idx*gap * 2].cbb.bounds[0].y = thrust::min(chunkList[idx*gap * 2].cbb.bounds[0].y, chunkList[idx*gap * 2 + gap].cbb.bounds[0].y);
//		chunkList[idx*gap * 2].cbb.bounds[0].z = thrust::min(chunkList[idx*gap * 2].cbb.bounds[0].z, chunkList[idx*gap * 2 + gap].cbb.bounds[0].z);
//
//		chunkList[idx*gap * 2].cbb.bounds[1].x = thrust::max(chunkList[idx*gap * 2].cbb.bounds[1].x, chunkList[idx*gap * 2 + gap].cbb.bounds[1].x);
//		chunkList[idx*gap * 2].cbb.bounds[1].y = thrust::max(chunkList[idx*gap * 2].cbb.bounds[1].y, chunkList[idx*gap * 2 + gap].cbb.bounds[1].y);
//		chunkList[idx*gap * 2].cbb.bounds[1].z = thrust::max(chunkList[idx*gap * 2].cbb.bounds[1].z, chunkList[idx*gap * 2 + gap].cbb.bounds[1].z);
//	}
//	else
//	{	
//		if (chunkList[idx*gap * 2 + gap].node == chunkList[0].node)
//		{
//			chunkList[idx*gap * 2].node->tbb.bounds[0].x = thrust::min(chunkList[idx*gap * 2].node->tbb.bounds[0].x, chunkList[idx*gap * 2].cbb.bounds[0].x);
//			chunkList[idx*gap * 2].node->tbb.bounds[0].y = thrust::min(chunkList[idx*gap * 2].node->tbb.bounds[0].y, chunkList[idx*gap * 2].cbb.bounds[0].y);
//			chunkList[idx*gap * 2].node->tbb.bounds[0].z = thrust::min(chunkList[idx*gap * 2].node->tbb.bounds[0].z, chunkList[idx*gap * 2].cbb.bounds[0].z);
//
//			chunkList[idx*gap * 2].node->tbb.bounds[1].x = thrust::max(chunkList[idx*gap * 2].node->tbb.bounds[1].x, chunkList[idx*gap * 2].cbb.bounds[1].x);
//			chunkList[idx*gap * 2].node->tbb.bounds[1].y = thrust::max(chunkList[idx*gap * 2].node->tbb.bounds[1].y, chunkList[idx*gap * 2].cbb.bounds[1].y);
//			chunkList[idx*gap * 2].node->tbb.bounds[1].z = thrust::max(chunkList[idx*gap * 2].node->tbb.bounds[1].z, chunkList[idx*gap * 2].cbb.bounds[1].z);
//
//			chunkList[idx*gap * 2] = chunkList[idx*gap * 2 + gap];
//		}
//		else
//		{
//			chunkList[idx*gap * 2 + gap].node->tbb.bounds[0].x = thrust::min(chunkList[idx*gap * 2 + gap].node->tbb.bounds[0].x, chunkList[idx*gap * 2 + gap].cbb.bounds[0].x);
//			chunkList[idx*gap * 2 + gap].node->tbb.bounds[0].y = thrust::min(chunkList[idx*gap * 2 + gap].node->tbb.bounds[0].y, chunkList[idx*gap * 2 + gap].cbb.bounds[0].y);
//			chunkList[idx*gap * 2 + gap].node->tbb.bounds[0].z = thrust::min(chunkList[idx*gap * 2 + gap].node->tbb.bounds[0].z, chunkList[idx*gap * 2 + gap].cbb.bounds[0].z);
//
//			chunkList[idx*gap * 2 + gap].node->tbb.bounds[1].x = thrust::max(chunkList[idx*gap * 2 + gap].node->tbb.bounds[1].x, chunkList[idx*gap * 2 + gap].cbb.bounds[1].x);
//			chunkList[idx*gap * 2 + gap].node->tbb.bounds[1].y = thrust::max(chunkList[idx*gap * 2 + gap].node->tbb.bounds[1].y, chunkList[idx*gap * 2 + gap].cbb.bounds[1].y);
//			chunkList[idx*gap * 2 + gap].node->tbb.bounds[1].z = thrust::max(chunkList[idx*gap * 2 + gap].node->tbb.bounds[1].z, chunkList[idx*gap * 2 + gap].cbb.bounds[1].z);
//		}
//	}
//
//	//	기준이 되는 노드의 정보 수정
//	chunkList[0].node->tbb = chunkList[0].cbb;
//}
//
//
//__global__ void SplitLargeNode(Nvector* activeList, KDTreeNode* devNextData)
//{
//	unsigned int idx = blockDim.x * blockIdx.x + threadIdx.x;
//
//	if (idx >= activeList->size())
//		return;
//
//
//	////////////////////////////////////////////////////
//	//	cut off empty space
//	//	min
//	if (abs(activeList->operator[](idx).bnd.bounds[0].x-activeList->operator[](idx).tbb.bounds[0].x) / 
//		abs(activeList->operator[](idx).bnd.bounds[0].x - activeList->operator[](idx).bnd.bounds[1].x) > CUTOFF)
//	{
//		activeList->operator[](idx).bnd.bounds[0].x = activeList->operator[](idx).tbb.bounds[0].x;
//	}
//
//	if (abs(activeList->operator[](idx).bnd.bounds[0].y - activeList->operator[](idx).tbb.bounds[0].y) / 
//		abs(activeList->operator[](idx).bnd.bounds[0].y- activeList->operator[](idx).bnd.bounds[1].y) > CUTOFF)
//	{
//		activeList->operator[](idx).bnd.bounds[0].y = activeList->operator[](idx).tbb.bounds[0].y;
//	}
//
//	if (abs(activeList->operator[](idx).bnd.bounds[0].z - activeList->operator[](idx).tbb.bounds[0].z) / 
//		abs(activeList->operator[](idx).bnd.bounds[0].z - activeList->operator[](idx).bnd.bounds[1].z) > CUTOFF)
//	{
//		activeList->operator[](idx).bnd.bounds[0].z = activeList->operator[](idx).tbb.bounds[0].z;
//	}
//
//
//	// max
//	if (abs(activeList->operator[](idx).bnd.bounds[1].x - activeList->operator[](idx).tbb.bounds[1].x) / 
//		abs(activeList->operator[](idx).bnd.bounds[0].x - activeList->operator[](idx).bnd.bounds[1].x)> CUTOFF)
//	{
//		activeList->operator[](idx).bnd.bounds[1].x = activeList->operator[](idx).tbb.bounds[1].x;
//	}
//
//	if (abs((*activeList)[idx].bnd.bounds[1].y - (*activeList)[idx].tbb.bounds[1].y) /
//		abs((*activeList)[idx].bnd.bounds[0].y - (*activeList)[idx].bnd.bounds[1].y) > CUTOFF)
//	{
//		(*activeList)[idx].bnd.bounds[1].y = (*activeList)[idx].tbb.bounds[1].y;
//	}
//
//	if (abs(activeList->operator[](idx).bnd.bounds[1].z - activeList->operator[](idx).tbb.bounds[1].z) / 
//		abs(activeList->operator[](idx).bnd.bounds[0].z - activeList->operator[](idx).bnd.bounds[1].z) > CUTOFF)
//	{
//		activeList->operator[](idx).bnd.bounds[1].z = activeList->operator[](idx).tbb.bounds[1].z;
//	}
//	////////////////////////////////////////////////////
//
//
//	////////////////////////////////////////////////////
//	//	split node at spatial median of the longest axis
//	float xAxis = abs(activeList->operator[](idx).tbb.bounds[0].x - activeList->operator[](idx).tbb.bounds[1].x);
//	float yAxis = abs(activeList->operator[](idx).tbb.bounds[0].y - activeList->operator[](idx).tbb.bounds[1].y);
//	float zAxis = abs(activeList->operator[](idx).tbb.bounds[0].z - activeList->operator[](idx).tbb.bounds[1].z);
//
//	float maxAxis = thrust::max(zAxis, thrust::max(xAxis, yAxis));
//	
//
//	if (xAxis == maxAxis)
//	{
//		float median = (activeList->operator[](idx).tbb.bounds[0].x + activeList->operator[](idx).tbb.bounds[1].x) / 2;
//
//		KDTreeNode* leftChild = &devNextData[idx * 2];
//		KDTreeNode* rightChild = &devNextData[idx * 2 + 1];
//
//		leftChild->bnd = activeList->operator[](idx).tbb;
//		leftChild->bnd.bounds[1].x = median;
//
//		rightChild->bnd = activeList->operator[](idx).tbb;
//		rightChild->bnd.bounds[0].x = median;
//
//		activeList->operator[](idx).leftChild = leftChild;
//		activeList->operator[](idx).rightChild = rightChild;
//
//	}
//	else if (yAxis == maxAxis)
//	{
//		float median = (activeList->operator[](idx).bnd.bounds[0].y + activeList->operator[](idx).bnd.bounds[1].y) / 2;
//
//		KDTreeNode* leftChild = &devNextData[idx * 2];
//		KDTreeNode* rightChild = &devNextData[idx * 2 + 1];
//
//		leftChild->bnd = activeList->operator[](idx).tbb;
//		leftChild->bnd.bounds[1].y = median;
//
//		rightChild->bnd = activeList->operator[](idx).tbb;
//		rightChild->bnd.bounds[0].y = median;
//
//		activeList->operator[](idx).leftChild = leftChild;
//		activeList->operator[](idx).rightChild = rightChild;
//	}
//	else
//	{
//		float median = (activeList->operator[](idx).bnd.bounds[0].z + activeList->operator[](idx).bnd.bounds[1].z) / 2;
//
//		KDTreeNode* leftChild = &devNextData[idx * 2];
//		KDTreeNode* rightChild = &devNextData[idx * 2 + 1];
//
//		leftChild->bnd = activeList->operator[](idx).tbb;
//		leftChild->bnd.bounds[1].z = median;
//
//		rightChild->bnd = activeList->operator[](idx).tbb;
//		rightChild->bnd.bounds[0].z = median;
//
//		activeList->operator[](idx).leftChild = leftChild;
//		activeList->operator[](idx).rightChild = rightChild;
//	}
//	////////////////////////////////////////////////////
//
//	//if (activeList->operator[](0).leftChild->triangleNum == 100)
//	//	activeList->operator[](idx).bnd.bounds[0].x = 11111.0f;
//}
//
//
//__global__ void SortAndClip(ChunkNode* chunkList)
//{
//
//}
//
//
//__global__ void Add(int* a)
//{
//	unsigned int idx = blockDim.x * blockIdx.x + threadIdx.x;
//
//	a++;
//}
//
//void ProcessLargeNodes(Nvector* activeList, Nvector* smallList, Nvector* nextList, Triangle* T, int triangleNum)
//{
//	//	copy active list to GPU memory
//	int* devNTL;
//	cudaMalloc((void**)&devNTL, sizeof(int)*triangleNum);
//	cudaMemcpy(devNTL, activeList->nodeTriangleList, sizeof(int)*triangleNum, cudaMemcpyHostToDevice);
//
//	KDTreeNode* devData;
//	cudaMalloc((void**)&devData, sizeof(KDTreeNode)*activeList->size());
//	cudaMemcpy(devData, activeList->data, sizeof(KDTreeNode)*activeList->size(), cudaMemcpyHostToDevice);
//
//	Nvector* tmp = new Nvector();
//	tmp->nodeTriangleList = devNTL;
//	tmp->data = devData;
//	tmp->capacity = activeList->capacity;
//	tmp->sz = activeList->sz;
//
//	Nvector* devActiveList;
//	cudaMalloc((void**)&devActiveList, sizeof(Nvector));
//	cudaMemcpy(devActiveList, tmp, sizeof(Nvector), cudaMemcpyHostToDevice);
//
//	
//
//	///////////////////////////////////////////////
//	//	1st step, group triangles into chunks
//	ChunkNode* chunkList;
//
//	//	active list에 존재하는 모든 chunk의 개수를 구한다.
//	int cnum = 0;
//	for (int i = 0; i < activeList->size(); i++)
//	{
//		cnum += activeList->operator[](i).chunkSize;
//	}
//	cudaMalloc((void**)&chunkList, sizeof(ChunkNode)*cnum);
//	
//	int block = activeList->size();
//
//	ChunkingTriangle << < block, 1 >> > (devActiveList, chunkList);	
//	///////////////////////////////////////////////
//
//
//	///////////////////////////////////////////////
//	//	2nd step, compute per-node bounding box
//	ComputeChunkAABB << < cnum, 1 >> > (chunkList, cnum, T);
//	
//	int a = 0;
//	if (cnum % 2 == 0)
//		a = cnum / 2;
//	else
//		a = cnum / 2 + 1;
//
//	for (int gap = 0; gap < a; gap++)
//	{
//		SegmentedReduction << < 1, cnum >> > (chunkList, pow(2, gap), cnum);
//	}
//	///////////////////////////////////////////////
//
//
//	///////////////////////////////////////////////
//	//	3rd step, split large node
//	block = activeList->size();
//
//	KDTreeNode* devNextData;
//	cudaMalloc((void**)&devNextData, 2 * sizeof(KDTreeNode) * block);
//
//	block = activeList->size();
//	SplitLargeNode << < block, 1 >> > (devActiveList, devNextData);
//
//	KDTreeNode* nextData = new KDTreeNode();
//	cudaMemcpy(nextData, devNextData, 2 * sizeof(KDTreeNode) * block, cudaMemcpyDeviceToHost);
//
//	for (int i = 0; i < 2 * sizeof(KDTreeNode) * block; i++)
//	{
//		nextList->push_back(nextData[i]);	
//	}
//	///////////////////////////////////////////////
//
//
//	///////////////////////////////////////////////
//	//	4th step, sort and clip triangles to child nodes
//
//	//SortAndClip << < block, thread >> > ();
//
//	///////////////////////////////////////////////
//
//
//	ChunkNode* hostList = new ChunkNode[cnum];
//	cudaMemcpy(hostList, chunkList, sizeof(ChunkNode)*cnum, cudaMemcpyDeviceToHost);
//
//	cout << "idx " <<hostList[33].triangleNum << endl;
//
//	for (int i = 0; i < 34; i++)
//	{
//		//cout << "AABB " << hostList[i].cbb.bounds[1].y << endl;
//	}
//
//	
//	Nvector *aa = new Nvector();
//	cudaMemcpy(aa, devActiveList, sizeof(Nvector), cudaMemcpyDeviceToHost);
//
//	//cudaMemcpy(hostList, chunkList, sizeof(ChunkNode)*cnum, cudaMemcpyDeviceToHost);
//	KDTreeNode* node11 = new KDTreeNode();
//	cudaMemcpy(node11, &aa->operator[](0), sizeof(KDTreeNode), cudaMemcpyDeviceToHost);
//
//	cout << "=============node tri=============" << endl;
//	cout << "AABB " << node11->tbb.bounds[0].x << endl;
//	cout << "AABB " << node11->tbb.bounds[0].y << endl;
//	cout << "AABB " << node11->tbb.bounds[0].z << endl;
//
//	cout << "AABB " << node11->tbb.bounds[1].x << endl;
//	cout << "AABB " << node11->tbb.bounds[1].y << endl;
//	cout << "AABB " << node11->tbb.bounds[1].z << endl;
//
//	cout << "=============node =============" << endl;
//	cout << "AABB " << node11->bnd.bounds[0].x << endl;
//	cout << "AABB " << node11->bnd.bounds[0].y << endl;
//	cout << "AABB " << node11->bnd.bounds[0].z << endl;
//
//	cout << "AABB " << node11->bnd.bounds[1].x << endl;
//	cout << "AABB " << node11->bnd.bounds[1].y << endl;
//	cout << "AABB " << node11->bnd.bounds[1].z << endl;
//
//
//	KDTreeNode* leftnode = new KDTreeNode();
//	cudaMemcpy(leftnode, node11->leftChild, sizeof(KDTreeNode), cudaMemcpyDeviceToHost);
//
//	cout << "============left==============" << endl;
//	cout << "AABB " << leftnode->bnd.bounds[0].x << endl;
//	cout << "AABB " << leftnode->bnd.bounds[0].y << endl;
//	cout << "AABB " << leftnode->bnd.bounds[0].z << endl;
//
//	cout << "AABB " << leftnode->bnd.bounds[1].x << endl;
//	cout << "AABB " << leftnode->bnd.bounds[1].y << endl;
//	cout << "AABB " << leftnode->bnd.bounds[1].z << endl;
//
//	KDTreeNode* rightnode = new KDTreeNode();
//	cudaMemcpy(rightnode, node11->rightChild, sizeof(KDTreeNode), cudaMemcpyDeviceToHost);
//
//	cout << "============right==============" << endl;
//	cout << "AABB " << rightnode->bnd.bounds[0].x << endl;
//	cout << "AABB " << rightnode->bnd.bounds[0].y << endl;
//	cout << "AABB " << rightnode->bnd.bounds[0].z << endl;
//
//	cout << "AABB " << rightnode->bnd.bounds[1].x << endl;
//	cout << "AABB " << rightnode->bnd.bounds[1].y << endl;
//	cout << "AABB " << rightnode->bnd.bounds[1].z << endl;
//
//
//	cudaFree(chunkList);
//	delete hostList;
//	cudaFree(devNTL);
//	cudaFree(devData);
//	cudaFree(devActiveList);
//
//	tmp->nodeTriangleList = nullptr;
//	tmp->data = nullptr;
//	delete tmp;
//} 
//#pragma endregion


__global__ void ComputeAABB(Triangle* T, int triangleNum, AABB* tbbs)
{
	unsigned int idx = blockDim.x * blockIdx.x + threadIdx.x;
	if (idx >= triangleNum)
		return;

	tbbs[idx].bounds[0].x = glm::min(T[idx].v2.x, glm::min(T[idx].v0.x, T[idx].v1.x));
	tbbs[idx].bounds[1].x = glm::max(T[idx].v2.x, glm::max(T[idx].v0.x, T[idx].v1.x));

	tbbs[idx].bounds[0].y = glm::min(T[idx].v2.y, glm::min(T[idx].v0.y, T[idx].v1.y));
	tbbs[idx].bounds[1].y = glm::max(T[idx].v2.y, glm::max(T[idx].v0.y, T[idx].v1.y));

	tbbs[idx].bounds[0].z = glm::min(T[idx].v2.z, glm::min(T[idx].v0.z, T[idx].v1.z));
	tbbs[idx].bounds[1].z = glm::max(T[idx].v2.z, glm::max(T[idx].v0.z, T[idx].v1.z));
}

KDTreeNode* BuildKDTree(const vector<Triangle>& T)
{
	thrust::device_vector<Triangle> t = T;
	int block = t.size() / 1024 + 1;

	AABB* tbbs;
	cudaMalloc((void**)&tbbs, sizeof(AABB) * t.size());

	ComputeAABB << < block, 1024 >> > (t.data().get(), t.size(), tbbs);
	cout << "Compute Tri AABB" << endl;
	
	Nvector* nodeList = new Nvector();

	Nvector* activeList = new Nvector();

	Nvector* smallList = new Nvector();

	Nvector* nextList = new Nvector();

	KDTreeNode* root = new KDTreeNode();

	//////////////////////////////////////////////
	//	initialize root node

	root->bnd.bounds[0] = vec3(-60, -60, -60);
	root->bnd.bounds[1] = vec3(60, 60, 60);
	root->triangleNum = t.size();
	root->chunkSize = t.size() / CHUNKSIZE + 1;

	int* triIdx = new int[t.size()];
	for (int i = 0; i < t.size(); i++)
	{
		triIdx[i] = i;
	}
	int* triIdxDev;
	cudaMalloc((void**)&triIdxDev, sizeof(int) * t.size());
	cudaMemcpy(triIdxDev, triIdx, sizeof(int) * t.size(), cudaMemcpyHostToDevice);
	root->triIdx = triIdxDev;
	
	root->triAABB = tbbs;

	int* tag;
	cudaMalloc((void**)&tag, sizeof(int) * t.size());
	cudaMemcpy(tag, triIdx, sizeof(int) * t.size(), cudaMemcpyHostToDevice);
	root->tag = tag;

	activeList->push_back(*root);

	//////////////////////////////////////////////



	//////////////////////////////////////////////
	// Large node stage
	int aa = 1;
	while (!activeList->empty() && aa == 1)
	{
		nodeList->append(activeList);
		delete nextList;
		nextList = new Nvector();

		ProcessLargeNodes(activeList, smallList, nextList, t.data().get(), t.size());

		/*Nvector* tmp = activeList;
		activeList = nextList;
		nextList = tmp;*/

		aa = 0;
	}
	

	cout << "KDend\n" << endl;
	
	delete nodeList;
	delete activeList;
	delete smallList;
	delete nextList;
	delete root;


	return nullptr;
}

__global__ void ChunkingTriangle(Nvector* activeList, ChunkNode* chunkList)
{
	unsigned int idx = blockDim.x * blockIdx.x + threadIdx.x;

	if (idx < activeList->size())
	{
		int size = activeList->operator[](idx).chunkSize;

		for (int i = 0; i < size; i++)
		{
			ChunkNode newChunk;
			newChunk.node = &activeList->operator[](idx);
			newChunk.firstTriangle = i*CHUNKSIZE;
			//newChunk.firstTriangle = 100;

			if (i == size - 1)
				newChunk.triangleNum = activeList->operator[](idx).triangleNum - CHUNKSIZE*i;
			else
				newChunk.triangleNum = CHUNKSIZE;

			// 자신보다 index가 앞인 노드들의 chunk 수를 모두 더해서 chunk list에서 현재 노드의 시작 위치를 알아낸다.
			int startIdx = 0;
			for (int j = 0; j < idx; j++)
			{
				startIdx += activeList->operator[](j).chunkSize;
			}

			chunkList[startIdx + i] = newChunk;
	
			//chunkList[0].triangleNum = size;
		}
	}
}


__global__ void ComputeChunkAABB(ChunkNode* chunkList, int chunkNum, Triangle* T)
{
	unsigned int idx = blockDim.x * blockIdx.x + threadIdx.x;

	if (idx < chunkNum)
	{
		vec3 max = { -99999,-99999,-99999 };
		vec3 min = { 99999,99999,99999 };

		for (int i = 0; i < CHUNKSIZE; i++)
		{
			chunkList[idx].cbb.bounds[0].x = thrust::min(min.x, chunkList[idx].node->triAABB[chunkList[idx].firstTriangle + i].bounds[0].x);
			chunkList[idx].cbb.bounds[0].y = thrust::min(min.y, chunkList[idx].node->triAABB[chunkList[idx].firstTriangle + i].bounds[0].y);
			chunkList[idx].cbb.bounds[0].z = thrust::min(min.z, chunkList[idx].node->triAABB[chunkList[idx].firstTriangle + i].bounds[0].z);

			chunkList[idx].cbb.bounds[1].x = thrust::max(max.x, chunkList[idx].node->triAABB[chunkList[idx].firstTriangle + i].bounds[1].x);
			chunkList[idx].cbb.bounds[1].y = thrust::max(max.y, chunkList[idx].node->triAABB[chunkList[idx].firstTriangle + i].bounds[1].y);
			chunkList[idx].cbb.bounds[1].z = thrust::max(max.z, chunkList[idx].node->triAABB[chunkList[idx].firstTriangle + i].bounds[1].z);
			//	???chunkList[idx].cbb.bounds[1].z = thrust::max(max.z, chunkList[idx].node->triAABB[chunkList[idx].node->triIdx[chunkList[idx].firstTriangle + i]].bounds[1].z);

			min.x = chunkList[idx].cbb.bounds[0].x;
			min.y = chunkList[idx].cbb.bounds[0].y;
			min.z = chunkList[idx].cbb.bounds[0].z;

			max.x = chunkList[idx].cbb.bounds[1].x;
			max.y = chunkList[idx].cbb.bounds[1].y;
			max.z = chunkList[idx].cbb.bounds[1].z;

		}	
	}
}


__global__ void SegmentedReduction(ChunkNode* chunkList, int gap, int cnum)
{
	unsigned int idx = blockDim.x * blockIdx.x + threadIdx.x;

	if (idx*gap * 2 > cnum - 1 || idx*gap * 2 + gap > cnum-1)
		return;

	if (chunkList[idx*gap * 2].node == chunkList[idx*gap * 2 + gap].node)
	{
		chunkList[idx*gap * 2].cbb.bounds[0].x = thrust::min(chunkList[idx*gap * 2].cbb.bounds[0].x, chunkList[idx*gap * 2 + gap].cbb.bounds[0].x);
		chunkList[idx*gap * 2].cbb.bounds[0].y = thrust::min(chunkList[idx*gap * 2].cbb.bounds[0].y, chunkList[idx*gap * 2 + gap].cbb.bounds[0].y);
		chunkList[idx*gap * 2].cbb.bounds[0].z = thrust::min(chunkList[idx*gap * 2].cbb.bounds[0].z, chunkList[idx*gap * 2 + gap].cbb.bounds[0].z);

		chunkList[idx*gap * 2].cbb.bounds[1].x = thrust::max(chunkList[idx*gap * 2].cbb.bounds[1].x, chunkList[idx*gap * 2 + gap].cbb.bounds[1].x);
		chunkList[idx*gap * 2].cbb.bounds[1].y = thrust::max(chunkList[idx*gap * 2].cbb.bounds[1].y, chunkList[idx*gap * 2 + gap].cbb.bounds[1].y);
		chunkList[idx*gap * 2].cbb.bounds[1].z = thrust::max(chunkList[idx*gap * 2].cbb.bounds[1].z, chunkList[idx*gap * 2 + gap].cbb.bounds[1].z);
	}
	else
	{	
		if (chunkList[idx*gap * 2 + gap].node == chunkList[0].node)
		{
			chunkList[idx*gap * 2].node->tbb.bounds[0].x = thrust::min(chunkList[idx*gap * 2].node->tbb.bounds[0].x, chunkList[idx*gap * 2].cbb.bounds[0].x);
			chunkList[idx*gap * 2].node->tbb.bounds[0].y = thrust::min(chunkList[idx*gap * 2].node->tbb.bounds[0].y, chunkList[idx*gap * 2].cbb.bounds[0].y);
			chunkList[idx*gap * 2].node->tbb.bounds[0].z = thrust::min(chunkList[idx*gap * 2].node->tbb.bounds[0].z, chunkList[idx*gap * 2].cbb.bounds[0].z);

			chunkList[idx*gap * 2].node->tbb.bounds[1].x = thrust::max(chunkList[idx*gap * 2].node->tbb.bounds[1].x, chunkList[idx*gap * 2].cbb.bounds[1].x);
			chunkList[idx*gap * 2].node->tbb.bounds[1].y = thrust::max(chunkList[idx*gap * 2].node->tbb.bounds[1].y, chunkList[idx*gap * 2].cbb.bounds[1].y);
			chunkList[idx*gap * 2].node->tbb.bounds[1].z = thrust::max(chunkList[idx*gap * 2].node->tbb.bounds[1].z, chunkList[idx*gap * 2].cbb.bounds[1].z);

			chunkList[idx*gap * 2] = chunkList[idx*gap * 2 + gap];
		}
		else
		{
			chunkList[idx*gap * 2 + gap].node->tbb.bounds[0].x = thrust::min(chunkList[idx*gap * 2 + gap].node->tbb.bounds[0].x, chunkList[idx*gap * 2 + gap].cbb.bounds[0].x);
			chunkList[idx*gap * 2 + gap].node->tbb.bounds[0].y = thrust::min(chunkList[idx*gap * 2 + gap].node->tbb.bounds[0].y, chunkList[idx*gap * 2 + gap].cbb.bounds[0].y);
			chunkList[idx*gap * 2 + gap].node->tbb.bounds[0].z = thrust::min(chunkList[idx*gap * 2 + gap].node->tbb.bounds[0].z, chunkList[idx*gap * 2 + gap].cbb.bounds[0].z);

			chunkList[idx*gap * 2 + gap].node->tbb.bounds[1].x = thrust::max(chunkList[idx*gap * 2 + gap].node->tbb.bounds[1].x, chunkList[idx*gap * 2 + gap].cbb.bounds[1].x);
			chunkList[idx*gap * 2 + gap].node->tbb.bounds[1].y = thrust::max(chunkList[idx*gap * 2 + gap].node->tbb.bounds[1].y, chunkList[idx*gap * 2 + gap].cbb.bounds[1].y);
			chunkList[idx*gap * 2 + gap].node->tbb.bounds[1].z = thrust::max(chunkList[idx*gap * 2 + gap].node->tbb.bounds[1].z, chunkList[idx*gap * 2 + gap].cbb.bounds[1].z);
		}
	}

	//	기준이 되는 노드의 정보 수정
	chunkList[0].node->tbb = chunkList[0].cbb;
}


__global__ void SplitLargeNode(Nvector* activeList, KDTreeNode* devNextData)
{
	unsigned int idx = blockDim.x * blockIdx.x + threadIdx.x;

	if (idx >= activeList->size())
		return;


	////////////////////////////////////////////////////
	//	cut off empty space
	//	min
	if (abs(activeList->operator[](idx).bnd.bounds[0].x-activeList->operator[](idx).tbb.bounds[0].x) / 
		abs(activeList->operator[](idx).bnd.bounds[0].x - activeList->operator[](idx).bnd.bounds[1].x) > CUTOFF)
	{
		activeList->operator[](idx).bnd.bounds[0].x = activeList->operator[](idx).tbb.bounds[0].x;
	}

	if (abs(activeList->operator[](idx).bnd.bounds[0].y - activeList->operator[](idx).tbb.bounds[0].y) / 
		abs(activeList->operator[](idx).bnd.bounds[0].y- activeList->operator[](idx).bnd.bounds[1].y) > CUTOFF)
	{
		activeList->operator[](idx).bnd.bounds[0].y = activeList->operator[](idx).tbb.bounds[0].y;
	}

	if (abs(activeList->operator[](idx).bnd.bounds[0].z - activeList->operator[](idx).tbb.bounds[0].z) / 
		abs(activeList->operator[](idx).bnd.bounds[0].z - activeList->operator[](idx).bnd.bounds[1].z) > CUTOFF)
	{
		activeList->operator[](idx).bnd.bounds[0].z = activeList->operator[](idx).tbb.bounds[0].z;
	}


	// max
	if (abs(activeList->operator[](idx).bnd.bounds[1].x - activeList->operator[](idx).tbb.bounds[1].x) / 
		abs(activeList->operator[](idx).bnd.bounds[0].x - activeList->operator[](idx).bnd.bounds[1].x)> CUTOFF)
	{
		activeList->operator[](idx).bnd.bounds[1].x = activeList->operator[](idx).tbb.bounds[1].x;
	}

	if (abs((*activeList)[idx].bnd.bounds[1].y - (*activeList)[idx].tbb.bounds[1].y) /
		abs((*activeList)[idx].bnd.bounds[0].y - (*activeList)[idx].bnd.bounds[1].y) > CUTOFF)
	{
		(*activeList)[idx].bnd.bounds[1].y = (*activeList)[idx].tbb.bounds[1].y;
	}

	if (abs(activeList->operator[](idx).bnd.bounds[1].z - activeList->operator[](idx).tbb.bounds[1].z) / 
		abs(activeList->operator[](idx).bnd.bounds[0].z - activeList->operator[](idx).bnd.bounds[1].z) > CUTOFF)
	{
		activeList->operator[](idx).bnd.bounds[1].z = activeList->operator[](idx).tbb.bounds[1].z;
	}
	////////////////////////////////////////////////////


	////////////////////////////////////////////////////
	//	split node at spatial median of the longest axis
	float xAxis = abs(activeList->operator[](idx).tbb.bounds[0].x - activeList->operator[](idx).tbb.bounds[1].x);
	float yAxis = abs(activeList->operator[](idx).tbb.bounds[0].y - activeList->operator[](idx).tbb.bounds[1].y);
	float zAxis = abs(activeList->operator[](idx).tbb.bounds[0].z - activeList->operator[](idx).tbb.bounds[1].z);

	float maxAxis = thrust::max(zAxis, thrust::max(xAxis, yAxis));
	

	if (xAxis == maxAxis)
	{
		float median = (activeList->operator[](idx).tbb.bounds[0].x + activeList->operator[](idx).tbb.bounds[1].x) / 2;

		KDTreeNode* leftChild = &devNextData[idx * 2];
		KDTreeNode* rightChild = &devNextData[idx * 2 + 1];

		leftChild->bnd = activeList->operator[](idx).tbb;
		leftChild->bnd.bounds[1].x = median;

		rightChild->bnd = activeList->operator[](idx).tbb;
		rightChild->bnd.bounds[0].x = median;

		activeList->operator[](idx).leftChild = leftChild;
		activeList->operator[](idx).rightChild = rightChild;

	}
	else if (yAxis == maxAxis)
	{
		float median = (activeList->operator[](idx).bnd.bounds[0].y + activeList->operator[](idx).bnd.bounds[1].y) / 2;

		KDTreeNode* leftChild = &devNextData[idx * 2];
		KDTreeNode* rightChild = &devNextData[idx * 2 + 1];

		leftChild->bnd = activeList->operator[](idx).tbb;
		leftChild->bnd.bounds[1].y = median;

		rightChild->bnd = activeList->operator[](idx).tbb;
		rightChild->bnd.bounds[0].y = median;

		activeList->operator[](idx).leftChild = leftChild;
		activeList->operator[](idx).rightChild = rightChild;
	}
	else
	{
		float median = (activeList->operator[](idx).bnd.bounds[0].z + activeList->operator[](idx).bnd.bounds[1].z) / 2;

		KDTreeNode* leftChild = &devNextData[idx * 2];
		KDTreeNode* rightChild = &devNextData[idx * 2 + 1];

		leftChild->bnd = activeList->operator[](idx).tbb;
		leftChild->bnd.bounds[1].z = median;

		rightChild->bnd = activeList->operator[](idx).tbb;
		rightChild->bnd.bounds[0].z = median;

		activeList->operator[](idx).leftChild = leftChild;
		activeList->operator[](idx).rightChild = rightChild;
	}
	////////////////////////////////////////////////////

	//if (activeList->operator[](0).leftChild->triangleNum == 100)
	//	activeList->operator[](idx).bnd.bounds[0].x = 11111.0f;
}


__global__ void SortAndClip(ChunkNode* chunkList, Triangle* T, int& cnum)
{
	unsigned int idx = blockDim.x * blockIdx.x + threadIdx.x;

	unsigned int chunkIdx = blockIdx.x;
	unsigned int triIdx = threadIdx.x;


	if (triIdx >= chunkList[chunkIdx].triangleNum || chunkIdx >= cnum)
		return;

	if (chunkList[chunkIdx].node->triAABB[chunkList[chunkIdx].node->triIdx[chunkList[chunkIdx].firstTriangle + triIdx]].bounds[0].x == 123445)
	{
		//T[idx].tag = 1;
	}
	
}



void ProcessLargeNodes(Nvector* activeList, Nvector* smallList, Nvector* nextList, Triangle* T, int triangleNum)
{
	//	copy active list to GPU memory

	KDTreeNode* devData;
	cudaMalloc((void**)&devData, sizeof(KDTreeNode)*activeList->size());
	cudaMemcpy(devData, activeList->data, sizeof(KDTreeNode)*activeList->size(), cudaMemcpyHostToDevice);

	Nvector* tmp = new Nvector();
	tmp->data = devData;
	tmp->capacity = activeList->capacity;
	tmp->sz = activeList->sz;

	Nvector* devActiveList;
	cudaMalloc((void**)&devActiveList, sizeof(Nvector));
	cudaMemcpy(devActiveList, tmp, sizeof(Nvector), cudaMemcpyHostToDevice);

	

	///////////////////////////////////////////////
	//	1st step, group triangles into chunks
	ChunkNode* chunkList;

	//	active list에 존재하는 모든 chunk의 개수를 구한다.
	int cnum = 0;
	for (int i = 0; i < activeList->size(); i++)
	{
		cnum += activeList->operator[](i).chunkSize;
	}
	cudaMalloc((void**)&chunkList, sizeof(ChunkNode)*cnum);
	
	int block = activeList->size();

	ChunkingTriangle << < block, 1 >> > (devActiveList, chunkList);	
	///////////////////////////////////////////////


	///////////////////////////////////////////////
	//	2nd step, compute per-node bounding box
	ComputeChunkAABB << < cnum, 1 >> > (chunkList, cnum, T);
	
	int a = 0;
	if (cnum % 2 == 0)
		a = cnum / 2;
	else
		a = cnum / 2 + 1;

	for (int gap = 0; gap < a; gap++)
	{
		SegmentedReduction << < 1, cnum >> > (chunkList, pow(2, gap), cnum);
	}
	///////////////////////////////////////////////


	///////////////////////////////////////////////
	//	3rd step, split large node
	block = activeList->size();

	KDTreeNode* devNextData;
	cudaMalloc((void**)&devNextData, 2 * sizeof(KDTreeNode) * block);

	block = activeList->size();
	SplitLargeNode << < block, 1 >> > (devActiveList, devNextData);

	KDTreeNode* nextData = new KDTreeNode();
	cudaMemcpy(nextData, devNextData, 2 * sizeof(KDTreeNode) * block, cudaMemcpyDeviceToHost);

	for (int i = 0; i < 2 * sizeof(KDTreeNode) * block; i++)
	{
		nextList->push_back(nextData[i]);	
	}
	///////////////////////////////////////////////


	///////////////////////////////////////////////
	//	4th step, sort and clip triangles to child nodes

	block = cnum;
	SortAndClip << < block, CHUNKSIZE >> > (chunkList, T, cnum);

	///////////////////////////////////////////////


	ChunkNode* hostList = new ChunkNode[cnum];
	cudaMemcpy(hostList, chunkList, sizeof(ChunkNode)*cnum, cudaMemcpyDeviceToHost);

	cout << "idx " <<hostList[33].triangleNum << endl;

	for (int i = 0; i < 34; i++)
	{
		//cout << "AABB " << hostList[i].cbb.bounds[1].y << endl;
	}

	
	Nvector *aa = new Nvector();
	cudaMemcpy(aa, devActiveList, sizeof(Nvector), cudaMemcpyDeviceToHost);

	//cudaMemcpy(hostList, chunkList, sizeof(ChunkNode)*cnum, cudaMemcpyDeviceToHost);
	KDTreeNode* node11 = new KDTreeNode();
	cudaMemcpy(node11, &aa->operator[](0), sizeof(KDTreeNode), cudaMemcpyDeviceToHost);

	cout << "=============node tri=============" << endl;
	cout << "AABB " << node11->tbb.bounds[0].x << endl;
	cout << "AABB " << node11->tbb.bounds[0].y << endl;
	cout << "AABB " << node11->tbb.bounds[0].z << endl;

	cout << "AABB " << node11->tbb.bounds[1].x << endl;
	cout << "AABB " << node11->tbb.bounds[1].y << endl;
	cout << "AABB " << node11->tbb.bounds[1].z << endl;

	cout << "=============node =============" << endl;
	cout << "AABB " << node11->bnd.bounds[0].x << endl;
	cout << "AABB " << node11->bnd.bounds[0].y << endl;
	cout << "AABB " << node11->bnd.bounds[0].z << endl;

	cout << "AABB " << node11->bnd.bounds[1].x << endl;
	cout << "AABB " << node11->bnd.bounds[1].y << endl;
	cout << "AABB " << node11->bnd.bounds[1].z << endl;


	KDTreeNode* leftnode = new KDTreeNode();
	cudaMemcpy(leftnode, node11->leftChild, sizeof(KDTreeNode), cudaMemcpyDeviceToHost);

	cout << "============left==============" << endl;
	cout << "AABB " << leftnode->bnd.bounds[0].x << endl;
	cout << "AABB " << leftnode->bnd.bounds[0].y << endl;
	cout << "AABB " << leftnode->bnd.bounds[0].z << endl;

	cout << "AABB " << leftnode->bnd.bounds[1].x << endl;
	cout << "AABB " << leftnode->bnd.bounds[1].y << endl;
	cout << "AABB " << leftnode->bnd.bounds[1].z << endl;

	KDTreeNode* rightnode = new KDTreeNode();
	cudaMemcpy(rightnode, node11->rightChild, sizeof(KDTreeNode), cudaMemcpyDeviceToHost);

	cout << "============right==============" << endl;
	cout << "AABB " << rightnode->bnd.bounds[0].x << endl;
	cout << "AABB " << rightnode->bnd.bounds[0].y << endl;
	cout << "AABB " << rightnode->bnd.bounds[0].z << endl;

	cout << "AABB " << rightnode->bnd.bounds[1].x << endl;
	cout << "AABB " << rightnode->bnd.bounds[1].y << endl;
	cout << "AABB " << rightnode->bnd.bounds[1].z << endl;


	cudaFree(chunkList);
	delete hostList;

	cudaFree(devData);
	cudaFree(devActiveList);

	tmp->data = nullptr;
	delete tmp;

} 
