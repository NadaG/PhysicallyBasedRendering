#pragma once

#include "Mesh.h"
#include "Material.h"

class Model
{
public:
	void LoadModel(const string& model);
	void DrawModel();

	void AddMesh(const MeshType& meshType);

	void DeleteModel();

private:

	unsigned int* meshTextureIndex;
	
	// 각 mesh 마다 하나의 material이 주어짐
	vector<Mesh> meshes;
	vector<Material> material;

	const aiScene *scene;
};