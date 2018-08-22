#include "RayTracer.cuh"
#include "Octree.cuh"
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


texture<float4, 2, cudaReadModeElementType> albedoTex;
texture<float4, 2, cudaReadModeElementType> normalTex;
texture<float4, 2, cudaReadModeElementType> aoTex;
texture<float4, 2, cudaReadModeElementType> metallicTex;
texture<float4, 2, cudaReadModeElementType> roughnessTex;

texture<float4, 2, cudaReadModeElementType> backgroundTex;



const int WINDOW_HEIGHT = 1024;
const int WINDOW_WIDTH = 1024;

const int RAY_X_NUM = 32;
const int RAY_Y_NUM = 32;

const int QUEUE_SIZE = 32;

const int DEPTH = 2;

const int SAMPLE_NUM = 1;

using std::cout;
using std::endl;
using std::max;
using std::min;

// TODO LIST
// 1. 에너지 보존 for reflect and refract 
// 4. marching cube로 나온 fluid가 뒷면이 culling 되어 있는 문제가 있음
// ggx distribution이라고 외우자
__device__ float DistributionGGX(vec3 N, vec3 H, float roughness)
{
	float a = roughness * roughness;
	float a2 = a * a;
	float NdotH = max(dot(N, H), 0.0f);
	float NdotH2 = NdotH * NdotH;

	float nominator = a2;
	float denominator = (NdotH2 * (a2 - 1.0) + 1.0);
	denominator = glm::pi<float>() * denominator * denominator;

	return nominator / denominator;
}

__device__ float GeometrySchlickGGX(float NdotV, float roughness)
{
	float r = (roughness + 1.0);
	float k = (r * r) / 8.0;

	float nominator = NdotV;
	float denominator = NdotV * (1.0 - k) + k;

	return nominator / denominator;
}

// smith geometry라고 외우자
// geometry shadowing 빛이 어떤 표면으로 갈 때 다른 표면에 막혀 가지 못하는 경우
// geometry obstruction 빛이 어떤 표면에서 눈으로 갈 때 다른 표면에 막혀 가지 못하는 경우
// 이 두가지를 모두 고려해야 해서 ggx1 * ggx2
// 0.8이 안 막히고, 0.8이 안 막힌다면 결국은 0.8 * 0.8
__device__ float GeometrySmith(vec3 N, vec3 V, vec3 L, float roughness)
{
	float NdotV = max(dot(N, V), 0.0f);
	float NdotL = max(dot(N, L), 0.0f);

	float ggx2 = GeometrySchlickGGX(NdotV, roughness);
	float ggx1 = GeometrySchlickGGX(NdotL, roughness);

	return ggx1 * ggx2;
}

// cosTheta가 작을 수록 큰 값이 들어간다
// 즉 90도에 가까운 곳에서 볼 수록 빛이 쎄진다는 것이다.
// 90이면 그냥 1임
// 각도가 높아지면 점점 약해지고 F0값에 가까워짐
__device__ vec3 fresnelSchlick(float cosTheta, vec3 F0)
{
	return F0 + (1.0f - F0) * pow(1.0f - cosTheta, 5.0f);
}

__device__ vec3 calculateEta(float refractiveIndex)
{
	return vec3(powf(1.0f - (1.0f / refractiveIndex), 2.0f) / powf(1.0f + (1.0f / refractiveIndex), 2.0f));
}

__device__ vec3 Interpolation(Triangle triangle, vec3 position, vec3& N, vec2& uv)
{
	vec3 v0 = triangle.v1 - triangle.v0;
	vec3 v1 = triangle.v2 - triangle.v0;
	vec3 v2 = position - triangle.v0;

	float d00 = dot(v0, v0);
	float d01 = dot(v0, v1);
	float d11 = dot(v1, v1);
	float d20 = dot(v2, v0);
	float d21 = dot(v2, v1);
	float denom = d00*d11 - d01*d01;

	float v = (d11*d20 - d01*d21) / denom;
	float w = (d00*d21 - d01*d20) / denom;
	float u = 1.0f - v - w;

	N = u * triangle.v0normal + v * triangle.v1normal + w * triangle.v2normal;
	uv = u * triangle.v0uv + v * triangle.v1uv + w * triangle.v2uv;
}

// ray와 sphere가 intersect하는지 검사하는 함수
__device__ bool RaySphereIntersect(Ray ray, Sphere sphere, float& dist)
{
	glm::vec3 s = ray.origin - sphere.origin;

	float a = dot(ray.dir, ray.dir);
	float bPrime = dot(s, ray.dir);
	float c = dot(s, s) - sphere.radius * sphere.radius;

	float D = bPrime * bPrime - a * c;
	if (D >= 0 && bPrime <= 0)
	{
		float t1 = (-bPrime + sqrt(D)) / a;
		float t2 = (-bPrime - sqrt(D)) / a;
		dist = t1 > t2 ? t2 : t1;
		return dist > 0.0001f;
	}
	else
		return false;
}

// ray와 triangle이 intersect하는지 검사하는 함수
__device__ bool RayTriangleIntersect(Ray ray, Triangle triangle, float& dist)
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

