#pragma once

#include <string>
#include <iostream>
#include <glm\common.hpp>

using namespace std;

// binary file을 읽는 역할
// 읽은 파일을 density, velocity 배열로 할당하는 역할을 함
// 여러 역할을 하는 클래스라는 것을 알고 있으셈
class SmokeSimulationImporter
{
public:

	SmokeSimulationImporter(int width, int height, int depth);
	virtual ~SmokeSimulationImporter(){}

	const int& GetWidth() { return width; }
	const int& GetHeight() { return height; }
	const int& GetDepth() { return depth; }

	// x, y, z
	float* velocityX;
	float* velocityY;
	float* velocityZ;
	float* density;

private:
	void ReadArray(float* arr, string filePath);

	int width;
	int height;
	int depth;

	FILE* fp;
};