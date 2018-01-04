#pragma once

#include "Script.h"

class CameraMovingScript : public Script
{
public:
	CameraMovingScript(Object* object)
		:Script(object)
	{}

	void Update();
	void Delete(){}

private:

	const float moveSpeed = 0.2f;
};