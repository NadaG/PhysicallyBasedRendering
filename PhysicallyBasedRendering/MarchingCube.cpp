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
	m_fCellSpacing = 0.0f;

	m_stlNodeList.clear();
}

MarchingCube::~MarchingCube(void)
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
	m_fCellSpacing = 0.0f;

	m_stlNodeList.clear();
}

// simulation ����, �󸶸�ŭ���� ���� ������ resolution
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

	mMarchingThres = thres;
	//mMarchingThres = 0.04f;
	//mMarchingThres = 0.29f;
	//Calculate Cell Spacing
	m_fCellSpacing = (float)m_nWidth / (float)m_nResX;

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
				Node node;
				node.mNodePosition = glm::vec3(dx, dy, dz);
				node.mDensity = 0.0f;

				m_stlNodeList.push_back(node);
				dx += m_fCellSpacing;
			}
			dy += m_fCellSpacing;
			dx = 0.0f;
		}
		dz += m_fCellSpacing;
		dy = 0.0f;
	}
}


void MarchingCube::ComputeDensity(GLfloat* particlePoses, const int particleNum)
{
	for (int i = 0; i < m_stlNodeList.size(); i++)
	{
		m_stlNodeList[i].mDensity = 0.0f;
	}

	for (int itr = 0; itr < particleNum; itr += 6)
	{
		float weightedDensity = 0.0f;

		glm::vec3 vecPos = glm::vec3(
			particlePoses[itr * 6 + 0], 
			particlePoses[itr * 6 + 1], 
			particlePoses[itr * 6 + 2]);

		vecPos += glm::vec3(m_nWidth * 0.5f, m_nHeight * 0.5f, m_nDepth * 0.5f);

		int k = vecPos.x / ((float)m_nWidth / (float)m_nResX);
		int j = vecPos.y / ((float)m_nHeight / (float)m_nResY);
		int i = vecPos.z / ((float)m_nDepth / (float)m_nResZ);
		int nCellIndex = FindCellIndex(k, j, i);

		//cout << vecPos.x << endl << vecPos.y << endl << vecPos.z << endl;
		//cout << i << endl << j << endl << k << endl;

		int nNodes[8];

		nNodes[0] = FindNodeIndex(k, j, i);
		nNodes[1] = FindNodeIndex(k + 1, j, i);
		nNodes[2] = FindNodeIndex(k + 1, j, i + 1);
		nNodes[3] = FindNodeIndex(k, j, i + 1);

		nNodes[4] = FindNodeIndex(k, j + 1, i);
		nNodes[5] = FindNodeIndex(k + 1, j + 1, i);
		nNodes[6] = FindNodeIndex(k + 1, j + 1, i + 1);
		nNodes[7] = FindNodeIndex(k, j + 1, i + 1);

		for (int node = 0; node < 8; node++)
		{
			// TODO x, y, z ��ǥ�� ���̳ʽ��� ���� �ִµ� ������ �����ȵ�
			// �̰��� ������ ��
			glm::vec3 nodePos = m_stlNodeList[nNodes[node]].mNodePosition;
			
			glm::vec3 dist = vecPos - nodePos;
			float h = glm::length(dist);

			if (h < m_fCellSpacing)
			{
				float kernel = ComputePoly6(h, m_fCellSpacing);
				m_stlNodeList[nNodes[node]].mDensity += 1.0 * -kernel;
			}
		}
	}
}

