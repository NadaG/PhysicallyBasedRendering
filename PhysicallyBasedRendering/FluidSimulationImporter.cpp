#include "FluidSimulationImporter.h"

#include <iostream>

using std::cout;
using std::endl;

struct float3
{
	float x;
	float y;
	float z;
};

struct int3
{
	int x;
	int y;
	int z;
};

struct SimulationParam
{
	float3 boundaryPos;
	float3 boundarySize;

	int objNum;
	int obsobjNum;

	float viscosity;
	float restDensity;
	float pressure;
	float surfacetension;
	float kernelSize;
	float surfaceThreshold;
	float gravity;

	int box2d;
	int box2d_particle;

	float vAtten;

	float yMaxValue;
};

SimulationParam sparam;
HMODULE handle;

struct ObstacleCube
{
	float3 pos;
	int3 size;
};

struct ObstacleSphere
{
	float3 pos;
	float radius;
};

int(*initialize)(SimulationParam param, FluidCube* cubes, ObstacleCube* obsobjs);
void(*update)(float* pos, float* vel, int* issur, ObstacleSphere *spheres, int n_spheres);
void(*add_particle)(float3 pos, float3 vel);
void(*quit)();

void FluidSimulationImporter::Initialize(const glm::vec3 boundarySize, FluidCube* cubes, int cubeNum)
{
	handle = LoadLibrary(SOLUTION_DIR L"\\x64\\Release\\FLing4.dll");

	initialize = (int(*)(SimulationParam, FluidCube*, ObstacleCube*))GetProcAddress(handle, "initialize");
	update = (void(*)(float*, float*, int*, ObstacleSphere *, int))GetProcAddress(handle, "update");
	quit = (void(*)())GetProcAddress(handle, "quit");
	add_particle = (void(*)(float3, float3))GetProcAddress(handle, "add_particle");

	sparam.boundaryPos.x = 0.0f;
	sparam.boundaryPos.y = 0.0f;
	sparam.boundaryPos.z = 0.0f;
	sparam.boundarySize.x = boundarySize.x;
	sparam.boundarySize.y = boundarySize.y;
	sparam.boundarySize.z = boundarySize.z;
	sparam.objNum = cubeNum;
	sparam.obsobjNum = 0;

	sparam.viscosity = 0.02f;
	sparam.restDensity = 1000.0f;
	sparam.pressure = 0.01f;
	sparam.surfacetension = 0.01f;
	sparam.kernelSize = 1.0f;
	sparam.surfaceThreshold = 3000.0f;
	sparam.gravity = 10.0f;
	sparam.vAtten = 0.00002f;

	sparam.box2d = 0;
	sparam.box2d_particle = 0;

	sparam.yMaxValue = 10000.0f;

	/*FluidCube* cubes = new FluidCube[sparam.objNum];
	cubes[0].size.x = 21;
	cubes[0].size.y = 50;
	cubes[0].size.z = 50;
	cubes[0].pos.x = -10.0f;
	cubes[0].pos.y = 0.0f;
	cubes[0].pos.z = 0.0f;*/

	particleNum = initialize(sparam, cubes, nullptr);
	
	pos = new float[particleNum * 3];
	stopFramePos = new float[particleNum * 3];
	vel = new float[particleNum * 3];
	issur = new int[particleNum];

	for (int i = 0; i < particleNum*3; i++)
	{
		pos[i] = 0.0f;
		stopFramePos[i] = 0.0f;
		vel[i] = 0.0f;
	}

	for (int i = 0; i < particleNum; i++)
		issur[i] = 0;

	posScalingFactor = 1.0f;
}

void FluidSimulationImporter::AddParticle(const glm::vec3 pos, const glm::vec3 vel)
{
	float3 pPos, pVel;
	pPos.x = pos.x;
	pPos.y = pos.y;
	pPos.z = pos.z;

	pVel.x = vel.x;
	pVel.y = vel.y;
	pVel.z = vel.z;

	add_particle(pPos, pVel);
}

// pos�� velocity�� ����
void FluidSimulationImporter::Update(GLfloat* v)
{
	nowFrame++;
	update(pos, vel, issur, nullptr, 0);

	if (nowFrame == toStopFrame)
	{
		for (int i = 0; i < particleNum; i++)
		{
			stopFramePos[i * 3 + 0] = pos[i * 3 + 0] * posScalingFactor;
			stopFramePos[i * 3 + 1] = pos[i * 3 + 1] * posScalingFactor;
			stopFramePos[i * 3 + 2] = pos[i * 3 + 2] * posScalingFactor;
		}
	}
	else if(nowFrame > toStopFrame)
	{
		for (int i = 0; i < particleNum; i++)
		{
			v[i * 6 + 0] = stopFramePos[i * 3 + 0];
			v[i * 6 + 1] = stopFramePos[i * 3 + 1];
			v[i * 6 + 2] = stopFramePos[i * 3 + 2];
			if (issur[i] > 0)
			{
				v[i * 6 + 3] = 1.0f;
				v[i * 6 + 4] = 1.0f;
				v[i * 6 + 5] = 1.0f;
			}
			else
			{
				v[i * 6 + 3] = 0.0f;
				v[i * 6 + 4] = 0.0f;
				v[i * 6 + 5] = 1.0f;
			}
		}
	}
	else
	{
		for (int i = 0; i < particleNum; i++)
		{
			v[i * 6 + 0] = pos[i * 3 + 0] * posScalingFactor;
			v[i * 6 + 1] = pos[i * 3 + 1] * posScalingFactor;
			v[i * 6 + 2] = pos[i * 3 + 2] * posScalingFactor;

			if (issur[i] > 0)
			{
				v[i * 6 + 3] = 1.0f;
				v[i * 6 + 4] = 1.0f;
				v[i * 6 + 5] = 1.0f;
			}
			else
			{
				v[i * 6 + 3] = 0.0f;
				v[i * 6 + 4] = 0.0f;
				v[i * 6 + 5] = 1.0f;
			}
		}
	}
}

void FluidSimulationImporter::Quit()
{
	quit();
	FreeLibrary(handle);
	delete[] stopFramePos;
	delete[] pos;
	delete[] vel;
	delete[] issur;
}