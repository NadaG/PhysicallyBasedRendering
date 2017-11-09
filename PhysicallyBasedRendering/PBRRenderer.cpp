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

	lightShader = new ShaderProgram("light.vs", "light.fs");
	lightShader->Use();

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
}

void PBRRenderer::Render()
{
	glEnable(GL_DEPTH_TEST);
	glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	vector<SceneObject>& objs = sceneManager->sceneObjs;
	SceneObject& camera = sceneManager->cameraObj;
	vector<SceneObject>& lights = sceneManager->lightObjs;

	glViewport(0, 0, WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);
	UseDefaultFrameBufferObject();
	
	pbrShader->Use();

	glm::mat4 projection = glm::perspective(
		glm::radians(45.0f),
		WindowManager::GetInstance()->width / WindowManager::GetInstance()->height,
		0.1f,
		30.0f);

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

	RenderObjects(pbrShader, objs);

	lightShader->Use();
	lightShader->SetUniformMatrix4f("view", view);
	lightShader->SetUniformMatrix4f("projection", projection);
	RenderObjects(lightShader, lights);

	glfwSwapBuffers(window);
}

void PBRRenderer::TerminateRender()
{
	pbrShader->Delete();
	delete pbrShader;

	lightShader->Delete();
	delete lightShader;

	sceneManager->TerminateObjects();
}
