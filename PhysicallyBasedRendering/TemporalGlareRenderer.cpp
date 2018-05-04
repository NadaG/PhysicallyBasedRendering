#include "TemporalGlareRenderer.h"

#include <fstream>

#include <stdlib.h>

vector<vec3> TemporalGlareRenderer::LoadColorMatchingFunction()
{
	string line;
	ifstream cmf;
	cmf.open("FunctionTable/color_matching_function.txt");

	vector<vec3> cmfVector;

	if (cmf.is_open())
	{
		while (getline(cmf, line))
		{
			vec3 rgb;
			const int commaNum = 3;
			for (int i = 0; i < commaNum; i++)
			{
				int commaIdx = 0;
				while (line[commaIdx++] != ',');

				if (i == 1)
					rgb.r = stof(line.substr(0, commaIdx - 1));
				else if (i == 2)
					rgb.g = stof(line.substr(0, commaIdx - 1));

				line.erase(0, commaIdx);
			}
			rgb.b = stof(line);
			cmfVector.push_back(rgb);
		}
		cmf.close();
	}

	return cmfVector;
}

void TemporalGlareRenderer::ExportSpecturmPSF(vector<vec3> cmf, fftw_complex* f)
{
	SceneObject& quad = sceneManager->quadObj;
	for (int i = 0; i < n; i++)
	{
		
		string fileName = "/psf_afters/psf_after";
		fileName.append(std::to_string(i));
		fileName.append(".png");
		ftMultipliedTex = ft.ApertureFrourierTransform(f, 1024, 1024, lambda, d, cmf[i * 2]);
		pngExporter.WritePngFile(fileName, ftMultipliedTex);
		lambda += lambdaDelta;
		Sleep(3000);
		cout << i << "번째 이미지 그리는 중" << endl;
	}

	/*pngExporter.WritePngFile("psf_before.png", multipliedTex);
	pngExporter.WritePngFile("psf_after_inverse.png", iftMultipliedTex);
	pngExporter.WritePngFile("fresnel_term.png", fresnelDiffractionTex);

	writeFileNum++;*/
}

void TemporalGlareRenderer::ExportSumPSF()
{
	png_bytep* initialImage = pngExporter.ReadPngFile("/psf_afters/psf_after0.png");

	for (int i = 1; i < n; i++)
	{
		string fileName = "/psf_afters/psf_after";
		fileName.append(std::to_string(i));
		fileName.append(".png");

		initialImage = pngExporter.SumPng(initialImage, fileName);

		Sleep(3000);
		cout << i << "번째 이미지 합치는 중" << endl;
	}

	pngExporter.WritePngFile("/psf_afters/psf_sum.png", initialImage, 1024, 1024, 8, PNG_COLOR_TYPE_RGBA);
}

void TemporalGlareRenderer::ExportMiddlePSF()
{
	string fileName = "/psf_after.png";
	ftMultipliedTex = ft.PointSpreadFunction(multipliedTex, d, lambda, false, glm::vec3(1.0, 1.0, 1.0));
	pngExporter.WritePngFile(fileName, ftMultipliedTex);
}

