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

	SceneManager();
	~SceneManager() {};

	virtual void InitializeObjects() = 0;

	virtual void Update() = 0;
	void TerminateObjects();

	void GenerateLight(glm::vec3 color, glm::vec3 size);

	// TODO Observer pattern을 이용해서 이 매니저를 참조하고 있는 객체들을 업데이트하기??
	// TODO 일단 decorator 패턴을 이용해서 cameraObj, 이런거 다 지우고 Obj로 통일할 거임
	vector<SceneObject> sceneObjs;
	// sceneobject는 render가 필요한 object
	vector<SceneObject*> lightObjs;

	// render가 안되는 object
	Object* movingCamera;
	Movement* cameraMovement;

	SceneObject quadObj;
	SceneObject skyboxObj;
	SceneObject cubeObj;

private:

};