#include "LTCSceneManager.h"

void LTCSceneManager::InitializeObjects()
{
	quadObj.LoadModel(QUAD);

	sceneObjs.push_back(quadObj);
	sceneObjs[0].Scale(glm::vec3(15.0));
	sceneObjs[0].Rotate(glm::vec3(1.0f, 0.0f, 0.0f), glm::radians(90.0f));
	sceneObjs[0].Translate(glm::vec3(0.0f, 0.0f, 0.0f));

	movingCamera->Translate(glm::vec3(0.0f, 5.0f, 20.0f));
}

void LTCSceneManager::Update()
{
	glm::mat4 view = glm::lookAt(
		movingCamera->GetWorldPosition(),
		movingCamera->GetWorldPosition() + glm::vec3(glm::vec4(0.0f, 0.0f, -5.0f, 0.0f) * movingCamera->GetRotate()),
		glm::vec3(0.0f, 1.0f, 0.0f)
	);

	/*if (InputManager::GetInstance()->IsKey(GLFW_KEY_J))
	{
		glm::vec4 dir = glm::vec4(-0.2f, 0.0f, 0.0f, 0.0f) * view;
		cameraObj.Translate(glm::vec3(dir));
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_L))
	{
		glm::vec4 dir = glm::vec4(0.2f, 0.0f, 0.0f, 0.0f) * view;
		cameraObj.Translate(dir);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_I))
	{
		glm::vec4 dir = glm::vec4(0.0f, 0.0f, -0.2f, 0.0f) * view;
		cameraObj.Translate(dir);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_K))
	{
		glm::vec4 dir = glm::vec4(0.0f, 0.0f, 0.2f, 0.0f) * view;
		cameraObj.Translate(dir);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_U))
	{
		glm::vec4 dir = glm::vec4(0.0f, 0.2f, 0.0f, 0.0f) * view;
		cameraObj.Translate(dir);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_O))
	{
		glm::vec4 dir = glm::vec4(0.0f, -0.2f, 0.0f, 0.0f) * view;
		cameraObj.Translate(dir);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_A))
		cameraObj.Rotate(glm::vec3(0.0, 1.0, 0.0), 0.01f);

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_D))
		cameraObj.Rotate(glm::vec3(0.0, 1.0, 0.0), -0.01f);*/
}