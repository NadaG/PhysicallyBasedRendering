#pragma once

#include "SceneManager.h"

class StarBurstSceneManager : public SceneManager
{
public:

	StarBurstSceneManager() {}
	virtual ~StarBurstSceneManager() {}

	void InitializeObjects();
	void Update();

private:

	SceneObject streetLight;
	const float cameraMoveSpeed = 0.2f;

	SceneObject streetLightModel;
};