//bool RayPlaneIntersect(Ray ray, vec4 plane, float& t)
//{
//	t = -dot(plane, vec4(ray.origin, 1.0)) / glm::dot(glm::vec3(plane), ray.dir);
//	return t > 0.0;
//}
//
//bool RayRectIntersect(Ray ray, Rect rect, float& t)
//{
//	bool intersect = RayPlaneIntersect(ray, rect.plane, t);
//	if (intersect)
//	{
//		vec3 pos = ray.origin + ray.dir*t;
//		vec3 lpos = pos - rect.center;
//
//		float x = dot(lpos, rect.dirx);
//		float y = dot(lpos, rect.diry);
//
//		if (abs(x) > rect.halfx || abs(y) > rect.halfy)
//			intersect = false;
//	}
//
//	return intersect;
//}

__device__ bool RayAABBIntersect(Ray ray, AABB box)
{
	float tmin, tmax, tymin, tymax, tzmin, tzmax;

	glm::vec3 invdir = 1.0f / ray.dir;
	int sign[3];
	sign[0] = invdir.x < 0;
	sign[1] = invdir.y < 0;
	sign[2] = invdir.z < 0;

	tmin = (box.bounds[sign[0]].x - ray.origin.x) * invdir.x;
	tmax = (box.bounds[1 - sign[0]].x - ray.origin.x) * invdir.x;
	tymin = (box.bounds[sign[1]].y - ray.origin.y) * invdir.y;
	tymax = (box.bounds[1 - sign[1]].y - ray.origin.y) * invdir.y;

	if ((tmin > tymax) || (tymin > tmax))
		return false;

	if (tymin > tmin)
		tmin = tymin;
	if (tymax < tmax)
		tmax = tymax;

	tzmin = (box.bounds[sign[2]].z - ray.origin.z) * invdir.z;
	tzmax = (box.bounds[1 - sign[2]].z - ray.origin.z) * invdir.z;

	if ((tmin > tzmax) || (tzmin > tmax))
		return false;

	return true;
}

__device__ bool RayAABBsIntersect(Ray ray, AABB* boxes, int boxNum)
{
	bool isIntersect = false;

	for (int it = 0; it < boxNum; it++)
	{
		if (RayAABBIntersect(ray, boxes[it]))
			isIntersect = true;
	}
	return isIntersect;
}


__device__ float RayTraversal(OctreeNode* root, Ray ray, float& minDist)
{
	if (root == nullptr)
		return false;

	if (ray.dir.x < 0)
	{
		ray.origin.x = root->bnd.bounds[0].x + root->bnd.bounds[1].x - ray.origin.x;
		ray.dir.x = -ray.dir.x;
	}
	if (ray.dir.y < 0)
	{
		ray.origin.y = root->bnd.bounds[0].y + root->bnd.bounds[1].y - ray.origin.y;
		ray.dir.y = -ray.dir.y;
	}
	if (ray.dir.z < 0)
	{
		ray.origin.z = root->bnd.bounds[0].z + root->bnd.bounds[1].z - ray.origin.z;
		ray.dir.z = -ray.dir.z;
	}

	double divx = 1 / ray.dir.x;
	double divy = 1 / ray.dir.y;
	double divz = 1 / ray.dir.z;

	double tx0 = (root->bnd.bounds[0].x - ray.origin.x) * divx;
	double tx1 = (root->bnd.bounds[1].x - ray.origin.x) * divx;
	double ty0 = (root->bnd.bounds[0].y - ray.origin.y) * divy;
	double ty1 = (root->bnd.bounds[1].y - ray.origin.y) * divy;
	double tz0 = (root->bnd.bounds[0].z - ray.origin.z) * divz;
	double tz1 = (root->bnd.bounds[1].z - ray.origin.z) * divz;

	float tmin = max(max(tx0, ty0), tz0);
	float tmax = min(min(tx1, ty1), tz1);

	if (tmin <= tmax)
	{
		//return true;

		if (tmin < minDist)
			return true;
		else
			return false;
	}
	else
		return false;

}

__device__ float KDRayTraversal(gpukdtreeNode root, Ray ray)
{


	if (ray.dir.x < 0)
	{
		ray.origin.x = root.nodeAABB.bounds[0].x + root.nodeAABB.bounds[1].x - ray.origin.x;
		ray.dir.x = -ray.dir.x;
	}
	if (ray.dir.y < 0)
	{
		ray.origin.y = root.nodeAABB.bounds[0].y + root.nodeAABB.bounds[1].y - ray.origin.y;
		ray.dir.y = -ray.dir.y;
	}
	if (ray.dir.z < 0)
	{
		ray.origin.z = root.nodeAABB.bounds[0].z + root.nodeAABB.bounds[1].z - ray.origin.z;
		ray.dir.z = -ray.dir.z;
	}

	double divx = 1 / ray.dir.x;
	double divy = 1 / ray.dir.y;
	double divz = 1 / ray.dir.z;

	double tx0 = (root.nodeAABB.bounds[0].x - ray.origin.x) * divx;
	double tx1 = (root.nodeAABB.bounds[1].x - ray.origin.x) * divx;
	double ty0 = (root.nodeAABB.bounds[0].y - ray.origin.y) * divy;
	double ty1 = (root.nodeAABB.bounds[1].y - ray.origin.y) * divy;
	double tz0 = (root.nodeAABB.bounds[0].z - ray.origin.z) * divz;
	double tz1 = (root.nodeAABB.bounds[1].z - ray.origin.z) * divz;

	float tmin = max(max(tx0, ty0), tz0);
	float tmax = min(min(tx1, ty1), tz1);

	if (tmin <= tmax)
	{
		return true;
	}
	else
		return false;

}

