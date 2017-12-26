#pragma once

#include "Mesh.h"

class Model
{
public:
	void LoadModel(const string& model);
	void DrawModel();

private:
	vector<Mesh> meshes;
	const aiScene *scene;
};