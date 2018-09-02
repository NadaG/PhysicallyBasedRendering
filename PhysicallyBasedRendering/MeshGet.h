#pragma once

#include "../solver.h"

#include <fstream>
#include <sstream>


using namespace std;

struct
{
	glm::vec3 pos;
	glm::vec3 normal;
}typedef Vertex;

class Mesh {
public:
	Mesh();
	virtual ~Mesh();

	// Attribute
public:
	std::vector<Vertex> mVList;
	std::vector<unsigned int> mFList;

public:
	bool	LoadMesh(const char *fileName);

	void	ComputeVertexNormal();

	//Inline Min/Max function
public:
	inline int minValue(int a, int b) { return (a > b) ? b : a; }
	inline int maxValue(int a, int b) { return (a < b) ? b : a; }
};



