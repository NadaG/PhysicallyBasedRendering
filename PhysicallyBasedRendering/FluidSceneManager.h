#pragma once

#include "SceneManager.h"

class FluidSceneManager : public SceneManager
{
public:

	FluidSceneManager(){}
	virtual ~FluidSceneManager(){}

	void InitializeObjects();
	void Update();

	SceneObject fluidObj;

private:
};