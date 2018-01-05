#include "CameraMovement.h"
#include "Object.h"

void CameraMovement::Update()
{
	if (InputManager::GetInstance()->IsKey(GLFW_KEY_J))
	{
		object->Rotate(glm::vec3(0.0f, 1.0f, 0.0f), 0.01f);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_L))
	{
		object->Rotate(glm::vec3(0.0f, 1.0f, 0.0f), -0.01f);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_I))
	{
		object->Translate(glm::vec3(0.0f, 0.0f, -moveSpeed));
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_K))
	{
		object->Translate(glm::vec3(0.0f, 0.0f, moveSpeed));
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_U))
	{
		object->Translate(glm::vec3(0.0f, moveSpeed, 0.0f));
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_O))
	{
		object->Translate(glm::vec3(0.0f, -moveSpeed, 0.0f));
	}
}
