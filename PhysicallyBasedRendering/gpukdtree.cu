#include <algorithm>
#include <assert.h>
#include <thrust/transform_reduce.h>
#include "RayTracer.cuh"

#define INF 999999.0f
__global__
void dkdtree::cu_create_AABB(int n, Triangle* tri, AABB* aabb)
{
	unsigned int tid = blockDim.x * blockIdx.x + threadIdx.x;
	if (tid >= n)
		return;
	dkdtree::AABBMax(&(tri[tid].v0), &(tri[tid].v1), &(tri[tid].v2), &(aabb[tid].bounds[1]));
	dkdtree::AABBMin(&(tri[tid].v0), &(tri[tid].v1), &(tri[tid].v2), &(aabb[tid].bounds[0]));
}

__inline__ __device__ void dkdtree::AABBMax(vec3* x, vec3* y, vec3* z, vec3* dist)
{
	float xmax = x->x>y->x ? x->x : y->x;
	xmax = xmax>z->x ? xmax : z->x;
	float ymax = x->y>y->y ? x->y : y->y;
	ymax = ymax>z->y ? ymax : z->y;
	float zmax = x->z>y->z ? x->z : y->z;
	zmax = zmax>z->z ? zmax : z->z;
	dist->x = xmax;
	dist->y = ymax;
	dist->z = zmax;
}
__inline__ __device__ void dkdtree::AABBMin(vec3* x, vec3* y, vec3* z, vec3* dist)
{
	float xmax = x->x<y->x ? x->x : y->x;
	xmax = xmax<z->x ? xmax : z->x;
	float ymax = x->y<y->y ? x->y : y->y;
	ymax = ymax<z->y ? ymax : z->y;
	float zmax = x->z<y->z ? x->z : y->z;
	zmax = zmax<z->z ? zmax : z->z;
	dist->x = xmax;
	dist->y = ymax;
	dist->z = zmax;
}

gpukdtree::gpukdtree(Triangle* tri, int n, AABB rootaabb)
{
	h_Triangles = tri;
	nTriangle = n;
	rootAABB = rootaabb;
}
gpukdtree::~gpukdtree()
{
	freeMemory();
}
void gpukdtree::allocateMemory()
{
	cudaMalloc((void**)&d_Triangles, sizeof(Triangle)*nTriangle);
	cudaMalloc((void**)&d_AABB, sizeof(AABB)*nTriangle);
	cudaMemcpy(d_Triangles, h_Triangles, sizeof(Triangle)*nTriangle, cudaMemcpyHostToDevice);

	

	nodes.allocateMemory(nTriangle / 3);
	triangleNodeAssociation.allocateMemory(nTriangle * 30);
	triangleNodeAssociationHelper.allocateMemory(nTriangle * 10);
	activeList.allocateMemory(nTriangle / 3);
	nextList.allocateMemory(nTriangle / 3);
	smallList.allocateMemory(nTriangle / 3);
}

void gpukdtree::freeMemory()
{
	cudaFree(d_Triangles);
	cudaFree(d_AABB);
}



void gpukdtree::create()
{
	cudaError_t err = cudaSuccess;
	int blocksize = (nTriangle + 255) / 256;

	allocateMemory();

	//cout << "memcpy on gpu" << endl;
	// calculate AABB
	dkdtree::cu_create_AABB << <blocksize, 256 >> >(nTriangle, d_Triangles, d_AABB);
	cudaThreadSynchronize();

	//create kd tree
	MidSplit();
	SAHSplit();
	//cout<<"gpu kdtree debug info:"<<endl;
	//cout<<nodes.size()<<endl;
	//cout<<triangleNodeAssociation.size()<<endl;

	err = cudaGetLastError();
	if (err != cudaSuccess)cout << cudaGetErrorString(err) << endl;
}

