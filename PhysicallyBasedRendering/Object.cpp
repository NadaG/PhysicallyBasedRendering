#include "Object.h"

Object::Object(Movement* const movement)
{
	this->positionVector = glm::vec3(0, 0, 0);
	this->scaleVector = glm::vec3(1, 1, 1);
	this->rotationMatrix = glm::mat4(1.0);

	this->movement = movement;
}

glm::vec3 Object::GetWorldPosition() const
{
	glm::vec3 rotatedPosition = rotationMatrix * glm::vec4(positionVector, 1.0f);

	glm::vec3 worldPosition = glm::vec3(
		scaleVector.x * rotatedPosition.x,
		scaleVector.y * rotatedPosition.y,
		scaleVector.z * rotatedPosition.z);
	return worldPosition;
}

const glm::mat4 Object::GetModelMatrix() const
{
	return glm::translate(positionVector) * rotationMatrix * glm::scale(scaleVector);
}

void Object::Translate(const glm::vec3& vec)
{
	this->positionVector += glm::fmat3(rotationMatrix) * vec;
}

// radians
// z y x
void Object::Rotate(const glm::vec3& vec, float angle)
{
	glm::vec3 v = glm::inverse(glm::fmat3(rotationMatrix)) * vec;
	this->rotationMatrix = glm::rotate(rotationMatrix, angle, v);
}

void Object::RotateX(const float angle)
{
	this->rotateX += angle;
}

void Object::RotateY(const float angle)
{
	this->rotateY += angle;
}

void Object::RotateZ(const float angle)
{
	this->rotateZ += angle;
}

void Object::Scale(const glm::vec3& vec)
{
	this->scaleVector.x *= vec.x;
	this->scaleVector.y *= vec.y;
	this->scaleVector.z *= vec.z;
}