void TemporalGlareRenderer::InitializeRender()
{
	vector<vec3> cmf = LoadColorMatchingFunction();

	d *= scale;
	lambda *= scale;
	lambdaDelta *= scale;

	cout << scale << endl;
	cout << d << endl;
	cout << lambda << endl;
	cout << lambdaDelta << endl;

	glareShader = new ShaderProgram("Quad.vs", "Pupil.fs");
	glareShader->Use();

	primitiveShader = new ShaderProgram("Primitive.vs", "Primitive.fs");
	primitiveShader->Use();

	fresnelDiffractionShader = new ShaderProgram("Quad.vs", "FresnelDiffraction.fs");
	fresnelDiffractionShader->Use();
	fresnelDiffractionShader->SetUniform1f("lambda", lambda);
	fresnelDiffractionShader->SetUniform1f("d", d);
	fresnelDiffractionShader->SetUniform1f("scalingFactor", scale);

	multiplyShader = new ShaderProgram("Quad.vs", "Multiply.fs");
	multiplyShader->Use();
	multiplyShader->BindTexture(&apertureTex, "apertureTex");
	multiplyShader->BindTexture(&fresnelDiffractionTex, "fresnelDiffractionTex");
	multiplyShader->SetUniform1f("lambda", lambda);
	multiplyShader->SetUniform1f("d", d);

	apertureFBO.GenFrameBufferObject();
	apertureFBO.BindDefaultDepthBuffer(WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);

	apertureTex.LoadTexture(
		GL_RGB16F,
		WindowManager::GetInstance()->width,
		WindowManager::GetInstance()->height,
		GL_RGB,
		GL_FLOAT);
	apertureTex.SetParameters(GL_LINEAR, GL_LINEAR, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);

	apertureFBO.BindTexture(GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, &apertureTex);
	apertureFBO.DrawBuffers();

	fresnelDiffractionFBO.GenFrameBufferObject();
	fresnelDiffractionFBO.BindDefaultDepthBuffer(WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);

	fresnelDiffractionTex.LoadTexture(
		GL_RGBA16F,
		WindowManager::GetInstance()->width,
		WindowManager::GetInstance()->height,
		GL_RGB,
		GL_FLOAT);
	fresnelDiffractionTex.SetParameters(GL_LINEAR, GL_LINEAR, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);

	fresnelDiffractionFBO.BindTexture(GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, &fresnelDiffractionTex);
	fresnelDiffractionFBO.DrawBuffers();

	multipliedFBO.GenFrameBufferObject();
	multipliedFBO.BindDefaultDepthBuffer(WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);

	multipliedTex.LoadTexture(
		GL_RGBA32F,
		WindowManager::GetInstance()->width,
		WindowManager::GetInstance()->height,
		GL_RGBA,
		GL_FLOAT);
	multipliedTex.SetParameters(GL_LINEAR, GL_LINEAR, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);

	multipliedFBO.BindTexture(GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, &multipliedTex);
	multipliedFBO.DrawBuffers();

	ftMultipliedTex.LoadTexture(
		GL_RGBA32F,
		WindowManager::GetInstance()->width,
		WindowManager::GetInstance()->height,
		GL_RGBA,
		GL_FLOAT
	);
	ftMultipliedTex.SetParameters(GL_LINEAR, GL_LINEAR, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);

	iftMultipliedTex.LoadTexture(
		GL_RGBA32F,
		WindowManager::GetInstance()->width,
		WindowManager::GetInstance()->height,
		GL_RGBA,
		GL_FLOAT
	);
	iftMultipliedTex.SetParameters(GL_LINEAR, GL_LINEAR, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);

	GenerateFibersVAO();
	GenerateParticlesVAO();
	GeneratePupilVAO();

	////////////////// debuging 용도임
	/*GenerateCosTex();
	cosFourierTex = ft.PointSpreadFunction(cosTex, 1.0f, 1.0f, false);

	pngExporter.WritePngFile("cos_before.png", cosTex);
	pngExporter.WritePngFile("cos_after.png", cosFourierTex);*/

	vector<SceneObject>& sceneObjs = sceneManager->sceneObjs;
	Object* camera = sceneManager->movingCamera;
	SceneObject& quad = sceneManager->quadObj;

	glViewport(0, 0, WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);
	apertureFBO.Use();
	apertureFBO.Clear(0.0f, 0.0f, 0.0f, 0.0f);

	primitiveShader->Use();

	glDisable(GL_DEPTH_TEST);
	glPointSize(3);
	DrawWithVAO(lensPupilVAO, lensPupilTrianglesNum * 3);
	DrawWithVAO(lensFibersVAO, lensFibersNum * 2);
	DrawWithVAO(lensParticlesVAO, lensParticlesNum);
	glEnable(GL_DEPTH_TEST);

	fresnelDiffractionFBO.Use();
	fresnelDiffractionFBO.Clear(0.0f, 0.0f, 0.0f, 0.0f);
	fresnelDiffractionShader->Use();
	quad.DrawModel();

	multipliedFBO.Use();
	multipliedFBO.Clear(0.0f, 0.0f, 0.0f, 0.0f);
	multiplyShader->Use();
	quad.DrawModel();

	/*ExportSpecturmPSF(cmf);
	SumPSF();*/
	//ExportMiddlePSF();

	fftw_complex* f = new fftw_complex[1024 * 1024];
	float* aperture = multipliedTex.GetTexImage();

	// i가 width, j가 height
	float center = 1024.0f / 2.0f;

	for (int i = 0; i < 1024; i++)
	{
		for (int j = 0; j < 1024; j++)
		{
			float x = (i - center) / 1024000.0f;
			float y = (j - center) / 1024000.0f;

			x *= scale;
			y *= scale;

			float ape = aperture[i * 1024 * 4 + j * 4 + 0];

			// real 
			f[i * 1024 + j][0] = cos(3.141592653 * (x*x + y*y) / (lambda * d)) * ape;
			// complex
			f[i * 1024 + j][1] = sin(3.141592653 * (x*x + y*y) / (lambda * d)) * ape;
		}
	}

	//ExportSpecturmPSF(cmf, f);
	//ExportSumPSF();

	ftMultipliedTex = ft.ApertureFrourierTransform(f, 1024, 1024, lambda, d, vec3(1.0, 1.0, 1.0));
	string fileName = "/psf_after.png";
	pngExporter.WritePngFile(fileName, ftMultipliedTex);
}