void gpukdtree::MidSplit()
{
	//dkdtree::InitRoot<<<1,1>>>(nTriangle, nodes.data, nodes.d_ptr, activeList.data, activeList.d_ptr, nextList.d_ptr, triangleNodeAssociation.d_ptr, CalculateRootAABB());
	dkdtree::InitRoot << <1, 1 >> >(nTriangle, nodes.data, nodes.d_ptr, activeList.data, activeList.d_ptr, nextList.d_ptr, smallList.d_ptr, triangleNodeAssociation.d_ptr, rootAABB);
	cudaDeviceSynchronize();

	dkdtree::CopyTriangle << <(nTriangle + 255) / 256, 256 >> >(triangleNodeAssociation.data, nTriangle);
	cudaDeviceSynchronize();


	while (!activeList.h_empty())
	{
		int base = nodes.size() - 1;
		int startnode = nodes.size();
		int start = triangleNodeAssociation.size();
		triangleNodeAssociationHelper.h_clear();
		dkdtree::MidSplitNode << <(activeList.size() + 255) / 256, 256 >> >(d_Triangles, d_AABB, nTriangle,
			nodes.data,
			nodes.d_ptr,
			activeList.data,
			activeList.d_ptr,
			nextList.data,
			nextList.d_ptr,
			smallList.data,
			smallList.d_ptr,
			triangleNodeAssociation.data,
			triangleNodeAssociation.d_ptr,
			triangleNodeAssociationHelper.data,
			triangleNodeAssociationHelper.d_ptr,
			start);
		cudaDeviceSynchronize();
		int end = triangleNodeAssociation.size();
		int endnode = nodes.size() - 1;
		int noftna = end - start;
		thrust::sort_by_key(triangleNodeAssociationHelper.thrustPtr, triangleNodeAssociationHelper.thrustPtr + noftna, triangleNodeAssociation.thrustPtr + start);
		cudaDeviceSynchronize();
		// calculate triangleIndex
		dkdtree::CalculateTriangleIndex << <1, 1 >> >(startnode, endnode, base, nodes.data);
		cudaDeviceSynchronize();
		// switch aciveList and nextList
		//cout<<"nextlist size:"<<nextList.size()<<" tnasize="<<noftna<<endl;
		cudaMemcpy(activeList.data, nextList.data, sizeof(int)*nextList.size(), cudaMemcpyDeviceToDevice);
		cudaMemcpy(activeList.d_ptr, nextList.d_ptr, sizeof(unsigned int), cudaMemcpyDeviceToDevice);

		nextList.h_clear();
		triangleNodeAssociationHelper.h_clear();
		cudaDeviceSynchronize();
	}
}

void gpukdtree::SAHSplit()
{
	while (!smallList.h_empty())
	{
		int base = nodes.size() - 1;
		int startnode = nodes.size();
		int start = triangleNodeAssociation.size();
		triangleNodeAssociationHelper.h_clear();
		dkdtree::SAHSplitNode << <(smallList.size() + 255) / 256, 256 >> >(d_Triangles, d_AABB, nTriangle,
			nodes.data,
			nodes.d_ptr,
			smallList.data,
			smallList.d_ptr,
			nextList.data,
			nextList.d_ptr,
			triangleNodeAssociation.data,
			triangleNodeAssociation.d_ptr,
			triangleNodeAssociationHelper.data,
			triangleNodeAssociationHelper.d_ptr,
			start);
		cudaDeviceSynchronize();
		int end = triangleNodeAssociation.size();
		int endnode = nodes.size() - 1;
		int noftna = end - start;
		thrust::sort_by_key(triangleNodeAssociationHelper.thrustPtr, triangleNodeAssociationHelper.thrustPtr + noftna, triangleNodeAssociation.thrustPtr + start);
		cudaDeviceSynchronize();
		// calculate triangleIndex
		dkdtree::CalculateTriangleIndex << <1, 1 >> >(startnode, endnode, base, nodes.data);
		cudaDeviceSynchronize();
		// switch aciveList and nextList
		//cout<<"nextlist size:"<<nextList.size()<<" tnasize="<<noftna<<endl;
		cudaMemcpy(smallList.data, nextList.data, sizeof(int)*nextList.size(), cudaMemcpyDeviceToDevice);
		cudaMemcpy(smallList.d_ptr, nextList.d_ptr, sizeof(unsigned int), cudaMemcpyDeviceToDevice);

		nextList.h_clear();
		triangleNodeAssociationHelper.h_clear();
		cudaDeviceSynchronize();
	}
}

