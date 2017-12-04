#include "PBRRenderer.h"

void PBRRenderer::InitializeRender()
{
	pbrShader = new ShaderProgram("PBR.vs", "PBR.fs");
	pbrShader->Use();
	pbrShader->SetUniform1i("aoMap", 0);
	pbrShader->SetUniform1i("albedoMap", 1);
	pbrShader->SetUniform1i("metallicMap", 3);
	pbrShader->SetUniform1i("normalMap", 4);
	pbrShader->SetUniform1i("roughnessMap", 5);
	pbrShader->SetUniform1i("irradianceMap", 6);
	pbrShader->SetUniform1i("prefilterMap", 7);
	pbrShader->SetUniform1i("brdfLUT", 8);

	lightShader = new ShaderProgram("light.vs", "light.fs");
	lightShader->Use();

	equirectangularToCubemapShader = new ShaderProgram("Cubemap.vs", "equirectangularToCubemap.fs");
	equirectangularToCubemapShader->Use();

	irradianceShader = new ShaderProgram("Cubemap.vs", "irradianceConvolution.fs");
	irradianceShader->Use();
	irradianceShader->SetUniform1i("skybox", 0);

	skyboxShader = new ShaderProgram("SkyBox.vs", "SkyBox.fs");
	skyboxShader->Use();
	skyboxShader->SetUniform1i("skybox", 0);

	prefilterShader = new ShaderProgram("Cubemap.vs", "Prefilter.fs");
	prefilterShader->Use();

	//cubeReflectShader = new ShaderProgram("Reflect.vs", "Reflect.fs");
	//cubeReflectShader->Use();
	//cubeReflectShader->SetUniform1i("skybox", 0);

	brdfShader = new ShaderProgram("Brdf.vs", "Brdf.fs");
	brdfShader->Use();

	aoTex.LoadTexture("Texture/Rock/ao.png");
	aoTex.SetParameters(GL_LINEAR_MIPMAP_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT);

	albedoTex.LoadTexture("Texture/Gold/albedo.png");
	albedoTex.SetParameters(GL_LINEAR_MIPMAP_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT);

	metallicTex.LoadTexture("Texture/Gold/metallic.png");
	metallicTex.SetParameters(GL_LINEAR_MIPMAP_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT);

	normalTex.LoadTexture("Texture/Gold/normal.png");
	normalTex.SetParameters(GL_LINEAR_MIPMAP_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT);

	roughnessTex.LoadTexture("Texture/Gold/roughness.png");
	roughnessTex.SetParameters(GL_LINEAR_MIPMAP_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT);

	captureFBO.GenFrameBufferObject();
	captureRBO.GenRenderBufferObject();
	captureRBO.RenderBufferStorage(GL_DEPTH_COMPONENT24, skyboxResolution, skyboxResolution);
	captureFBO.BindRenderBuffer(GL_DEPTH_ATTACHMENT, captureRBO);

	hdrTex.LoadTexture("Texture/Factory/Factory_Catwalk_Bg.jpg");
	hdrTex.SetParameters(GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE, GL_LINEAR, GL_LINEAR);

	hdrSkyboxTex.LoadTextureCubeMap(GL_RGB16F, skyboxResolution, skyboxResolution, GL_RGB, GL_FLOAT);
	hdrSkyboxTex.SetParameters(GL_LINEAR, GL_LINEAR, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);

	// 큐브의 한 면을 바라 볼 수 있도록 perpective matrix setting
	captureProjection = glm::perspective(glm::radians(90.0f), 1.0f, 0.1f, 10.0f);
	// 상하좌우앞뒤
	captureViews[0] = glm::lookAt(glm::vec3(0.0f), glm::vec3(1.0f, 0.0f, 0.0f),  glm::vec3(0.0f, -1.0f, 0.0f));
	captureViews[1] = glm::lookAt(glm::vec3(0.0f), glm::vec3(-1.0f, 0.0f, 0.0f), glm::vec3(0.0f, -1.0f, 0.0f));
	captureViews[2] = glm::lookAt(glm::vec3(0.0f), glm::vec3(0.0f, 1.0f, 0.0f),  glm::vec3(0.0f, 0.0f, 1.0f));
	captureViews[3] = glm::lookAt(glm::vec3(0.0f), glm::vec3(0.0f, -1.0f, 0.0f), glm::vec3(0.0f, 0.0f, -1.0f));
	captureViews[4] = glm::lookAt(glm::vec3(0.0f), glm::vec3(0.0f, 0.0f, 1.0f),  glm::vec3(0.0f, -1.0f, 0.0f));
	captureViews[5] = glm::lookAt(glm::vec3(0.0f), glm::vec3(0.0f, 0.0f, -1.0f), glm::vec3(0.0f, -1.0f, 0.0f));

	////////////////////////////////////////////////////
	equirectangularToCubemapShader->Use();
	equirectangularToCubemapShader->SetUniform1i("equirectangularMap", 0);
	equirectangularToCubemapShader->SetUniformMatrix4f("projection", captureProjection);

	glViewport(0, 0, skyboxResolution, skyboxResolution);
	captureFBO.Use();
	for (int i = 0; i < 6; i++)
	{
		equirectangularToCubemapShader->SetUniformMatrix4f("view", captureViews[i]);
		hdrSkyboxTex.Bind(GL_TEXTURE0);
		captureFBO.BindTexture(GL_COLOR_ATTACHMENT0, GL_TEXTURE_CUBE_MAP_POSITIVE_X + i, &hdrSkyboxTex);
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

		sceneManager->skyboxObj.Draw();
	}

	UseDefaultFrameBufferObject();
	////////////////////////////////////////////////////
	irradianceSkyboxTex.LoadTextureCubeMap(GL_RGB16F, 32, 32, GL_RGB, GL_FLOAT);
	irradianceSkyboxTex.SetParameters(GL_LINEAR, GL_LINEAR, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);
	
	captureFBO.Use();
	captureRBO.RenderBufferStorage(GL_DEPTH_COMPONENT24, 32, 32);

	irradianceShader->Use();
	irradianceShader->SetUniform1i("skybox", 0);
	irradianceShader->SetUniformMatrix4f("projection", captureProjection);
	hdrSkyboxTex.Bind(GL_TEXTURE0);

	glViewport(0, 0, 32, 32);
	captureFBO.Use();
	for (int i = 0; i < 6; i++)
	{
		irradianceShader->SetUniformMatrix4f("view", captureViews[i]);
		captureFBO.BindTexture(GL_COLOR_ATTACHMENT0, GL_TEXTURE_CUBE_MAP_POSITIVE_X + i, &irradianceSkyboxTex);
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

		sceneManager->skyboxObj.Draw();
	}
	UseDefaultFrameBufferObject();
	////////////////////////////////////////////////////
	prefilterSkyboxTex.LoadTextureCubeMap(GL_RGB16F, 128, 128, GL_RGB, GL_FLOAT);
	prefilterSkyboxTex.SetParameters(GL_LINEAR_MIPMAP_LINEAR, GL_LINEAR, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);
	prefilterSkyboxTex.GenerateMipmap();

	////////////////////////////////////////////////////
	prefilterShader->Use();
	prefilterShader->SetUniform1i("environmentMap", 0);
	prefilterShader->SetUniformMatrix4f("projection", captureProjection);
	
	hdrSkyboxTex.Bind(GL_TEXTURE0);

	captureFBO.Use();
	const int maxMipLevels = 5;
	for (int mip = 0; mip < maxMipLevels; ++mip)
	{
		// 1 -> 1/2 -> 1/4 -> 1/8
		// 128 -> 64 -> 32 -> 16
		int mipWidth = 128 * pow(0.5, mip);
		int mipHeight = 128 * pow(0.5, mip);

		captureRBO.Bind();
		captureRBO.RenderBufferStorage(GL_DEPTH_COMPONENT24, mipWidth, mipHeight);
		glViewport(0, 0, mipWidth, mipHeight);

		float roughness = (float)mip / (float)(maxMipLevels - 1);
		prefilterShader->SetUniform1f("roughness", roughness);

		for (int i = 0; i < 6; ++i)
		{
			prefilterShader->SetUniformMatrix4f("view", captureViews[i]);
			captureFBO.BindTexture(GL_COLOR_ATTACHMENT0, GL_TEXTURE_CUBE_MAP_POSITIVE_X + i, &hdrSkyboxTex);

			glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
			sceneManager->skyboxObj.Draw();
		}
	}
	UseDefaultFrameBufferObject();

	////////////////////////////////////////////////////
	brdfTex.LoadTexture(GL_RG16F, 512, 512, GL_RG, GL_FLOAT);
	brdfTex.SetParameters(GL_LINEAR, GL_LINEAR, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);
	captureFBO.Use();
	captureRBO.Bind();
	captureRBO.RenderBufferStorage(GL_DEPTH_COMPONENT24, 512, 512);
	captureFBO.BindTexture(GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, &brdfTex);

	glViewport(0, 0, 512, 512);
	brdfShader->Use();
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	sceneManager->quadObj.Draw();

	UseDefaultFrameBufferObject();
	////////////////////////////////////////////////////
}

