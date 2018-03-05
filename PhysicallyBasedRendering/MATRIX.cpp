#include "MATRIX.h"

MATRIX MATRIX::Add(MATRIX m)
{
	MATRIX result;
	for (int i = 0; i < 3; i++)
		for (int j = 0; j < 3; j++)
			result.ele[i][j] = ele[i][j] + m.ele[i][j];

	return result;
}

MATRIX MATRIX::Subtract(MATRIX m)
{
	MATRIX result;
	for (int i = 0; i < 3; i++)
		for (int j = 0; j < 3; j++)
			result.ele[i][j] = ele[i][j] - m.ele[i][j];

	return result;
}

MATRIX MATRIX::Multiply(MATRIX m)
{
	MATRIX result;
	for (int i = 0; i < 3; i++)
		for (int j = 0; j < 3; j++)
			result.ele[i][j] = 0.0;

	for (int i = 0; i < 3; i++)
		for (int j = 0; j < 3; j++)
			for (int k = 0; k < 3; k++)
				result.ele[i][j] += ele[i][k] * m.ele[k][j];

	return result;
}

MATRIX MATRIX::Multiply(float t)
{
	MATRIX result;
	for (int i = 0; i < 3; i++)
		for (int j = 0; j < 3; j++)
			result.ele[i][j] = t * ele[i][j];

	return result;
}

MATRIX MATRIX::Transpose()
{
	MATRIX result;
	for (int i = 0; i < 3; i++)
		for (int j = 0; j < 3; j++)
			result.ele[i][j] = ele[j][i];

	return result;
}

float MATRIX::Determinant()
{
	float result = 0.0f;

	result = ele[0][0] * (ele[1][1] * ele[2][2] - ele[1][2] * ele[2][1])
		   - ele[0][1] * (ele[1][0] * ele[2][2] - ele[1][2] * ele[2][0])
		   + ele[0][2] * (ele[1][0] * ele[2][1] - ele[1][1] * ele[2][0]);

	return result;
}

MATRIX MATRIX::Inverse()
{
	MATRIX result;
	float determinant = Determinant();

	result.ele[0][0] = ele[1][1] * ele[2][2] - ele[1][2] * ele[2][1];
	result.ele[0][1] = ele[0][2] * ele[2][1] - ele[0][1] * ele[2][2];
	result.ele[0][2] = ele[0][1] * ele[1][2] - ele[0][2] * ele[1][1];

	result.ele[1][0] = ele[1][2] * ele[2][0] - ele[1][0] * ele[2][2];
	result.ele[1][1] = ele[0][0] * ele[2][2] - ele[0][2] * ele[2][1];
	result.ele[1][2] = ele[0][2] * ele[1][0] - ele[0][0] * ele[1][2];

	result.ele[2][0] = ele[1][0] * ele[2][1] - ele[1][1] * ele[2][0];
	result.ele[2][1] = ele[0][1] * ele[2][0] - ele[0][0] * ele[2][1];
	result.ele[2][2] = ele[0][0] * ele[1][1] - ele[0][1] * ele[1][0];

	for (int i = 0; i < 3; i++)
		for (int j = 0; j < 3; j++)
			result.ele[i][j] /= determinant;

	return result;
}

VECTOR2D MATRIX::operator*(VECTOR2D v)
{
	VECTOR2D result;

	result.x = ele[0][0] * v.x + ele[0][1] * v.y;
	result.y = ele[1][0] * v.x + ele[1][1] * v.y;

	return result;
}

VECTOR3D MATRIX::operator*(VECTOR3D v)
{
	VECTOR3D result;

	result.x = ele[0][0] * v.x + ele[0][1] * v.y + ele[0][2] * v.z;
	result.y = ele[1][0] * v.x + ele[1][1] * v.y + ele[1][2] * v.z;
	result.z = ele[2][0] * v.x + ele[2][1] * v.y + ele[2][2] * v.z;

	return result;
}
