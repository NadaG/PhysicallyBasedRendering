#include "StarBurstSceneManager.h"

void StarBurstSceneManager::InitializeObjects()
{
	quadObj.LoadMesh(QUAD);
	skyboxObj.LoadMesh(CUBE);

	road.LoadModel("Texture/Road/road.obj");

	streetLight.LoadMesh("Obj/StreetLight.obj");
	streetLight.Scale(glm::vec3(0.1f));

	sceneObjs.push_back(road);
	sceneObjs.push_back(streetLight);

	SceneObject lightObj;
	lightObj.LoadMesh("Obj/Sphere.obj");

	lightObjs.push_back(lightObj);
	lightObjs[0].Scale(glm::vec3(0.1f));
	lightObjs[0].SetColor(glm::vec3(10.0f, 0.0f, 0.0f));

	lightObjs.push_back(lightObj);
	lightObjs[1].Scale(glm::vec3(0.1f));
	lightObjs[1].SetColor(glm::vec3(0.0f, 10.0f, 0.0f));

	lightObjs.push_back(lightObj);
	lightObjs[2].Scale(glm::vec3(0.1f));
	lightObjs[2].SetColor(glm::vec3(0.0f, 0.0f, 10.0f));

	lightObjs.push_back(lightObj);
	lightObjs[3].Scale(glm::vec3(0.1f));
	lightObjs[3].SetColor(glm::vec3(10.0f, 10.0f, 10.0f));
	
	cameraObj.Translate(glm::vec3(0.0f, 2.0f, 10.0f));
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

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_A))
	{
		glm::mat4 view = glm::lookAt(
			cameraObj.GetWorldPosition(),
			glm::vec3(0.0f, cameraObj.GetPosition().y, 0.0f),
			glm::vec3(0.0f, 1.0f, 0.0f)
		);

		glm::vec4 v = glm::inverse(view) * glm::vec4(-lightMoveSpeed, 0.0f, 0.0f, 0.0f);
		lightObjs[selectedLightId].Translate(v);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_D))
	{
		glm::mat4 view = glm::lookAt(
			cameraObj.GetWorldPosition(),
			glm::vec3(0.0f, cameraObj.GetPosition().y, 0.0f),
			glm::vec3(0.0f, 1.0f, 0.0f)
		);

		glm::vec4 v = glm::inverse(view) * glm::vec4(lightMoveSpeed, 0.0f, 0.0f, 0.0f);
		lightObjs[selectedLightId].Translate(v);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_W))
	{
		glm::mat4 view = glm::lookAt(
			cameraObj.GetWorldPosition(),
			glm::vec3(0.0f, cameraObj.GetPosition().y, 0.0f),
			glm::vec3(0.0f, 1.0f, 0.0f)
		);

		glm::vec4 v = glm::inverse(view) * glm::vec4(0.0f, 0.0f, -lightMoveSpeed, 0.0f);
		lightObjs[selectedLightId].Translate(v);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_S))
	{
		glm::mat4 view = glm::lookAt(
			cameraObj.GetWorldPosition(),
			glm::vec3(0.0f, cameraObj.GetPosition().y, 0.0f),
			glm::vec3(0.0f, 1.0f, 0.0f)
		);

		glm::vec4 v = glm::inverse(view) * glm::vec4(0.0f, 0.0f, lightMoveSpeed, 0.0f);
		lightObjs[selectedLightId].Translate(v);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_Q))
	{
		glm::mat4 view = glm::lookAt(
			cameraObj.GetWorldPosition(),
			glm::vec3(0.0f, cameraObj.GetPosition().y, 0.0f),
			glm::vec3(0.0f, 1.0f, 0.0f)
		);

		glm::vec4 v = glm::inverse(view) * glm::vec4(0.0f, lightMoveSpeed, 0.0f, 0.0f);
		lightObjs[selectedLightId].Translate(v);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_E))
	{
		glm::mat4 view = glm::lookAt(
			cameraObj.GetWorldPosition(),
			glm::vec3(0.0f, cameraObj.GetPosition().y, 0.0f),
			glm::vec3(0.0f, 1.0f, 0.0f)
		);

		glm::vec4 v = glm::inverse(view) * glm::vec4(0.0f, -lightMoveSpeed, 0.0f, 0.0f);
		lightObjs[selectedLightId].Translate(v);
	}

	for (int i = 0; i < lightObjs.size(); i++)
	{
		if (InputManager::GetInstance()->IsKey(GLFW_KEY_1 + i))
			selectedLightId = i;
	}
}