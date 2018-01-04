#pragma once

#include<glm/glm.hpp>
#include<glm/gtx/transform.hpp>

class Object
{
public:
	Object();
	virtual ~Object() {}

	virtual void Update() = 0;
	virtual void Delete() = 0;

	void Translate(const glm::vec3& vec);
	void Rotate(const glm::vec3& vec, float angle);
	void Scale(const glm::vec3& vec);

	glm::vec3 GetPosition() const { return positionVector; }
	glm::vec3 GetScale() const { return scaleVector; }
	glm::mat4 GetRotate() const { return rotationMatrix; }

	glm::vec3 GetWorldPosition() const;

	const glm::mat4 GetModelMatrix() const;
	
private:

	glm::vec3 scaleVector;
	glm::mat4 rotationMatrix;
	glm::vec3 positionVector;
};