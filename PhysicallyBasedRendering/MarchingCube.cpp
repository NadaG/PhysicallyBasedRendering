#include "MarchingCube.h"
#include <iostream>

using std::cout;
using std::endl;

MarchingCube::MarchingCube(void)
{
	m_nWidth = 0;
	m_nHeight = 0;
	m_nDepth = 0;
	m_nResX = 0;
	m_nResY = 0;
	m_nResZ = 0;
	m_nNodeResX = 0;
	m_nNodeResY = 0;
	m_nNodeResZ = 0;

	Kr = 4.0f;
	//Ks = 1400.0f;
	Ks = 1.0f;
	Kn = 0.5f;
	Ne = 25;

	sigma = 1.0f;

	h = 2.0f;
	r = h * 2;
}

MarchingCube::~MarchingCube(void)
{
	m_stlNodeList.clear();
}

// simulation 공간, 얼마만큼으로 나눌 것인지 resolution
void MarchingCube::BuildingGird(int nWidth, int nHeight, int nDepth, int nResX, int nResY, int nResZ, float thres)
{
	m_nWidth = nWidth;
	m_nHeight = nHeight;
	m_nDepth = nDepth;
	m_nResX = nResX;
	m_nResY = nResY;
	m_nResZ = nResZ;
	m_nNodeResX = m_nResX + 1;
	m_nNodeResY = m_nResY + 1;
	m_nNodeResZ = m_nResZ + 1;

	m_DensityThres = thres;
	//mMarchingThres = 0.04f;
	//mMarchingThres = 0.29f;

	//Calculate Cell Spacing
	float widthSpacing = (float)m_nWidth / (float)m_nResX;
	float heightSpacing = (float)m_nHeight / (float)m_nResY;
	float depthSpacing = (float)m_nDepth / (float)m_nResZ;

	float dx = 0.0f;
	float dy = 0.0f;
	float dz = 0.0f;

	int nodeIdx = 0;

	//Building Node
	for (int i = 0; i < m_nNodeResZ; i++)
	{
		for (int j = 0; j < m_nNodeResY; j++)
		{
			for (int k = 0; k < m_nNodeResX; k++)
			{
				// 각 node는 voxel로 보지말고 voxel의 끝 점이라고 생각할 것
				Node node;
				// node의 world position
				node.mNodePosition = glm::vec3(dx - m_nWidth * 0.5f, dy - m_nHeight * 0.5f, dz - m_nDepth * 0.5f);
				node.mDensity = 0.0f;

				m_stlNodeList.push_back(node);
				dx += widthSpacing;
			}
			dy += heightSpacing;
			dx = 0.0f;
		}
		dz += depthSpacing;
		dy = 0.0f;
	}
}


