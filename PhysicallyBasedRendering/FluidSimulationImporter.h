#pragma once

#include<GL\glew.h>
#include<vector>
#include<Windows.h>
#include<glm\common.hpp>

using std::vector;

struct ObstacleSphere;
struct FluidCube;

class FluidSimulationImporter
{
public:
	FluidSimulationImporter(){}
	~FluidSimulationImporter(){}

	void Initialize(const glm::vec3 boundarySize, FluidCube* cubes, int cubeNum);
	void AddParticle(const glm::vec3 pos, const glm::vec3 vel);

	void Update(GLfloat* v);
	void Quit();

	int particleNum;

	float* pos;
	float* vel;
	int* issur;

	float* stopFramePos;

	const int toStopFrame = 1000;
	int nowFrame = 0;

	float posScalingFactor;

private:

};