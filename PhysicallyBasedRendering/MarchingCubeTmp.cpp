#include <iostream>
#include <algorithm>

#include "MarchingCubeTMp.h"
#include "MarchingCubeVertexNormalUtility.h"

using std::cout;
using std::endl;

using std::min;

MarchingCubeTmp::MarchingCubeTmp(void)
{
	simulWidth = 0;
	simulHeight = 0;
	simulDepth = 0;

	simulOriginX = 0.0f;
	simulOriginY = 0.0f;
	simulOriginZ = 0.0f;

	nodeNumX = 0;
	nodeNumY = 0;
	nodeNumZ = 0;

	nodeWidth = 0.0f;
	nodeHeight = 0.0f;
	nodeDepth = 0.0f;


	// 너무 한 축으로 길게 늘어지지 않도록 해주는 상수
	Kr = 4.0f;

	// particle 일정 수 
	Ne = 25;

	// 일정 수 이상의 particle이 있을 때 singular matrix에 곱해질 상수
	Ks = 2.0f;

	// 일정 수 이하의 particle이 있을 때 identity matrix에 곱해질 상수
	Kn = 0.25f;

	// 괜찮은 parameter
	// h = 1.5, thres = 1.5, resolution = 3.0

	h = 1.5f;
	r = h * 2;


	m_ppt3dVertices = NULL;
	m_piTriangleIndices = NULL;
	m_pvec3dNormals = NULL;

	paddingHalfWidth = 10;
	paddingHalfHeight = 10;
	paddingHalfDepth = 10;
}

MarchingCubeTmp::~MarchingCubeTmp(void)
{
	nodeList.clear();
}

// simulation 공간, 얼마만큼으로 나눌 것인지 resolution
void MarchingCubeTmp::BuildingGird(
	float simulWidth, float simulHeight, float simulDepth,
	float simulOriginX, float simulOriginY, float simulOriginZ,
	float reso, float thres)
{
	this->simulWidth = simulWidth;
	this->simulHeight = simulHeight;
	this->simulDepth = simulDepth;

	this->simulOriginX = simulOriginX;
	this->simulOriginY = simulOriginY;
	this->simulOriginZ = simulOriginZ;

	// 양쪽에 같은 크기의 padding + 가장 마지막에 하나 추가
	this->nodeNumX = this->simulWidth * reso + paddingHalfWidth * 2 + 1;
	this->nodeNumY = this->simulHeight * reso + paddingHalfHeight * 2 + 1;
	this->nodeNumZ = this->simulDepth * reso + paddingHalfDepth * 2 + 1;

	this->resolution = reso;

	this->nodeWidth = 1.0f / this->resolution;
	this->nodeHeight = 1.0f / this->resolution;
	this->nodeDepth = 1.0f / this->resolution;

	densityThres = thres;

	//Calculate Cell Spacing
	float initNodePosX = simulOriginX - this->nodeNumX * this->nodeWidth;
	float initNodePosY = simulOriginY - this->nodeNumY * this->nodeHeight;
	float initNodePosZ = simulOriginZ - this->nodeNumZ * this->nodeDepth;

	//Building Node
	// node position은 world 좌표계에서 정의됨 (값이 -일 수 있음)
	// node의 index는 0부터 시작하기 때문에 시작이 0이 되도록 조정해야 함
	for (int i = 0; i < nodeNumZ; i++)
	{
		for (int j = 0; j < nodeNumY; j++)
		{
			for (int k = 0; k < nodeNumX; k++)
			{
				// 각 node는 voxel로 보지말고 voxel의 끝 점이라고 생각할 것
				Node node;
				// node의 world position
				node.mNodePosition = glm::vec3(
					initNodePosX + k * nodeWidth,
					initNodePosY + j * nodeHeight,
					initNodePosZ + i * nodeDepth);

				node.mValue = 0.0f;

				nodeList.push_back(node);
			}
		}
	}
}

float* MarchingCubeTmp::ComputeParticleDensity(GLfloat* particlePoses, const int particleNum)
{
	float* particleDensities = new float[particleNum];

	for (int i = 0; i < particleNum; i++)
	{
		particleDensities[i] = 0.0f;
		vec3 particlePosA = vec3(
			particlePoses[i * 6 + 0],
			particlePoses[i * 6 + 1],
			particlePoses[i * 6 + 2]);

		for (int j = 0; j < particleNum; j++)
		{
			if (i == j)
				continue;

			vec3 particlePosB = vec3(
				particlePoses[j * 6 + 0],
				particlePoses[j * 6 + 1],
				particlePoses[j * 6 + 2]);

			particleDensities[i] += ComputePoly6(glm::distance(particlePosA, particlePosB));
		}

		// 0~7정도 되는 듯
		//cout << particleDensities[i] << endl;
	}
	cout << "compute particle density end" << endl;

	return particleDensities;
}

