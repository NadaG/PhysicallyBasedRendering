#include "StarBurstSceneManager.h"

void StarBurstSceneManager::InitializeObjects()
{
	quadObj.LoadModel(QUAD);
	skyboxObj.LoadModel(CUBE);

	road.LoadModel("Texture/Road/road.obj");

	streetLight.LoadModel("Obj/StreetLight.obj");
	streetLight.Scale(glm::vec3(0.1f));

	sceneObjs.push_back(road);
	sceneObjs.push_back(streetLight);

	GenerateLight(glm::vec3(10.0f, 2.0f, 0.0f), glm::vec3(0.1f));
	GenerateLight(glm::vec3(0.0f, 10.0f, 0.0f), glm::vec3(0.1f));
	GenerateLight(glm::vec3(10.0f, 0.0f, 10.0f), glm::vec3(0.1f));
	GenerateLight(glm::vec3(10.0f, 10.0f, 10.0f), glm::vec3(0.1f));
	
	movingCamera->Translate(glm::vec3(0.0f, 2.0f, 10.0f));
}

void StarBurstSceneManager::Update()
{
	// 이 안에서 update가 돌아가야 함
	movingCamera->Update();
	lightObjs[selectedLightId]->Update();

	for (int i = 0; i < lightObjs.size(); i++)
	{
		if (InputManager::GetInstance()->IsKey(GLFW_KEY_1 + i))
			selectedLightId = i;
	}
}