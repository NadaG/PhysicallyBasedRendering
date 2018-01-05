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

	/*Object* light = new SceneObject();
	SceneObject* movingLight = new LightMovingScript(light, movingCamera);
	movingLight->LoadModel("Obj/Sphere.obj");
	movingLight->Scale(glm::vec3(0.5f));
	movingLight->SetColor(glm::vec3(10.0f, 0.0f, 0.0f));
	movingLights.push_back(movingLight);*/

	lightMovement = new LightMovement(movingCamera);
	movingLight = new SceneObject(lightMovement);
	lightMovement->BindObject(movingLight);
	
	//movingLight->LoadModel("Obj/Sphere.obj");
	movingLight->Scale(glm::vec3(0.1f));
	//movingLight->SetColor(glm::vec3(10.0, 0.0, 0.0));

	/*lightObjs.push_back(lightObj);
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
	lightObjs[3].SetColor(glm::vec3(10.0f, 10.0f, 10.0f));*/
	
	movingCamera->Translate(glm::vec3(0.0f, 2.0f, 10.0f));
}

void StarBurstSceneManager::Update()
{
	// 이 안에서 update가 돌아가야 함
	movingCamera->Update();
	movingLight->Update();

	/*
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
	}*/
}