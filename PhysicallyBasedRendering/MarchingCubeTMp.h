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

//#include <Eigen/Dense>
//#include <Eigen/SVD>

#include "Model.h"
#include "MCTable.h"
#include "Mesh.h"

struct Vec3ID
{
	unsigned int newID;
	float x, y, z;
};

struct TRIANGLE
{
	unsigned int pointID[3];
};

typedef std::map<unsigned int, Vec3ID> ID2POINT3DID;
typedef std::vector<TRIANGLE> TRIANGLEVECTOR;

struct Node
{
	glm::vec3 mNodePosition;
	float mValue;
};

class MarchingCubeTmp
{
public:
	MarchingCubeTmp(void);
	~MarchingCubeTmp(void);

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

	// marching cube를 진행할 때 추가로 둘 padding의 반 개수
	int	paddingHalfWidth;
	int	paddingHalfHeight;
	int	paddingHalfDepth;

	float densityThres;

	std::vector<Node>		nodeList;

	// isotropic

	// density radius
	float h;
	// neighbor radius (average position radius)
	float r;

	float Kr;
	float Ks;
	float Kn;
	int Ne;

	ID2POINT3DID m_i2pt3idVertices;
	TRIANGLEVECTOR m_trivecTriangles;

	unsigned int m_nVertices;
	vec3* m_ppt3dVertices;

	unsigned int m_nTriangles;
	unsigned int* m_piTriangleIndices;

	unsigned int m_nNormals;
	vec3* m_pvec3dNormals;

public:
	// simulation boundary 크기와 origin, resolution을 이용해서 node들 생성
	void BuildingGird(
		float simulWidth, float simulHeight, float simulDepth, 
		float simulOriginX, float simulOriginY, float simulOriginZ,
		float reso, float thres);

	float* ComputeParticleDensity(GLfloat* particlePoses, const int particleNum);

	void ComputeSphericalKernelGridDensity(GLfloat* particlePoses, float* densities, const int particleNum);
	void ComputeAnisotropicKernelGridDensity(GLfloat* particlePoses, float* densities, const int particleNum);
	void ExcuteMarchingCube(int& vertexNum, int& indexNum);

	float* GetVertices(const int vertexNum);
	GLuint* GetIndices(const int indexNum);

	void FreeVerticesIndices();

	float DecaySpline(float a);
	float ComputePoly6(float r);

	float WeightFunc(vec3 relativePos, float r);

	// relative pos와 matrix를 인풋으로 받아 float을 return하는 함수
	float AnisotropicSmoothingKernel(glm::vec3 r, glm::mat3 G);

	glm::vec3 Interpolation(Node* p1, Node* p2);

	int FindVertexIndex(int nX, int nY, int nZ);
	int	FindNodeIndex(int nX, int nY, int nZ);
	int FindEdgeIndex(unsigned int nX, unsigned int nY, unsigned int nZ, unsigned int nEdgeNo);

	void RenameVerticesAndTriangles();
	void CalculateNormals();

	void DeleteSurface();

	void PrintDensity();

private:
	Mesh tmpMesh;
};

