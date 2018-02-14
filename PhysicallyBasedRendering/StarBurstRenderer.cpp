#include "StarBurstRenderer.h"

void StarBurstRenderer::InitializeRender()
{
	debugQuadShader->Use();
	debugQuadShader->SetUniform1i("map", 0);

	lightShader = new ShaderProgram("light.vs", "light.fs");
	lightShader->Use();

	pbrShader = new ShaderProgram("PBR.vs", "PBRBrightness.fs");
	pbrShader->Use();
	// bind의 순서와 shader 내에서의 sampler2D 정의 순서는 연관되어 있다.
	pbrShader->BindTexture(&aoTex, "aoMap");
	pbrShader->BindTexture(&albedoTex, "albedoMap");
	pbrShader->BindTexture(&emissionTex, "emissionMap");
	pbrShader->BindTexture(&metallicTex, "metallicMap");
	pbrShader->BindTexture(&normalTex, "normalMap");
	pbrShader->BindTexture(&roughnessTex, "roughnessMap");

	brightShader = new ShaderProgram("Quad.vs", "Brightness.fs");
	brightShader->Use();
	brightShader->BindTexture(&worldMap, "map");

	blurShader = new ShaderProgram("Quad.vs", "GaussianBlur.fs");
	blurShader->Use();
	blurShader->SetUniform1i("map", 0);

	bloomShader = new ShaderProgram("Quad.vs", "BloomBlend.fs");
	bloomShader->Use();
	bloomShader->BindTexture(&worldMap, "worldMap");
	bloomShader->BindTexture(&pingpongBlurMap[1], "blurredBrightMap");
	bloomShader->BindTexture(&fresnelDiffractionTex, "debugMap");
	bloomShader->SetUniform1f("exposure", 1.0);

	glareShader = new ShaderProgram("Quad.vs", "Pupil.fs");
	glareShader->Use();

	// smart pointer 한 번 사용해봄
	skyboxShader = make_shared<ShaderProgram>("SkyBox.vs", "SkyBox.fs");
	skyboxShader->Use();
	skyboxShader->SetUniform1i("skybox", 0);

	primitiveShader = new ShaderProgram("Primitive.vs", "Primitive.fs");
	primitiveShader->Use();

	fresnelDiffractionShader = new ShaderProgram("Quad.vs", "FresnelDiffraction.fs");
	fresnelDiffractionShader->Use();

	multiplyShader = new ShaderProgram("Quad.vs", "Multiply.fs");
	multiplyShader->Use();
	multiplyShader->BindTexture(&apertureTex, "apertureTex");
	multiplyShader->BindTexture(&fresnelDiffractionTex, "fresnelDiffractionTex");

	// TODO 지금은 texture를 불러오는 과정을 각 랜더러에서 하고 있지만 나중에는 VertexShader등의 class에서 해주어야한다.
	/*string folder = "StreetLight";
	aoTex.LoadTexture("Texture/" + folder + "/ao.png");
	aoTex.SetParameters(GL_LINEAR_MIPMAP_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT);

	albedoTex.LoadTexture("Texture/" + folder + "/albedo.png");
	albedoTex.SetParameters(GL_LINEAR_MIPMAP_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT);

	emissionTex.LoadTexture("Texture/" + folder + "/emission.jpg");
	emissionTex.SetParameters(GL_LINEAR_MIPMAP_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT);

	metallicTex.LoadTexture("Texture/" + folder + "/metallic.png");
	metallicTex.SetParameters(GL_LINEAR_MIPMAP_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT);

	normalTex.LoadTexture("Texture/" + folder + "/normal.png");
	normalTex.SetParameters(GL_LINEAR_MIPMAP_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT);

	roughnessTex.LoadTexture("Texture/" + folder + "/roughness.png");
	roughnessTex.SetParameters(GL_LINEAR_MIPMAP_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT);*/

	brightFBO.GenFrameBufferObject();
	brightFBO.BindDefaultDepthBuffer(WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);

	worldFBO.GenFrameBufferObject();
	worldFBO.BindDefaultDepthBuffer(WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);

	worldMap.LoadTexture(
		GL_RGB16F,
		WindowManager::GetInstance()->width,
		WindowManager::GetInstance()->height,
		GL_RGB,
		GL_FLOAT);
	worldMap.SetParameters(GL_LINEAR, GL_LINEAR, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);

	brightMap.LoadTexture(
		GL_RGB16F,
		WindowManager::GetInstance()->width,
		WindowManager::GetInstance()->height,
		GL_RGB,
		GL_FLOAT);
	brightMap.SetParameters(GL_LINEAR, GL_LINEAR, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);

	worldFBO.BindTexture(GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, &worldMap);
	brightFBO.BindTexture(GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, &brightMap);

	// fbo를 bind하고 clear(gl_color_buffer_bit)를 하면
	// glDrawBuffers로 셋팅된 모든 buffer가 clear 된다.
	// glDrawBuffers를 이용해 잠깐 바꿈으로써 특정한 buffer만 clear할 수 있다.
	worldFBO.DrawBuffers();
	brightFBO.DrawBuffers();

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
		GL_RGBA16F,
		WindowManager::GetInstance()->width,
		WindowManager::GetInstance()->height,
		GL_RGB,
		GL_FLOAT);
	multipliedTex.SetParameters(GL_LINEAR, GL_LINEAR, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);

	multipliedFBO.BindTexture(GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, &multipliedTex);
	multipliedFBO.DrawBuffers();

	hdrTex.LoadTexture("Texture/Factory/BG.jpg");
	hdrTex.SetParameters(GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE, GL_LINEAR, GL_LINEAR);

	hdrSkyBoxTex = new TextureCube();
	hdrSkyBoxTex->LoadTextureCubeMap(GL_RGB16F, 2048, 2048, GL_RGB, GL_FLOAT);
	hdrSkyBoxTex->SetParameters(GL_LINEAR, GL_LINEAR, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);

	GenCubemapFromEquirectangular(hdrSkyBoxTex, hdrTex);

	for (int i = 0; i < 2; i++)
	{
		pingpongBlurFBO[i].GenFrameBufferObject();
		pingpongBlurFBO[i].BindDefaultDepthBuffer(WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);
		pingpongBlurMap[i].LoadTexture(
			GL_RGB16F,
			WindowManager::GetInstance()->width,
			WindowManager::GetInstance()->height,
			GL_RGB,
			GL_FLOAT);
		pingpongBlurMap[i].SetParameters(GL_LINEAR, GL_LINEAR, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);
		pingpongBlurFBO[i].BindTexture(GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, &pingpongBlurMap[i]);
		pingpongBlurFBO[i].DrawBuffers();
	}

	backgroundColor = glm::vec4(0.2f, 0.2f, 0.2f, 0.0f);

	////////////////////////////////////////////////////////////////////////
	// lens fiber
	////////////////////////////////////////////////////////////////////////
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

	////////////////////////////////////////////////////////////////////////
	// lens pupil
	////////////////////////////////////////////////////////////////////////

	// TODO pupil size가 luminance(조도)에 따라 달라지는 것 구현해야 함
	GLfloat* lensPupilTriangles = new GLfloat[lensPupilTrianglesNum * 18];
	const float perTriangleTheta = 2 * 3.141592653 / (lensPupilTrianglesNum * 2 / 3);
	nowTheta = 0.0f;
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

	////////////////////////////////////////////////////////////////////////
	// lens particles
	////////////////////////////////////////////////////////////////////////

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

	delete[] lensFibers;
	delete[] lensPupilTriangles;
	delete[] lensParticles;

	// DEBUG fourier transform test
	// real part는 array대로이고 imginary part는 전부 0임!
	int dxNum = 128;
	
}