Mesh* MarchingCube::ExcuteMarchingCube()
{
	Mesh* mesh = new Mesh;
	
	Vertex* verts;
	GLuint* inds;
	/*pMesh->nList.clear();
	pMesh->vList.clear();
	pMesh->fList.clear();*/

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

				if (m_stlNodeList[nNodes[0]].mDensity <= mMarchingThres) cubeIdx |= 1;		//LBB
				if (m_stlNodeList[nNodes[1]].mDensity <= mMarchingThres) cubeIdx |= 2;		//RBB
				if (m_stlNodeList[nNodes[2]].mDensity <= mMarchingThres) cubeIdx |= 4;		//RBF
				if (m_stlNodeList[nNodes[3]].mDensity <= mMarchingThres) cubeIdx |= 8;		//LBF
				if (m_stlNodeList[nNodes[4]].mDensity <= mMarchingThres) cubeIdx |= 16;		//LTB
				if (m_stlNodeList[nNodes[5]].mDensity <= mMarchingThres) cubeIdx |= 32;		//RTB
				if (m_stlNodeList[nNodes[6]].mDensity <= mMarchingThres) cubeIdx |= 64;		//RTF
				if (m_stlNodeList[nNodes[7]].mDensity <= mMarchingThres) cubeIdx |= 128;	//LTF

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
					int loop = triTable[cubeIdx][n];

					Vertex verts[3];

					verts[0].position = 
						glm::vec3(
							verList[triTable[cubeIdx][n + 2]].x, 
							verList[triTable[cubeIdx][n + 2]].y, 
							verList[triTable[cubeIdx][n + 2]].z) - 
						glm::vec3(m_nWidth * 0.5f, m_nHeight * 0.5f, m_nDepth * 0.5f);
					verts[1].position = 
						glm::vec3(
							verList[triTable[cubeIdx][n + 1]].x, 
							verList[triTable[cubeIdx][n + 1]].y, 
							verList[triTable[cubeIdx][n + 1]].z) -
						glm::vec3(m_nWidth * 0.5f, m_nHeight * 0.5f, m_nDepth * 0.5f);
					verts[2].position = 
						glm::vec3(
							verList[triTable[cubeIdx][n]].x, 
							verList[triTable[cubeIdx][n]].y, 
							verList[triTable[cubeIdx][n]].z) -
						glm::vec3(m_nWidth * 0.5f, m_nHeight * 0.5f, m_nDepth * 0.5f);

					indsVec.push_back(nVID);
					nVID++;
					indsVec.push_back(nVID);
					nVID++; 
					indsVec.push_back(nVID);
					nVID++;

					vertsVec.push_back(verts[0]);
					vertsVec.push_back(verts[1]);
					vertsVec.push_back(verts[2]);

					//Vertex verts[3];

					/*Vertex* verts = new Vertex[3];
					GLuint* inds = new GLuint[3];

					verts[0].position = glm::vec3(verList[triTable[cubeIdx][n + 2]].x, verList[triTable[cubeIdx][n + 2]].y, verList[triTable[cubeIdx][n + 2]].z);
					verts[1].position = glm::vec3(verList[triTable[cubeIdx][n + 1]].x, verList[triTable[cubeIdx][n + 1]].y, verList[triTable[cubeIdx][n + 1]].z);
					verts[2].position = glm::vec3(verList[triTable[cubeIdx][n]].x, verList[triTable[cubeIdx][n]].y, verList[triTable[cubeIdx][n]].z);

					inds[0] = 0;
					inds[1] = 1;
					inds[2] = 2;
					*/

					/*pMesh->fList.push_back(nVID);
					nVID++;
					pMesh->fList.push_back(nVID);
					nVID++;
					pMesh->fList.push_back(nVID);
					nVID++;

					pMesh->vList.push_back(verts[0]);
					pMesh->vList.push_back(verts[1]);
					pMesh->vList.push_back(verts[2]);*/
				}
			}
		}
	}

	/*pMesh->ComputeFaceNormal();*/

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
	return mesh;
}

glm::vec3 MarchingCube::Interpolation(Node* p1, Node* p2)
{
	glm::vec3 p = glm::vec3(0.0f, 0.0f, 0.0f);
	float scalar = 0.0000f;

	if (abs(mMarchingThres - p1->mDensity) < scalar)
		return p1->mNodePosition;
	if (abs(mMarchingThres - p2->mDensity) < scalar)
		return p2->mNodePosition;
	if (abs(p2->mDensity - p1->mDensity) < scalar)
		return p1->mNodePosition;

	float mu = (mMarchingThres - p1->mDensity) / (p2->mDensity - p1->mDensity);

	p.x = p1->mNodePosition.x + mu * (p2->mNodePosition.x - p1->mNodePosition.x);
	p.y = p1->mNodePosition.y + mu * (p2->mNodePosition.y - p1->mNodePosition.y);
	p.z = p1->mNodePosition.z + mu * (p2->mNodePosition.z - p1->mNodePosition.z);

	return p;
}

float MarchingCube::ComputePoly6(float h, float r)
{
	float a = h*h - r*r;

	return 1.56668f * a * a * a;
}

int	MarchingCube::FindCellIndex(int nX, int nY, int nZ)
{
	return (nZ * m_nResX * m_nResY) + (nY * m_nResX) + nX;
}

int	MarchingCube::FindNodeIndex(int nX, int nY, int nZ)
{
	return (nZ * m_nNodeResY * m_nNodeResX) + (nY * m_nNodeResX) + nX;
}
