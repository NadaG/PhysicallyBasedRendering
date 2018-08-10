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


__global__ void ComputeAABB(Triangle* T, int triangleNum)
{
	unsigned int idx = blockDim.x * blockIdx.x + threadIdx.x;
	if (idx >= triangleNum)
		return;

	T[idx].tbb.bounds[0].x = glm::min(T[idx].v2.x, glm::min(T[idx].v0.x, T[idx].v1.x));
	T[idx].tbb.bounds[1].x = glm::max(T[idx].v2.x, glm::max(T[idx].v0.x, T[idx].v1.x));

	T[idx].tbb.bounds[0].y = glm::min(T[idx].v2.y, glm::min(T[idx].v0.y, T[idx].v1.y));
	T[idx].tbb.bounds[1].y = glm::max(T[idx].v2.y, glm::max(T[idx].v0.y, T[idx].v1.y));

	T[idx].tbb.bounds[0].z = glm::min(T[idx].v2.z, glm::min(T[idx].v0.z, T[idx].v1.z));
	T[idx].tbb.bounds[1].z = glm::max(T[idx].v2.z, glm::max(T[idx].v0.z, T[idx].v1.z));
}

KDTreeNode* BuildKDTree(const vector<Triangle>& T)
{
	thrust::device_vector<Triangle> t = T;
	int block = t.size() / 1024 + 1;

	ComputeAABB << < block, 1024 >> > (t.data().get(), t.size());
	cout << "Compute Tri AABB" << endl;

	//// node list
	//Nvector* nodeList = new Nvector();
	//cudaMalloc((void**)&(nodeList->nodeTriangleList), sizeof(int)*t.size());

	//Nvector* deviceNodeList;
	//cudaMalloc((void**)&deviceNodeList, sizeof(Nvector));
	//cudaMemcpy(deviceNodeList, nodeList, sizeof(Nvector), cudaMemcpyHostToDevice);

	//// active list
	//Nvector* activeList = new Nvector();
	//cudaMalloc((void**)&(activeList->nodeTriangleList), sizeof(int)*t.size());

	//Nvector* deviceActiveList;
	//cudaMalloc((void**)&deviceActiveList, sizeof(Nvector));
	//cudaMemcpy(deviceActiveList, activeList, sizeof(Nvector), cudaMemcpyHostToDevice);

	//// small list
	//Nvector* smallList = new Nvector();
	//cudaMalloc((void**)&(smallList->nodeTriangleList), sizeof(int)*t.size());

	//Nvector* deviceSmallList;
	//cudaMalloc((void**)&deviceSmallList, sizeof(Nvector));
	//cudaMemcpy(deviceSmallList, smallList, sizeof(Nvector), cudaMemcpyHostToDevice);

	//// next list
	//Nvector* nextList = new Nvector();
	//cudaMalloc((void**)&(nextList->nodeTriangleList), sizeof(int)*t.size());

	//Nvector* deviceNextList;
	//cudaMalloc((void**)&deviceNextList, sizeof(Nvector));
	//cudaMemcpy(deviceNextList, nextList, sizeof(Nvector), cudaMemcpyHostToDevice);


	//KDTreeNode* root;
	//cudaMalloc((void**)&root, sizeof(KDTreeNode));
	
	Nvector* nodeList = new Nvector();
	nodeList->nodeTriangleList = new int[t.size()];

	Nvector* activeList = new Nvector();
	activeList->nodeTriangleList = new int[t.size()];

	Nvector* smallList = new Nvector();
	smallList->nodeTriangleList = new int[t.size()];

	Nvector* nextList = new Nvector();
	nextList->nodeTriangleList = new int[t.size()];

	KDTreeNode* root = new KDTreeNode();
	root->firstTriangle = 0;
	root->triangleNum = t.size();
	root->bnd.bounds[0] = vec3(-60, -60, -60);
	root->bnd.bounds[1] = vec3(60, 60, 60);
	root->chunkSize = t.size() / CHUNKSIZE + 1;

	activeList->push_back(*root);
	for (int i = 0; i < t.size(); i++)
	{
		activeList->nodeTriangleList[i] = i;
	}

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
	

	cout << "KDend" << endl;
	
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
			newChunk.firstTriangle = activeList->operator[](idx).firstTriangle + i*CHUNKSIZE;
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
			chunkList[idx].cbb.bounds[0].x = thrust::min(min.x, T[chunkList[idx].firstTriangle + i].tbb.bounds[0].x);
			chunkList[idx].cbb.bounds[0].y = thrust::min(min.y, T[chunkList[idx].firstTriangle + i].tbb.bounds[0].y);
			chunkList[idx].cbb.bounds[0].z = thrust::min(min.z, T[chunkList[idx].firstTriangle + i].tbb.bounds[0].z);

			chunkList[idx].cbb.bounds[1].x = thrust::max(max.x, T[chunkList[idx].firstTriangle + i].tbb.bounds[1].x);
			chunkList[idx].cbb.bounds[1].y = thrust::max(max.y, T[chunkList[idx].firstTriangle + i].tbb.bounds[1].y);
			chunkList[idx].cbb.bounds[1].z = thrust::max(max.z, T[chunkList[idx].firstTriangle + i].tbb.bounds[1].z);

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

	chunkList[0].node->tbb = chunkList[0].cbb;
}