__global__ void dkdtree::SAHSplitNode(Triangle* tri,
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
	unsigned int tnaStartPtr)
{
	unsigned int tid = blockDim.x*blockIdx.x + threadIdx.x;
	if (tid >= *smallListPtr)
		return;
	//printf("tid=%d\n",tid);
	int id = smallList[tid];
	//printf("node triangle number=%d\n",nodes[id].triangleNumber);
	int leftid;
	int rightid;
	float tpos;
	//gpukdtreeNode currentNode(nodes[id]);
	vec3 volume = nodes[id].nodeAABB.bounds[1] - nodes[id].nodeAABB.bounds[0];
	if (volume.x >= volume.y && volume.x >= volume.z)// split x
	{
		nodes[id].splitAxis = 0;
		// looking for best candidate
		float minsah = 999999.0f;
		float minpos;

		for (float p = 0.1f; p<1.0f; p += 0.1f) {
			tpos = nodes[id].nodeAABB.bounds[0].x + volume.x*p;
			int ct1, ct2;
			ct1 = ct2 = 0;
			for (int i = nodes[id].triangleIndex, j = 0; j<nodes[id].triangleNumber; i++, j++) {
				if ((aabb[tnaPtr[i]].bounds[0].x + aabb[tnaPtr[i]].bounds[1].x) / 2<tpos)
					ct1++;
				else
					ct2++;
			}
			float sah = ct1*p + ct2*(1 - p);
			if (sah<minsah) {
				minsah = sah;
				minpos = tpos;
			}
		}
		nodes[id].splitPos = tpos;

		gpukdtreeNode atarashiiNode;
		atarashiiNode.nodeAABB = nodes[id].nodeAABB;
		atarashiiNode.nodeAABB.bounds[1].x = tpos;
		leftid = DeviceVector<gpukdtreeNode>::push_back(nodes, nodesPtr, atarashiiNode);
		nodes[id].leftChild = leftid;

		atarashiiNode.nodeAABB.bounds[1].x = nodes[id].nodeAABB.bounds[1].x;
		atarashiiNode.nodeAABB.bounds[0].x = tpos;
		rightid = DeviceVector<gpukdtreeNode>::push_back(nodes, nodesPtr, atarashiiNode);
		nodes[id].rightChild = rightid;
	}
	else if (volume.y >= volume.x && volume.y >= volume.z)// split y
	{
		nodes[id].splitAxis = 1;
		// looking for best candidate
		float minsah = 999999.0f;
		float minpos;

		for (float p = 0.1f; p<1.0f; p += 0.1f) {
			tpos = nodes[id].nodeAABB.bounds[0].y + volume.y*p;
			int ct1, ct2;
			ct1 = ct2 = 0;
			for (int i = nodes[id].triangleIndex, j = 0; j<nodes[id].triangleNumber; i++, j++) {
				if ((aabb[tnaPtr[i]].bounds[0].y + aabb[tnaPtr[i]].bounds[1].y) / 2<tpos)
					ct1++;
				else
					ct2++;
			}
			float sah = ct1*p + ct2*(1 - p);
			if (sah<minsah) {
				minsah = sah;
				minpos = tpos;
			}
		}
		nodes[id].splitPos = tpos;

		gpukdtreeNode atarashiiNode;
		atarashiiNode.nodeAABB = nodes[id].nodeAABB;
		atarashiiNode.nodeAABB.bounds[1].y = tpos;
		leftid = DeviceVector<gpukdtreeNode>::push_back(nodes, nodesPtr, atarashiiNode);
		nodes[id].leftChild = leftid;

		atarashiiNode.nodeAABB.bounds[1].y = nodes[id].nodeAABB.bounds[1].y;
		atarashiiNode.nodeAABB.bounds[0].y = tpos;
		rightid = DeviceVector<gpukdtreeNode>::push_back(nodes, nodesPtr, atarashiiNode);
		nodes[id].rightChild = rightid;
	}
	else // split z
	{
		nodes[id].splitAxis = 2;
		// looking for best candidate
		float minsah = 999999.0f;
		float minpos;

		for (float p = 0.1f; p<1.0f; p += 0.1f) {
			tpos = nodes[id].nodeAABB.bounds[0].z + volume.z*p;
			int ct1, ct2;
			ct1 = ct2 = 0;
			for (int i = nodes[id].triangleIndex, j = 0; j<nodes[id].triangleNumber; i++, j++) {
				if ((aabb[tnaPtr[i]].bounds[0].z + aabb[tnaPtr[i]].bounds[1].z) / 2<tpos)
					ct1++;
				else
					ct2++;
			}
			float sah = ct1*p + ct2*(1 - p);
			if (sah<minsah) {
				minsah = sah;
				minpos = tpos;
			}
		}
		nodes[id].splitPos = tpos;

		gpukdtreeNode atarashiiNode;
		atarashiiNode.nodeAABB = nodes[id].nodeAABB;
		atarashiiNode.nodeAABB.bounds[1].z = tpos;
		leftid = DeviceVector<gpukdtreeNode>::push_back(nodes, nodesPtr, atarashiiNode);
		nodes[id].leftChild = leftid;

		atarashiiNode.nodeAABB.bounds[1].z = nodes[id].nodeAABB.bounds[1].z;
		atarashiiNode.nodeAABB.bounds[0].z = tpos;
		rightid = DeviceVector<gpukdtreeNode>::push_back(nodes, nodesPtr, atarashiiNode);
		nodes[id].rightChild = rightid;
	}
	//printf("sp=%.3f\n",sp);
	// split triangles
	int leftcount = 0;
	int rightcount = 0;
	unsigned int tnapos;
	int endPtr = nodes[id].triangleIndex + nodes[id].triangleNumber - 1;
	/*printf("triangleIndex=%d\n", currentNode.triangleIndex);
	printf("triangleNumber=%d\n", currentNode.triangleNumber);
	printf("endPtr=%d\n", endPtr);*/
	for (int i = nodes[id].triangleIndex; i <= endPtr; i++)
	{
		int triid = tna[i];

		switch (nodes[id].splitAxis)
		{
		case 0:
			if (aabb[triid].bounds[0].x <= tpos) {
				tnapos = DeviceVector<int>::push_back(tna, tnaPtr, triid);
				//DeviceVector<int>::push_back(tnahelper, tnahelperPtr, leftid);
				tnahelper[tnapos - tnaStartPtr] = leftid;
				leftcount++;
			}
			if (aabb[triid].bounds[1].x >= tpos) {
				tnapos = DeviceVector<int>::push_back(tna, tnaPtr, triid);
				tnahelper[tnapos - tnaStartPtr] = rightid;
				rightcount++;
			}
			break;
		case 1:
			if (aabb[triid].bounds[0].y <= tpos) {
				tnapos = DeviceVector<int>::push_back(tna, tnaPtr, triid);
				tnahelper[tnapos - tnaStartPtr] = leftid;
				leftcount++;
			}
			if (aabb[triid].bounds[1].y >= tpos) {
				tnapos = DeviceVector<int>::push_back(tna, tnaPtr, triid);
				tnahelper[tnapos - tnaStartPtr] = rightid;
				rightcount++;
			}
			break;
		case 2:
			if (aabb[triid].bounds[0].z <= tpos) {
				tnapos = DeviceVector<int>::push_back(tna, tnaPtr, triid);
				tnahelper[tnapos - tnaStartPtr] = leftid;
				leftcount++;
			}
			if (aabb[triid].bounds[1].z >= tpos) {
				tnapos = DeviceVector<int>::push_back(tna, tnaPtr, triid);
				tnahelper[tnapos - tnaStartPtr] = rightid;
				rightcount++;
			}
			break;
		}
	}
	//printf("leftcount=%d\nrightcount=%d\n", leftcount, rightcount);
	nodes[leftid].triangleNumber = leftcount;
	nodes[rightid].triangleNumber = rightcount;
	//printf("node %d was splited with left = %d and right = %d with sp=%.5f tna=%d\n", id, leftcount, rightcount, sp, *tnaPtr);
	// add to nextList

	if (leftcount>GPUKDTREETHRESHOLD)
		DeviceVector<int>::push_back(smallList, smallListPtr, leftid);

	if (rightcount>GPUKDTREETHRESHOLD)
		DeviceVector<int>::push_back(smallList, smallListPtr, rightid);
}

