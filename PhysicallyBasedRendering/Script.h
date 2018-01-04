#pragma once

#include "Object.h"

class Script : public Object
{
public:
	void Update();

	Script(Object* const object) { this->object = object; }
	virtual ~Script() {}

private:
	Object* object;
};