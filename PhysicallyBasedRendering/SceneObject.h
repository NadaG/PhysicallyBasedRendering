#pragma once

#include "Model.h"
#include "Object.h"

class SceneObject : public Object
{
public:
	//SceneObject() : Object(new DefaultMovement()){}
	SceneObject(Movement* const movement = new DefaultMovement()) : Object(movement){}
	virtual ~SceneObject() {}

	void DrawModel();

	void LoadModel(const char* s);
	void LoadModel(const MeshType& meshType);

	// TO Refacto 이거는 바꿔야함
	void SetColor(const glm::vec3& color);
	const glm::vec3& GetColor() { return this->color; }

	// base의 delete함수를 부르는 것
	void Delete() override { Object::Delete(); model.Delete(); }
	// 딱히 Update를 override할 필요가 없었음

	std::vector<Triangle> GetTriangles() const;

private:

	// To Refacto 이거는 확실히 바꿔야 함
	glm::vec3 color;

	Model model;
};