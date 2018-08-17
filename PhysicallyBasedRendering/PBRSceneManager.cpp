#include "PBRSceneManager.h"

void PBRSceneManager::InitializeObjects()
{
	skyboxObj.LoadModel(CUBE);
	cubeObj.LoadModel(CUBE);
	quadObj.LoadModel(QUAD);

	selectedLightId = 0;

	float yDist = 3.0f;
	float xDist = 5.0f;
	for (int i = 0; i < 3; i++)
	{
		for (int j = 0; j < 3; j++)
		{
			glm::vec3 pos = glm::vec3((j - (3 / 2))*xDist, (i - 3 / 2)*yDist, 0.0f);
			SceneObject sphereObj;
			sphereObj.LoadModel("Obj/Sphere.obj");
			sceneObjs.push_back(sphereObj);
			sceneObjs[i * 3 + j].WorldTranslate(pos);
		}
	}

	skyboxObj.Scale(glm::vec3(1.0f));
	cubeObj.Scale(glm::vec3(4.0f, 1.0f, 1.0f));

	movingCamera->WorldTranslate(glm::vec3(0.0f, 0.0f, 15.0f));

	GenerateLight(glm::vec3(10.0f, 0.0f, 0.0f), glm::vec3(0.1f));
	GenerateLight(glm::vec3(0.0f, 10.0f, 0.0f), glm::vec3(0.1f));
	GenerateLight(glm::vec3(0.0f, 0.0f, 10.0f), glm::vec3(0.1f));
	GenerateLight(glm::vec3(10.0f, 10.0f, 10.0f), glm::vec3(0.1f));
}

void PBRSceneManager::Update()
{
	/*movingCamera->Update();
	lightObjs[selectedLightId]->Update();

	for (int i = 0; i < lightObjs.size(); i++)
	{
		if (InputManager::GetInstance()->IsKey(GLFW_KEY_1 + i))
			selectedLightId = i;
	}*/
}