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

	void WorldTranslate(const glm::vec3& vec);
	// world 좌표계에서의 위치가 translate
	void ModelTranslate(const glm::vec3& vec);

	void SetPosition(const glm::vec3& vec) { this->positionVector = vec; }

	void ModelRotate(const glm::vec3& vec, float angle);
	// world 좌표계에서 정의된 axis를 따라서 rotate
	void WorldRotate(const glm::vec3& vec, float angle);

	void RotateX(const float angle);
	void RotateY(const float angle);
	void RotateZ(const float angle);

	// model scaling 밖에 없음
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

	float rotateX;
	float rotateY;
	float rotateZ;

	glm::vec3 positionVector;
};