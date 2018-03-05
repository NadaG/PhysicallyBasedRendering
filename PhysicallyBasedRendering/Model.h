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
	
	// 각 mesh 마다 하나의 material이 주어짐
	vector<Mesh> meshes;
	vector<Material> material;

	const aiScene *scene;
};