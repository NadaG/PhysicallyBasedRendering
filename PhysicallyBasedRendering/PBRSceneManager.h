#pragma once

#include "SceneManager.h"

class PBRSceneManager : public SceneManager
{
public:

	PBRSceneManager() {}
	virtual ~PBRSceneManager() {}

	void InitializeObjects();
	void Update();

	const int& GetSelectedLightId() { return selectedLightId; }

private:
	int selectedLightId;

	const float cameraMoveSpeed = 0.2f;
	const float lightMoveSpeed = 0.1f;
};