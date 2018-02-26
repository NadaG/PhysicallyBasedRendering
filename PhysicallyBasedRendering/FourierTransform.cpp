#include "FourierTransform.h"
#include "Texture2D.h"

#include "Debug.h"

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
		F[i][0] = 0.0f;
		F[i][1] = 0.0f;

		f[i][0] = inArray[i * 4];
		f[i][1] = 0.0f;
	}

	fftw_plan p = fftw_plan_dft_2d(width, height, f, F, FFTW_FORWARD, FFTW_ESTIMATE);
	fftw_execute(p);
	fftw_destroy_plan(p);

	////////////////////////////////////////////////////////////////////////////////
	//for (int i = 0; i < width * height; ++i)
	//{
	//	F[i][0] = F[i][0] / (float)(width*height);
	//}

	//for (int i = 0; i < width*height; ++i)
	//{
	//	float re = F[i][0];
	//	float mag = sqrt(re*re);
	//	float value = mag;

	//	//const int index = (i * 4 + (width*height) / 2) % (width*height);
	//	const int index = i * 4;

	//	outArray[index + 0] = value;
	//	outArray[index + 1] = value;
	//	outArray[index + 2] = value;
	//	outArray[index + 3] = 1.0f;

	//	/*if (value > 0.01f)
	//		Debug::GetInstance()->Log(i);*/
	//}
	////////////////////////////////////////////////////////////////////////////////

	////////////////////////////////////////////////////////////////////////////////
	for (int i = 0; i < width*height; ++i)
	{
		float re = F[i][0] * F[i][0] / (0.1f*0.1f*0.1f*0.1f);
		float value = re;

		int index = i * 4;

		// 위쪽이라면
		if (index > width*height * 2)
		{
			index = (index + width * height * 2) % (width*height * 4);
		}
		else
		{
			index = (index + width * height * 2);
		}

		if (index % (width * 4) > width * 2)
		{
			index = (index + width * 4) % (width * 2);
		}
		else
		{
			//value = 0.0f;
		}

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

	/*fftw_free(f);
	fftw_free(F);*/

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