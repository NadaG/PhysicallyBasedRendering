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

	// �ùķ��̼� ���� ����
	float simulWidth;
	float simulHeight;
	float simulDepth;

	float simulOriginX;
	float simulOriginY;
	float simulOriginZ;

	// grid ������ ����
	int nodeNumX;
	int nodeNumY;
	int nodeNumZ;

	float nodeWidth;
	float nodeHeight;
	float nodeDepth;

	// �ùķ��̼� ���� ������ �� �࿡�� �� ���� grid�� �� ������
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
	// simulation boundary ũ��� origin, resolution�� �̿��ؼ� node�� ����
	void BuildingGird(float simulWidth, float simulHeight, float simulDepth, float simulOriginX, float simulOriginY, float simulOriginZ, float reso);

	// TODO particle pos��κ��� particle���� densities�� �̴� �Լ�
	// ���ڷ� ���� particlePoses�� ������
	// position.x position.y position.z velocity.x velocity.y velocity.z.. �̱� ������ ���Ŀ� �°� �����ؾ� ��
	void ComputeParticleDensity(GLfloat* particlePoses, const int particleNum);

	float* ComputeScalarFieldUsingSphericalKernel(GLfloat* particlePoses, const int particleNum);
	float* ComputeScalarFieldUsingAnisotropicKernel(GLfloat* particlePoses, const int particleNum);

private:

	float* particleDensities;

	float DecaySpline(float a);
	float ComputePoly6(float r);

	float WeightFunc(vec3 relativePos, float r);

	// relative pos�� matrix�� ��ǲ���� �޾� float�� return�ϴ� �Լ�
	float AnisotropicSmoothingKernel(glm::vec3 r, glm::mat3 G);

	int	FindScalarFieldIndex(int nX, int nY, int nZ);

	void PrintDensity();

	// marching cube�� ������ �� �߰��� �� padding�� �� ����
	int	paddingHalfWidth;
	int	paddingHalfHeight;
	int	paddingHalfDepth;
};

