#include "StarBurstRenderer.h"

void StarBurstRenderer::InitializeRender()
{
	lightShader = new ShaderProgram("light.vs", "light.fs");
	lightShader->Use();

	pbrShader = new ShaderProgram("PBR.vs", "PBR.fs");
	pbrShader->Use();
	pbrShader->SetUniform1i("aoMap", 0);
	pbrShader->SetUniform1i("albedoMap", 1);
	pbrShader->SetUniform1i("emissionMap", 2);
	pbrShader->SetUniform1i("metallicMap", 3);
	pbrShader->SetUniform1i("normalMap", 4);
	pbrShader->SetUniform1i("roughnessMap", 5);

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

	backgroundColor = glm::vec4(0.5f, 0.15f, 0.15f, 0.0f);
}

void StarBurstRenderer::Render()
{
	glEnable(GL_DEPTH_TEST);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	vector<SceneObject>& sceneObjs = sceneManager->sceneObjs;
	SceneObject& camera = sceneManager->cameraObj;
	vector<SceneObject>& lights = sceneManager->lightObjs;

	glViewport(0, 0, WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);
	UseDefaultFrameBufferObject();

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
	pbrShader->SetUniformVector3f("eyePos", camera.GetWorldPosition());

	for (int i = 0; i < lights.size(); i++)
	{
		pbrShader->SetUniformVector3f("lightPositions[" + std::to_string(i) + "]", lights[i].GetPosition());
		pbrShader->SetUniformVector3f("lightColors[" + std::to_string(i) + "]", lights[i].GetColor());
	}

	aoTex.Bind(GL_TEXTURE0);
	albedoTex.Bind(GL_TEXTURE1);
	emissionTex.Bind(GL_TEXTURE2);
	metallicTex.Bind(GL_TEXTURE3);
	normalTex.Bind(GL_TEXTURE4);
	roughnessTex.Bind(GL_TEXTURE5);

	RenderObjects(pbrShader, sceneObjs);

	lightShader->Use();
	lightShader->SetUniformMatrix4f("view", view);
	lightShader->SetUniformMatrix4f("projection", projection);
	RenderObjects(lightShader, lights);
}

void StarBurstRenderer::TerminateRender()
{
	//phongShader.Delete();
	
	pbrShader->Delete();
	delete pbrShader;
}