__device__ void RayTreeTraversal(OctreeNode* root, 
								Ray ray, 
								int& minIdx, 
								float& tmpDist, 
								Triangle* triangles, 
								const float& rayThreshold, 
								float& minDist)
{
	//// recursive
	//if (RayTraversal(root, ray))
	//{
	//	//int a = 0;

	//	if (root->children[0] != nullptr)
	//	{
	//		for (int i = 0; i < 8; i++)
	//		{
	//			if (root->children[i] != nullptr)
	//			{
	//				RayTreeTraversal(root->children[i], ray, minIdx, tmpDist, triangles, rayThreshold, minDist);
	//				//a++;
	//			}
	//		}
	//	}

	//	else
	//	{
	//		for (int i = 0; i < root->triangleIdx.size(); i++)
	//		{
	//			//idx->push_back(newIdx.operator[](i));
	//			if (RayTriangleIntersect(ray, triangles[root->triangleIdx.operator[](i)], tmpDist))
	//			{
	//				if (tmpDist > rayThreshold && tmpDist < minDist)
	//				{
	//					minDist = tmpDist;
	//					minIdx = root->triangleIdx.operator[](i);
	//				}
	//			}
	//		}
	//		
	//	}
	//}
	//return;

	OctreeNode* stack[64];
	OctreeNode** stackPtr = stack;
	*stackPtr++ = NULL;


	OctreeNode* node = root;
	do
	{
		OctreeNode* children[8];
		for (int i = 0; i < 8; i++)
			children[i] = node->children[i];

		bool intersect[8];
		//float dist[8];
		for (int i = 0; i < 8; i++)
			intersect[i] = RayTraversal(children[i], ray, minDist);

		for (int i = 0; i < 8; i++)
			if (intersect[i] && children[i]->children[0] == nullptr)
			{
				for (int j = 0; j < children[i]->triangleIdx.size(); j++)
				{
					if (RayTriangleIntersect(ray, triangles[children[i]->triangleIdx[j]], tmpDist))
					{
						if (tmpDist > rayThreshold && tmpDist < minDist)
						{
							minDist = tmpDist;
							minIdx = children[i]->triangleIdx.operator[](j);
						}
					}	
				}
			}
		


		bool traverse[8];
		for (int i = 0; i < 8; i++)
			traverse[i] = intersect[i] && children[i]->children[0] != nullptr;


		if (!traverse[0] && !traverse[1] && !traverse[2] && !traverse[3] && !traverse[4] && !traverse[5] && !traverse[6] && !traverse[7])
			node = *--stackPtr;
		else
		{
			int a = 0;
			for (int i = 0; i < 8; i++)
			{
				if (traverse[i])
				{
					node = children[i];
					a = i;
					break;
				}
			}

			for (int i = a+1; i < 8; i++)
			{
				if (traverse[i])
				{
					*stackPtr++ = children[i];
				}
			}
		}
	
	} while (node != NULL);
}

__device__ void RayKDTreeTraversal(gpukdtree* root,
									Ray ray,
									int& minIdx,
									float& tmpDist,
									Triangle* triangles,
									const float& rayThreshold,
									float& minDist)
{
	int currentid, leftid, rightid, cid;
	DeviceStack<int> treestack;
	treestack.push(0);
	while (!treestack.empty())
	{
		currentid = treestack.pop();

		//test node intersection
		if (KDRayTraversal(root->nodes.data[currentid], ray)) {
			leftid = root->nodes.data[currentid].leftChild;
			rightid = root->nodes.data[currentid].rightChild;
			//// leaf node
			if (leftid == -1 && rightid == -1) {
				/*if (dkdtree::Intersect_nodeTriangles_Ray(ray, currentid, tmpDist, cid, root->nodes.data, triangles, root->triangleNodeAssociation.data)) {
					if (tmpDist<minDist) {
						minDist = tmpDist;
						minIdx = cid;
					}
				}*/
				continue;
			}
			// middle node
			if (leftid != -1)
				treestack.push(leftid);
			if (rightid != -1)
				treestack.push(rightid);
		}
	}

}

//ray의 원점과 가장 가까운 곳에서 intersect하는 triangle의 id를 가져오는 함수
//octree 사용
__device__ int OTFindNearestTriangleIdx(Ray ray, Triangle* triangles, OctreeNode* root, float& dist)
{
	const float rayThreshold = 0.01f;
	float minDist = 99999.0f;
	int minIdx = -1;
	float tmpDist;

	RayTreeTraversal(root, ray, minIdx, tmpDist, triangles, rayThreshold, minDist);	//	전체 삼각형 중 해당 ray가 지나가는 node에 있는 것만 골라낸다.

	dist = minDist;
	return minIdx;
}

