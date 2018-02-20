#pragma once

#include <fftw3.h>

class Texture2D;

class FourierTransform
{
public:
	FourierTransform() {}
	virtual ~FourierTransform() {}

	float* fourierTransform2D(const int width, const int height, float* f);
	Texture2D fourierTransform2D(const Texture2D& inputTexture);

	float* InverseFourierTransform2D(const int width, const int height, float* F);
	Texture2D InverseFourierTransform2D(const Texture2D& inputTexture);

private:

	fftw_complex* f;
	fftw_complex* F;

	fftw_plan p;
};