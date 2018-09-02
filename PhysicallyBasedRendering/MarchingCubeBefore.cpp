#include <iostream>
#include <algorithm>

#include "MarchingCubeBefore.h"
#include "MarchingCubeVertexNormalUtility.h"

using std::cout;
using std::endl;

using std::min;

MarchingCube::MarchingCube(void)
//	:Kr(4.0f), Ne(100), Ks(1.0f), Kn(5.0f)
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
	Ne = 1000000;

	// 일정 수 이상의 particle이 있을 때 singular matrix에 곱해질 상수
	Ks = 0.25f;

	// 일정 수 이하의 particle이 있을 때 identity matrix에 곱해질 상수
	Kn = 0.1f;

	// 괜찮은 parameter
	// h = 1.5, thres = 1.5, resolution = 3.0

	h = 1.0f;
	r = h * 2;

	paddingHalfWidth = 15;
	paddingHalfHeight = 15;
	paddingHalfDepth = 15;
}

MarchingCube::~MarchingCube(void)
{
	//nodeList.clear();
	scalarField.clear();
}

// simulation 공간, 얼마만큼으로 나눌 것인지 resolution
void MarchingCube::BuildingGird(
	float simulWidth, float simulHeight, float simulDepth,
	float simulOriginX, float simulOriginY, float simulOriginZ,
	float reso)
{
	this->simulWidth = simulWidth;
	this->simulHeight = simulHeight;
	this->simulDepth = simulDepth;

	this->simulOriginX = simulOriginX;
	this->simulOriginY = simulOriginY;
	this->simulOriginZ = simulOriginZ;

	// 양쪽에 같은 크기의 padding(paddingHalfWidth*2)
	// 단 scalar field의 크기는 node의 개수보다 1 많아야 함
	this->nodeNumX = this->simulWidth * reso + paddingHalfWidth * 2;
	this->nodeNumY = this->simulHeight * reso + paddingHalfHeight * 2;
	this->nodeNumZ = this->simulDepth * reso + paddingHalfDepth * 2;

	this->resolution = reso;

	this->nodeWidth = 1.0f  / this->resolution;
	this->nodeHeight = 1.0f / this->resolution;
	this->nodeDepth = 1.0f  / this->resolution;

	//Calculate Cell Spacing
	this->initNodePosX = simulOriginX - (this->nodeNumX+1) * this->nodeWidth * 0.5f;
	this->initNodePosY = simulOriginY - (this->nodeNumY+1) * this->nodeHeight * 0.5f;
	this->initNodePosZ = simulOriginZ - (this->nodeNumZ+1) * this->nodeDepth * 0.5f;

	//Building Node
	// node position은 world 좌표계에서 정의됨 (값이 -일 수 있음)
	// node의 index는 0부터 시작하기 때문에 시작이 0이 되도록 조정해야 함
	for (int i = 0; i <= nodeNumZ; i++)
	{
		for (int j = 0; j <= nodeNumY; j++)
		{
			for (int k = 0; k <= nodeNumX; k++)
			{
				glm::vec3 nodePos = glm::vec3(
					initNodePosX + k * this->nodeWidth,
					initNodePosY + j * this->nodeHeight,
					initNodePosZ + i * this->nodeDepth);

				ScalarField scalar;
				scalar.value = 0.0f;

				if (k == nodeNumX || j == nodeNumY || k == nodeNumZ)
				{
					scalar.position = nodePos + 0.5f * vec3(this->nodeWidth, this->nodeHeight, this->nodeDepth);
					scalarField.push_back(scalar);
				}
				else
				{
					scalar.position = nodePos - 0.5f * vec3(this->nodeWidth, this->nodeHeight, this->nodeDepth);
					scalarField.push_back(scalar);
				}
			}
		}
	}

	//cout << "node num: " << nodeList.size() << endl << "scalar field num: " << scalarField.size() << endl;
}

float* MarchingCube::ComputeParticleDensity(GLfloat* particlePoses, const int particleNum)
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