void MarchingCubeTmp::ComputeSphericalKernelGridDensity(GLfloat* particlePoses, float* densities, const int particleNum)
{
	for (int i = 0; i < nodeList.size(); i++)
	{
		nodeList[i].mValue = 0.0f;
	}

	for (int itr = 0; itr < particleNum; itr++)
	{
		// particle의 world coordinate의 위치
		glm::vec3 particlePos = glm::vec3(
			particlePoses[itr * 6 + 0],
			particlePoses[itr * 6 + 1],
			particlePoses[itr * 6 + 2]);

		// width의 반을 중간으로 설정
		vec3 translatedParticlePos = particlePos + glm::vec3(
			simulWidth * 0.5f,
			simulHeight * 0.5f,
			simulDepth * 0.5f);

		int k = translatedParticlePos.x * this->resolution;
		int j = translatedParticlePos.y * this->resolution;
		int i = translatedParticlePos.z * this->resolution;

		int nodeNum = 
			(paddingHalfWidth * 2 + 1) * 
			(paddingHalfHeight * 2 + 1) * 
			(paddingHalfDepth * 2 + 1);

		int* nNodes = new int[nodeNum];

		for (int ii = -paddingHalfDepth; ii <= paddingHalfDepth; ii++)
		{
			for (int jj = -paddingHalfHeight; jj <= paddingHalfHeight; jj++)
			{
				for (int kk = -paddingHalfWidth; kk <= paddingHalfWidth; kk++)
				{
					int index =
						(ii + paddingHalfDepth) * (paddingHalfHeight * 2 + 1) * (paddingHalfWidth * 2 + 1) +
						(jj + paddingHalfHeight) * (paddingHalfWidth * 2 + 1) +
						(kk + paddingHalfWidth);
					nNodes[index] = FindNodeIndex(kk + k, jj + j, ii + i);
				}
			}
		}

		for (int node = 0; node < nodeNum; node++)
		{
			// 공간 밖의 node
			if (nNodes[node] == -1.0f)
				continue;

			// node pos가 곧 node의 각 꼭짓점
			glm::vec3 nodePos = nodeList[nNodes[node]].mNodePosition;

			// 파티클과 node의 거리가 thresh hold 값보다 작으면 
			if (glm::distance(particlePos, nodePos) <= this->h)
			{
				float value = ComputePoly6(glm::distance(nodePos, particlePos)) / densities[i];
				nodeList[nNodes[node]].mValue += value;
			}
		}

		delete[] nNodes;
	}
}

