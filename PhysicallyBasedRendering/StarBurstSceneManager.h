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

	int selectedLightId;

	const float cameraMoveSpeed = 0.2f;
	const float lightMoveSpeed = 0.1f;
};