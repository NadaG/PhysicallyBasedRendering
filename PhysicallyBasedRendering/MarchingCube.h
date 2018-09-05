#pragma once

#include <iostream>
#include <GL/glew.h>
#include <glm\common.hpp>
#include <glm\gtx\norm.hpp>
#include <vector>
#include <unordered_map>
#include <map>

#include <Eigen/Dense>
#include <Eigen/SVD>

#include "CIsoSurface.h"

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

	// 시뮬레이션 공간 정보
	float simulWidth;
	float simulHeight;
	float simulDepth;

	float simulOriginX;
	float simulOriginY;
	float simulOriginZ;

	// grid 나누기 정보
	int nodeNumX;
	int nodeNumY;
	int nodeNumZ;

	float nodeWidth;
	float nodeHeight;
	float nodeDepth;

	// 시뮬레이션 단위 공간에 한 축에서 몇 개의 grid가 들어갈 것인지
	float resolution;

	float initNodePosX;
	float initNodePosY;
	float initNodePosZ;

	std::vector<ScalarField>	scalarField;

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

	// TODO particle pos들로부터 particle들의 densities를 뽑는 함수
	// 인자로 들어온 particlePoses의 형식이
	// position.x position.y position.z velocity.x velocity.y velocity.z.. 이기 때문에 형식에 맞게 수정해야 함
	void ComputeParticleDensity(GLfloat* particlePoses, const int particleNum);

	float* ComputeScalarFieldUsingSphericalKernel(GLfloat* particlePoses, const int particleNum);
	float* ComputeScalarFieldUsingAnisotropicKernel(GLfloat* particlePoses, const int particleNum);

private:

	float* particleDensities;

	float DecaySpline(float a);
	float ComputePoly6(float r);

	float WeightFunc(vec3 relativePos, float r);

	// relative pos와 matrix를 인풋으로 받아 float을 return하는 함수
	float AnisotropicSmoothingKernel(glm::vec3 r, glm::mat3 G);

	int	FindScalarFieldIndex(int nX, int nY, int nZ);

	void PrintDensity();

	// marching cube를 진행할 때 추가로 둘 padding의 반 개수
	int	paddingHalfWidth;
	int	paddingHalfHeight;
	int	paddingHalfDepth;
};