void MarchingCubeTmp::ComputeAnisotropicKernelGridDensity(GLfloat* particlePoses, float* densities, const int particleNum)
{
	/*vector<int> xs;
	xs.resize(m_nNodeResX);*/

	//for (int i = 0; i < nodeList.size(); i++)
	//{
	//	nodeList[i].mValue = 0.0f;
	//}

	//float min_x = 10000.0f;
	//for (int itr = 0; itr < particleNum; itr++)
	//{
	//	// particle의 world coordinate의 위치
	//	glm::vec3 particlePos = glm::vec3(
	//		particlePoses[itr * 6 + 0],
	//		particlePoses[itr * 6 + 1],
	//		particlePoses[itr * 6 + 2]);

	//	// 논문에서는 0.9 ~ 1.0을 사용했다 함
	//	float lambda = 0.9f;
	//	vec3 weightPosSum = glm::vec3();
	//	float weightSum = 0.0f;

	//	int neighborNum = 0;

	//	for (int jtr = 0; jtr < particleNum; jtr++)
	//	{
	//		if (itr == jtr)
	//			continue;

	//		glm::vec3 particlePos2 = glm::vec3(
	//			particlePoses[jtr * 6 + 0],
	//			particlePoses[jtr * 6 + 1],
	//			particlePoses[jtr * 6 + 2]);

	//		if (glm::distance(particlePos, particlePos2) < this->r)
	//		{
	//			neighborNum++;
	//		}

	//		float weight = WeightFunc(particlePos - particlePos2, this->r);
	//		weightSum += weight;
	//		weightPosSum += weight * particlePos2;
	//	}

	//	vec3 weightPosMean = particlePos;
	//	vec3 averagedPos = particlePos;
	//	if (neighborNum > 0)
	//	{
	//		weightPosMean = weightPosSum / weightSum;
	//		averagedPos = (1.0f - lambda) * particlePos + lambda * weightPosMean;
	//	}

	//	//cout << neighborNum << endl;

	//	Eigen::Matrix3f C;
	//	glm::mat3 G, singular;
	//	for (int i = 0; i < 3; i++)
	//	{
	//		for (int j = 0; j < 3; j++)
	//		{
	//			C(i, j) = 0.0f;
	//		}
	//	}

	//	for (int jtr = 0; jtr < particleNum; jtr++)
	//	{
	//		if (itr == jtr)
	//			continue;

	//		glm::vec3 particlePos2 = glm::vec3(
	//			particlePoses[jtr * 6 + 0],
	//			particlePoses[jtr * 6 + 1],
	//			particlePoses[jtr * 6 + 2]);

	//		float weight = WeightFunc(particlePos - particlePos2, this->r);

	//		C(0, 0) += weight * (particlePos2.x - weightPosMean.x) * (particlePos2.x - weightPosMean.x);
	//		C(0, 1) += weight * (particlePos2.x - weightPosMean.x) * (particlePos2.y - weightPosMean.y);
	//		C(0, 2) += weight * (particlePos2.x - weightPosMean.x) * (particlePos2.z - weightPosMean.z);
	//		C(1, 1) += weight * (particlePos2.y - weightPosMean.y) * (particlePos2.y - weightPosMean.y);
	//		C(1, 2) += weight * (particlePos2.y - weightPosMean.y) * (particlePos2.z - weightPosMean.z);
	//		C(2, 2) += weight * (particlePos2.z - weightPosMean.z) * (particlePos2.z - weightPosMean.z);
	//	}
	//	C(1, 0) = C(0, 1);
	//	C(2, 0) = C(0, 2);
	//	C(2, 1) = C(1, 2);

	//	/*
	//	cout << "c:" << endl;
	//	cout << c << endl << endl << endl;*/

	//	if (neighborNum > 0)
	//	{
	//		C /= weightSum;
	//	}

	//	//cout << c.determinant() << endl;
	//	//cout << "covariance matrix: " << c << endl;

	//	Eigen::JacobiSVD<Eigen::Matrix3f> decomposedC(C, Eigen::ComputeFullU);

	//	//cout << "sigular values:" << decomposedC.singularValues() << endl;

	//	// singularValues의 x값이 가장 큼
	//	glm::vec3 singularValues = glm::vec3(
	//		decomposedC.singularValues()(0),
	//		decomposedC.singularValues()(1),
	//		decomposedC.singularValues()(2));

	//	//Debug::GetInstance()->Log(singularValues);

	//	glm::mat3 R = glm::mat3(
	//		decomposedC.matrixU()(0, 0), decomposedC.matrixU()(0, 1), decomposedC.matrixU()(0, 2),
	//		decomposedC.matrixU()(1, 0), decomposedC.matrixU()(1, 1), decomposedC.matrixU()(1, 2),
	//		decomposedC.matrixU()(2, 0), decomposedC.matrixU()(2, 1), decomposedC.matrixU()(2, 2));

	//	/*singular = Ks * glm::mat3(
	//	singularValues.x, 0.0f, 0.0f,
	//	0.0f, singularValues.y, 0.0f,
	//	0.0f, 0.0f, singularValues.z);*/
	//	//cout << "det kC" << endl;
	//	//glm::mat3 kC = R * singular * glm::transpose(R);
	//	//Debug::GetInstance()->Log(glm::determinant(kC));

	//	if (neighborNum > Ne)
	//	{
	//		singular = Ks * glm::mat3(
	//			singularValues.x, 0.0f, 0.0f,
	//			0.0f, glm::max(singularValues.y, singularValues.x / Kr), 0.0f,
	//			0.0f, 0.0f, glm::max(singularValues.z, singularValues.x / Kr));
	//	}
	//	else
	//	{
	//		// identity matrix
	//		singular = Kn * glm::mat3();
	//	}

	//	/*	cout << "singular" << endl;
	//	Debug::GetInstance()->Log(singular);*/

	//	G = R * glm::inverse(singular) * glm::transpose(R) / this->h;
	//	//G = R * glm::transpose(R) / this->h;

	//	/*	cout << "G " << endl;
	//	Debug::GetInstance()->Log(G);*/

	//	// width의 반을 중간으로 설정
	//	vec3 translatedParticlePos = particlePos + glm::vec3(
	//		simulWidth * 0.5f + nodeWidth * paddingHalfWidth,
	//		simulHeight * 0.5f + nodeHeight * paddingHalfHeight,
	//		simulDepth * 0.5f + nodeDepth * paddingHalfDepth);

	//	/*vec3 translatedParticlePos = particlePos + glm::vec3(
	//	m_nWidth * 0.5f,
	//	m_nHeight * 0.5f,
	//	m_nDepth * 0.5f);*/

	//	min_x = min(translatedParticlePos.x, min_x);
	//	//cout << widthGridRatio << endl;

	//	// 반올림을 위해 0.5 더함
	//	int k = floorf(translatedParticlePos.x * resolution + 0.5f);
	//	int j = floorf(translatedParticlePos.y * resolution + 0.5f);
	//	int i = floorf(translatedParticlePos.z * resolution + 0.5f);

	//	/*int k = floorf(translatedParticlePos.x * widthGridRatio);
	//	int j = floorf(translatedParticlePos.y * heightGridRatio);
	//	if (j < 20)
	//	xs[k]++;
	//	int i = floorf(translatedParticlePos.z * depthGridRatio);*/

	//	//Debug::GetInstance()->Log(k);

	//	const int nodeNum =
	//		(paddingHalfWidth * 2 + 1) *
	//		(paddingHalfHeight * 2 + 1) *
	//		(paddingHalfDepth * 2 + 1);

	//	int* nNodes = new int[nodeNum];

	//	for (int ii = -paddingHalfDepth; ii <= paddingHalfDepth; ii++)
	//	{
	//		for (int jj = -paddingHalfHeight; jj <= paddingHalfHeight; jj++)
	//		{
	//			for (int kk = -paddingHalfWidth; kk <= paddingHalfWidth; kk++)
	//			{
	//				int index =
	//					(ii + paddingHalfDepth) * (paddingHalfHeight * 2 + 1) * (paddingHalfWidth * 2 + 1) +
	//					(jj + paddingHalfHeight) * (paddingHalfWidth * 2 + 1) +
	//					(kk + paddingHalfWidth);
	//				nNodes[index] = FindNodeIndex(kk + k, jj + j, ii + i);
	//			}
	//		}
	//	}

	//	for (int node = 0; node < nodeNum; node++)
	//	{
	//		// 공간 밖의 node
	//		if (nNodes[node] == -1.0f)
	//			continue;

	//		// node pos가 곧 node의 각 꼭짓점
	//		glm::vec3 nodePos = nodeList[nNodes[node]].mNodePosition;

	//		// anisotropic
	//		if (glm::distance(averagedPos, nodePos) <= this->h)
	//		{
	//			float value = AnisotropicSmoothingKernel(nodePos - averagedPos, G) / densities[i];
	//			nodeList[nNodes[node]].mValue += value;
	//		}

	//		// isotropic
	//		/*if (glm::distance(particlePos, nodePos) <= this->h)
	//		{
	//		float value = ComputePoly6(glm::distance(nodePos, particlePos)) / densities[i];
	//		m_stlNodeList[nNodes[node]].mValue += value;
	//		}*/
	//	}

	//	delete[] nNodes;
	//}
	////cout << min_x << endl;
	////cout << "ratio:" << widthGridRatio << " " << heightGridRatio << " " << depthGridRatio << endl;

	//////PrintDensity();
	////for (int i = 0; i < xs.size(); i++)
	////{
	////	cout << i << "번째: " << xs[i] << endl;
	////}

	////xs.clear();
}

