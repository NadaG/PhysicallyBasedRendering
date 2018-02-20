#include "FourierTransform.h"
#include "Texture2D.h"

float * FourierTransform::fourierTransform2D(const int width, const int height, float * f)
{
	return nullptr;
}

Texture2D FourierTransform::fourierTransform2D(const Texture2D& inputTexture)
{
	Texture2D outputTexture;

	const int width = inputTexture.GetWidth();
	const int height = inputTexture.GetHeight();

	float* inArray = inputTexture.TexImage();
	float* outArray = new float[width * height * inputTexture.GetPerPixelFloatNum()];

	fftw_complex* f = new fftw_complex[width * height];
	fftw_complex* F = new fftw_complex[width * height];

	for (int i = 0; i < width * height; ++i)
	{
		f[i][0] = inArray[i * 3 + 0];
	}

	fftw_plan p = fftw_plan_dft_2d(width, height, f, F, FFTW_FORWARD, FFTW_ESTIMATE);
	fftw_execute(p);
	fftw_destroy_plan(p);

	for (int i = 0; i < width * height; ++i)
	{
		outArray[i * 3 + 0] = F[i][0];
		outArray[i * 3 + 1] = F[i][0];
		outArray[i * 3 + 2] = F[i][0];
	}

	outputTexture.LoadTexture(
		inputTexture.GetInternalFormat(),
		inputTexture.GetWidth(), 
		inputTexture.GetHeight(), 
		inputTexture.GetFormat(), 
		inputTexture.GetType());
	outputTexture.UpdateTexture(outArray);

	return outputTexture;
}

float * FourierTransform::InverseFourierTransform2D(const int width, const int height, float * F)
{
	return nullptr;
}

Texture2D FourierTransform::InverseFourierTransform2D(const Texture2D& inputTexture)
{
	Texture2D outputTexture;

	return outputTexture;
}