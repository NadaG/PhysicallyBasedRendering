#pragma once

#include<GL\glfw3.h>

class InputManager
{
public:
	static InputManager* GetInstance();

	void SetLeftMouseClicked(bool isClicked) { this->isLeftMouseClicked = isClicked; }
	bool IsLeftMouseClicked() { return this->isLeftMouseClicked; }
	void Initialize(GLFWwindow* window);
	void PollEvents();

	bool IsKey(int key) { return glfwGetKey(window, key); }

private:
	InputManager() {};
	InputManager(const InputManager& other);
	~InputManager() {};

	bool isLeftMouseClicked = false;

	static InputManager* instance;
	GLFWwindow* window;
};