void MarchingCubeTmp::ExcuteMarchingCube(int& vertexNum, int& indexNum)
{
	ID2POINT3DID ***i2pt3idVertices = alloc3D<ID2POINT3DID>(nodeNumX, nodeNumY, nodeNumZ);
	TRIANGLEVECTOR ***trivecTriangles = alloc3D<TRIANGLEVECTOR>(nodeNumX, nodeNumY, nodeNumZ);

	for (int i = 0; i < nodeNumZ; i++)
	{
		for (int j = 0; j < nodeNumY; j++)
		{
			for (int k = 0; k < nodeNumX; k++)
			{
				int cubeIdx = 0;
				int nNodes[8];

				nNodes[0] = FindNodeIndex(k, j, i);
				nNodes[1] = FindNodeIndex(k, j + 1, i);
				nNodes[2] = FindNodeIndex(k, j + 1, i + 1);
				nNodes[3] = FindNodeIndex(k, j, i + 1);

				nNodes[4] = FindNodeIndex(k + 1, j, i);
				nNodes[5] = FindNodeIndex(k + 1, j + 1, i);
				nNodes[6] = FindNodeIndex(k + 1, j + 1, i + 1);
				nNodes[7] = FindNodeIndex(k + 1, j, i + 1);

				if (nodeList[nNodes[0]].mValue <= densityThres) cubeIdx |= 1;	//LBB
				if (nodeList[nNodes[1]].mValue <= densityThres) cubeIdx |= 2;	//RBB
				if (nodeList[nNodes[2]].mValue <= densityThres) cubeIdx |= 4;	//RBF
				if (nodeList[nNodes[3]].mValue <= densityThres) cubeIdx |= 8;	//LBF
				if (nodeList[nNodes[4]].mValue <= densityThres) cubeIdx |= 16;	//LTB
				if (nodeList[nNodes[5]].mValue <= densityThres) cubeIdx |= 32;	//RTB
				if (nodeList[nNodes[6]].mValue <= densityThres) cubeIdx |= 64;	//RTF
				if (nodeList[nNodes[7]].mValue <= densityThres) cubeIdx |= 128;	//LTF

				if (edgeTable[cubeIdx] == 0) continue;

				glm::vec3 verList[12];
				for (int idx = 0; idx < 12; idx++)
					verList[idx] = glm::vec3(0.0, 0.0, 0.0);

				if (edgeTable[cubeIdx] & 1)
				{
					Vec3ID vec3id;
					verList[0] = Interpolation(&nodeList[nNodes[0]], &nodeList[nNodes[1]]);
					vec3id.x = verList[0].x;
					vec3id.y = verList[0].y;
					vec3id.z = verList[0].z;
					vec3id.newID = 0;
					unsigned int id = FindEdgeIndex(i, j, k, 0);
					i2pt3idVertices[i][j][k].insert(ID2POINT3DID::value_type(id, vec3id));
				}
				if ((edgeTable[cubeIdx] & 2) && (j == nodeNumY - 1))
				{
					Vec3ID vec3id;
					verList[1] = Interpolation(&nodeList[nNodes[1]], &nodeList[nNodes[2]]);
					vec3id.x = verList[1].x;
					vec3id.y = verList[1].y;
					vec3id.z = verList[1].z;
					vec3id.newID = 1;
					unsigned int id = FindEdgeIndex(i, j, k, 1);
					i2pt3idVertices[i][j][k].insert(ID2POINT3DID::value_type(id, vec3id));
				}
				if ((edgeTable[cubeIdx] & 4) && (i == nodeNumX - 1))
				{
					Vec3ID vec3id;
					verList[2] = Interpolation(&nodeList[nNodes[2]], &nodeList[nNodes[3]]);
					vec3id.x = verList[2].x;
					vec3id.y = verList[2].y;
					vec3id.z = verList[2].z;
					vec3id.newID = 2;
					unsigned int id = FindEdgeIndex(i, j, k, 2);
					i2pt3idVertices[i][j][k].insert(ID2POINT3DID::value_type(id, vec3id));
				}
				if (edgeTable[cubeIdx] & 8)
				{
					Vec3ID vec3id;
					verList[3] = Interpolation(&nodeList[nNodes[3]], &nodeList[nNodes[0]]);
					vec3id.x = verList[3].x;
					vec3id.y = verList[3].y;
					vec3id.z = verList[3].z;
					vec3id.newID = 3;
					unsigned int id = FindEdgeIndex(i, j, k, 3);
					i2pt3idVertices[i][j][k].insert(ID2POINT3DID::value_type(id, vec3id));
				}
				if ((edgeTable[cubeIdx] & 16) && (k == nodeNumZ - 1))
				{
					Vec3ID vec3id;
					verList[4] = Interpolation(&nodeList[nNodes[4]], &nodeList[nNodes[5]]);
					vec3id.x = verList[4].x;
					vec3id.y = verList[4].y;
					vec3id.z = verList[4].z;
					vec3id.newID = 4;
					unsigned int id = FindEdgeIndex(i, j, k, 4);
					i2pt3idVertices[i][j][k].insert(ID2POINT3DID::value_type(id, vec3id));
				}
				if ((edgeTable[cubeIdx] & 32) && (j == nodeNumY - 1) && (k == nodeNumZ - 1))
				{
					Vec3ID vec3id;
					verList[5] = Interpolation(&nodeList[nNodes[5]], &nodeList[nNodes[6]]);
					vec3id.x = verList[5].x;
					vec3id.y = verList[5].y;
					vec3id.z = verList[5].z;
					vec3id.newID = 5;
					unsigned int id = FindEdgeIndex(i, j, k, 5);
					i2pt3idVertices[i][j][k].insert(ID2POINT3DID::value_type(id, vec3id));
				}
				if ((edgeTable[cubeIdx] & 64) && (i == nodeNumX - 1) && (k == nodeNumZ - 1))
				{
					Vec3ID vec3id;
					verList[6] = Interpolation(&nodeList[nNodes[6]], &nodeList[nNodes[7]]);
					vec3id.x = verList[6].x;
					vec3id.y = verList[6].y;
					vec3id.z = verList[6].z;
					vec3id.newID = 6;
					unsigned int id = FindEdgeIndex(i, j, k, 6);
					i2pt3idVertices[i][j][k].insert(ID2POINT3DID::value_type(id, vec3id));
				}
				if ((edgeTable[cubeIdx] & 128) && (k == nodeNumZ - 1))
				{
					Vec3ID vec3id;
					verList[7] = Interpolation(&nodeList[nNodes[7]], &nodeList[nNodes[4]]);
					vec3id.x = verList[7].x;
					vec3id.y = verList[7].y;
					vec3id.z = verList[7].z;
					vec3id.newID = 7;
					unsigned int id = FindEdgeIndex(i, j, k, 7);
					i2pt3idVertices[i][j][k].insert(ID2POINT3DID::value_type(id, vec3id));
				}
				if (edgeTable[cubeIdx] & 256)
				{
					Vec3ID vec3id;
					verList[8] = Interpolation(&nodeList[nNodes[0]], &nodeList[nNodes[4]]);
					vec3id.x = verList[8].x;
					vec3id.y = verList[8].y;
					vec3id.z = verList[8].z;
					vec3id.newID = 8;
					unsigned int id = FindEdgeIndex(i, j, k, 8);
					i2pt3idVertices[i][j][k].insert(ID2POINT3DID::value_type(id, vec3id));
				}
				if ((edgeTable[cubeIdx] & 512) && (j == nodeNumY - 1))
				{
					Vec3ID vec3id;
					verList[9] = Interpolation(&nodeList[nNodes[1]], &nodeList[nNodes[5]]);
					vec3id.x = verList[9].x;
					vec3id.y = verList[9].y;
					vec3id.z = verList[9].z;
					vec3id.newID = 9;
					unsigned int id = FindEdgeIndex(i, j, k, 9);
					i2pt3idVertices[i][j][k].insert(ID2POINT3DID::value_type(id, vec3id));
				}
				if ((edgeTable[cubeIdx] & 1024) && (i == nodeNumX - 1) && (j == nodeNumY - 1))
				{
					Vec3ID vec3id;
					verList[10] = Interpolation(&nodeList[nNodes[2]], &nodeList[nNodes[6]]);
					vec3id.x = verList[10].x;
					vec3id.y = verList[10].y;
					vec3id.z = verList[10].z;
					vec3id.newID = 10;
					unsigned int id = FindEdgeIndex(i, j, k, 10);
					i2pt3idVertices[i][j][k].insert(ID2POINT3DID::value_type(id, vec3id));
				}
				if ((edgeTable[cubeIdx] & 2048) && (i == nodeNumX - 1))
				{
					Vec3ID vec3id;
					verList[11] = Interpolation(&nodeList[nNodes[3]], &nodeList[nNodes[7]]);
					vec3id.x = verList[11].x;
					vec3id.y = verList[11].y;
					vec3id.z = verList[11].z;
					vec3id.newID = 11;
					unsigned int id = FindEdgeIndex(i, j, k, 11);
					i2pt3idVertices[i][j][k].insert(ID2POINT3DID::value_type(id, vec3id));
				}

				for (int ii = 0; ii < 12; ii++)
				{
					if (verList[ii].x > 1000000 || verList[ii].x < -1000000)
						Debug::GetInstance()->Log(verList[ii]);
				}

				//Generate Vertex
				for (int n = 0; triTable[cubeIdx][n] != -1; n += 3)
				{
					TRIANGLE triangle;
					unsigned int pointID0, pointID1, pointID2;

					pointID0 = FindEdgeIndex(i, j, k, triTable[cubeIdx][n]);
					pointID1 = FindEdgeIndex(i, j, k, triTable[cubeIdx][n + 1]);
					pointID2 = FindEdgeIndex(i, j, k, triTable[cubeIdx][n + 2]);
					if (pointID0 == -1 || pointID1 == -1 || pointID2 == -1)
						cout << "-1 found" << endl;
					triangle.pointID[0] = pointID0;
					triangle.pointID[1] = pointID1;
					triangle.pointID[2] = pointID2;
					trivecTriangles[i][j][k].push_back(triangle);
				}
			}
		}
	}

	for (unsigned int x = 0; x < nodeNumZ; x++)
	{
		for (unsigned int y = 0; y < nodeNumY; y++)
		{
			for (unsigned int z = 0; z < nodeNumX; z++)
			{
				ID2POINT3DID::iterator it = i2pt3idVertices[x][y][z].begin();
				while (it != i2pt3idVertices[x][y][z].end())
				{
					m_i2pt3idVertices.insert(ID2POINT3DID::value_type((*it).first, (*it).second));
					it++;
				}
				i2pt3idVertices[x][y][z].clear();

				TRIANGLEVECTOR::iterator it2 = trivecTriangles[x][y][z].begin();
				while (it2 != trivecTriangles[x][y][z].end())
				{
					m_trivecTriangles.push_back(*it2);
					it2++;
				}
				trivecTriangles[x][y][z].clear();
			}
		}
	}

	RenameVerticesAndTriangles();
	CalculateNormals();

	free3D(i2pt3idVertices);
	free3D(trivecTriangles);

	vertexNum = m_nVertices;
	indexNum = m_nTriangles * 3;

	cout << "vertex num: " << m_nVertices << endl;
	cout << "index num: " << m_nTriangles << endl;

	///////////////////////////////////////////////////////////

}

