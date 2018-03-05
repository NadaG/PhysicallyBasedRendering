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

	// TO Refacto �̰Ŵ� �ٲ����
	void SetColor(const glm::vec3& color);
	const glm::vec3& GetColor() { return this->color; }

	// base�� delete�Լ��� �θ��� ��
	void Delete() override { Object::Delete(); model.Delete(); }
	// ���� Update�� override�� �ʿ䰡 ������

	std::vector<Triangle> GetTriangles() const;

private:

	// To Refacto �̰Ŵ� Ȯ���� �ٲ�� ��
	glm::vec3 color;

	Model model;
};