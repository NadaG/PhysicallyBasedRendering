#pragma once
#include<glm/glm.hpp>
#include<glm/gtx/transform.hpp>
#include "Model.h"

class SceneObject
{
public:
	SceneObject();
	virtual ~SceneObject() {}

	void Translate(const glm::vec3& vec);
	void WorldTranslate(const glm::vec3 vec);

	void Rotate(const glm::vec3& vec, float angle);
	void WorldRotate(const glm::vec3 vec);

	void Scale(const glm::vec3& vec);

	void SetPosition(const glm::vec3 position) { positionVector = position; }
	void SetRotate(const glm::mat4 mat) { rotationMatrix = mat; }
	void SetScale(const glm::vec3 scale) { scaleVector = scale; }

	glm::vec3 GetPosition() { return positionVector; }
	glm::vec3 GetScale() { return scaleVector; }
	glm::mat4 GetRotate() { return rotationMatrix; }

	glm::vec3 GetWorldPosition();

	const glm::mat4 GetModelMatrix();
	void Draw();

	void LoadMesh(const char* s);
	void LoadMesh(const MeshType& meshType);

	void LoadModel(const char* s);

	// TO Refacto 이거는 바꿔야함
	void SetColor(const glm::vec3& color);
	const glm::vec3& GetColor() { return this->color; }

	void TerminateMesh();
private:

	// To Refacto 이거는 확실히 바꿔야 함
	glm::vec3 color;
	
	glm::vec3 scaleVector;
	glm::mat4 rotationMatrix;
	glm::vec3 positionVector;

	Mesh mesh;
	Model model;
};