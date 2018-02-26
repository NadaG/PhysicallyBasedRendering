#include "TemporalGlareRenderer.h"

void TemporalGlareRenderer::InitializeRender()
{
	glareShader = new ShaderProgram("Quad.vs", "Pupil.fs");
	glareShader->Use();

	primitiveShader = new ShaderProgram("Primitive.vs", "Primitive.fs");
	primitiveShader->Use();

	fresnelDiffractionShader = new ShaderProgram("Quad.vs", "FresnelDiffraction.fs");
	fresnelDiffractionShader->Use();

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

	GenerateFibersVAO();
	GenerateParticlesVAO();
	GeneratePupilVAO();

	//
	GenerateCosTex();
	cosFourierTex = ft.fourierTransform2D(cosTex);

	pngExporter.WritePngFile("cos_before.png", cosTex);
	pngExporter.WritePngFile("cos_after.png", cosFourierTex);
}

void TemporalGlareRenderer::Render()
{
	vector<SceneObject>& sceneObjs = sceneManager->sceneObjs;
	Object* camera = sceneManager->movingCamera;
	SceneObject& quad = sceneManager->quadObj;

	glViewport(0, 0, WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);
	apertureFBO.Use();
	apertureFBO.Clear(0.0f, 0.0f, 0.0f, 0.0f);

	primitiveShader->Use();

	glDisable(GL_DEPTH_TEST);
	glPointSize(5);
	DrawWithVAO(lensPupilVAO, lensPupilTrianglesNum * 3);
	DrawWithVAO(lensFibersVAO, lensFibersNum * 2);
	DrawWithVAO(lensParticlesVAO, lensParticlesNum);
	glEnable(GL_DEPTH_TEST);

	multipliedFBO.Use();
	multipliedFBO.Clear(0.0f, 0.0f, 0.0f, 0.0f);
	multiplyShader->Use();
	quad.DrawModel();

	UseDefaultFBO();
	ClearDefaultFBO();
	multiplyShader->Use();
	quad.DrawModel();

	if (!writeFileNum)
	{
		ftMultipliedTex = ft.fourierTransform2D(multipliedTex);

		pngExporter.WritePngFile("psf_before.png", multipliedTex);
		pngExporter.WritePngFile("psf_after.png", ftMultipliedTex);
		
		writeFileNum++;
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

	const int lineWidth = 23;
	const float linePerWidth = 0.06f;
	const int lineDepths[] = { 1, 2, 3, 4, 5, 9, 12, 14, 15, 16, 16, 16, 16, 16, 15, 14, 12, 9, 5, 4, 3, 2, 1 };
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