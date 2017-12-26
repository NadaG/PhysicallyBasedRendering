#pragma once

#include "ShaderProgram.h"
#include "Model.h"

class PhongShaderProgram : public ShaderProgram
{
public:
	PhongShaderProgram()
	{
		shaderProgramID = glCreateProgram();
		LoadShaders("Basic.vs", "Phong.fs");
	}

	void LoadPhongModel();
	void DrawPhongModel();

private:
	Assimp::Importer importer;
	vector<Mesh> meshes;
	const aiScene *scene;
};