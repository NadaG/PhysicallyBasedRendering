#pragma once

#include <iostream>
#include <GL/glew.h>
#include <GL/glut.h>
#include <GL/gl.h>
#include <GL/glu.h>
#include <glm\common.hpp>
#include <glm\gtx\norm.hpp>
#include <vector>
#include <unordered_map>

#include "MarchingMesh.h"
#include "MCTable.h"
#include "Mesh.h"

struct Node
{
	glm::vec3 mNodePosition;
	float mDensity;
};

class MarchingCube
{
public:
	MarchingCube(void);
	~MarchingCube(void);

public:
	int		m_nWidth;
	int		m_nHeight;
	int		m_nDepth;
	int		m_nResX;
	int		m_nResY;
	int		m_nResZ;
	int		m_nNodeResX;
	int		m_nNodeResY;
	int		m_nNodeResZ;

	float m_DensityThres;
	float m_KernelDistThres;

	std::vector<Node>		m_stlNodeList;

	// isotropic

	// smoothing radius
	const float h = 1.0f;
	
	float Kr = 4.0f;
	float Ks = 1400.0f;
	float Kn = 0.5f;
	int Ne = 25;

public:
	void BuildingGird(int nWidth, int nHeight, int nDepth, int nResX, int nResY, int nResZ, float thres);

	void ComputeDensity(GLfloat* particlePoses, const int particleNum);
	void ComputeIsotropicSmoothingDensity(GLfloat* particlePoses, const int particleNum);
	Mesh* ExcuteMarchingCube();

	float ComputePoly6(float h, float r);

	float WeightFunc(vec3 relativePos, float r);

	// relative pos와 matrix를 인풋으로 받아 float을 return하는 함수
	float IsotropicSmoothingKernel(glm::vec3 r, glm::mat3 G);


	glm::vec3 Interpolation(Node* p1, Node* p2);

	int	FindCellIndex(int nX, int nY, int nZ);
	int	FindNodeIndex(int nX, int nY, int nZ);
};

