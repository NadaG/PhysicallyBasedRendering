#pragma once

#include<GL\glfw3.h>
#include <cstdio>

class WindowManager
{
public:
	static WindowManager* GetInstance();

	void WindowHint(int hint, int value);
	GLFWwindow* CreateMyWindow(int width, int height, const char* name);
	bool WindowShouldClose();
	
	void Initialize();
	void Terminate();
	float width, height;

private:
	WindowManager() {};
	~WindowManager() {};

	bool isLeftMouseClicked = false;

	static WindowManager* instance;
	GLFWwindow* window;

};