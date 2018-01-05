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
	// �ܼ��� referencing�ϴ� ���̱� ������ �޸� ������ ���⼭ ���� ����
	Object* object;
};