float* MarchingCubeTmp::GetVertices(const int vertexNum)
{
	float* verts = new float[vertexNum * 6];
	//Vertex* verts2 = new Vertex[vertexNum];

	for (int i = 0; i < vertexNum; i++)
	{
		verts[i * 6 + 0] = m_ppt3dVertices[i].x;
		verts[i * 6 + 1] = m_ppt3dVertices[i].y;
		verts[i * 6 + 2] = m_ppt3dVertices[i].z;
		verts[i * 6 + 3] = m_pvec3dNormals[i].x;
		verts[i * 6 + 4] = m_pvec3dNormals[i].y;
		verts[i * 6 + 5] = m_pvec3dNormals[i].z;

		/*verts2[i].position.x = verts[i * 6 + 0];
		verts2[i].position.y = verts[i * 6 + 1];
		verts2[i].position.z = verts[i * 6 + 2];
		verts2[i].normal.x = verts[i * 6 + 3];
		verts2[i].normal.y = verts[i * 6 + 4];
		verts2[i].normal.z = verts[i * 6 + 5];*/
	}

	//tmpMesh.SetVertices(verts2, vertexNum);

	return verts;
}

GLuint* MarchingCubeTmp::GetIndices(const int indexNum)
{
	GLuint* inds = new GLuint[indexNum];
	for (int i = 0; i < indexNum; i++)
	{
		inds[i] = (GLuint)m_piTriangleIndices[i];
	}

	/*tmpMesh.SetIndices(inds, indexNum);
	tmpMesh.Export("ttt.obj");*/

	return inds;
}

