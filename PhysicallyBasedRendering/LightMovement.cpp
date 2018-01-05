#include "LightMovement.h"
#include "Object.h"

#include "Debug.h"

void LightMovement::Update()
{
	glm::mat4 view = glm::lookAt(
		camera->GetWorldPosition(),
		glm::vec3(0.0f, camera->GetPosition().y, 0.0f),
		glm::vec3(0.0f, 1.0f, 0.0f)
	);

	Debug::GetInstance()->Log(object->GetWorldPosition());

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_A))
	{
		glm::vec4 v = glm::inverse(view) * glm::vec4(-moveSpeed, 0.0f, 0.0f, 0.0f);
		object->Translate(v);
	}

	Debug::GetInstance()->Log(object->GetWorldPosition());

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_D))
	{
		glm::vec4 v = glm::inverse(view) * glm::vec4(moveSpeed, 0.0f, 0.0f, 0.0f);
		object->Translate(v);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_W))
	{
		glm::vec4 v = glm::inverse(view) * glm::vec4(0.0f, 0.0f, -moveSpeed, 0.0f);
		object->Translate(v);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_S))
	{
		glm::vec4 v = glm::inverse(view) * glm::vec4(0.0f, 0.0f, moveSpeed, 0.0f);
		object->Translate(v);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_Q))
	{
		glm::vec4 v = glm::inverse(view) * glm::vec4(0.0f, moveSpeed, 0.0f, 0.0f);
		object->Translate(v);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_E))
	{
		glm::vec4 v = glm::inverse(view) * glm::vec4(0.0f, -moveSpeed, 0.0f, 0.0f);
		object->Translate(v);
	}
}