void gpukdtree::IntersectRay(const Ray* r, int n, float* dist, int* iid)
{
	Ray* d_r;
	float* d_dist;
	int* d_iid;
	cudaMalloc((void**)&d_r, sizeof(Ray)*n);
	cudaMalloc((void**)&d_dist, sizeof(float)*n);
	cudaMalloc((void**)&d_iid, sizeof(int)*n);
	cudaMemcpy(d_r, r, sizeof(Ray)*n, cudaMemcpyHostToDevice);
	cudaMemcpy(d_dist, dist, sizeof(float)*n, cudaMemcpyHostToDevice);
	cudaMemcpy(d_iid, iid, sizeof(int)*n, cudaMemcpyHostToDevice);
	dkdtree::IntersectRay << <(n + 255) / 256, 256 >> >(d_r, n, d_dist, d_iid, nodes.data, d_Triangles, triangleNodeAssociation.data);
	cudaDeviceSynchronize();
	cudaMemcpy(dist, d_dist, sizeof(float)*n, cudaMemcpyDeviceToHost);
	cudaMemcpy(iid, d_iid, sizeof(int)*n, cudaMemcpyDeviceToHost);
	cudaFree(d_r);
	cudaFree(d_dist);
	cudaFree(d_iid);
}

AABB gpukdtree::CalculateRootAABB()
{
	thrust::device_ptr<AABB> thrustPtr(d_AABB);
	float maxx = thrust::transform_reduce(thrustPtr, thrustPtr + nTriangle, dkdtree::MaxX(), 0, thrust::maximum<float>());
	float maxy = thrust::transform_reduce(thrustPtr, thrustPtr + nTriangle, dkdtree::MaxY(), 0, thrust::maximum<float>());
	float maxz = thrust::transform_reduce(thrustPtr, thrustPtr + nTriangle, dkdtree::MaxZ(), 0, thrust::maximum<float>());
	float minx = thrust::transform_reduce(thrustPtr, thrustPtr + nTriangle, dkdtree::MinX(), 0, thrust::minimum<float>());
	float miny = thrust::transform_reduce(thrustPtr, thrustPtr + nTriangle, dkdtree::MinY(), 0, thrust::minimum<float>());
	float minz = thrust::transform_reduce(thrustPtr, thrustPtr + nTriangle, dkdtree::MinZ(), 0, thrust::minimum<float>());
	cudaDeviceSynchronize();

	AABB tmp;

	tmp.bounds[0] = vec3(minx, miny, minz);
	tmp.bounds[1] = vec3(maxx, maxy, maxz);

	return tmp;
}

