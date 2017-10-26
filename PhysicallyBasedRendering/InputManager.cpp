#include "InputManager.h"

InputManager* InputManager::instance = nullptr;
void mouseButtonCallback(GLFWwindow* window, int button, int action, int mods);

InputManager* InputManager::GetInstance()
{
	if (instance == nullptr)
	{
		instance = new InputManager();
	}

	return instance;
}

void InputManager::Initialize(GLFWwindow* window)
{
	this->window = window;
	glfwSetMouseButtonCallback(this->window, mouseButtonCallback);
	glfwSetInputMode(this->window, GLFW_STICKY_KEYS, GL_TRUE);
}

void InputManager::PollEvents()
{
	glfwPollEvents();
}

void mouseButtonCallback(GLFWwindow* window, int button, int action, int mods)
{
	if (button == GLFW_MOUSE_BUTTON_LEFT)
	{
		if (action == GLFW_PRESS)
		{
			InputManager::GetInstance()->SetLeftMouseClicked(true);
		}

		if (action == GLFW_RELEASE)
		{
			InputManager::GetInstance()->SetLeftMouseClicked(false);
		}
	}
}