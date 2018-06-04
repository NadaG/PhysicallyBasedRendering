#include "FluidSceneManager.h"

void FluidSceneManager::InitializeObjects()
{
	quadObj.LoadModel(QUAD);
	skyboxObj.LoadModel(CUBE);

	fluidObj.LoadModel("Obj/Fluid/0250.obj");

	sceneObjs.push_back(quadObj);
	sceneObjs[0].Scale(glm::vec3(15.0));
	sceneObjs[0].ModelRotate(glm::vec3(1.0f, 0.0f, 0.0f), glm::radians(90.0f));
	sceneObjs[0].WorldTranslate(glm::vec3(0.0f, -5.7f, 0.0f));

	sceneObjs.push_back(skyboxObj);
	sceneObjs[1].Scale(glm::vec3(10.0f));

	// fluid Ãß°¡ÇÔ
	sceneObjs.push_back(fluidObj);

	movingCamera->WorldTranslate(glm::vec3(0.0f, 0.0f, 0.0f));
}

void FluidSceneManager::Update()
{
	movingCamera->Update();

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_A))
	{
		movingCamera->ModelRotate(glm::vec3(0.0f, 1.0f, 0.0f), 0.03f);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_D))
	{
		movingCamera->ModelRotate(glm::vec3(0.0f, 1.0f, 0.0f), -0.03f);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_W))
	{
		movingCamera->ModelRotate(glm::vec3(1.0f, 0.0f, 0.0f), 0.03f);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_S))
	{
		movingCamera->ModelRotate(glm::vec3(1.0f, 0.0f, 0.0f), -0.03f);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_Q))
	{
		movingCamera->ModelRotate(glm::vec3(0.0f, 0.0f, 1.0f), 0.03f);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_E))
	{
		movingCamera->ModelRotate(glm::vec3(0.0f, 0.0f, 1.0f), -0.03f);
	}

	/*if (InputManager::GetInstance()->IsKey(GLFW_KEY_A))
	{
		glm::mat4 view = glm::lookAt(
			movingCamera->GetWorldPosition(),
			glm::vec3(0.0f, movingCamera->GetPosition().y, 0.0f),
			glm::vec3(0.0f, 1.0f, 0.0f)
		);

		glm::vec4 v = glm::inverse(view) * glm::vec4(-0.2f, 0.0f, 0.0f, 0.0f);
		sceneObjs[0].WorldTranslate(v);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_D))
	{
		glm::mat4 view = glm::lookAt(
			movingCamera->GetWorldPosition(),
			glm::vec3(0.0f, movingCamera->GetPosition().y, 0.0f),
			glm::vec3(0.0f, 1.0f, 0.0f)
		);

		glm::vec4 v = glm::inverse(view) * glm::vec4(0.2f, 0.0f, 0.0f, 0.0f);
		sceneObjs[0].WorldTranslate(v);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_W))
	{
		glm::mat4 view = glm::lookAt(
			movingCamera->GetWorldPosition(),
			glm::vec3(0.0f, movingCamera->GetPosition().y, 0.0f),
			glm::vec3(0.0f, 1.0f, 0.0f)
		);

		glm::vec4 v = glm::inverse(view) * glm::vec4(0.0f, 0.2f, 0.0f, 0.0f);
		sceneObjs[0].WorldTranslate(v);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_S))
	{
		glm::mat4 view = glm::lookAt(
			movingCamera->GetWorldPosition(),
			glm::vec3(0.0f, movingCamera->GetPosition().y, 0.0f),
			glm::vec3(0.0f, 1.0f, 0.0f)
		);

		glm::vec4 v = glm::inverse(view) * glm::vec4(0.0f, -0.2f, 0.0f, 0.0f);
		sceneObjs[0].WorldTranslate(v);
	}*/
}