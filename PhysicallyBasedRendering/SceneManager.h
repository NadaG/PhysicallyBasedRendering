#pragma once

#include<GL\glew.h>
#include<GL\glfw3.h>
#include<cstdio>
#include<glm/glm.hpp>
#include<vector>

#include "InputManager.h"
#include "SceneObject.h"

using std::vector;

class SceneManager
{
public:

	SceneManager() {};
	~SceneManager() {};

	virtual void InitializeObjects() = 0;

	virtual void Update() = 0;
	void TerminateObjects();

	// TODO Observer pattern�� �̿��ؼ� �� �Ŵ����� �����ϰ� �ִ� ��ü���� ������Ʈ�ϱ�??
	vector<SceneObject> sceneObjs;
	vector<SceneObject> lightObjs;
	SceneObject cameraObj;
	SceneObject quadObj;
	SceneObject skyboxObj;
	SceneObject cubeObj;

private:

};