void TemporalGlareRenderer::Render()
{
	vector<SceneObject>& sceneObjs = sceneManager->sceneObjs;
	Object* camera = sceneManager->movingCamera;
	SceneObject& quad = sceneManager->quadObj;

	UseDefaultFBO();
	ClearDefaultFBO();
	multiplyShader->Use();
	quad.DrawModel();

	if (!writeFileNum)
	{
		
		/*for (int i = 0; i < n; i++)
		{
			string fileName = "/psf_afters/psf_after.png";
			ftMultipliedTex = ft.fourierTransform2D(multipliedTex, d, lambda, false);
			pngExporter.WritePngFile(fileName, ftMultipliedTex);
		}

		pngExporter.WritePngFile("psf_before.png", multipliedTex);
		pngExporter.WritePngFile("psf_after_inverse.png", iftMultipliedTex);
		pngExporter.WritePngFile("fresnel_term.png", fresnelDiffractionTex);
		*/
	}
}

void TemporalGlareRenderer::TerminateRender()
{
	glareShader->Delete();
	delete glareShader;

	primitiveShader->Delete();
	delete primitiveShader;

	fresnelDiffractionShader->Delete();
	delete fresnelDiffractionShader;
	
	multiplyShader->Delete();
	delete multiplyShader;

	sceneManager->TerminateObjects();
}

void TemporalGlareRenderer::GenerateFibersVAO()
{
	GLfloat* lensFibers = new GLfloat[lensFibersNum * 12];
	const float perTheta = 2 * 3.141592653 / lensFibersNum;
	float nowTheta = 0.0f;
	for (int i = 0; i < lensFibersNum; ++i)
	{
		lensFibers[i * 12 + 0] = lensFiberInRadius * glm::cos(nowTheta);
		lensFibers[i * 12 + 1] = lensFiberInRadius * glm::sin(nowTheta);
		lensFibers[i * 12 + 2] = 0.0f;
		lensFibers[i * 12 + 3] = 0.0f;
		lensFibers[i * 12 + 4] = 0.0f;
		lensFibers[i * 12 + 5] = 0.0f;

		lensFibers[i * 12 + 6] = lensFiberOutRadius * glm::cos(nowTheta);
		lensFibers[i * 12 + 7] = lensFiberOutRadius * glm::sin(nowTheta);
		lensFibers[i * 12 + 8] = 0.0f;
		lensFibers[i * 12 + 9] = 0.0f;
		lensFibers[i * 12 + 10] = 0.0f;
		lensFibers[i * 12 + 11] = 0.0f;
		nowTheta += perTheta;
	}

	lensFibersVAO.GenVAOVBOIBO();
	lensFibersVAO.SetDrawMode(GL_LINES);

	lensFibersVAO.VertexBufferData(lensFibersNum * sizeof(GLfloat) * 12, lensFibers);

	// position
	lensFibersVAO.VertexAttribPointer(3, 6);
	// color
	lensFibersVAO.VertexAttribPointer(3, 6);

	delete[] lensFibers;
}

