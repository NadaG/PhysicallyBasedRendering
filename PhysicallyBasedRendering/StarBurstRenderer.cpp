#include "StarBurstRenderer.h"

void StarBurstRenderer::InitializeRender()
{
	lightShader = new ShaderProgram("light.vs", "light.fs");
	lightShader->Use();

	// bind의 순서와 shader 내에서의 sampler2D 정의 순서는 연관되어 있다.
	pbrShader = new ShaderProgram("PBR.vs", "PBRBrightness.fs");
	pbrShader->Use();
	pbrShader->BindTexture(&aoTex, "aoMap");
	pbrShader->BindTexture(&albedoTex, "albedoMap");
	pbrShader->BindTexture(&emissionTex, "emissionMap");
	pbrShader->BindTexture(&metallicTex, "metallicMap");
	pbrShader->BindTexture(&normalTex, "normalMap");
	pbrShader->BindTexture(&roughnessTex, "roughnessMap");

	string folder = "StreetLight";
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
	roughnessTex.SetParameters(GL_LINEAR_MIPMAP_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT);

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
	bloomShader->SetUniform1f("exposure", 1.0);

	brightFBO.GenFrameBufferObject();
	worldFBO.GenFrameBufferObject();

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

	worldFBO.BindDefaultDepthBuffer(WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);
	brightFBO.BindDefaultDepthBuffer(WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);

	worldFBO.DrawBuffers();
	brightFBO.DrawBuffers();

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
	worldFBO.Clear(0.0f, 0.0f, 0.0f, 0.0f);
	//UseDefaultFBO();
	//ClearDefaultFBO();

	glm::mat4 projection = glm::perspective(
		glm::radians(45.0f),
		WindowManager::GetInstance()->width / WindowManager::GetInstance()->height,
		zNear,
		zFar);

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
		//Debug::GetInstance()->Log(lights[i]->GetPosition());
		pbrShader->SetUniformVector3f("lightColors[" + std::to_string(i) + "]", lights[i]->GetColor());
	}

	RenderObjects(pbrShader, sceneObjs);

	// light는 어차피 bright 하므로...
	lightShader->Use();
	lightShader->SetUniformMatrix4f("view", view);
	lightShader->SetUniformMatrix4f("projection", projection);
	RenderObjects(lightShader, lights);

	glViewport(0, 0, WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);
	brightFBO.Use();
	brightFBO.Clear(0.0f, 0.0f, 0.0f, 0.0f);
	glEnable(GL_DEPTH_TEST);
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

	UseDefaultFBO();
	ClearDefaultFBO();
	bloomShader->Use();
	quad.DrawModel();
}

void StarBurstRenderer::TerminateRender()
{
	pbrShader->Delete();
	delete pbrShader;

	lightShader->Delete();
	delete lightShader;

	blurShader->Delete();
	delete blurShader;

	sceneManager->TerminateObjects();
}