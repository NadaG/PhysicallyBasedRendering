#pragma once

#include "SceneManager.h"

class FluidSceneManager : public SceneManager
{
public:

	FluidSceneManager() :moveSpeed(0.5f) {}
	virtual ~FluidSceneManager() {}

	void InitializeObjects();
	void Update();

private:

	const float moveSpeed;
};