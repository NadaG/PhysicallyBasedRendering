#include "StarBurstSceneManager.h"

void StarBurstSceneManager::InitializeObjects()
{
	streetLightModel.LoadModel("Obj/street_lamp.obj");
	streetLight.LoadMesh("Obj/street_lamp.obj");

	cameraObj.Translate(glm::vec3(0.0f, 0.0f, 10.0f));

	sceneObjs.push_back(streetLight);
	sceneObjs.push_back(streetLightModel);
}

void StarBurstSceneManager::Update()
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
		cameraObj.Translate(glm::vec3(0.0f, 0.0f, -cameraMoveSpeed));
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_K))
	{
		cameraObj.Translate(glm::vec3(0.0f, 0.0f, cameraMoveSpeed));
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_U))
	{
		cameraObj.Translate(glm::vec3(0.0f, cameraMoveSpeed, 0.0f));
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_O))
	{
		cameraObj.Translate(glm::vec3(0.0f, -cameraMoveSpeed, 0.0f));
	}
}