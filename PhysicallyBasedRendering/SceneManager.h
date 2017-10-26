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
	static SceneManager* GetInstance();

	void InitializeObjects();
	void InitializeObjectsFluid();

	void Update();
	void TerminateObjects();

	vector<SceneObject> sceneObjs;
	SceneObject cameraObj;
	SceneObject quadObj;

private:
	SceneManager() {};
	~SceneManager() {};

	static SceneManager* instance;
	GLFWwindow* window;
};