__device__ int KDFindNearestTriangleIdx(Ray ray, Triangle* triangles, gpukdtree* root, float& dist)
{
	const float rayThreshold = 0.01f;
	float minDist = 99999.0f;
	int minIdx = -1;
	float tmpDist;

	RayKDTreeTraversal(root, ray, minIdx, tmpDist, triangles, rayThreshold, minDist);	//	전체 삼각형 중 해당 ray가 지나가는 node에 있는 것만 골라낸다.

	dist = minDist;
	return minIdx;
}


 __device__ int findnearesttriangleidx(Ray ray, Triangle* triangles, int trianglenum, float& dist)
{

	const float raythreshold = 0.01f;
	float mindist = 9999999.0f;
	int minidx = -1;
	float tmpdist;

	for (int i = 0; i < trianglenum; ++i)
	{
		if (RayTriangleIntersect(ray, triangles[i], tmpdist))
		{
			if (tmpdist > raythreshold && tmpdist < mindist)
			{
				mindist = tmpdist;
				minidx = i;
			}
		}
	}

	dist = mindist;
	return minidx;
}

// ray의 원점과 가장 가까운 곳에서 intersect하는 sphere의 id를 가져오는 함수
__device__ int FindNearestSphereIdx(Ray ray, Sphere* spheres, int sphereNum, float& dist)
{
	const float rayThreshold = 0.0001f;
	float minDist = 999999.0f;
	int minIdx = -1;
	float tmpDist;

	for (int i = 0; i < sphereNum; ++i)
	{
		if (RaySphereIntersect(ray, spheres[i], tmpDist))
		{
			if (tmpDist > rayThreshold && tmpDist < minDist)
			{
				minDist = tmpDist;
				minIdx = i;
			}
		}
	}

	dist = minDist;
	return minIdx;
}

// window의 픽셀의 위치가 각각 x, y로 입력됨
__device__ Ray GenerateCameraRay(int y, int x, glm::mat4 cameraModelMatrix, int rayX, int rayY)
{
	Ray ray;

	// 각 픽셀의 중앙을 가르키는 값 생성, 0~1의 값으로 Normalizing
	// antialiasing
	float NDCy = (y + 0.33333f + 0.33333f*rayY) / WINDOW_HEIGHT;
	float NDCx = (x + 0.33333f + 0.33333f*rayX) / WINDOW_WIDTH;

	// no antialiasing
	/*float NDCy = (y + 0.5f) / WINDOW_HEIGHT;
	float NDCx = (x + 0.5f) / WINDOW_WIDTH;*/

	// window 종횡비
	float aspectRatio = WINDOW_WIDTH / WINDOW_HEIGHT;

	// 시야각 설정
	float fov = 45.0f;

	// unProject
	float xx = (NDCx * 2.0f - 1.0f) * tan(fov * 0.5f * 3.141592653f / 180.0f) * aspectRatio;
	float yy = (NDCy * 2.0f - 1.0f) * tan(fov * 0.5f * 3.141592653f / 180.0f);

	// world space에서의 ray 정보를 계산
	ray.origin = glm::vec3(cameraModelMatrix * glm::vec4(0.0f, 0.0f, 0.0f, 1.0f));
	ray.dir = normalize(vec3(cameraModelMatrix * vec4(glm::vec3(xx, yy, -1.0), 0.0f)));
	ray.decay = 1.0f;
	ray.depth = 1;

	// 만들어진 ray를 return
	return ray;
}

__device__ void Enqueue(Ray* rayQueue, Ray ray, int& rear)
{
	rayQueue[rear] = ray;
	rear = (rear + 1) % QUEUE_SIZE;
}

__device__ void Dequeue(Ray* rayQueue, int& front)
{
	front = (front + 1) % QUEUE_SIZE;
}

__device__ Ray GetQueueFront(Ray* rayQueue, const int front)
{
	return rayQueue[front];
}

__device__ bool IsQueueEmpty(const int front, const int rear)
{
	return front == rear;
}

__device__ bool IsLight(const vec3 emission)
{
	return emission.x > 0.0f || emission.y > 0.0f || emission.z > 0.0f;
}

__device__ bool IsLighted(
	vec3 hitPoint,
	Light light,
	Triangle* triangles,
	const int triangleNum,
	const int nearestTriangleIdx,
	Sphere* spheres,
	const int sphereNum,
	const int nearestSphereIdx)
{
	// shadow ray 생성, origin은 hit point, 방향은 hit point부터 광원까지의 방향
	Ray shadowRay;
	shadowRay.origin = hitPoint;
	shadowRay.dir = normalize(light.pos - hitPoint);
	float distance = glm::distance(light.pos, hitPoint);

	float distToTriangle;

	for (int t_i = 0; t_i < triangleNum; ++t_i)
	{
		// 처음 hit한 triangle은 제외
		if (nearestTriangleIdx != t_i)
		{
			// shadow
			if (RayTriangleIntersect(shadowRay, triangles[t_i], distToTriangle))
			{
				// 앞쪽의 dir만 봄, 매우 가까운 곳은 그림자 아님
				if (distToTriangle > 0.01f && distToTriangle < glm::distance(light.pos, hitPoint))
				{
					return false;
				}
			}
		}
	}

	float distToSphere;

	for (int s_i = 0; s_i < sphereNum; ++s_i)
	{
		// 광원은 0임, 광원을 제외한 경우에만 그림자 생김
		if (nearestSphereIdx != s_i && s_i != 0)
		{
			if (RaySphereIntersect(shadowRay, spheres[s_i], distToSphere))
			{
				// 앞쪽의 dir만 봄, 매우 가까운 곳은 그림자 아님
				if (distToSphere > 0.01f && distToSphere < glm::distance(light.pos, hitPoint))
				{
					return false;
				}
			}
		}
	}

	return true;
}

