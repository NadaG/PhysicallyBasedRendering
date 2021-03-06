#include "SceneObject.h"

void SceneObject::LoadModel(const char * s)
{
	model.Load(s);
}

void SceneObject::LoadModel(const MeshType& meshType)
{
	model.AddMesh(meshType);
}

void SceneObject::SetColor(const glm::vec3& color)
{
	this->color = color;
}

std::vector<Triangle> SceneObject::GetTriangles() const
{
	return model.GetTriangles();
}

void SceneObject::DrawModel()
{
	model.Draw();
}
