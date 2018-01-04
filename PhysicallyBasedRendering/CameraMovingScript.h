#pragma once

#include "Script.h"

class CameraMovingScript : public Script
{
public:
	CameraMovingScript(Object* object)
		:Script(object)
	{}

	void Update();
private:

	const float moveSpeed = 0.2f;
	const float lightMoveSpeed = 0.1f;
};