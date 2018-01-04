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
	
	// �� mesh ���� �ϳ��� material�� �־���
	vector<Mesh> meshes;
	vector<Material> material;

	const aiScene *scene;
};