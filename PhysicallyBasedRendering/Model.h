#pragma once

#include "Mesh.h"
#include "Material.h"

class Model
{
public:
	void Load(const string& model);
	void Draw();

	void AddMesh(const MeshType& meshType);

	void Delete();

	std::vector<Triangle> GetTriangles() const;

private:

	unsigned int* meshMaterialIndex;
	
	// �� mesh ���� �ϳ��� material�� �־���
	vector<Mesh> meshes;
	vector<Material> material;

	const aiScene *scene;
};