void MarchingCubeTmp::FreeVerticesIndices()
{
	DeleteSurface();
}

glm::vec3 MarchingCubeTmp::Interpolation(Node* p1, Node* p2)
{
	glm::vec3 p = glm::vec3(0.0f, 0.0f, 0.0f);
	float scalar = 0.00001f;

	if (abs(densityThres - p1->mValue) < scalar)
		return p1->mNodePosition;
	if (abs(densityThres - p2->mValue) < scalar)
		return p2->mNodePosition;
	if (abs(p2->mValue - p1->mValue) < scalar)
		return p1->mNodePosition;

	float mu = (densityThres - p1->mValue) / (p2->mValue - p1->mValue);

	p.x = p1->mNodePosition.x + mu * (p2->mNodePosition.x - p1->mNodePosition.x);
	p.y = p1->mNodePosition.y + mu * (p2->mNodePosition.y - p1->mNodePosition.y);
	p.z = p1->mNodePosition.z + mu * (p2->mNodePosition.z - p1->mNodePosition.z);

	return p;
}

// a가 0에 가까울 수록 1에 가깝고
// 1에 가까울 수록 0에 가까운 함수
// 
float MarchingCubeTmp::DecaySpline(float a)
{
	if (a > 1.0f)
		return 0;
	return (1.0f - a*a)*(1.0f - a*a)*(1.0f - a*a);
}

