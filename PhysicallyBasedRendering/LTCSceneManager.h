#pragma once

#include "SceneManager.h"

class LTCSceneManager : public SceneManager
{
public:

	LTCSceneManager() {}
	virtual ~LTCSceneManager() {}

	void InitializeObjects();
	void Update();

private:
};