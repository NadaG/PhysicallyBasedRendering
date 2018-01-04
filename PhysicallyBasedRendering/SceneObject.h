#pragma once
#include<glm/glm.hpp>
#include<glm/gtx/transform.hpp>
#include "Model.h"
#include "Material.h"
#include "Object.h"

class SceneObject : public Object
{
public:
	SceneObject();
	virtual ~SceneObject() {}

	void Translate(const glm::vec3& vec);
	void Rotate(const glm::vec3& vec, float angle);
	void Scale(const glm::vec3& vec);

	glm::vec3 GetPosition() const { return positionVector; }
	glm::vec3 GetScale() const { return scaleVector; }
	glm::mat4 GetRotate() const { return rotationMatrix; }

	glm::vec3 GetWorldPosition() const;

	const glm::mat4 GetModelMatrix() const;


	void DrawModel();

	void LoadModel(const char* s);
	void LoadModel(const MeshType& meshType);

	// TO Refacto 이거는 바꿔야함
	void SetColor(const glm::vec3& color);
	const glm::vec3& GetColor() { return this->color; }

	void TerminateModel();

	// override
	void Update(){}

private:

	// To Refacto 이거는 확실히 바꿔야 함
	glm::vec3 color;
	
	glm::vec3 scaleVector;
	glm::mat4 rotationMatrix;
	glm::vec3 positionVector;

	Model model;
};