#pragma once

#include <fftw3.h>

class Texture2D;

class FourierTransform
{
public:
	FourierTransform() {}
	virtual ~FourierTransform() {}

	float* fourierTransform2D(const int width, const int height, float* f, const bool isInverse);
	Texture2D fourierTransform2D(const Texture2D& inputTexture, const float scalingFactor, const bool isInverse);

private:

	fftw_complex* f;
	fftw_complex* F;

	fftw_plan p;
};