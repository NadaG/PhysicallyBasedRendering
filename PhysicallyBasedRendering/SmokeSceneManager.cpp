#include "SmokeSceneManager.h"

void SmokeSceneManager::InitializeObjects()
{
	for (int i = 0; i < 100; i++)
	{
		for (int j = 0; j < 100; j++)
		{
			SceneObject cube;
			cube.LoadMesh(CUBE);
			sceneObjs.push_back(cube);
			sceneObjs[i * 100 + j].Translate(glm::vec3(i * 0.3f, j * 0.3f, 0));
			sceneObjs[i * 100 + j].Scale(glm::vec3(0.1f));
		}
	}
	cameraObj.Translate(glm::vec3(0.0f, 0.0f, 20.0f));
}

void SmokeSceneManager::Update()
{
	if (InputManager::GetInstance()->IsKey(GLFW_KEY_J))
	{
		cameraObj.Rotate(glm::vec3(0.0f, 1.0f, 0.0f), 0.01f);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_L))
	{
		cameraObj.Rotate(glm::vec3(0.0f, 1.0f, 0.0f), -0.01f);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_I))
	{
		cameraObj.Translate(glm::vec3(0.0f, 0.0f, -0.2f));
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_K))
	{
		cameraObj.Translate(glm::vec3(0.0f, 0.0f, 0.2f));
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_U))
	{
		cameraObj.Translate(glm::vec3(0.0f, 0.2f, 0.0f));
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_O))
	{
		cameraObj.Translate(glm::vec3(0.0f, -0.2f, 0.0f));
	}
}
