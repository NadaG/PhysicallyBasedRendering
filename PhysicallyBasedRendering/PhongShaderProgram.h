#pragma once

#include "ShaderProgram.h"
#include "Mesh.h"

class PhongShaderProgram : public ShaderProgram
{
public:
	PhongShaderProgram()
	{
		shaderProgramID = glCreateProgram();
		LoadShaders("Basic.vs", "Phong.fs");
	}

	void LoadPhongMesh();
	void DrawPhongMesh();

private:
	vector<Mesh> phongMeshes;
};