#pragma once

#include "SceneManager.h"

#include "MATRIX.h"

class LectureSceneManager : public SceneManager
{
public:

	LectureSceneManager() {}
	virtual ~LectureSceneManager() {}

	void InitializeObjects();
	void Update();

private:
};