float* MarchingCube::ComputeSphericalKernelGridDensity(GLfloat* particlePoses, float* densities, const int particleNum)
{
	for (int i = 0; i < scalarField.size(); i++)
	{
		scalarField[i].value = 0.0f;
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
			simulWidth * 0.5f + nodeWidth * paddingHalfWidth,
			simulHeight * 0.5f + nodeHeight * paddingHalfHeight,
			simulDepth * 0.5f + nodeDepth * paddingHalfDepth);

		int k = floorf(translatedParticlePos.x * resolution + 0.5f);
		int j = floorf(translatedParticlePos.y * resolution + 0.5f);
		int i = floorf(translatedParticlePos.z * resolution + 0.5f);

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
					nNodes[index] = FindScalarFieldIndex(kk + k, jj + j, ii + i);
				}
			}
		}

		for (int node = 0; node < nodeNum; node++)
		{
			// 공간 밖의 node
			if (nNodes[node] == -1.0f)
				continue;

			// node pos가 곧 node의 각 꼭짓점
			glm::vec3 pos = scalarField[nNodes[node]].position;

			// 파티클과 node의 거리가 thresh hold 값보다 작으면 
			if (glm::distance(particlePos, pos) <= this->h && densities[i] >= 0.0001f)
			{
				float value = ComputePoly6(glm::distance(particlePos, pos)) / densities[i];
				scalarField[nNodes[node]].value += value;
			}
		}

		delete[] nNodes;
	}

	//PrintDensity();

	float* retScalarField = new float[(nodeNumX + 1)*(nodeNumY + 1)*(nodeNumZ + 1)];
	for (int i = 0; i < (nodeNumX + 1)*(nodeNumY + 1)*(nodeNumZ + 1); i++)
	{
		retScalarField[i] = scalarField[i].value;
	}
	return retScalarField;
}