// r값은 0~1 사이의 값
// return 되는 값은 0~1.5668
float MarchingCubeTmp::ComputePoly6(float r)
{
	float a = this->h*this->h - r*r;
	float h3 = this->h*this->h*this->h;
	float h6 = this->h*this->h*this->h*this->h*this->h*this->h;

	if (a < 0)
		return 0;

	return (1.56668f / h3) * DecaySpline(r / this->h);
}

float MarchingCubeTmp::WeightFunc(vec3 relativePos, float r)
{
	float len = glm::length(relativePos);

	if (len >= r)
		return 0.0f;

	// (1-a)^3인지 1-a^3인지 모르겠음, 오타가 있음
	return 1.0f - (len / r)*(len / r)*(len / r);
}

void MarchingCubeTmp::DeleteSurface()
{
	if (m_ppt3dVertices != NULL) {
		delete[] m_ppt3dVertices;
		m_ppt3dVertices = NULL;
	}
	if (m_piTriangleIndices != NULL) {
		delete[] m_piTriangleIndices;
		m_piTriangleIndices = NULL;
	}
	if (m_pvec3dNormals != NULL) {
		delete[] m_pvec3dNormals;
		m_pvec3dNormals = NULL;
	}
}

float MarchingCubeTmp::AnisotropicSmoothingKernel(glm::vec3 r, glm::mat3 G)
{
	/*cout << "det: " << glm::determinant(G) << endl;
	cout << "r original len: " << glm::length(r) << endl;
	cout << "r roteted len: " << glm::length(G*r) << endl;*/

	/*cout << "r original len: " << glm::length(r) << endl;
	cout << "r roteted len: " << glm::length(G*r) << endl;*/

	/*if (glm::length(G*r) > 1.0f)
	cout << "!";*/

	return 1.56668f * glm::determinant(G) * DecaySpline(glm::length(G*r));
}

int MarchingCubeTmp::FindEdgeIndex(unsigned int nX, unsigned int nY, unsigned int nZ, unsigned int nEdgeNo)
{
	switch (nEdgeNo)
	{
	case 0:
		return FindVertexIndex(nX, nY, nZ) + 1;
	case 1:
		return FindVertexIndex(nX, nY + 1, nZ);
	case 2:
		return FindVertexIndex(nX + 1, nY, nZ) + 1;
	case 3:
		return FindVertexIndex(nX, nY, nZ);
	case 4:
		return FindVertexIndex(nX, nY, nZ + 1) + 1;
	case 5:
		return FindVertexIndex(nX, nY + 1, nZ + 1);
	case 6:
		return FindVertexIndex(nX + 1, nY, nZ + 1) + 1;
	case 7:
		return FindVertexIndex(nX, nY, nZ + 1);
	case 8:
		return FindVertexIndex(nX, nY, nZ) + 2;
	case 9:
		return FindVertexIndex(nX, nY + 1, nZ) + 2;
	case 10:
		return FindVertexIndex(nX + 1, nY + 1, nZ) + 2;
	case 11:
		return FindVertexIndex(nX + 1, nY, nZ) + 2;
	default:
		cout << "invalid edge" << endl;
		// Invalid edge no.
		return -1;
	}
}

