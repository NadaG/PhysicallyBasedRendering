#pragma once

#include<glm/glm.hpp>
#include<glm/gtx/transform.hpp>

#include "CameraMovement.h"
#include "LightMovement.h"
#include "DefaultMovement.h"

class Object
{
public:
	Object(Movement* const movement);
	virtual ~Object() {}

	virtual void Update() { movement->Update(); }
	// 여기서 delete를 하는게 맞는지 저쪽에서 해주는게 맞는지 잘 모르겠음
	virtual void Delete() { delete movement; }

	void Translate(const glm::vec3& vec);
	void Rotate(const glm::vec3& vec, float angle);
	void Scale(const glm::vec3& vec);

	void SetRotation(const glm::mat4& rotMat) { rotationMatrix = rotMat; }

	glm::vec3 GetPosition() const { return positionVector; }
	glm::vec3 GetScale() const { return scaleVector; }
	glm::mat4 GetRotate() const { return rotationMatrix; }

	glm::vec3 GetWorldPosition() const;

	const glm::mat4 GetModelMatrix() const;
	
private:

	// 여차하면 vector로 바꿀 것
	Movement* movement;

	glm::vec3 scaleVector;
	glm::mat4 rotationMatrix;
	glm::vec3 positionVector;
};