// ray가 hit 했다면 true를 리턴하고 hit한 곳의 정보를 가져오는 함수
__device__ bool GetHitPointInfo(
	Ray nowRay,
	Triangle* triangles,
	int triangleNum,
	int& nearestTriangleIdx,
	Sphere* spheres,
	int sphereNum,
	int& nearestSphereIdx,
	vec3& hitPoint, 
	int& materialId, 
	vec3& N,
	vec2& uv,
	OctreeNode* root,
	gpukdtree* kdroot)
{
	float distToTriangle, distToSphere, distToAreaLight = 0.0f;
	
	//옥트리
	//nearestTriangleIdx = KDFindNearestTriangleIdx(nowRay, triangles, kdroot, distToTriangle);
	nearestTriangleIdx = OTFindNearestTriangleIdx(nowRay, triangles, root, distToTriangle);
	//nearestTriangleIdx = FindNearestTriangleIdx(nowRay, triangles, triangleNum, distToTriangle);
	nearestSphereIdx = FindNearestSphereIdx(nowRay, spheres, sphereNum, distToSphere);

	// 아무곳도 intersect를 못했다거나 뒤쪽에 있다면
	if ((nearestTriangleIdx == -1 || distToTriangle < 0.0f) &&
		(nearestSphereIdx == -1 || distToSphere < 0.0f) &&
		(distToAreaLight <= 0.0f))
		return false;

	if (distToSphere > distToTriangle)
	{
		Triangle nearestTriangle = triangles[nearestTriangleIdx];
		hitPoint = nowRay.origin + nowRay.dir * distToTriangle;
		materialId = nearestTriangle.materialId;
		Interpolation(nearestTriangle, hitPoint, N, uv);
	}
	else
	{
		Sphere nearestSphere = spheres[nearestSphereIdx];
		hitPoint = nowRay.origin + nowRay.dir * distToSphere;
		materialId = nearestSphere.materialId;
		N = glm::normalize(hitPoint - nearestSphere.origin);
		// no uv...
	}

	return true;
}


