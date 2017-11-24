#pragma once

#include "SmokeSimulationImporter.h"
#include "SceneManager.h"

class SmokeSceneManager : public SceneManager
{
public:
	SmokeSceneManager() {}
	virtual ~SmokeSceneManager() {}

	void InitializeObjects();
	void Update();

private:
};