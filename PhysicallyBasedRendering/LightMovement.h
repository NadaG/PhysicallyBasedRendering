#pragma once

#include "Movement.h"

class LightMovement : public Movement
{
public:
	LightMovement(Object* const camera) :camera(camera) {}
	virtual ~LightMovement(){}

	void Update();
	
private:

	const float moveSpeed = 0.2f;
	Object* camera;
};