#pragma once

#include<GL\glew.h>
#include<vector>
#include<Windows.h>
#include<glm\common.hpp>

using std::vector;

struct ObstacleSphere;

class FluidSimulationImporter
{
public:
	FluidSimulationImporter(){}
	~FluidSimulationImporter(){}

	void Initialize(const glm::vec3 boundarySize);
	void Update(GLfloat* v);
	void Quit();

	int particleNum;

	float* pos;
	float* vel;
	int* issur;

	float* stopFramePos;

	const int toStopFrame = 500;
	int nowFrame = 0;

private:

};