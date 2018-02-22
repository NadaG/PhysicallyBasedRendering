#pragma once

#include "SceneManager.h"

class TemporalGlareSceneManager : public SceneManager
{
public:

	TemporalGlareSceneManager() {}
	virtual ~TemporalGlareSceneManager() {}

	void InitializeObjects();
	void Update();

private:

};