#include "VECTOR.h"

float VECTOR3D::Magnitude()
{
	return sqrt(x * x + y * y + z * z);
}

float VECTOR3D::InnerProduct(VECTOR3D v)
{
	return (x * v.x + y * v.y + z * v.z);
}

VECTOR3D VECTOR3D::CrossProduct(VECTOR3D v)
{
	VECTOR3D result;
	result.x = y * v.z - z * v.y;
	result.y = z * v.x - x * v.z;
	result.z = x * v.y - y * v.x;

	return result;
}

void VECTOR3D::Normalize()
{
	float w = Magnitude();
	if (w < 0.00001) return;
	x /= w;
	y /= w;
	z /= w;
}

VECTOR3D VECTOR3D::operator+(VECTOR3D v)
{
	VECTOR3D result = (*this);
	result.x += v.x;
	result.y += v.y;
	result.z += v.z;

	return result;
}

VECTOR3D VECTOR3D::operator*(float val)
{
	VECTOR3D result = (*this);
	result.x *= val;
	result.y *= val;
	result.z *= val;

	return result;
}

VECTOR3D operator*(float val, VECTOR3D v)
{
	return v*val;
}