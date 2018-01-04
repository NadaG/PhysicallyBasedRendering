#pragma once

#include "Object.h"
#include "InputManager.h"

class Script : public Object
{
public:
	virtual void Update() = 0;
	virtual void Delete() = 0;

	Script(Object* const object) { this->object = object; }
	virtual ~Script() {}

	bool enabled = true;

protected:
	Object* object;
};