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
	float* outArray = new float[width * height * 4];

	fftw_complex* f = new fftw_complex[width * height];
	fftw_complex* F = new fftw_complex[width * height];

	for (int i = 0; i < width * height; ++i)
	{
		f[i][0] = inArray[i * 4];
	}

	fftw_plan p = fftw_plan_dft_2d(width, height, f, F, FFTW_FORWARD, FFTW_ESTIMATE);
	fftw_execute(p);
	fftw_destroy_plan(p);

	/*F[i][0] = F[i][0] * F[i][0];
	F[i][0] /= (lambda * lambda * d * d);*/

	for (int i = 0; i < width * height; ++i)
	{
		float value = F[i][0] * F[i][0] / ((0.01f*0.1f)*(0.01f*0.1f));
		outArray[i * 4 + 0] = value;
		outArray[i * 4 + 1] = value;
		outArray[i * 4 + 2] = value;
		outArray[i * 4 + 3] = 1.0f;
	}

	outputTexture.LoadTexture(
		inputTexture.GetInternalFormat(),
		inputTexture.GetWidth(), 
		inputTexture.GetHeight(), 
		GL_RGBA, 
		GL_FLOAT);
	outputTexture.UpdateTexture(outArray, GL_RGBA, GL_FLOAT);

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