void MarchingCubeTmp::RenameVerticesAndTriangles()
{
	unsigned int nextID = 0;
	ID2POINT3DID::iterator mapIterator = m_i2pt3idVertices.begin();
	TRIANGLEVECTOR::iterator vecIterator = m_trivecTriangles.begin();

	// Rename vertices.
	while (mapIterator != m_i2pt3idVertices.end())
	{
		(*mapIterator).second.newID = nextID;
		nextID++;
		mapIterator++;
	}

	// Now rename triangles.
	while (vecIterator != m_trivecTriangles.end())
	{
		for (unsigned int i = 0; i < 3; i++) {
			unsigned int newID = m_i2pt3idVertices[(*vecIterator).pointID[i]].newID;
			(*vecIterator).pointID[i] = newID;
		}
		vecIterator++;
	}

	// Copy all the vertices and triangles into two arrays so that they
	// can be efficiently accessed.
	// Copy vertices.
	mapIterator = m_i2pt3idVertices.begin();
	m_nVertices = m_i2pt3idVertices.size();
	m_ppt3dVertices = new vec3[m_nVertices];

	for (unsigned int i = 0; i < m_nVertices; i++, mapIterator++)
	{
		m_ppt3dVertices[i][0] = (*mapIterator).second.x;
		m_ppt3dVertices[i][1] = (*mapIterator).second.y;
		m_ppt3dVertices[i][2] = (*mapIterator).second.z;
	}
	// Copy vertex indices which make triangles.
	vecIterator = m_trivecTriangles.begin();
	m_nTriangles = m_trivecTriangles.size();
	m_piTriangleIndices = new unsigned int[m_nTriangles * 3];

	for (unsigned int i = 0; i < m_nTriangles; i++, vecIterator++)
	{
		m_piTriangleIndices[i * 3] = (*vecIterator).pointID[0];
		m_piTriangleIndices[i * 3 + 1] = (*vecIterator).pointID[1];
		m_piTriangleIndices[i * 3 + 2] = (*vecIterator).pointID[2];
	}

	m_i2pt3idVertices.clear();
	m_trivecTriangles.clear();
}

void MarchingCubeTmp::CalculateNormals()
{
	m_nNormals = m_nVertices;
	m_pvec3dNormals = new vec3[m_nNormals];

	// Set all normals to 0.
	for (int i = 0; i < m_nNormals; i++)
	{
		m_pvec3dNormals[i][0] = 0;
		m_pvec3dNormals[i][1] = 0;
		m_pvec3dNormals[i][2] = 0;
	}

	// Calculate normals.
	for (unsigned int i = 0; i < m_nTriangles; i++)
	{
		vec3 vec1, vec2, normal;
		unsigned int id0, id1, id2;
		id0 = m_piTriangleIndices[i * 3];
		id1 = m_piTriangleIndices[i * 3 + 1];
		id2 = m_piTriangleIndices[i * 3 + 2];

		glm::vec3 ve1 = glm::vec3(m_ppt3dVertices[id0][0], m_ppt3dVertices[id0][1], m_ppt3dVertices[id0][2]);
		glm::vec3 ve2 = glm::vec3(m_ppt3dVertices[id1][0], m_ppt3dVertices[id1][1], m_ppt3dVertices[id1][2]);
		glm::vec3 ve3 = glm::vec3(m_ppt3dVertices[id2][0], m_ppt3dVertices[id2][1], m_ppt3dVertices[id2][2]);

		glm::vec3 v1 = ve2 - ve1;
		glm::vec3 v2 = ve3 - ve1;

		glm::vec3 c_v1_v2 = glm::cross(v1, v2);

		m_pvec3dNormals[id0][0] += c_v1_v2.x;
		m_pvec3dNormals[id0][1] += c_v1_v2.y;
		m_pvec3dNormals[id0][2] += c_v1_v2.z;

		m_pvec3dNormals[id1][0] += c_v1_v2.x;
		m_pvec3dNormals[id1][1] += c_v1_v2.y;
		m_pvec3dNormals[id1][2] += c_v1_v2.z;

		m_pvec3dNormals[id2][0] += c_v1_v2.x;
		m_pvec3dNormals[id2][1] += c_v1_v2.y;
		m_pvec3dNormals[id2][2] += c_v1_v2.z;

	}

	// Normalize normals.
	for (int i = 0; i < m_nNormals; i++)
	{
		float length = sqrt(m_pvec3dNormals[i][0] * m_pvec3dNormals[i][0] + m_pvec3dNormals[i][1] * m_pvec3dNormals[i][1] + m_pvec3dNormals[i][2] * m_pvec3dNormals[i][2]);
		m_pvec3dNormals[i][0] /= length;
		m_pvec3dNormals[i][1] /= length;
		m_pvec3dNormals[i][2] /= length;
	}
}

int MarchingCubeTmp::FindVertexIndex(int nX, int nY, int nZ)
{
	return 3 * (nZ * (nodeNumY + 1) * (nodeNumX + 1) + nY * (nodeNumX + 1) + nX);
}

int	MarchingCubeTmp::FindNodeIndex(int nX, int nY, int nZ)
{
	// 0 ~ m_nNodeResX - 1까지의 범위
	if (nX < 0 || nX >= nodeNumX || nY < 0 || nY >= nodeNumY || nZ < 0 || nZ >= nodeNumZ)
		return -1.0f;

	return (nZ * nodeNumY * nodeNumX) + (nY * nodeNumX) + nX;
}

void MarchingCubeTmp::PrintDensity()
{
	for (int i = 0; i < nodeList.size(); i++)
	{
		cout << nodeList[i].mValue << endl;
	}
}