void MarchingCube::ComputeDensity(GLfloat* particlePoses, const int particleNum)
{
	for (int i = 0; i < m_stlNodeList.size(); i++)
	{
		m_stlNodeList[i].mDensity = 0.0f;
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
			m_nWidth * 0.5f, 
			m_nHeight * 0.5f, 
			m_nDepth * 0.5f);

		int k = translatedParticlePos.x / ((float)m_nWidth / (float)m_nResX);
		int j = translatedParticlePos.y / ((float)m_nHeight / (float)m_nResY);
		int i = translatedParticlePos.z / ((float)m_nDepth / (float)m_nResZ);

		const int halfWidth = 4;
		const int nodeNum = (halfWidth * 2 + 1) * (halfWidth * 2 + 1) * (halfWidth * 2 + 1);

		int nNodes[nodeNum];

		for (int ii = -halfWidth; ii <= halfWidth; ii++)
		{
			for (int jj = -halfWidth; jj <= halfWidth; jj++)
			{
				for (int kk = -halfWidth; kk <= halfWidth; kk++)
				{
					int index = 
						(ii + halfWidth) * (halfWidth * 2 + 1) * (halfWidth * 2 + 1) + 
						(jj + halfWidth) * (halfWidth * 2 + 1) +
						(kk + halfWidth);
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
			glm::vec3 nodePos = m_stlNodeList[nNodes[node]].mNodePosition;
			
			float r = glm::distance(particlePos, nodePos);

			// 파티클과 node의 거리가 thresh hold 값보다 작으면 
			if (r < this->h)
			{
				float kernel = ComputePoly6(r / this->h);
				m_stlNodeList[nNodes[node]].mDensity += 1.0 * kernel;
			}
		}
	}

	//PrintDensity();
}

void MarchingCube::ComputeIsotropicSmoothingDensity(GLfloat * particlePoses, const int particleNum)
{
	for (int i = 0; i < m_stlNodeList.size(); i++)
	{
		m_stlNodeList[i].mDensity = 0.0f;
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

			if (glm::distance(particlePos, particlePos2) < r)
			{
				neighborNum++;
			}

			float weight = WeightFunc(particlePos - particlePos2, r);
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

		Eigen::Matrix3f c;
		glm::mat3 G, singular;
		for (int i = 0; i < 3; i++)
		{
			for (int j = 0; j < 3; j++)
			{
				c(i, j) = 0.0f;
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

			float weight = WeightFunc(particlePos - particlePos2, r);

			c(0, 0) += weight * (particlePos2.x - weightPosMean.x) * (particlePos2.x - weightPosMean.x);
			c(0, 1) += weight * (particlePos2.x - weightPosMean.x) * (particlePos2.y - weightPosMean.y);
			c(0, 2) += weight * (particlePos2.x - weightPosMean.x) * (particlePos2.z - weightPosMean.z);
			c(1, 1) += weight * (particlePos2.y - weightPosMean.y) * (particlePos2.y - weightPosMean.y);
			c(1, 2) += weight * (particlePos2.y - weightPosMean.y) * (particlePos2.z - weightPosMean.z);
			c(2, 2) += weight * (particlePos2.z - weightPosMean.z) * (particlePos2.z - weightPosMean.z);
		}
		c(1, 0) = c(0, 1);
		c(2, 0) = c(0, 2);
		c(2, 1) = c(1, 2);

		/*cout << "c:" << endl;
		cout << c << endl << endl << endl;*/

		if (neighborNum > 0)
			c /= weightSum;

		//cout << c.determinant() << endl;
		//cout << "covariance matrix: " << c << endl;

		Eigen::JacobiSVD<Eigen::Matrix3f> decomposedC(c, Eigen::ComputeFullU | Eigen::ComputeFullV);

		//cout << "sigular values:" << decomposedC.singularValues() << endl;
		
		glm::vec3 singularValues = glm::vec3(
			decomposedC.singularValues()(0), 
			decomposedC.singularValues()(1), 
			decomposedC.singularValues()(2));
		
		if (neighborNum > Ne)
		{
			singular = Ks * glm::mat3(
				singularValues.x, 0.0f, 0.0f, 
				0.0f, glm::max(singularValues.y, singularValues.x / Kr), 0.0f,
				0.0f, 0.0f, glm::max(singularValues.z, singularValues.x / Kr));
		}
		else
		{
			// identity matrix
			singular = Kn * glm::mat3();
		}

		glm::mat3 R = glm::mat3(
			decomposedC.matrixU()(0, 0), decomposedC.matrixU()(0, 1), decomposedC.matrixU()(0, 2),
			decomposedC.matrixU()(1, 0), decomposedC.matrixU()(1, 1), decomposedC.matrixU()(1, 2),
			decomposedC.matrixU()(2, 0), decomposedC.matrixU()(2, 1), decomposedC.matrixU()(2, 2));

	/*	cout << "singular" << endl;
		Debug::GetInstance()->Log(singular);*/

		G = R * glm::inverse(singular) * glm::transpose(R) / this->h;

	/*	cout << "G " << endl;
		Debug::GetInstance()->Log(G);*/

		// width의 반을 중간으로 설정
		vec3 translatedParticlePos = averagedPos + glm::vec3(
			m_nWidth * 0.5f,
			m_nHeight * 0.5f,
			m_nDepth * 0.5f);

		int k = translatedParticlePos.x / ((float)m_nWidth / (float)m_nResX);
		int j = translatedParticlePos.y / ((float)m_nHeight / (float)m_nResY);
		int i = translatedParticlePos.z / ((float)m_nDepth / (float)m_nResZ);

		const int halfWidth = 5;
		const int nodeNum = (halfWidth * 2 + 1) * (halfWidth * 2 + 1) * (halfWidth * 2 + 1);

		int nNodes[nodeNum];

		for (int ii = -halfWidth; ii <= halfWidth; ii++)
		{
			for (int jj = -halfWidth; jj <= halfWidth; jj++)
			{
				for (int kk = -halfWidth; kk <= halfWidth; kk++)
				{
					int index =
						(ii + halfWidth) * (halfWidth * 2 + 1) * (halfWidth * 2 + 1) +
						(jj + halfWidth) * (halfWidth * 2 + 1) +
						(kk + halfWidth);
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
			glm::vec3 nodePos = m_stlNodeList[nNodes[node]].mNodePosition;

			// 파티클과 node의 거리가 thresh hold 값보다 작으면 
			if (glm::distance(particlePos, nodePos) < this->h)
			{
				float density = IsotropicSmoothingKernel(particlePos - nodePos, G);
				m_stlNodeList[nNodes[node]].mDensity += density;
			}
		}
	}

	//PrintDensity();
}

void MarchingCube::ExcuteMarchingCube(const string& meshfile)
{
	Mesh* mesh = new Mesh;
	
	Vertex* verts;
	GLuint* inds;

	std::vector<Vertex> vertsVec;
	std::vector<GLuint> indsVec;

	std::vector<glm::vec3> vList;

	int nVID = 0;

	for (int i = 0; i < m_nResZ; i++)
	{
		for (int j = 0; j < m_nResY; j++)
		{
			for (int k = 0; k < m_nResX; k++)
			{
				int cubeIdx = 0;
				int nCellIdx = FindCellIndex(k, j, i);
				int nNodes[8];
				nNodes[0] = FindNodeIndex(k, j, i);
				nNodes[1] = FindNodeIndex(k + 1, j, i);
				nNodes[2] = FindNodeIndex(k + 1, j, i + 1);
				nNodes[3] = FindNodeIndex(k, j, i + 1);

				nNodes[4] = FindNodeIndex(k, j + 1, i);
				nNodes[5] = FindNodeIndex(k + 1, j + 1, i);
				nNodes[6] = FindNodeIndex(k + 1, j + 1, i + 1);
				nNodes[7] = FindNodeIndex(k, j + 1, i + 1);

				//cout << m_stlNodeList[nNodes[0]].mDensity << endl;
				
				if (m_stlNodeList[nNodes[0]].mDensity <= m_DensityThres) cubeIdx |= 1;		//LBB
				if (m_stlNodeList[nNodes[1]].mDensity <= m_DensityThres) cubeIdx |= 2;		//RBB
				if (m_stlNodeList[nNodes[2]].mDensity <= m_DensityThres) cubeIdx |= 4;		//RBF
				if (m_stlNodeList[nNodes[3]].mDensity <= m_DensityThres) cubeIdx |= 8;		//LBF
				if (m_stlNodeList[nNodes[4]].mDensity <= m_DensityThres) cubeIdx |= 16;		//LTB
				if (m_stlNodeList[nNodes[5]].mDensity <= m_DensityThres) cubeIdx |= 32;		//RTB
				if (m_stlNodeList[nNodes[6]].mDensity <= m_DensityThres) cubeIdx |= 64;		//RTF
				if (m_stlNodeList[nNodes[7]].mDensity <= m_DensityThres) cubeIdx |= 128;	//LTF

				if (edgeTable[cubeIdx] == 0) continue;

				glm::vec3 verList[12];
				for (int idx = 0; idx < 12; idx++)
					verList[idx] = glm::vec3(0.0, 0.0, 0.0);

				if (edgeTable[cubeIdx] & 1) verList[0] = Interpolation(&m_stlNodeList[nNodes[0]], &m_stlNodeList[nNodes[1]]);
				if (edgeTable[cubeIdx] & 2) verList[1] = Interpolation(&m_stlNodeList[nNodes[1]], &m_stlNodeList[nNodes[2]]);
				if (edgeTable[cubeIdx] & 4) verList[2] = Interpolation(&m_stlNodeList[nNodes[2]], &m_stlNodeList[nNodes[3]]);
				if (edgeTable[cubeIdx] & 8) verList[3] = Interpolation(&m_stlNodeList[nNodes[3]], &m_stlNodeList[nNodes[0]]);
				if (edgeTable[cubeIdx] & 16) verList[4] = Interpolation(&m_stlNodeList[nNodes[4]], &m_stlNodeList[nNodes[5]]);
				if (edgeTable[cubeIdx] & 32) verList[5] = Interpolation(&m_stlNodeList[nNodes[5]], &m_stlNodeList[nNodes[6]]);
				if (edgeTable[cubeIdx] & 64) verList[6] = Interpolation(&m_stlNodeList[nNodes[6]], &m_stlNodeList[nNodes[7]]);
				if (edgeTable[cubeIdx] & 128) verList[7] = Interpolation(&m_stlNodeList[nNodes[7]], &m_stlNodeList[nNodes[4]]);
				if (edgeTable[cubeIdx] & 256) verList[8] = Interpolation(&m_stlNodeList[nNodes[0]], &m_stlNodeList[nNodes[4]]);
				if (edgeTable[cubeIdx] & 512) verList[9] = Interpolation(&m_stlNodeList[nNodes[1]], &m_stlNodeList[nNodes[5]]);
				if (edgeTable[cubeIdx] & 1024) verList[10] = Interpolation(&m_stlNodeList[nNodes[2]], &m_stlNodeList[nNodes[6]]);
				if (edgeTable[cubeIdx] & 2048) verList[11] = Interpolation(&m_stlNodeList[nNodes[3]], &m_stlNodeList[nNodes[7]]);

				//Generate Vertex
				for (int n = 0; triTable[cubeIdx][n] != -1; n += 3)
				{
					Vertex verts[3];

					verts[0].position = 
						glm::vec3(
							verList[triTable[cubeIdx][n + 2]].x, 
							verList[triTable[cubeIdx][n + 2]].y, 
							verList[triTable[cubeIdx][n + 2]].z);
					verts[1].position = 
						glm::vec3(
							verList[triTable[cubeIdx][n + 1]].x, 
							verList[triTable[cubeIdx][n + 1]].y, 
							verList[triTable[cubeIdx][n + 1]].z);
					verts[2].position = 
						glm::vec3(
							verList[triTable[cubeIdx][n]].x, 
							verList[triTable[cubeIdx][n]].y, 
							verList[triTable[cubeIdx][n]].z);

					indsVec.push_back(nVID);
					nVID++;
					indsVec.push_back(nVID);
					nVID++; 
					indsVec.push_back(nVID);
					nVID++;

					vertsVec.push_back(verts[0]);
					vertsVec.push_back(verts[1]);
					vertsVec.push_back(verts[2]);
				}
			}
		}
	}

	verts = new Vertex[vertsVec.size()];
	inds = new GLuint[indsVec.size()];

	for (int i = 0; i < vertsVec.size(); i++)
	{
		verts[i] = vertsVec[i];
	}

	for (int i = 0; i < indsVec.size(); i++)
	{
		inds[i] = indsVec[i];
	}

	mesh->SetVertices(verts, vertsVec.size());
	mesh->SetIndices(inds, indsVec.size());
	mesh->CaculateVertexNormal();
	mesh->CaculateFaceNormal();

	mesh->GenerateAndSetVAO();
	mesh->Export(meshfile);

	delete mesh;
}

glm::vec3 MarchingCube::Interpolation(Node* p1, Node* p2)
{
	glm::vec3 p = glm::vec3(0.0f, 0.0f, 0.0f);
	float scalar = 0.0f;

	if (abs(m_DensityThres - p1->mDensity) < scalar)
		return p1->mNodePosition;
	if (abs(m_DensityThres - p2->mDensity) < scalar)
		return p2->mNodePosition;
	if (abs(p2->mDensity - p1->mDensity) < scalar)
		return p1->mNodePosition;

	float mu = (m_DensityThres - p1->mDensity) / (p2->mDensity - p1->mDensity);

	p.x = p1->mNodePosition.x + mu * (p2->mNodePosition.x - p1->mNodePosition.x);
	p.y = p1->mNodePosition.y + mu * (p2->mNodePosition.y - p1->mNodePosition.y);
	p.z = p1->mNodePosition.z + mu * (p2->mNodePosition.z - p1->mNodePosition.z);

	return p;
}

// r값은 0~1 사이의 값
// return 되는 값은 0~1.5668
float MarchingCube::ComputePoly6(float r)
{
	float a = 1.0f - r*r;

	if (a < 0)
		return 0;

	return 1.56668f * a * a * a;
}

float MarchingCube::WeightFunc(vec3 relativePos, float r)
{
	float len = glm::length(relativePos);

	if (len >= r)
		return 0.0f;

	// (1-a)^3인지 1-a^3인지 모르겠음, 오타가 있음
	return 1.0f - (len / r)*(len / r)*(len / r);
}

float MarchingCube::IsotropicSmoothingKernel(glm::vec3 r, glm::mat3 G)
{
	/*cout << "det: " << glm::determinant(G) << endl;
	cout << "r original len: " << glm::length(r) << endl;
	cout << "r roteted len: " << glm::length(G*r) << endl;*/

	return sigma * glm::determinant(G) * ComputePoly6(glm::length(G*r));
}

int	MarchingCube::FindCellIndex(int nX, int nY, int nZ)
{
	return (nZ * m_nResX * m_nResY) + (nY * m_nResX) + nX;
}

int	MarchingCube::FindNodeIndex(int nX, int nY, int nZ)
{
	if (nX < 0 || nX >= m_nNodeResX || nY < 0 || nY >= m_nNodeResY || nZ < 0 || nZ >= m_nNodeResZ)
		return -1.0f;

	return (nZ * m_nNodeResY * m_nNodeResX) + (nY * m_nNodeResX) + nX;
}

void MarchingCube::PrintDensity()
{
	for (int i = 0; i < m_stlNodeList.size(); i++)
	{
		cout << m_stlNodeList[i].mDensity << endl;
	}
}