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
	// ���⼭ delete�� �ϴ°� �´��� ���ʿ��� ���ִ°� �´��� �� �𸣰���
	virtual void Delete() { delete movement; }

	void WorldTranslate(const glm::vec3& vec);
	// world ��ǥ�迡���� ��ġ�� translate
	void ModelTranslate(const glm::vec3& vec);

	void SetPosition(const glm::vec3& vec) { this->positionVector = vec; }

	void ModelRotate(const glm::vec3& vec, float angle);
	// world ��ǥ�迡�� ���ǵ� axis�� ���� rotate
	void WorldRotate(const glm::vec3& vec, float angle);

	void RotateX(const float angle);
	void RotateY(const float angle);
	void RotateZ(const float angle);

	// model scaling �ۿ� ����
	void Scale(const glm::vec3& vec);

	void SetRotation(const glm::mat4& rotMat) { rotationMatrix = rotMat; }

	glm::vec3 GetPosition() const { return positionVector; }
	glm::vec3 GetScale() const { return scaleVector; }
	glm::mat4 GetRotate() const { return rotationMatrix; }

	glm::vec3 GetWorldPosition() const;

	const glm::mat4 GetModelMatrix() const;
	
private:

	// �����ϸ� vector�� �ٲ� ��
	Movement* movement;

	glm::vec3 scaleVector;
	glm::mat4 rotationMatrix;

	float rotateX;
	float rotateY;
	float rotateZ;

	glm::vec3 positionVector;
};