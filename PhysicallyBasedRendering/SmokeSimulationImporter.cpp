#include "SmokeSimulationImporter.h"

SmokeSimulationImporter::SmokeSimulationImporter(int width, int height, int depth)
{
	this->width = width;
	this->height = height;
	this->depth = depth;

	density = new float[(width + 2)*(height + 2)*(depth + 2)];
	velocityX = new float[(width + 2)*(height + 2)*(depth + 2)];
	velocityY = new float[(width + 2)*(height + 2)*(depth + 2)];
	velocityZ = new float[(width + 2)*(height + 2)*(depth + 2)];

	ReadArray(density, "./Simulation/Smoke/00100.density");
	ReadArray(velocityX, "./Simulation/Smoke/00100.u");
	ReadArray(velocityY, "./Simulation/Smoke/00100.v");
	ReadArray(velocityZ, "./Simulation/Smoke/00100.w");
}

void SmokeSimulationImporter::ReadArray(float* arr, string filePath)
{
	errno_t err;
	err = fopen_s(&fp, filePath.c_str(), "rb");
	if (err)
	{
		cout << "Cannot open" << filePath << endl;
	}
	fread(arr, sizeof(float)*(width + 2)*(height + 2)*(depth + 2), 1, fp);
	fclose(fp);
}