#include "FourierTransform.h"
#include "Texture2D.h"

#include "Debug.h"

Texture2D FourierTransform::PointSpreadFunction(
	const Texture2D& inputTexture, 
	const float d, 
	const float lambda,
	const bool isInverse,
	const vec3 cmf)
{
	Texture2D outputTexture;

	const int width = inputTexture.GetWidth();
	const int height = inputTexture.GetHeight();

	float* inArray = inputTexture.GetTexImage();
	float* outArray = new float[width * height * 4];

	fftw_complex* f = new fftw_complex[width * height];
	fftw_complex* F = new fftw_complex[width * height];

	// 초기화
	for (int i = 0; i < width * height; ++i)
	{
		F[i][0] = 0.0f;
		F[i][1] = 0.0f;

		f[i][0] = inArray[i * 4];
		f[i][1] = 0.0f;
	}

	fftw_plan p = fftw_plan_dft_2d(width, height, f, F, isInverse ? FFTW_BACKWARD : FFTW_FORWARD, FFTW_ESTIMATE);
	fftw_execute(p);
	fftw_destroy_plan(p);
	fftw_cleanup();

	for (int i = 0; i < width * height; ++i)
	{
		int y = i / width;
		int x = i % width;

		x = (x + width / 2) % width;
		y = (y + height / 2) % height;

		int newi = y * width + x;

		float re = F[newi][0] * F[newi][0] / (d * lambda * d * lambda);

		if (isInverse)
			re /= width*height;

		float value = re;

		int index = i * 4;

		const float nm = 0.5f;

		outArray[index + 0] = value * cmf.r * nm;
		outArray[index + 1] = value * cmf.g * nm;
		outArray[index + 2] = value * cmf.b * nm;
		outArray[index + 3] = 1.0f;
	}
	////////////////////////////////////////////////////////////////////////////////

	outputTexture.LoadTexture(
		inputTexture.GetInternalFormat(),
		inputTexture.GetWidth(), 
		inputTexture.GetHeight(), 
		GL_RGBA, 
		GL_FLOAT);
	outputTexture.UpdateTexture(outArray, GL_RGBA, GL_FLOAT);

	delete[] f;
	delete[] F;

	delete[] inArray;
	delete[] outArray;

	return outputTexture;
}

Texture2D FourierTransform::ExcuteFourierTransform(const Texture2D& inputTexture)
{
	Texture2D outputTexture;

	const int width = inputTexture.GetWidth();
	const int height = inputTexture.GetHeight();

	float* inArray = inputTexture.GetTexImage();
	float* outArray = new float[width * height * 4];

	fftw_complex* f = new fftw_complex[width * height];
	fftw_complex* F = new fftw_complex[width * height];

	// 초기화
	for (int i = 0; i < width * height; ++i)
	{
		F[i][0] = 0.0f;
		F[i][1] = 0.0f;

		f[i][0] = inArray[i * 4];
		f[i][1] = 0.0f;
	}

	fftw_plan p = fftw_plan_dft_2d(width, height, f, F, FFTW_FORWARD, FFTW_ESTIMATE);
	fftw_execute(p);
	fftw_destroy_plan(p);
	fftw_cleanup();

	for (int i = 0; i < width * height; ++i)
	{
		int y = i / width;
		int x = i % width;

		x = (x + width / 2) % width;
		y = (y + height / 2) % height;

		int newi = y * width + x;

		float re = F[newi][0];
		float im = F[newi][1];

		/*if (isInverse)
			re /= width*height;*/

		float value = re;

		int index = i * 4;

		outArray[index + 0] = value;
		outArray[index + 1] = value;
		outArray[index + 2] = value;
		outArray[index + 3] = 1.0f;
	}
	////////////////////////////////////////////////////////////////////////////////

	outputTexture.LoadTexture(
		inputTexture.GetInternalFormat(),
		inputTexture.GetWidth(),
		inputTexture.GetHeight(),
		GL_RGBA,
		GL_FLOAT);
	outputTexture.UpdateTexture(outArray, GL_RGBA, GL_FLOAT);

	delete[] f;
	delete[] F;

	delete[] inArray;
	delete[] outArray;

	return outputTexture;
}

Texture2D FourierTransform::ApertureFrourierTransform(
	fftw_complex* f, 
	const int width, 
	const int height,
	const float lambda,
	const float d,
	const vec3 cmf
	)
{
	Texture2D outputTexture;
	float* outArray = new float[width * height * 4];

	fftw_complex* F = new fftw_complex[width * height];

	// 초기화
	for (int i = 0; i < width * height; ++i)
	{
		F[i][0] = 0.0f;
		F[i][1] = 0.0f;
	}

	fftw_plan p = fftw_plan_dft_2d(width, height, f, F, FFTW_FORWARD, FFTW_ESTIMATE);
	fftw_execute(p);
	fftw_destroy_plan(p);
	fftw_cleanup();

	for (int i = 0; i < width * height; ++i)
	{
		int y = i / width;
		int x = i % width;

		x = (x + width / 2) % width;
		y = (y + height / 2) % height;

		int newi = y * width + x;

		float re = F[newi][0];
		float im = F[newi][1];

		float value = re*re + im*im;

		value /= (lambda*lambda * d*d);

		int index = i * 4;

		outArray[index + 0] = value * cmf.r;
		outArray[index + 1] = value * cmf.g;
		outArray[index + 2] = value * cmf.b;
		outArray[index + 3] = 1.0f;
	}

	outputTexture.LoadTexture(
		GL_RGBA,
		width,
		height,
		GL_RGBA,
		GL_FLOAT);
	outputTexture.UpdateTexture(outArray, GL_RGBA, GL_FLOAT);

	delete[] F;
	delete[] outArray;
	return outputTexture;
}
