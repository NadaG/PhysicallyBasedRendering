#pragma once

#include "SceneManager.h"

class FluidSceneManager : public SceneManager
{
public:

	FluidSceneManager() :moveSpeed(0.5f), rotateSpeed(0.01f), currentFrame(0), isDynamicScene(false) {}
	virtual ~FluidSceneManager() {}

	void InitializeObjects();
	void Update();

	const bool isDynamicScene;

private:


	int currentFrame;

	const float moveSpeed;
	float rotateSpeed;
};