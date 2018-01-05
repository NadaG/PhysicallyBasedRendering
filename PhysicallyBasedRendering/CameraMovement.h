#pragma once

#include "Movement.h"

class CameraMovement : public Movement
{
public:
	CameraMovement(){}
	virtual ~CameraMovement(){}

	void Update();
	
private:

	const float moveSpeed = 0.2f;
};