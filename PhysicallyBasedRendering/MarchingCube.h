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
	float	m_fCellSpacing;

	float		mMarchingThres;
	std::vector<Node>		m_stlNodeList;


public:
	void BuildingGird(int nWidth, int nHeight, int nDepth, int nResX, int nResY, int nResZ, float thres);

	void ComputeDensity(GLfloat* particlePoses, const int particleNum);
	Mesh* ExcuteMarchingCube();

	float ComputePoly6(float h, float r);
	glm::vec3 Interpolation(Node* p1, Node* p2);

	int	FindCellIndex(int nX, int nY, int nZ);
	int	FindNodeIndex(int nX, int nY, int nZ);
};