void ProcessLargeNodes(Nvector* activeList, Nvector* smallList, Nvector* nextList, Triangle* T, int triangleNum)
{
	//	copy active list to GPU memory
	int* devNTL;
	cudaMalloc((void**)&devNTL, sizeof(int)*triangleNum);
	cudaMemcpy(devNTL, activeList->nodeTriangleList, sizeof(int)*triangleNum, cudaMemcpyHostToDevice);

	KDTreeNode* devData;
	cudaMalloc((void**)&devData, sizeof(KDTreeNode)*activeList->size());
	cudaMemcpy(devData, activeList->data, sizeof(KDTreeNode)*activeList->size(), cudaMemcpyHostToDevice);

	Nvector* tmp = new Nvector();
	tmp->nodeTriangleList = devNTL;
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

	//SplitLargeNode << < 1, 1 >> > ();

	///////////////////////////////////////////////





	ChunkNode* hostList = new ChunkNode[cnum];
	cudaMemcpy(hostList, chunkList, sizeof(ChunkNode)*cnum, cudaMemcpyDeviceToHost);

	cout << "idx " <<hostList[33].triangleNum << endl;

	for (int i = 0; i < 34; i++)
	{
		//cout << "AABB " << hostList[i].cbb.bounds[1].y << endl;
	}

	
	//cudaMemcpy(hostList, chunkList, sizeof(ChunkNode)*cnum, cudaMemcpyDeviceToHost);
	KDTreeNode* node11 = new KDTreeNode();
	cudaMemcpy(node11, hostList[0].node, sizeof(KDTreeNode), cudaMemcpyDeviceToHost);

	//cout << "==========================" << endl;
	//cout << "AABB " << hostList[0].cbb.bounds[0].x << endl;
	//cout << "AABB " << hostList[0].cbb.bounds[0].y << endl;
	//cout << "AABB " << hostList[0].cbb.bounds[0].z << endl;

	//cout << "AABB "<<hostList[0].cbb.bounds[1].x << endl;
	//cout << "AABB " << hostList[0].cbb.bounds[1].y << endl;
	//cout << "AABB " << hostList[0].cbb.bounds[1].z << endl;

	cout << "==========================" << endl;
	cout << "AABB " << node11->tbb.bounds[0].x << endl;
	cout << "AABB " << node11->tbb.bounds[0].y << endl;
	cout << "AABB " << node11->tbb.bounds[0].z << endl;

	cout << "AABB " << node11->tbb.bounds[1].x << endl;
	cout << "AABB " << node11->tbb.bounds[1].y << endl;
	cout << "AABB " << node11->tbb.bounds[1].z << endl;

	cudaFree(chunkList);
	delete hostList;
	cudaFree(devNTL);
	cudaFree(devData);
	cudaFree(devActiveList);

	tmp->nodeTriangleList = nullptr;
	tmp->data = nullptr;
	delete tmp;
}  