float* MarchingCube::ComputeAnisotropicKernelGridDensity(GLfloat* particlePoses, float* densities, const int particleNum)
{
	for (int i = 0; i < scalarField.size(); i++)
	{
		scalarField[i].value = 0.0f;
	}

	for (int itr = 0; itr < particleNum; itr++)
	{
		// particle의 world coordinate의 위치
		glm::vec3 particlePos = glm::vec3(
			particlePoses[itr * 6 + 0],
			particlePoses[itr * 6 + 1],
			particlePoses[itr * 6 + 2]);

		// 논문에서는 0.9 ~ 1.0을 사용했다 함
		float lambda = 0.9f;
		vec3 weightPosSum = glm::vec3();
		float weightSum = 0.0f;

		int neighborNum = 0;

		for (int jtr = 0; jtr < particleNum; jtr++)
		{
			if (itr == jtr)
				continue;

			glm::vec3 particlePos2 = glm::vec3(
				particlePoses[jtr * 6 + 0],
				particlePoses[jtr * 6 + 1],
				particlePoses[jtr * 6 + 2]);

			if (glm::distance(particlePos, particlePos2) < this->r)
			{
				neighborNum++;
			}

			float weight = WeightFunc(particlePos - particlePos2, this->r);
			weightSum += weight;
			weightPosSum += weight * particlePos2;
		}

		vec3 weightPosMean = particlePos;
		vec3 averagedPos = particlePos;
		if (neighborNum > 0)
		{
			weightPosMean = weightPosSum / weightSum;
			averagedPos = (1.0f - lambda) * particlePos + lambda * weightPosMean;
		}

		//cout << neighborNum << endl;

		Eigen::Matrix3f C;
		glm::mat3 G, singular;
		for (int i = 0; i < 3; i++)
		{
			for (int j = 0; j < 3; j++)
			{
				C(i, j) = 0.0f;
			}
		}

		for (int jtr = 0; jtr < particleNum; jtr++)
		{
			if (itr == jtr)
				continue;

			glm::vec3 particlePos2 = glm::vec3(
				particlePoses[jtr * 6 + 0],
				particlePoses[jtr * 6 + 1],
				particlePoses[jtr * 6 + 2]);

			float weight = WeightFunc(particlePos - particlePos2, this->r);

			C(0, 0) += weight * (particlePos2.x - weightPosMean.x) * (particlePos2.x - weightPosMean.x);
			C(0, 1) += weight * (particlePos2.x - weightPosMean.x) * (particlePos2.y - weightPosMean.y);
			C(0, 2) += weight * (particlePos2.x - weightPosMean.x) * (particlePos2.z - weightPosMean.z);
			C(1, 1) += weight * (particlePos2.y - weightPosMean.y) * (particlePos2.y - weightPosMean.y);
			C(1, 2) += weight * (particlePos2.y - weightPosMean.y) * (particlePos2.z - weightPosMean.z);
			C(2, 2) += weight * (particlePos2.z - weightPosMean.z) * (particlePos2.z - weightPosMean.z);
		}
		C(1, 0) = C(0, 1);
		C(2, 0) = C(0, 2);
		C(2, 1) = C(1, 2);

		/*
		cout << "c:" << endl;
		cout << c << endl << endl << endl;*/

		if (neighborNum > 0)
		{
			C /= weightSum;
		}

		//cout << c.determinant() << endl;
		//cout << "covariance matrix: " << c << endl;

		Eigen::JacobiSVD<Eigen::Matrix3f> decomposedC(C, Eigen::ComputeFullU);

		//cout << "sigular values:" << decomposedC.singularValues() << endl;

		// singularValues의 x값이 가장 큼
		glm::vec3 singularValues = glm::vec3(
			decomposedC.singularValues()(0),
			decomposedC.singularValues()(1),
			decomposedC.singularValues()(2));

		//Debug::GetInstance()->Log(singularValues);

		glm::mat3 R = glm::mat3(
			decomposedC.matrixU()(0, 0), decomposedC.matrixU()(0, 1), decomposedC.matrixU()(0, 2),
			decomposedC.matrixU()(1, 0), decomposedC.matrixU()(1, 1), decomposedC.matrixU()(1, 2),
			decomposedC.matrixU()(2, 0), decomposedC.matrixU()(2, 1), decomposedC.matrixU()(2, 2));

		/*singular = Ks * glm::mat3(
		singularValues.x, 0.0f, 0.0f,
		0.0f, singularValues.y, 0.0f,
		0.0f, 0.0f, singularValues.z);*/
		//cout << "det kC" << endl;
		//glm::mat3 kC = R * singular * glm::transpose(R);
		//Debug::GetInstance()->Log(glm::determinant(kC));

		if (neighborNum > Ne)
		{
			singular = Ks * glm::mat3(
				singularValues.x, 0.0f, 0.0f,
				0.0f, glm::max(singularValues.y, singularValues.x / Kr), 0.0f,
				0.0f, 0.0f, glm::max(singularValues.z, singularValues.x / Kr));
		}
		else
		{
			singular = glm::mat3(Kn);
		}

		/*	cout << "singular" << endl;
		Debug::GetInstance()->Log(singular);*/

		G = R * glm::inverse(singular) * glm::transpose(R) / this->h;
		//G = R * glm::transpose(R) / this->h;

		/*	cout << "G " << endl;
		Debug::GetInstance()->Log(G);*/

		// width의 반을 중간으로 설정
		vec3 translatedParticlePos = particlePos + glm::vec3(
			simulWidth * 0.5f + nodeWidth * paddingHalfWidth,
			simulHeight * 0.5f + nodeHeight * paddingHalfHeight,
			simulDepth * 0.5f + nodeDepth * paddingHalfDepth);

		// -15.0 ~ 15.0의 값을 0~30으로 바꿈
		/*vec3 translatedParticlePos = particlePos + glm::vec3(
			simulWidth * 0.5f,
			simulHeight * 0.5f,
			simulDepth * 0.5f);*/
		//Debug::GetInstance()->Log(translatedParticlePos);

		// 반올림을 위해 0.5 더함
		int k = floorf(translatedParticlePos.x * resolution + 0.5f);
		int j = floorf(translatedParticlePos.y * resolution + 0.5f);
		int i = floorf(translatedParticlePos.z * resolution + 0.5f);

		/*int k = floorf(translatedParticlePos.x * resolution);
		int j = floorf(translatedParticlePos.y * resolution);
		int i = floorf(translatedParticlePos.z * resolution);*/

		/*
		int k = translatedParticlePos.x*resolution;
		int j = translatedParticlePos.y*resolution;
		int i = translatedParticlePos.z*resolution;
		*/

		//Debug::GetInstance()->Log(k);

		const int nodeNum =
			(paddingHalfWidth * 2 + 1) *
			(paddingHalfHeight * 2 + 1) *
			(paddingHalfDepth * 2 + 1);

		int* scalarFieldIndices = new int[nodeNum];

		for (int ii = -paddingHalfDepth; ii <= paddingHalfDepth; ii++)
		{
			for (int jj = -paddingHalfHeight; jj <= paddingHalfHeight; jj++)
			{
				for (int kk = -paddingHalfWidth; kk <= paddingHalfWidth; kk++)
				{
					// from 0 to max
					int index =
						(ii + paddingHalfDepth) * (paddingHalfHeight * 2 + 1) * (paddingHalfWidth * 2 + 1) +
						(jj + paddingHalfHeight) * (paddingHalfWidth * 2 + 1) +
						(kk + paddingHalfWidth);
					scalarFieldIndices[index] = FindScalarFieldIndex(kk + k, jj + j, ii + i);
					//cout << FindScalarFieldIndex(kk + k, jj + j, ii + i) << endl;
				}
			}
		}

		//cout << endl << endl << endl;

		for (int node = 0; node < nodeNum; node++)
		{
			// 공간 밖의 node
			if (scalarFieldIndices[node] == -1)
				continue;

			// node pos가 곧 node의 각 꼭짓점
			glm::vec3 position = scalarField[scalarFieldIndices[node]].position;
			
			// anisotropic
			if (glm::distance(averagedPos, position) <= this->h && densities[i] >= 0.0001f)
			{
				//cout << "dist: " << glm::distance(averagedPos, position) << endl;
				float value = AnisotropicSmoothingKernel(position - averagedPos, G) / densities[i];
				scalarField[scalarFieldIndices[node]].value += value;
			}

			// isotropic
			/*if (glm::distance(particlePos, nodePos) <= this->h)
			{
			float value = ComputePoly6(glm::distance(nodePos, particlePos)) / densities[i];
			m_stlNodeList[nNodes[node]].mValue += value;
			}*/
		}

		delete[] scalarFieldIndices;
	}


	float* retScalarField = new float[(nodeNumX + 1)*(nodeNumY + 1)*(nodeNumZ + 1)];
	for (int i = 0; i < (nodeNumX + 1)*(nodeNumY + 1)*(nodeNumZ + 1); i++)
	{
		retScalarField[i] = scalarField[i].value;
	}
	return retScalarField;
}