// TODO pupil size가 luminance(조도)에 따라 달라지는 것 구현해야 함
void TemporalGlareRenderer::GeneratePupilVAO()
{
	GLfloat* lensPupilTriangles = new GLfloat[lensPupilTrianglesNum * 18];
	const float perTriangleTheta = 2 * 3.141592653 / (lensPupilTrianglesNum * 2 / 3);
	float nowTheta = 0.0f;
	for (int i = 0; i < lensPupilTrianglesNum; ++i)
	{
		lensPupilTriangles[i * 18 + 0] = 0.0f;
		lensPupilTriangles[i * 18 + 1] = 0.0f;
		lensPupilTriangles[i * 18 + 2] = 0.0f;
		lensPupilTriangles[i * 18 + 3] = 1.0f;
		lensPupilTriangles[i * 18 + 4] = 1.0f;
		lensPupilTriangles[i * 18 + 5] = 1.0f;

		lensPupilTriangles[i * 18 + 6] = pupilRadius * glm::cos(nowTheta);
		lensPupilTriangles[i * 18 + 7] = pupilRadius * glm::sin(nowTheta);
		lensPupilTriangles[i * 18 + 8] = 0.0f;
		lensPupilTriangles[i * 18 + 9] = 1.0f;
		lensPupilTriangles[i * 18 + 10] = 1.0f;
		lensPupilTriangles[i * 18 + 11] = 1.0f;

		lensPupilTriangles[i * 18 + 12] = pupilRadius * glm::cos(nowTheta + perTriangleTheta);
		lensPupilTriangles[i * 18 + 13] = pupilRadius * glm::sin(nowTheta + perTriangleTheta);
		lensPupilTriangles[i * 18 + 14] = 0.0f;
		lensPupilTriangles[i * 18 + 15] = 1.0f;
		lensPupilTriangles[i * 18 + 16] = 1.0f;
		lensPupilTriangles[i * 18 + 17] = 1.0f;
		nowTheta += perTriangleTheta;
	}

	lensPupilVAO.GenVAOVBOIBO();
	lensPupilVAO.SetDrawMode(GL_TRIANGLES);

	lensPupilVAO.VertexBufferData(lensPupilTrianglesNum * sizeof(GLfloat) * 18, lensPupilTriangles);

	// position
	lensPupilVAO.VertexAttribPointer(3, 6);
	// color
	lensPupilVAO.VertexAttribPointer(3, 6);

	delete[] lensPupilTriangles;
}

void TemporalGlareRenderer::GenerateParticlesVAO()
{
	srand(time(nullptr));

	const int lineWidth = 88;
	const float linePerWidth = 0.015f;
	const int lineDepths[] = { 
		1, 2, 3, 4, 5, 9, 12, 14, 15, 16, 16,			// 11개
		18, 20, 23, 24, 25, 29, 32, 34, 35, 36, 36,
		38, 40, 43, 44, 45, 49, 52, 54, 55, 56, 56,
		58, 60, 63, 64, 65, 69, 72, 74, 75, 76, 76,
		58, 60, 63, 64, 65, 69, 72, 74, 75, 76, 76,
		38, 40, 43, 44, 45, 49, 52, 54, 55, 56, 56,
		18, 20, 23, 24, 25, 29, 32, 34, 35, 36, 36,
		16, 16, 16, 15, 14, 12, 9, 5, 4, 3, 2, 1 
	};
	const float linePerDepth = 0.06f;

	for (int i = 0; i < lineWidth; ++i)
	{
		lensParticlesNum += lineDepths[i];
	}

	// TODO particles가 deformation하는 것 구현해야 함
	GLfloat* lensParticles = new GLfloat[lensParticlesNum * 6];

	int index = 0;
	for (int i = 0; i < lineWidth; ++i)
	{
		for (int j = 0; j < lineDepths[i]; ++j)
		{
			// 0 부터 180까지의 float
			float randomDegree = static_cast<float>(rand()) / static_cast<float>(RAND_MAX) * 180.0f;
			float randomRadians = glm::radians(randomDegree);

			lensParticles[index * 6 + 0] = (i - lineWidth / 2) * linePerWidth;
			lensParticles[index * 6 + 1] = glm::tan(randomRadians) * (lineDepths[i] - j) * linePerDepth;
			lensParticles[index * 6 + 2] = 0.0f;
			lensParticles[index * 6 + 3] = 0.0f;
			lensParticles[index * 6 + 4] = 0.0f;
			lensParticles[index * 6 + 5] = 0.0f;
			index++;
		}
	}

	lensParticlesVAO.GenVAOVBOIBO();
	lensParticlesVAO.SetDrawMode(GL_POINTS);

	lensParticlesVAO.VertexBufferData(lensParticlesNum * sizeof(GLfloat) * 6, lensParticles);

	// position
	lensParticlesVAO.VertexAttribPointer(3, 6);
	// color
	lensParticlesVAO.VertexAttribPointer(3, 6);
	
	delete[] lensParticles;
}

void TemporalGlareRenderer::GenerateCosTex()
{
	SceneObject& quad = sceneManager->quadObj;

	cosTex.LoadTexture(GL_RGBA32F, 1024, 1024, GL_RGBA, GL_FLOAT);

	FrameBufferObject cosFBO;
	cosFBO.GenFrameBufferObject();
	cosFBO.BindDefaultDepthBuffer(1024, 1024);
	cosFBO.BindTexture(GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, &cosTex);

	ShaderProgram* cosShader = new ShaderProgram("Quad.vs", "Cos.fs");
	cosShader->Use();
	quad.DrawModel();
}