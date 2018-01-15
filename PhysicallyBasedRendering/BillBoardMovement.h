#pragma once

#include "Movement.h"

class Object;

class BillBoardMovement : public Movement
{
public:
	BillBoardMovement(Object* const camera) :camera(camera) {}
	virtual ~BillBoardMovement(){}

	void Update();

private:
	Object* camera;
};