__device__ vec4 RayTraceColor(
	Ray ray,
	int rayIndex,
	Ray* rayQueue,
	Triangle* triangles,
	int triangleNum,
	Sphere* spheres,
	int sphereNum,
	Light* lights,
	int lightNum,
	Material* materials,
	int matNum,
	float* randomNums,
	int depth,
	OctreeNode* root,
	gpukdtree* kdroot)
{
	vec3 sumLo = vec3(0.0f, 0.0f, 0.0f);
	int front = 0, rear = 0;

	Enqueue(rayQueue, ray, rear);

	vec3 V = -ray.dir;

	while (!IsQueueEmpty(front, rear))
	{
		Ray nowRay;
		nowRay = GetQueueFront(rayQueue, front);
		Dequeue(rayQueue, front);

		vec3 hitPoint = glm::vec3(0.0f);
		// hit한 object의 material id
		int materialId = 0;
		// normal vector
		vec3 N = glm::vec3(0.0f);
		vec2 uv = glm::vec2(0.0f);
		int nearestTriangleIdx = 0;
		int nearestSphereIdx = 0;

		// hit point의 정보를 가져옴
		if (GetHitPointInfo(
			nowRay,
			triangles,
			triangleNum,
			nearestTriangleIdx,
			spheres,
			sphereNum,
			nearestSphereIdx,
			hitPoint,
			materialId,
			N,
			uv,
			root,
			kdroot))
		{

			// ∫Ω(kd c / π + ks DFG / 4(ωo⋅n)(ωi⋅n)) Li(p,ωi) n⋅ωi dωi
			// radiance * (1.0f * textureColor/pi + 0.0f) * lightcolor * NdotL
			vec3 albedo;
			vec3 emission;
			vec3 F0;
			float4 texNormal;
			float ao;
			float metallic;
			float roughness;

			vec3 kS;
			vec3 kD;

			// sphere
			if (materials[materialId].texId == 0)
			{
				float4 texRGBA;
				texRGBA = tex2D(albedoTex, uv.x, uv.y);
				albedo = glm::pow(glm::vec3(texRGBA.x, texRGBA.y, texRGBA.z), vec3(2.2));

				texNormal = tex2D(normalTex, uv.x, uv.y);
				ao = tex2D(aoTex, uv.x, uv.y).x;
				metallic = tex2D(metallicTex, uv.x, uv.y).x;
				roughness = tex2D(roughnessTex, uv.x, uv.y).x;

				glm::vec3 texNormalVec = glm::vec3(
					texNormal.x * 2.0f - 1.0f,
					texNormal.y * 2.0f - 1.0f,
					texNormal.z * 2.0f - 1.0f);

				glm::mat3 TBN = glm::mat3(
					triangles[nearestTriangleIdx].tangent,
					triangles[nearestTriangleIdx].bitangent,
					N);

				// TBN의 inverse
				N = glm::normalize(texNormalVec);

				N = TBN * N;
			}
			// plane
			else if (materials[materialId].texId == 1)
			{
				float4 texRGBA;
				texRGBA = tex2D(backgroundTex, uv.x, uv.y);
				albedo = glm::pow(glm::vec3(texRGBA.x, texRGBA.y, texRGBA.z), vec3(2.2));

				ao = materials[materialId].ambient;
				metallic = materials[materialId].metallic;
				roughness = materials[materialId].roughness;
				emission = materials[materialId].emission;
			}
			// fluid
			else
			{
				albedo = materials[materialId].albedo;
				ao = materials[materialId].ambient;
				metallic = materials[materialId].metallic;
				roughness = materials[materialId].roughness;
				emission = materials[materialId].emission;
			}

			// fluid라면
			if (materials[materialId].refractiveIndex != 0.0f)
			{
				F0 = calculateEta(materials[materialId].refractiveIndex);
			}
			else
			{
				// metallic이면 F0가 큼, 아니면 작음
				F0 = glm::mix(vec3(0.04f), albedo, metallic);
			}

			vec3 Lo = vec3(0.0f);
			for (int k = 0; k < lightNum; k++)
			{
				vec3 L = glm::normalize(lights[k].pos - hitPoint);
				vec3 H = glm::normalize(V + L);

				float distance = glm::distance(lights[k].pos, hitPoint);
				float attenuation = 1.0 / (distance*distance);

				vec3 radiance = lights[k].color * attenuation;

				float NDF = DistributionGGX(N, H, roughness);
				float G = GeometrySmith(N, V, L, roughness);
				vec3 F = fresnelSchlick(glm::max(glm::dot(H, V), 0.0f), F0);

				vec3 nominator = NDF * G * F;
				float denominator = 4 * glm::max(glm::dot(N, V), 0.0f) * glm::max(glm::dot(N, L), 0.0f) + 0.001f;
				vec3 specular = nominator / denominator;

				kS = F;

				kD = vec3(1.0) - kS;
				kD *= (1.0f - metallic);

				vec3 diffuse = kD * albedo / glm::pi<float>();

				float NdotL = glm::clamp(glm::dot(N, L), 0.0f, 1.0f);

				if (!IsLighted(hitPoint, lights[k], triangles, triangleNum, nearestTriangleIdx,
					spheres, sphereNum, nearestSphereIdx))
				{
					// brdf * radiance * NdotL
					Lo += (diffuse + specular) * radiance * NdotL * 0.1f;
				}
				else
				{
					// brdf * radiance * NdotL
					Lo += (diffuse + specular) * radiance * NdotL;
				}
			}

			vec3 ambient = vec3(0.03) * albedo * ao;

			// Light Sampling
			if (nowRay.depth == 1)
			{
				if (IsLight(emission))
				{
					sumLo += emission;
				}
				else
				{
					sumLo += (ambient + Lo) * nowRay.decay;
				}
			}
			else
			{
				float distance = glm::distance(hitPoint, nowRay.origin);
				float attenuation = 1.0f / (distance * distance);
				sumLo += emission * attenuation * nowRay.decay / (float)SAMPLE_NUM;
			}

			// Path Tracing, BRDF Sampling
			// 광원에 닿았으면
			/*if (nowRay.depth == 1)
			{
				if (IsLight(emission))
				{
					sumLo += emission * (nowRay.decay / SAMPLE_NUM);
				}
			}
			else
			{
				float distance = glm::distance(hitPoint, nowRay.origin);
				float attenuation = 1.0f / (distance * distance);
				sumLo += emission * attenuation * (nowRay.decay / SAMPLE_NUM);
			}*/

			//////////////////////////////////////////////////////////////////////////////////////////분리선

			if (nowRay.depth < DEPTH)
			{
				for (int j = 0; j < SAMPLE_NUM; ++j)
				{
					float r = sqrtf(1.0f -
						randomNums[(rayIndex * SAMPLE_NUM + j) * 2] *
						randomNums[(rayIndex * SAMPLE_NUM + j) * 2]);
					float phi = 2 * glm::pi<float>() * randomNums[(rayIndex * SAMPLE_NUM + j) * 2 + 1];

					vec3 randomVec = normalize(vec3(
						cosf(phi)*r,
						randomNums[(rayIndex * SAMPLE_NUM + j) * 2],
						sinf(phi)*r));

					glm::mat3 TNB = glm::mat3(
						triangles[nearestTriangleIdx].tangent,
						N,
						triangles[nearestTriangleIdx].bitangent);
					vec3 reflectRandomVec = TNB * randomVec;

					
					Ray reflectRay;
					// 여기서 kS.r을 쓴 이유는 reflect ray 하나만 쓰기 때문에 한 것
					// Ray Tracing
					/*reflectRay.dir = normalize(reflect(nowRay.dir, N));
					reflectRay.decay = kS.r * nowRay.decay / SAMPLE_NUM;*/
					
					// Path Tracing
					reflectRay.dir = normalize(reflectRandomVec);
					reflectRay.decay = nowRay.decay *
						glm::clamp(dot(N, reflectRay.dir), 0.0f, 1.0f);
					
					reflectRay.depth = nowRay.depth + 1;
					reflectRay.origin = hitPoint + reflectRay.dir * 0.08f;

					Enqueue(rayQueue, reflectRay, rear);

	/*				glm::mat3 refractTNB = glm::mat3(
						triangles[nearestTriangleIdx].tangent,
						normalize(refract(nowRay.dir, N, 1.0f / materials[materialId].refractiveIndex)),
						-triangles[nearestTriangleIdx].bitangent);
					vec3 refractRandomVec = ;*/

					Ray refractRay;
					// 현재 빛의 감쇠 정도와 물체의 재질에 따라 refract ray의 감쇠 정도가 정해짐
					refractRay.dir = normalize(refract(
						nowRay.dir, N, 1.0f / materials[materialId].refractiveIndex));
					refractRay.decay = nowRay.decay * kD.r / SAMPLE_NUM;

					// 투명한 Object이기 때문에 kD가 refract decay로 들어간 거임

					refractRay.depth = nowRay.depth + 1;
					refractRay.origin = hitPoint + refractRay.dir * 0.08f;

					Enqueue(rayQueue, refractRay, rear);
				}
			}
		}
	}

	// hdr
	sumLo = sumLo / (sumLo + vec3(1.0));
	// gamma correction
	sumLo = glm::pow(sumLo, vec3(1.0 / 2.2));

	vec4 color = glm::vec4(sumLo, 1.0f);

	return color;
}