__global__ void dkdtree::InitRoot(int nTri,
	gpukdtreeNode* nodes,
	unsigned int* nodesPtr,
	int* activeList,
	unsigned int* activeListPtr,
	unsigned int* nextListPtr,
	unsigned int* smallListPtr,
	unsigned int* tnaPtr,
	AABB aabb)
{
	DeviceVector<int>::clear(activeListPtr);
	DeviceVector<int>::clear(nextListPtr);
	DeviceVector<int>::clear(smallListPtr);
	DeviceVector<int>::clear(tnaPtr);
	DeviceVector<gpukdtreeNode>::clear(nodesPtr);

	

	gpukdtreeNode n;
	n.triangleIndex = 0;
	n.triangleNumber = nTri;
	n.nodeAABB = aabb;
	DeviceVector<gpukdtreeNode>::push_back(nodes, nodesPtr, n);
	*(tnaPtr) = nTri;

	int i = 0;
	DeviceVector<int>::push_back(activeList, activeListPtr, i);
}

__global__ void dkdtree::MidSplitNode(Triangle* tri,
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
	unsigned int tnaStartPtr)
{
	unsigned int tid = blockDim.x*blockIdx.x + threadIdx.x;
	if (tid >= *activeListPtr)
		return;
	//printf("tid=%d\n",tid);
	int id = activeList[tid];
	//printf("node triangle number=%d\n",nodes[id].triangleNumber);
	int leftid;
	int rightid;
	float sp;
	//gpukdtreeNode currentNode(nodes[id]);
	vec3 volume = nodes[id].nodeAABB.bounds[1] - nodes[id].nodeAABB.bounds[0];
	if (volume.x >= volume.y && volume.x >= volume.z)// split x
	{
		nodes[id].splitAxis = 0;
		sp = nodes[id].nodeAABB.bounds[0].x + volume.x / 2;
		nodes[id].splitPos = sp;

		gpukdtreeNode atarashiiNode;
		atarashiiNode.nodeAABB = nodes[id].nodeAABB;
		atarashiiNode.nodeAABB.bounds[1].x = sp;
		leftid = DeviceVector<gpukdtreeNode>::push_back(nodes, nodesPtr, atarashiiNode);
		nodes[id].leftChild = leftid;

		atarashiiNode.nodeAABB.bounds[1].x = nodes[id].nodeAABB.bounds[1].x;
		atarashiiNode.nodeAABB.bounds[0].x = sp;
		rightid = DeviceVector<gpukdtreeNode>::push_back(nodes, nodesPtr, atarashiiNode);
		nodes[id].rightChild = rightid;
	}
	else if (volume.y >= volume.x && volume.y >= volume.z)// split y
	{
		nodes[id].splitAxis = 1;
		sp = nodes[id].nodeAABB.bounds[0].y + volume.y / 2;
		nodes[id].splitPos = sp;

		gpukdtreeNode atarashiiNode;
		atarashiiNode.nodeAABB = nodes[id].nodeAABB;
		atarashiiNode.nodeAABB.bounds[1].y = sp;
		leftid = DeviceVector<gpukdtreeNode>::push_back(nodes, nodesPtr, atarashiiNode);
		nodes[id].leftChild = leftid;

		atarashiiNode.nodeAABB.bounds[1].y = nodes[id].nodeAABB.bounds[1].y;
		atarashiiNode.nodeAABB.bounds[0].y = sp;
		rightid = DeviceVector<gpukdtreeNode>::push_back(nodes, nodesPtr, atarashiiNode);
		nodes[id].rightChild = rightid;
	}
	else // split z
	{
		nodes[id].splitAxis = 2;
		sp = nodes[id].nodeAABB.bounds[0].z + volume.z / 2;
		nodes[id].splitPos = sp;

		gpukdtreeNode atarashiiNode;
		atarashiiNode.nodeAABB = nodes[id].nodeAABB;
		atarashiiNode.nodeAABB.bounds[1].z = sp;
		leftid = DeviceVector<gpukdtreeNode>::push_back(nodes, nodesPtr, atarashiiNode);
		nodes[id].leftChild = leftid;

		atarashiiNode.nodeAABB.bounds[1].z = nodes[id].nodeAABB.bounds[1].z;
		atarashiiNode.nodeAABB.bounds[0].z = sp;
		rightid = DeviceVector<gpukdtreeNode>::push_back(nodes, nodesPtr, atarashiiNode);
		nodes[id].rightChild = rightid;
	}
	//printf("sp=%.3f\n",sp);
	// split triangles
	int leftcount = 0;
	int rightcount = 0;
	unsigned int tnapos;
	int endPtr = nodes[id].triangleIndex + nodes[id].triangleNumber - 1;
	/*printf("triangleIndex=%d\n", currentNode.triangleIndex);
	printf("triangleNumber=%d\n", currentNode.triangleNumber);
	printf("endPtr=%d\n", endPtr);*/
	for (int i = nodes[id].triangleIndex; i <= endPtr; i++)
	{
		int triid = tna[i];

		switch (nodes[id].splitAxis)
		{
		case 0:
			if (aabb[triid].bounds[0].x <= sp) {
				tnapos = DeviceVector<int>::push_back(tna, tnaPtr, triid);
				//DeviceVector<int>::push_back(tnahelper, tnahelperPtr, leftid);
				tnahelper[tnapos - tnaStartPtr] = leftid;
				leftcount++;
			}
			if (aabb[triid].bounds[1].x >= sp) {
				tnapos = DeviceVector<int>::push_back(tna, tnaPtr, triid);
				tnahelper[tnapos - tnaStartPtr] = rightid;
				rightcount++;
			}
			break;
		case 1:
			if (aabb[triid].bounds[0].y <= sp) {
				tnapos = DeviceVector<int>::push_back(tna, tnaPtr, triid);
				tnahelper[tnapos - tnaStartPtr] = leftid;
				leftcount++;
			}
			if (aabb[triid].bounds[1].y >= sp) {
				tnapos = DeviceVector<int>::push_back(tna, tnaPtr, triid);
				tnahelper[tnapos - tnaStartPtr] = rightid;
				rightcount++;
			}
			break;
		case 2:
			if (aabb[triid].bounds[0].z <= sp) {
				tnapos = DeviceVector<int>::push_back(tna, tnaPtr, triid);
				tnahelper[tnapos - tnaStartPtr] = leftid;
				leftcount++;
			}
			if (aabb[triid].bounds[1].z >= sp) {
				tnapos = DeviceVector<int>::push_back(tna, tnaPtr, triid);
				tnahelper[tnapos - tnaStartPtr] = rightid;
				rightcount++;
			}
			break;
		}
	}
	//printf("leftcount=%d\nrightcount=%d\n", leftcount, rightcount);
	nodes[leftid].triangleNumber = leftcount;
	nodes[rightid].triangleNumber = rightcount;
	//printf("node %d was splited with left = %d and right = %d with sp=%.5f tna=%d\n", id, leftcount, rightcount, sp, *tnaPtr);
	// add to nextList
	if (leftcount>GPUKDTREETHRESHOLD * 2)
		DeviceVector<int>::push_back(nextList, nextListPtr, leftid);
	else if (leftcount>GPUKDTREETHRESHOLD)
		DeviceVector<int>::push_back(smallList, smallListPtr, leftid);
	if (rightcount>GPUKDTREETHRESHOLD * 2)
		DeviceVector<int>::push_back(nextList, nextListPtr, rightid);
	else if (rightcount>GPUKDTREETHRESHOLD)
		DeviceVector<int>::push_back(smallList, smallListPtr, rightid);
}