void PBRRenderer::Render()
{
	glEnable(GL_DEPTH_TEST);
	glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	vector<SceneObject>& objs = sceneManager->sceneObjs;
	SceneObject& camera = sceneManager->cameraObj;
	vector<SceneObject>& lights = sceneManager->lightObjs;
	SceneObject& cube = sceneManager->cubeObj;
	SceneObject& skybox = sceneManager->skyboxObj;

	// glfwGetFramebufferSize로 받아오는 방식이 더 좋을 거 같음
	glViewport(0, 0, WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);
	UseDefaultFrameBufferObject();
	
	pbrShader->Use();

	glm::mat4 projection = glm::perspective(
		glm::radians(45.0f),
		WindowManager::GetInstance()->width / WindowManager::GetInstance()->height,
		0.1f,
		30.0f);

	// TODO 마우스 오른쪽 버튼을 누른 채로 카메라 회전을 조절하고 키보드로 움직이게 하자
	glm::mat4 view = glm::lookAt(
		camera.GetWorldPosition(),
		glm::vec3(0.0f, camera.GetPosition().y, 0.0f),
		glm::vec3(0.0f, 1.0f, 0.0f)
	);

	pbrShader->Use();
	pbrShader->SetUniformMatrix4f("view", view);
	pbrShader->SetUniformMatrix4f("projection", projection);
	for (int i = 0; i < lights.size(); i++)
	{
		pbrShader->SetUniformVector3f("lightPositions[" + std::to_string(i) + "]", lights[i].GetPosition());
		pbrShader->SetUniformVector3f("lightColors[" + std::to_string(i) + "]", lights[i].GetColor());
	}

	pbrShader->SetUniformVector3f("eyePos", camera.GetWorldPosition());

	aoTex.Bind(GL_TEXTURE0);
	albedoTex.Bind(GL_TEXTURE1);
	metallicTex.Bind(GL_TEXTURE3);
	normalTex.Bind(GL_TEXTURE4);
	roughnessTex.Bind(GL_TEXTURE5);
	irradianceSkyboxTex.Bind(GL_TEXTURE6);
	prefilterSkyboxTex.Bind(GL_TEXTURE7);
	brdfTex.Bind(GL_TEXTURE8);

	RenderObjects(pbrShader, objs);

	lightShader->Use();
	lightShader->SetUniformMatrix4f("view", view);
	lightShader->SetUniformMatrix4f("projection", projection);
	RenderObjects(lightShader, lights);

	/*cubeReflectShader->Use();
	cubeReflectShader->SetUniformVector3f("eyePos", camera.GetWorldPosition());
	cubeReflectShader->SetUniformMatrix4f("view", view);
	cubeReflectShader->SetUniformMatrix4f("projection", projection);
	hdrSkyboxTex.BindCubemap(GL_TEXTURE0);
	RenderObject(cubeReflectShader, cube);*/

	// 들어오는 픽셀이 작거나 같으면 통과
	glDepthFunc(GL_LEQUAL);
	skyboxShader->Use();
	skyboxShader->SetUniformMatrix4f("view", glm::mat4(glm::mat3(view)));
	skyboxShader->SetUniformMatrix4f("projection", projection);
	skyboxShader->SetUniformBool("isHDR", false);
	hdrSkyboxTex.Bind(GL_TEXTURE0);
	RenderObject(skyboxShader, skybox);
	// 들어오는 픽셀이 작으면 통과(디폴트)
	glDepthFunc(GL_LESS);
}

void PBRRenderer::TerminateRender()
{
	pbrShader->Delete();
	delete pbrShader;

	lightShader->Delete();
	delete lightShader;

	skyboxShader->Delete();
	delete skyboxShader;

	sceneManager->TerminateObjects();
}