__global__ void RayTraceD(
	glm::vec4* data,
	const int gridX,
	const int gridY,
	glm::mat4 view,
	Triangle* triangles, int triangleNum,
	Sphere* spheres, int sphereNum,
	Light* lights, int lightNum,
	Material* materials, int matNum,
	float* randomNums,
	OctreeNode* root,
	gpukdtree* kdroot)
{
	//unsigned int x = blockIdx.x * blockDim.x + threadIdx.x;
	unsigned int x = (blockIdx.x + gridY * RAY_Y_NUM) * WINDOW_HEIGHT + (threadIdx.x + gridX * RAY_X_NUM);
	glm::vec4 color = glm::vec4(0.0f);

	Ray rayQueue[QUEUE_SIZE];
	
	for (int i = 0; i < 2; i++)
	{
		for (int j = 0; j < 2; j++)
		{
			Ray ray = GenerateCameraRay(blockIdx.x + gridY * RAY_Y_NUM, threadIdx.x + gridX * RAY_X_NUM, view, i, j);

			// NOTICE for문을 돌릴 때 iter를 변수로 하니까 검은 화면이 나옴
			// y, x로 들어가고
			// 0, 0 좌표는 좌하단
			color += RayTraceColor(
				ray,
				blockIdx.x * blockDim.x + threadIdx.x,
				rayQueue,
				triangles,
				triangleNum,
				spheres,
				sphereNum,
				lights,
				lightNum,
				materials,
				matNum,
				randomNums,
				DEPTH,
				root,
				kdroot);
		}
	}

	//color = glm::vec4(randomNums[x%1024]);

	data[x] = color / 4.0f;
}

__global__ void random(float* result, int seed)
{
	curandState_t state;
	const int randomMax = 10000;

	curand_init(seed, blockIdx.x, 0, &state);
	int randNum = curand(&state) % randomMax;

	// theta 범위는 0 ~ 1
	result[blockIdx.x] = (float)randNum / (float)randomMax;
}

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
	gpukdtree* kdroot)
{
	thrust::device_vector<Triangle> t = triangles;
	thrust::device_vector<Sphere> s = spheres;
	thrust::device_vector<Light> l = lights;
	thrust::device_vector<Material> m = materials;
	thrust::device_vector<float> rnums = randomThetaPi;

	cudaDeviceSetLimit(cudaLimitMallocHeapSize, 5000000000 * sizeof(float));
	
	/*vec3 min = vec3(-30, -30, -30);
	vec3 max = vec3(30, 30, 30);

	
	int tnum = t.size();

	printf("Num Triangles: %d\n", tnum);

	OctreeNode* root = BuildOctree((Triangle *)triangles.data(), tnum, 1000, min, max);

	OctreeNode* octree = OTHostToDevice(root);*/

	//cout << "ray trace device start" << endl;

	RayTraceD << <RAY_Y_NUM, RAY_X_NUM >> > (
		data,
		gridX,
		gridY,
		view,
		t.data().get(),
		t.size(),
		s.data().get(),
		s.size(),
		l.data().get(),
		l.size(),
		m.data().get(),
		m.size(),
		rnums.data().get(),
		root,
		kdroot
	);
}

