#include "SceneObject.h"

SceneObject::SceneObject()
{
	this->positionVector = glm::vec3(0, 0, 0);
	this->scaleVector = glm::vec3(1, 1, 1);
	this->rotationMatrix = glm::mat4(1.0);
}

void SceneObject::LoadModel(const char * s)
{
	model.LoadModel(s);
}

void SceneObject::LoadModel(const MeshType& meshType)
{
	model.AddMesh(meshType);
}

void SceneObject::SetColor(const glm::vec3& color)
{
	this->color = color;
}

void SceneObject::TerminateModel()
{
	model.DeleteModel();
}

glm::vec3 SceneObject::GetWorldPosition()
{
	glm::vec3 rotatedPosition = rotationMatrix * glm::vec4(positionVector, 1.0f);

	glm::vec3 worldPosition = glm::vec3(
		scaleVector.x * rotatedPosition.x,
		scaleVector.y * rotatedPosition.y,
		scaleVector.z * rotatedPosition.z);
	return worldPosition;
}

const glm::mat4 SceneObject::GetModelMatrix()
{
	return glm::translate(positionVector) * rotationMatrix * glm::scale(scaleVector);
}

void SceneObject::DrawModel()
{
	model.DrawModel();
}

void SceneObject::Translate(const glm::vec3& vec)
{
	this->positionVector += vec;
}

void SceneObject::WorldTranslate(const glm::vec3 vec)
{
}

void SceneObject::Rotate(const glm::vec3& vec, float angle)
{
	this->rotationMatrix = glm::rotate(rotationMatrix, angle, vec);
}

void SceneObject::WorldRotate(const glm::vec3 vec)
{
}

void SceneObject::Scale(const glm::vec3& vec)
{
	this->scaleVector.x *= vec.x;
	this->scaleVector.y *= vec.y;
	this->scaleVector.z *= vec.z;
}