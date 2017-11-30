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

	// TODO Observer pattern을 이용해서 이 매니저를 참조하고 있는 객체들을 업데이트하기??
	vector<SceneObject> sceneObjs;
	vector<SceneObject> lightObjs;
	SceneObject cameraObj;
	SceneObject quadObj;
	SceneObject skyboxObj;
	SceneObject cubeObj;

private:

};