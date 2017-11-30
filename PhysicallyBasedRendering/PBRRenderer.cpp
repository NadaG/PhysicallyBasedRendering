#include "PBRRenderer.h"

void PBRRenderer::InitializeRender()
{
	pbrShader = new ShaderProgram("PBR.vs", "PBR.fs");
	pbrShader->Use();
	pbrShader->SetUniform1i("aoMap", 0);
	pbrShader->SetUniform1i("albedoMap", 1);
	pbrShader->SetUniform1i("heightMap", 2);
	pbrShader->SetUniform1i("metallicMap", 3);
	pbrShader->SetUniform1i("normalMap", 4);
	pbrShader->SetUniform1i("roughnessMap", 5);
	pbrShader->SetUniform1i("irradianceMap", 6);

	lightShader = new ShaderProgram("light.vs", "light.fs");
	lightShader->Use();

	equirectangularToCubemapShader = new ShaderProgram("Cubemap.vs", "equirectangularToCubemap.fs");
	equirectangularToCubemapShader->Use();

	irradianceShader = new ShaderProgram("cubemap.vs", "irradianceConvolution.fs");
	irradianceShader->Use();
	irradianceShader->SetUniform1i("skybox", 0);

	skyboxShader = new ShaderProgram("SkyBox.vs", "SkyBox.fs");
	skyboxShader->Use();
	skyboxShader->SetUniform1i("skybox", 0);

	cubeReflectShader = new ShaderProgram("Reflect.vs", "Reflect.fs");
	cubeReflectShader->Use();
	cubeReflectShader->SetUniform1i("skybox", 0);

	aoTex.LoadTexture("Texture/Rock/ao.png");
	aoTex.SetParameters(GL_LINEAR_MIPMAP_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT);

	albedoTex.LoadTexture("Texture/Rock/albedo.png");
	albedoTex.SetParameters(GL_LINEAR_MIPMAP_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT);

	heightTex.LoadTexture("Texture/Rock/height.jpg");
	heightTex.SetParameters(GL_LINEAR_MIPMAP_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT);

	metallicTex.LoadTexture("Texture/Rock/metallic.png");
	metallicTex.SetParameters(GL_LINEAR_MIPMAP_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT);

	normalTex.LoadTexture("Texture/Rock/normal.png");
	normalTex.SetParameters(GL_LINEAR_MIPMAP_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT);

	roughnessTex.LoadTexture("Texture/Rock/roughness.png");
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
		captureFBO.BindTexture(GL_COLOR_ATTACHMENT0, GL_TEXTURE_CUBE_MAP_POSITIVE_X + i, hdrSkyboxTex);
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
	hdrSkyboxTex.BindCubemap(GL_TEXTURE0);

	glViewport(0, 0, 32, 32);
	captureFBO.Use();
	for (int i = 0; i < 6; i++)
	{
		irradianceShader->SetUniformMatrix4f("view", captureViews[i]);
		captureFBO.BindTexture(GL_COLOR_ATTACHMENT0, GL_TEXTURE_CUBE_MAP_POSITIVE_X + i, irradianceSkyboxTex);
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

		sceneManager->skyboxObj.Draw();
	}
	UseDefaultFrameBufferObject();
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
	heightTex.Bind(GL_TEXTURE2);
	metallicTex.Bind(GL_TEXTURE3);
	normalTex.Bind(GL_TEXTURE4);
	roughnessTex.Bind(GL_TEXTURE5);
	irradianceSkyboxTex.BindCubemap(GL_TEXTURE6);

	RenderObjects(pbrShader, objs);

	lightShader->Use();
	lightShader->SetUniformMatrix4f("view", view);
	lightShader->SetUniformMatrix4f("projection", projection);
	RenderObjects(lightShader, lights);

	cubeReflectShader->Use();
	cubeReflectShader->SetUniformVector3f("eyePos", camera.GetWorldPosition());
	cubeReflectShader->SetUniformMatrix4f("view", view);
	cubeReflectShader->SetUniformMatrix4f("projection", projection);
	hdrSkyboxTex.BindCubemap(GL_TEXTURE0);
	RenderObject(cubeReflectShader, cube);

	// 들어오는 픽셀이 작거나 같으면 통과
	glDepthFunc(GL_LEQUAL);
	skyboxShader->Use();
	skyboxShader->SetUniformMatrix4f("view", glm::mat4(glm::mat3(view)));
	skyboxShader->SetUniformMatrix4f("projection", projection);
	skyboxShader->SetUniformBool("isHDR", false);
	hdrSkyboxTex.BindCubemap(GL_TEXTURE0);
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
