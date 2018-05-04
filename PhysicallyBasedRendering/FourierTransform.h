#pragma once

#include <fftw3.h>

#include <glm/glm.hpp>

using glm::vec3;

class Texture2D;

class FourierTransform
{
public:
	FourierTransform() {}
	virtual ~FourierTransform() {}

	Texture2D PointSpreadFunction(
		const Texture2D& inputTexture,
		const float d,
		const float lambda,
		const bool isInverse,
		const vec3 cmf);

	Texture2D ExcuteFourierTransform(const Texture2D& inputTexture);

	Texture2D ApertureFrourierTransform(
		fftw_complex* f, const int width, const int height, const float lambda, const float d, const vec3 cmf);

private:

	fftw_complex* f;
	fftw_complex* F;

	fftw_plan p;
};