__global__ void dkdtree::CalculateTriangleIndex(int start, int end, int base, gpukdtreeNode* nodes)
{
	int count = 0;
	int basecount = nodes[base].triangleIndex + nodes[base].triangleNumber;
	for (int i = start; i <= end; i++)
	{
		nodes[i].triangleIndex = basecount + count;
		count += nodes[i].triangleNumber;
	}
}

__global__ void dkdtree::CopyTriangle(int* tna, int n)
{
	unsigned int tid = blockDim.x*blockIdx.x + threadIdx.x;
	if (tid >= n)
		return;
	tna[tid] = tid;
}

__global__ void dkdtree::IntersectRay(const Ray* ray, int n, float* dist, int* iid, gpukdtreeNode* nodes, Triangle* tri, int* tna)
{
	unsigned int tid = blockDim.x*blockIdx.x + threadIdx.x;
	if (tid >= n)
		return;
	float mindist = INF;
	float cdist;
	int currentid, leftid, rightid, cid;
	Ray r = ray[tid];
	iid[tid] = -1;

	DeviceStack<int> treestack;
	treestack.push(0);
	while (!treestack.empty())
	{
		currentid = treestack.pop();

		//test node intersection
		if (Intersect_nodeAABB_Ray(r, currentid, nodes)) {
			leftid = nodes[currentid].leftChild;
			rightid = nodes[currentid].rightChild;
			// leaf node
			if (leftid == -1 && rightid == -1) {
				if (Intersect_nodeTriangles_Ray(r, currentid, cdist, cid, nodes, tri, tna)) {
					if (cdist<mindist) {
						mindist = cdist;
						iid[tid] = cid;
					}
				}
				continue;
			}
			// middle node
			if (leftid != -1)
				treestack.push(leftid);
			if (rightid != -1)
				treestack.push(rightid);
		}
	}
	dist[tid] = mindist;
}

