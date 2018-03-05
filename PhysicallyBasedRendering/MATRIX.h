#pragma once

#include "VECTOR.h"

#include <iostream>

class MATRIX
{
public:

	MATRIX()
	:ele{ 0 }{}

	MATRIX  Add(MATRIX m);
	MATRIX  Subtract(MATRIX m);
	MATRIX  Multiply(MATRIX m);
	MATRIX  Multiply(float t);
	MATRIX  Transpose();

	MATRIX  Inverse();
	float   Determinant();

	VECTOR2D operator*(VECTOR2D v);
	VECTOR3D operator*(VECTOR3D v);

	float       ele[3][3];
};



