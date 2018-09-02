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
#include <map>

#include <Eigen/Dense>
#include <Eigen/SVD>

#include "Model.h"
#include "Mesh.h"
#include "MCTable.h"
#include "CIsoSurface.h"

struct Node
{
	glm::vec3 mNodePosition;
	//float mValue;
};

struct ScalarField
{
	glm::vec3 position;
	float value;
};

class MarchingCube
{
public:
	MarchingCube(void);
	~MarchingCube(void);

public:

	float simulWidth;
	float simulHeight;
	float simulDepth;

	float simulOriginX;
	float simulOriginY;
	float simulOriginZ;

	int nodeNumX;
	int nodeNumY;
	int nodeNumZ;

	float nodeWidth;
	float nodeHeight;
	float nodeDepth;

	float resolution;

	float initNodePosX;
	float initNodePosY;
	float initNodePosZ;

	//std::vector<Node>			nodeList;
	std::vector<ScalarField>	scalarField;

	// isotropic

	// density radius
	float h;
	// neighbor radius (average position radius)
	float r;

	float Kr;
	float Ks;
	float Kn;
	int Ne;

public:
	// simulation boundary 크기와 origin, resolution을 이용해서 node들 생성
	void BuildingGird(float simulWidth, float simulHeight, float simulDepth, float simulOriginX, float simulOriginY, float simulOriginZ, float reso);

	float* ComputeParticleDensity(GLfloat* particlePoses, const int particleNum);

	float* ComputeSphericalKernelGridDensity(GLfloat* particlePoses, float* densities, const int particleNum);
	float* ComputeAnisotropicKernelGridDensity(GLfloat* particlePoses, float* densities, const int particleNum);

	float DecaySpline(float a);
	float ComputePoly6(float r);

	float WeightFunc(vec3 relativePos, float r);

	// relative pos와 matrix를 인풋으로 받아 float을 return하는 함수
	float AnisotropicSmoothingKernel(glm::vec3 r, glm::mat3 G);

	int	FindScalarFieldIndex(int nX, int nY, int nZ);

	void PrintDensity();

private:

	// marching cube를 진행할 때 추가로 둘 padding의 반 개수
	int	paddingHalfWidth;
	int	paddingHalfHeight;
	int	paddingHalfDepth;
};

