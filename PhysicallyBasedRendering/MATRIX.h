#pragma once

#include "VECTOR.h"

#include <iostream>

class MATRIX
{
public:

	MATRIX()
	:ele{ 0 }{}

	MATRIX  Transpose();
	MATRIX  Inverse();
	float   Determinant();

	MATRIX operator+(MATRIX m);
	MATRIX operator-(MATRIX m);
	MATRIX operator*(MATRIX m);
	MATRIX operator*(float t);

	VECTOR2D operator*(VECTOR2D v);
	VECTOR3D operator*(VECTOR3D v);

	float       ele[3][3];
};



