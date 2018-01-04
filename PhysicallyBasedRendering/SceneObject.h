#pragma once

#include "Model.h"
#include "Object.h"

class SceneObject : public Object
{
public:
	SceneObject();
	virtual ~SceneObject() {}

	void DrawModel();

	void LoadModel(const char* s);
	void LoadModel(const MeshType& meshType);

	// TO Refacto �̰Ŵ� �ٲ����
	void SetColor(const glm::vec3& color);
	const glm::vec3& GetColor() { return this->color; }

	// override
	void Update(){}
	void Delete() { model.Delete(); }

private:

	// To Refacto �̰Ŵ� Ȯ���� �ٲ�� ��
	glm::vec3 color;

	Model model;
};