void StarBurstRenderer::Render()
{
	vector<SceneObject>& sceneObjs = sceneManager->sceneObjs;
	Object* camera = sceneManager->movingCamera;
	vector<SceneObject*>& lights = sceneManager->lightObjs;
	SceneObject* billboard = sceneManager->billboard;
	SceneObject& quad = sceneManager->quadObj;
	SceneObject& skyboxObj = sceneManager->skyboxObj;

	glViewport(0, 0, WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);
	worldFBO.Use();
	glEnable(GL_DEPTH_TEST);
	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	glm::mat4 projection = glm::perspective(
		glm::radians(45.0f),
		WindowManager::GetInstance()->width / WindowManager::GetInstance()->height,
		zNear,
		zFar);

	// TODO 마우스 오른쪽 버튼을 누른 채로 카메라 회전을 조절하고 키보드로 움직이게 하자
	glm::mat4 view = glm::lookAt(
		camera->GetWorldPosition(),
		glm::vec3(0.0f, camera->GetPosition().y, 0.0f),
		glm::vec3(0.0f, 1.0f, 0.0f)
	);

	pbrShader->Use();

	pbrShader->SetUniformMatrix4f("view", view);
	pbrShader->SetUniformMatrix4f("projection", projection);
	pbrShader->SetUniformVector3f("eyePos", camera->GetWorldPosition());

	for (int i = 0; i < lights.size(); i++)
	{
		pbrShader->SetUniformVector3f("lightPositions[" + std::to_string(i) + "]", lights[i]->GetPosition());
		pbrShader->SetUniformVector3f("lightColors[" + std::to_string(i) + "]", lights[i]->GetColor());
	}

	RenderObjects(pbrShader, sceneObjs);

	glareShader->Use();

	glareShader->SetUniformMatrix4f("view", view);
	glareShader->SetUniformMatrix4f("projection", projection);

	RenderObject(glareShader, billboard);

	// light는 어차피 bright 하므로...
	lightShader->Use();
	lightShader->SetUniformMatrix4f("view", view);
	lightShader->SetUniformMatrix4f("projection", projection);
	RenderObjects(lightShader, lights);
	
	// skybox 그리는 부분
	/*glDepthFunc(GL_LEQUAL);
	skyboxShader->Use();
	skyboxShader->SetUniformMatrix4f("view", view);
	skyboxShader->SetUniformMatrix4f("projection", projection);
	skyboxShader->SetUniformBool("isHDR", false);
	hdrSkyBoxTex->Bind(GL_TEXTURE0);
	skyboxObj.Draw();
	glDepthFunc(GL_LESS);*/

	glViewport(0, 0, WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);
	brightFBO.Use();
	glEnable(GL_DEPTH_TEST);
	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	brightShader->Use();
	quad.DrawModel();

	for (int i = 0; i < blurStep * 2; ++i)
	{
		pingpongBlurFBO[i % 2].Use();
		glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

		blurShader->Use();
		blurShader->SetUniformBool("horizontal", i % 2);
		if (i == 0)
		{
			// 아.. 셰이더에 붙은 texture를 바꿀 때도 있구나..
			brightMap.Bind(GL_TEXTURE0);
		}
		else
		{
			pingpongBlurMap[(i - 1) % 2].Bind(GL_TEXTURE0);
		}

		quad.DrawModel();
	}

	glViewport(0, 0, WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);
	apertureFBO.Use();
	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	primitiveShader->Use();
	
	glDisable(GL_DEPTH_TEST);
	glPointSize(5);
	DrawWithVAO(lensPupilVAO, lensPupilTrianglesNum * 3);
	DrawWithVAO(lensFibersVAO, lensFibersNum * 2);
	DrawWithVAO(lensParticlesVAO, lensParticlesNum);
	// TODO point size를 z값에 따라 다르게 그리는 것 해야함
	glEnable(GL_DEPTH_TEST);

	fresnelDiffractionFBO.Use();
	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	fresnelDiffractionShader->Use();
	quad.DrawModel();

	multipliedFBO.Use();
	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	multiplyShader->Use();
	quad.DrawModel();

	UseDefaultFrameBufferObject();
	multiplyShader->Use();
	quad.DrawModel();

	float* multipliedTexArray = multipliedTex.TexImage();
	fftw_complex* f = new fftw_complex[multipliedTex.GetWidth() * multipliedTex.GetHeight()];
	fftw_complex* F = new fftw_complex[multipliedTex.GetWidth() * multipliedTex.GetHeight()];

	for (int i = 0; i < multipliedTex.GetWidth() * multipliedTex.GetHeight(); i++)
	{
		f[i][0] = multipliedTexArray[i];
	}

	fftw_plan p = fftw_plan_dft_2d(multipliedTex.GetWidth(), multipliedTex.GetHeight(), f, F, FFTW_FORWARD, FFTW_ESTIMATE);
	fftw_execute(p);
	fftw_destroy_plan(p);

	/*for (int i = 0; i < apertureTex.GetWidth()*apertureTex.GetHeight(); i++)
	{
		if (F[i][0] > 10)
			cout << F[i][0] << endl;
	}*/
}

void StarBurstRenderer::TerminateRender()
{
	pbrShader->Delete();
	delete pbrShader;

	lightShader->Delete();
	delete lightShader;

	blurShader->Delete();
	delete blurShader;

	skyboxShader->Delete();

	sceneManager->TerminateObjects();
}