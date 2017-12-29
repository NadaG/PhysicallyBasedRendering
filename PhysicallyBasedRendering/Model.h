#pragma once

#include "Mesh.h"
#include "Texture2D.h"
#include "TextureCube.h"

class Model
{
public:
	void LoadModel(const string& model);
	void DrawModel();

private:

	unsigned int* meshTextureIndex;
	vector<Mesh> meshes;
	vector<Texture2D> textures;

	const aiScene *scene;
};