// a가 0에 가까울 수록 1에 가깝고
// 1에 가까울 수록 0에 가까운 함수
float MarchingCube::DecaySpline(float a)
{
	if (a > 1.0f)
		return 0;
	return (1.0f - a*a)*(1.0f - a*a)*(1.0f - a*a);
}

// r값은 0~1 사이의 값
// return 되는 값은 0~1.5668
float MarchingCube::ComputePoly6(float r)
{
	float a = this->h*this->h - r*r;
	float h3 = this->h*this->h*this->h;
	float h6 = this->h*this->h*this->h*this->h*this->h*this->h;

	if (a < 0)
		return 0;

	return (1.56668f / h3) * DecaySpline(r / this->h);
}

float MarchingCube::WeightFunc(vec3 relativePos, float r)
{
	float len = glm::length(relativePos);

	if (len >= r)
		return 0.0f;

	// (1-a)^3인지 1-a^3인지 모르겠음, 오타가 있음
	return 1.0f - (len / r)*(len / r)*(len / r);
}

void MarchingCube::PrintDensity()
{
	for (int i = 0; i < scalarField.size(); i++)
	{
		if (scalarField[i].value != 0.0f)
			cout << scalarField[i].value << endl;
	}
}

float MarchingCube::AnisotropicSmoothingKernel(glm::vec3 r, glm::mat3 G)
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

int MarchingCube::FindScalarFieldIndex(int nX, int nY, int nZ)
{
	if (nX < 0 || nX > nodeNumX || nY < 0 || nY > nodeNumY || nZ < 0 || nZ > nodeNumZ)
		return -1;

	return nZ*(nodeNumY + 1)*(nodeNumX + 1) + nY*(nodeNumX + 1) + nX;
}