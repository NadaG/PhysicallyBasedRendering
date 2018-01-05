#pragma once

#include "InputManager.h"

class Object;

class Movement
{
public:
	Movement(){}
	virtual ~Movement() {}

	virtual void Update() = 0;

	void BindObject(Object* const object) { this->object = object; }
	
	bool enabled = true;

protected:
	// 단순히 referencing하는 것이기 때문에 메모리 해제를 여기서 하지 않음
	Object* object;
};