void LoadCudaTextures()
{
	Texture2D texFile;
	texFile.LoadFixedTexture("Texture/RustedIron/albedo.png");
	texFile.SetParameters(GL_LINEAR_MIPMAP_LINEAR, GL_LINEAR_MIPMAP_LINEAR, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);
	float* texArray = texFile.GetTexImage(GL_RGBA);

	unsigned int size = 2048 * 2048 * 4 * sizeof(float);

	cudaChannelFormatDesc channelDesc = cudaCreateChannelDesc(32, 32, 32, 32, cudaChannelFormatKindFloat);
	cudaArray* cuArray;
	//cudaMipmappedArray* cuMipmappedArray;

	cudaMallocArray(&cuArray, &channelDesc, 2048, 2048);
	//cudaMalloc3DArray()

	cudaMemcpyToArray(cuArray, 0, 0, texArray, size, cudaMemcpyHostToDevice);

	albedoTex.addressMode[0] = cudaAddressModeWrap;
	albedoTex.addressMode[1] = cudaAddressModeWrap;
	albedoTex.filterMode = cudaFilterModeLinear;
	albedoTex.normalized = true;

	cudaBindTextureToArray(albedoTex, cuArray, channelDesc);
	delete texArray;

	//////////////////////////////////////////////////////////////////////////////

	texFile.LoadFixedTexture("Texture/RustedIron/normal.png");
	texFile.SetParameters(GL_LINEAR_MIPMAP_LINEAR, GL_LINEAR_MIPMAP_LINEAR, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);
	texArray = texFile.GetTexImage(GL_RGBA);

	size = 2048 * 2048 * 4 * sizeof(float);

	cuArray;
	cudaMallocArray(&cuArray, &channelDesc, 2048, 2048);

	cudaMemcpyToArray(cuArray, 0, 0, texArray, size, cudaMemcpyHostToDevice);

	normalTex.addressMode[0] = cudaAddressModeWrap;
	normalTex.addressMode[1] = cudaAddressModeWrap;
	normalTex.filterMode = cudaFilterModeLinear;
	normalTex.normalized = true;

	cudaBindTextureToArray(normalTex, cuArray, channelDesc);
	delete texArray;

	//////////////////////////////////////////////////////////////////////////////
	//channelDesc = cudaCreateChannelDesc(32, 0, 0, 0, cudaChannelFormatKindFloat);

	texFile.LoadFixedTexture("Texture/RustedIron/ao.png");
	texFile.SetParameters(GL_LINEAR_MIPMAP_LINEAR, GL_LINEAR_MIPMAP_LINEAR, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);
	texArray = texFile.GetTexImage(GL_RGBA);

	size = 2048 * 2048 * 4 * sizeof(float);

	cuArray;
	cudaMallocArray(&cuArray, &channelDesc, 2048, 2048);

	cudaMemcpyToArray(cuArray, 0, 0, texArray, size, cudaMemcpyHostToDevice);

	aoTex.addressMode[0] = cudaAddressModeWrap;
	aoTex.addressMode[1] = cudaAddressModeWrap;
	aoTex.filterMode = cudaFilterModeLinear;
	aoTex.normalized = true;

	cudaBindTextureToArray(aoTex, cuArray, channelDesc);
	delete texArray;

	//////////////////////////////////////////////////////////////////////////////

	texFile.LoadFixedTexture("Texture/RustedIron/metallic.png");
	texFile.SetParameters(GL_LINEAR_MIPMAP_LINEAR, GL_LINEAR_MIPMAP_LINEAR, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);
	texArray = texFile.GetTexImage(GL_RGBA);

	size = 2048 * 2048 * 4 * sizeof(float);

	cuArray;
	cudaMallocArray(&cuArray, &channelDesc, 2048, 2048);

	cudaMemcpyToArray(cuArray, 0, 0, texArray, size, cudaMemcpyHostToDevice);

	metallicTex.addressMode[0] = cudaAddressModeWrap;
	metallicTex.addressMode[1] = cudaAddressModeWrap;
	metallicTex.filterMode = cudaFilterModeLinear;
	metallicTex.normalized = true;

	cudaBindTextureToArray(metallicTex, cuArray, channelDesc);
	delete texArray;

	//////////////////////////////////////////////////////////////////////////////

	texFile.LoadFixedTexture("Texture/RustedIron/roughness.png");
	texFile.SetParameters(GL_LINEAR_MIPMAP_LINEAR, GL_LINEAR_MIPMAP_LINEAR, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);
	texArray = texFile.GetTexImage(GL_RGBA);

	size = 2048 * 2048 * 4 * sizeof(float);

	cuArray;
	cudaMallocArray(&cuArray, &channelDesc, 2048, 2048);

	cudaMemcpyToArray(cuArray, 0, 0, texArray, size, cudaMemcpyHostToDevice);

	roughnessTex.addressMode[0] = cudaAddressModeWrap;
	roughnessTex.addressMode[1] = cudaAddressModeWrap;
	roughnessTex.filterMode = cudaFilterModeLinear;
	roughnessTex.normalized = true;

	cudaBindTextureToArray(roughnessTex, cuArray, channelDesc);
	delete texArray;

	//////////////////////////////////////////////////////////////////////////////

	texFile.LoadFixedTexture("Texture/Background/stripe.png");
	texFile.SetParameters(GL_LINEAR_MIPMAP_LINEAR, GL_LINEAR_MIPMAP_LINEAR, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);
	texArray = texFile.GetTexImage(GL_RGBA);

	size = 2048 * 2048 * 4 * sizeof(float);

	cuArray;
	cudaMallocArray(&cuArray, &channelDesc, 2048, 2048);

	cudaMemcpyToArray(cuArray, 0, 0, texArray, size, cudaMemcpyHostToDevice);

	backgroundTex.addressMode[0] = cudaAddressModeWrap;
	backgroundTex.addressMode[1] = cudaAddressModeWrap;
	backgroundTex.filterMode = cudaFilterModeLinear;
	backgroundTex.normalized = true;

	cudaBindTextureToArray(backgroundTex, cuArray, channelDesc);
	delete texArray;
}