#pragma once

#include "SceneManager.h"

class RayTracingSceneManager : public SceneManager
{
public:

	RayTracingSceneManager() {}
	virtual ~RayTracingSceneManager() {}

	void InitializeObjects();
	void Update();

private:
};