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

//#include <Eigen/Dense>
//#include <Eigen/SVD>

#include "Model.h"
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

	std::vector<Node>		m_stlNodeList;

	// isotropic

	// density radius
	float h;
	// neighbor radius (average position radius)
	float r;
	
	float Kr;
	float Ks;
	float Kn;
	int Ne;

	float sigma;

public:
	void BuildingGird(int nWidth, int nHeight, int nDepth, int nResX, int nResY, int nResZ, float thres);

	void ComputeDensity(GLfloat* particlePoses, const int particleNum);
	void ComputeIsotropicSmoothingDensity(GLfloat* particlePoses, const int particleNum);
	void ExcuteMarchingCube(const string& meshfile);

	float ComputePoly6(float r);

	float WeightFunc(vec3 relativePos, float r);

	// relative pos와 matrix를 인풋으로 받아 float을 return하는 함수
	float IsotropicSmoothingKernel(glm::vec3 r, glm::mat3 G);


	glm::vec3 Interpolation(Node* p1, Node* p2);

	int	FindCellIndex(int nX, int nY, int nZ);
	int	FindNodeIndex(int nX, int nY, int nZ);

	void PrintDensity();
};

