#pragma once

#include "SceneManager.h"

class PBRSceneManager : public SceneManager
{
public:

	PBRSceneManager() {}
	virtual ~PBRSceneManager() {}

	void InitializeObjects();
	void Update();

private:
};