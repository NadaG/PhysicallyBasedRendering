#include "RayTracingSceneManager.h"

void RayTracingSceneManager::InitializeObjects()
{
	quadObj.LoadModel(QUAD);

	sceneObjs.push_back(quadObj);
	sceneObjs[0].Scale(glm::vec3(15.0));
	sceneObjs[0].Rotate(glm::vec3(1.0f, 0.0f, 0.0f), glm::radians(90.0f));
	sceneObjs[0].Translate(glm::vec3(0.0f, 0.0f, 0.0f));

	movingCamera->Translate(glm::vec3(0.0f, 0.1f, 10.0f));
}

void RayTracingSceneManager::Update()
{
	movingCamera->Update();
}