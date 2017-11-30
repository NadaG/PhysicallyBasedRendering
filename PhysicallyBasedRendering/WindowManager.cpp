#include "WindowManager.h"

WindowManager* WindowManager::instance = nullptr;

WindowManager* WindowManager::GetInstance()
{
	if (instance == nullptr)
	{
		instance = new WindowManager();
	}

	return instance;
}

void WindowManager::WindowHint(int hint, int value)
{
	glfwWindowHint(hint, value);
}

GLFWwindow* WindowManager::CreateMyWindow(int width, int height, const char* name)
{
	this->width = width;
	this->height = height;
	window = glfwCreateWindow(width, height, name, NULL, NULL);
	glfwSetWindowPos(window, 30, 30);
	if (window == NULL)
	{
		fprintf(stderr, "GLFW 윈도우를 여는데 실패했습니다. Intel GPU 를 사용한다면, 3.3 지원을 하지 않습니다. 2.1 버전용 튜토리얼을 시도하세요.\n");
		//glfwTerminate();
	}
	glfwMakeContextCurrent(window);
	return window;
}

bool WindowManager::WindowShouldClose()
{
	return glfwWindowShouldClose(window);
}

void WindowManager::Initialize()
{
	glfwInit();
}

void WindowManager::Terminate()
{
	glfwTerminate();
}
