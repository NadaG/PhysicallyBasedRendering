#pragma once
#include<glm/glm.hpp>
#include<glm/gtx/transform.hpp>
#include "Mesh.h"

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
	void Draw() { mesh.Draw(); }

	void LoadMesh(const char* s);
	void LoadMesh(const MeshType& meshType);

	void TerminateMesh();
private:
	
	glm::vec3 scaleVector;
	glm::mat4 rotationMatrix;
	glm::vec3 positionVector;

	Mesh mesh;
};