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

	// marching cube를 진행할 때 검색할 주위 grid 개수의 반
	int		halfWidth;

	float widthSpacing;
	float heightSpacing;		
	float depthSpacing;

	float widthGridRatio;
	float heightGridRatio;
	float depthGridRatio;

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

	ID2POINT3DID m_i2pt3idVertices;
	TRIANGLEVECTOR m_trivecTriangles;

	unsigned int m_nVertices;
	vec3* m_ppt3dVertices;

	unsigned int m_nTriangles;
	unsigned int* m_piTriangleIndices;

	unsigned int m_nNormals;
	vec3* m_pvec3dNormals;

public:
	void BuildingGird(int nWidth, int nHeight, int nDepth, int nResX, int nResY, int nResZ, float thres);

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

	void PrintDensity();

private:
	Mesh tmpMesh;
};