__device__ bool Intersect_nodeAABB_Ray(const Ray& r, int id, gpukdtreeNode* nodes)
{
	bool intersection = true;
	float p_near_result = -FLT_MAX;
	float p_far_result = FLT_MAX;
	float p_near_comp, p_far_comp;
	AABB aabb(nodes[id].nodeAABB);

	vec3 inv_dir(1.0 / r.dir.x, 1.0 / r.dir.y, 1.0 / r.dir.z);

	for (int i = 0; i<3; i++)
	{
		switch (i)
		{
		case 0:
			p_near_comp = (aabb.bounds[0].x - r.origin.x) * inv_dir.x;
			p_far_comp = (aabb.bounds[1].x - r.origin.x) * inv_dir.x;
			break;
		case 1:
			p_near_comp = (aabb.bounds[0].y - r.origin.y) * inv_dir.y;
			p_far_comp = (aabb.bounds[1].y - r.origin.y) * inv_dir.y;
			break;
		case 2:
			p_near_comp = (aabb.bounds[0].z - r.origin.z) * inv_dir.z;
			p_far_comp = (aabb.bounds[1].z - r.origin.z) * inv_dir.z;
			break;
		}

		if (p_near_comp > p_far_comp) {
			float temp = p_near_comp;
			p_near_comp = p_far_comp;
			p_far_comp = temp;
		}

		p_near_result = ((p_near_comp > p_near_result) ? p_near_comp : p_near_result);
		p_far_result = ((p_far_comp < p_far_result) ? p_far_comp : p_far_result);

		if (p_near_result > p_far_result)
			intersection = false;
	}

	return intersection;
}
__device__ __host__ bool intersect_triangle(Ray ray, Triangle triangle, float& dist)
{
	glm::vec3 v0v1 = triangle.v1 - triangle.v0;
	glm::vec3 v0v2 = triangle.v2 - triangle.v0;
	glm::vec3 pvec = glm::cross(ray.dir, v0v2);

	float det = dot(v0v1, pvec);

	// back face culling
	if (det < 0.001f)
		return false;

	/*if (fabsf(det) < 0.01f)
	return false;*/

	float invDet = 1 / det;

	glm::vec3 tvec = ray.origin - triangle.v0;
	float u = glm::dot(tvec, pvec) * invDet;
	if (u < 0 || u > 1)
		return false;

	glm::vec3 qvec = cross(tvec, v0v1);
	float v = dot(ray.dir, qvec) * invDet;
	if (v < 0 || u + v > 1)
		return false;

	dist = dot(v0v2, qvec) * invDet;

	return dist > 0.001f;
}

__device__ bool Intersect_nodeTriangles_Ray(const Ray& r, int id, float& dist, int& iid, gpukdtreeNode* nodes, Triangle* tri, int* tna)
{
	bool intersection = false;
	float cdist;
	float mindist = INF;
	int n = nodes[id].triangleIndex + nodes[id].triangleNumber - 1;

	for (int i = nodes[id].triangleIndex; i <= n; i++)
	{
		if (intersect_triangle(r, tri[tna[i]], cdist)) {
			if (cdist<mindist) {
				mindist = cdist;
				iid = tna[i];
				intersection = true;
			}
		}
	}
	dist = mindist;
	return intersection;
}