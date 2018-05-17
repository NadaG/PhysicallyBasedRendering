#include "SmokeSceneManager.h"

void SmokeSceneManager::InitializeObjects()
{
	for (int i = 0; i < 100; i++)
	{
		for (int j = 0; j < 100; j++)
		{
			SceneObject cube;
			cube.LoadModel(CUBE);
			sceneObjs.push_back(cube);
			sceneObjs[i * 100 + j].WorldTranslate(glm::vec3(i * 0.3f, j * 0.3f, 0));
			sceneObjs[i * 100 + j].Scale(glm::vec3(0.1f));
		}
	}
	movingCamera->WorldTranslate(glm::vec3(0.0f, 0.0f, 20.0f));
}

void SmokeSceneManager::Update()
{
	movingCamera->Update();
}
