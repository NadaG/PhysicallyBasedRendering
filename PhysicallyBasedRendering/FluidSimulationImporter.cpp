#include "FluidSimulationImporter.h"

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
	float threshold;
	float surfaceThreshold;

	int box2d;
	int box2d_particle;

	float vAtten;

	float yMaxValue;
};

SimulationParam sparam;

struct FluidCube
{
	float3 pos;
	int3 size;
};

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
void(*quit)();

void FluidSimulationImporter::Initialize()
{
	HMODULE handle;
	handle = LoadLibrary(SOLUTION_DIR L"\\x64\\Release\\FLing.dll");

	initialize = (int(*)(SimulationParam, FluidCube*, ObstacleCube*))GetProcAddress(handle, "initialize");
	update = (void(*)(float*, float*, int*, ObstacleSphere *, int))GetProcAddress(handle, "update");
	quit = (void(*)())GetProcAddress(handle, "quit");

	sparam.boundaryPos.x = 0.0f;
	sparam.boundaryPos.y = 2.5f;
	sparam.boundaryPos.z = 0.0f;
	sparam.boundarySize.x = 10.0f;
	sparam.boundarySize.y = 15.0f;
	sparam.boundarySize.z = 10.0f;
	sparam.objNum = 1;
	sparam.obsobjNum = 0;

	sparam.viscosity = 0.002f;
	sparam.restDensity = 2000.0f;
	sparam.pressure = 0.1f;
	sparam.surfacetension = 0.002f;
	sparam.threshold = 1.0f;
	sparam.surfaceThreshold = 0.005f;
	sparam.vAtten = 1.0f;

	sparam.box2d = 0;
	sparam.box2d_particle = 0;

	sparam.yMaxValue = 10000.0f;

	FluidCube* cubes = new FluidCube[sparam.objNum];
	cubes[0].size.x = 15;
	cubes[0].size.y = 15;
	cubes[0].size.z = 15;
	cubes[0].pos.x = 0.0f;
	cubes[0].pos.y = 5.0f;
	cubes[0].pos.z = 0.0f;

	particleNum = initialize(sparam, cubes, nullptr);
	
	pos = new float[particleNum * 3];
	vel = new float[particleNum * 3];
	issur = new int[particleNum];
}

void FluidSimulationImporter::Update(GLfloat* v)
{
	update(pos, vel, issur, nullptr, 0);

	for (int i = 0; i < particleNum; i++)
	{
		v[i * 6 + 0] = pos[i * 3 + 0];
		v[i * 6 + 1] = pos[i * 3 + 1];
		v[i * 6 + 2] = pos[i * 3 + 2];
		v[i * 6 + 4] = vel[i * 3 + 0];
		v[i * 6 + 5] = vel[i * 3 + 1];
		v[i * 6 + 6] = vel[i * 3 + 2];
	}
}

void FluidSimulationImporter::Quit()
{
	delete pos;
	delete vel;
	delete issur;
	quit();
	
}