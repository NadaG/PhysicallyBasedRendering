#include "CameraMovement.h"
#include "Object.h"

void CameraMovement::Update()
{
	if (InputManager::GetInstance()->IsKey(GLFW_KEY_J))
	{
		//object->ModelRotate(glm::vec3(0.0f, 1.0f, 0.0f), 0.01f);
		object->ModelTranslate(glm::vec3(-moveSpeed, 0.0f, 0.0f));
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_L))
	{
		//object->ModelRotate(glm::vec3(0.0f, 1.0f, 0.0f), -0.01f);
		object->ModelTranslate(glm::vec3(moveSpeed, 0.0f, 0.0f));
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_I))
	{
		object->ModelTranslate(glm::vec3(0.0f, 0.0f, -moveSpeed));
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_K))
	{
		object->ModelTranslate(glm::vec3(0.0f, 0.0f, moveSpeed));
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_U))
	{
		object->ModelTranslate(glm::vec3(0.0f, moveSpeed, 0.0f));
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_O))
	{
		object->ModelTranslate(glm::vec3(0.0f, -moveSpeed, 0.0f));
	}


}
