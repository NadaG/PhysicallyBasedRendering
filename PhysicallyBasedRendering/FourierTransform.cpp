#include "FourierTransform.h"
#include "Texture2D.h"

#include "Debug.h"


float* FourierTransform::PointSpreadFunction(const int width, const int height, float* f, const bool isInverse)
{
	return nullptr;
}

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

	float* inArray = inputTexture.TexImage();
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

		// temporal glare에 한정된 코드
		float re = F[newi][0] * F[newi][0] / (d * lambda * d * lambda);

		if (isInverse)
			re /= width*height;

		float value = re;

		int index = i * 4;

		cout << cmf.r << endl;

		outArray[index + 0] = glm::clamp(value, 0.0f, 1.0f) * cmf.r;
		outArray[index + 1] = glm::clamp(value, 0.0f, 1.0f) * cmf.g;
		outArray[index + 2] = glm::clamp(value, 0.0f, 1.0f) * cmf.b;
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