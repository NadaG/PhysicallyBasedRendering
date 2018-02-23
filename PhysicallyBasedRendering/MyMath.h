#pragma once
//
//#include <valarray>
//#include <complex>
//#include <iostream>
//#include <fftw3.h>
//
//using Complex = std::complex<double>;
//using ComplexArray = std::valarray<Complex>;
//using ComplexArray2D = std::valarray<std::valarray<Complex>>;
//
//void FastFourierTransform(ComplexArray& x);
//void FastFourierTransform(ComplexArray2D& x);
//
//void InverseFastFourierTransform(ComplexArray& x);
//void InverseFastFourierTransform(ComplexArray2D& x);

struct Matrix44
{
	float m[4][4];

	Matrix44()
	{
		m[0][0] = 1.0f; m[0][1] = 0.0f; m[0][2] = 0.0f; m[0][3] = 0.0f;
		m[1][0] = 0.0f; m[1][1] = 1.0f; m[1][2] = 0.0f; m[1][3] = 0.0f;
		m[2][0] = 0.0f; m[2][1] = 0.0f; m[2][2] = 1.0f; m[2][3] = 0.0f;
		m[3][0] = 0.0f; m[3][1] = 0.0f; m[3][2] = 0.0f; m[3][3] = 1.0f;
	}

	Matrix44(
		const float m00, const float m01, const float m02, const float m03,
		const float m10, const float m11, const float m12, const float m13,
		const float m20, const float m21, const float m22, const float m23,
		const float m30, const float m31, const float m32, const float m33)
	{}
};