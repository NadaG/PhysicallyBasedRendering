#include "VolumeRenderer.h"

void VolumeRenderer::InitializeRender()
{
	backgroundColor = glm::vec4(1.0f, 0.0f, 1.0f, 0.0f);

	basicShader = new ShaderProgram("Basic.vs", "Basic.fs");
	basicShader->Use();

	importer = new SmokeSimulationImporter(100, 100, 100);
}

void VolumeRenderer::Render()
{
	UseDefaultFrameBufferObject();
	glViewport(0, 0, WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);

	glEnable(GL_DEPTH_TEST);
	glClearColor(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	SceneObject& camera = sceneManager->cameraObj;
	SceneObject& quad = sceneManager->quadObj;
	vector<SceneObject>& objs = sceneManager->sceneObjs;

	glm::mat4 projection = glm::perspective(
		glm::radians(45.0f),
		WindowManager::GetInstance()->width / WindowManager::GetInstance()->height,
		0.1f,
		100.0f);

	glm::mat4 view = glm::lookAt(
		camera.GetWorldPosition(),
		glm::vec3(0.0f, camera.GetPosition().y, 0.0f),
		glm::vec3(0.0f, 1.0f, 0.0f)
	);

	basicShader->Use();

	basicShader->SetUniformMatrix4f("view", view);
	basicShader->SetUniformMatrix4f("projection", projection);

	for (int i = 0; i < objs.size(); i++)
	{
		glm::mat4 model = objs[i].GetModelMatrix();
		basicShader->SetUniformMatrix4f("model", model);
		basicShader->SetUniformVector3f("inColor", glm::vec3(importer->density[i]+1.0f)*0.1f);
		objs[i].Draw();
	}
}

void VolumeRenderer::TerminateRender()
{
	basicShader->Delete();
	delete basicShader;
}