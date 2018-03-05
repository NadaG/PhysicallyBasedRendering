#pragma once

#include <cmath>

class VECTOR3D
{
public:

	VECTOR3D()
		:x(0.0f), y(0.0f), z(0.0f) {}

	VECTOR3D(float x, float y, float z)
		:x(x), y(y), z(z) {}

	float Magnitude();
	float InnerProduct(VECTOR3D v);
	VECTOR3D CrossProduct(VECTOR3D v);
	void Normalize();

	VECTOR3D operator+(VECTOR3D v);
	VECTOR3D operator*(float val);

	float x;
	float y;
	float z;
};

VECTOR3D operator*(float val, VECTOR3D v);

class VECTOR2D
{
public:
	VECTOR2D()
		:x(0.0f), y(0.0f) {}

	VECTOR2D(float x, float y)
		:x(x), y(y) {}

	float x;
	float y;
};

template<typename T>
class TVECTOR
{
public:
	TVECTOR<T>()
	{
	}

	TVECTOR<T>(float a, float b, float c)
	{
		x = a;
		y = b;
		z = c;
	}

	~TVECTOR<T>()
	{
	}

	T TVECTOR<T>::Magnitude()
	{
		return sqrt(x*x + y*y + z*z);
	}

	T TVECTOR<T>::InnerProduct(TVECTOR<T> v)
	{
		return (x*v.x + y*v.y + z*v.z);
	}

	TVECTOR<T> TVECTOR<T>::CrossProduct(TVECTOR<T> v)
	{
		TVECTOR<T> result;
		result.x = y * v.z - z * v.y;
		result.y = z * v.x - x * v.z;
		result.z = x * v.y - y * v.x;

		return result;
	}

	T x;
	T y;
	T z;
};