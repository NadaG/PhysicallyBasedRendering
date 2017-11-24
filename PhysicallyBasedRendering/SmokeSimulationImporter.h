#pragma once

#include <string>
#include <iostream>
#include <glm\common.hpp>

using namespace std;

// binary file�� �д� ����
// ���� ������ density, velocity �迭�� �Ҵ��ϴ� ������ ��
// ���� ������ �ϴ� Ŭ������� ���� �˰� ������
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