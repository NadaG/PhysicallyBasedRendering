#pragma once

#include "Script.h"

class LightMovingScript : public Script
{
public:
	LightMovingScript(Object* object, Object* camera)
		:Script(object), camera(camera)
	{}

	void Update();
	void Delete() {}

	unsigned int selectedLightId;

private:

	const float moveSpeed = 0.2f;
	Object* camera;
};