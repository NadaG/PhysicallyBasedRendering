#pragma once

#include "Object.h"
#include "InputManager.h"

class Script : public Object
{
public:
	virtual void Update() = 0;

	Script(Object* const object) { this->object = object; }
	virtual ~Script() {}

protected:
	Object* object;
};