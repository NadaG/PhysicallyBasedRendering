#pragma once

#include<GL\glew.h>
#include<vector>
#include<Windows.h>

using std::vector;

struct ObstacleSphere;

class FluidSimulationImporter
{
public:
	FluidSimulationImporter(){}
	~FluidSimulationImporter(){}

	void Initialize();
	void Update(GLfloat* v);
	void Quit();

	int particleNum;

	float* pos;
	float* vel;
	int* issur;

	float* stopFramePos;

	const int toStopFrame = 170;
	int nowFrame = 0;

private:

};