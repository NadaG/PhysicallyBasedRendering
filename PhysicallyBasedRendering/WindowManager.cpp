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
		fprintf(stderr, "GLFW �����츦 ���µ� �����߽��ϴ�. Intel GPU �� ����Ѵٸ�, 3.3 ������ ���� �ʽ��ϴ�. 2.1 ������ Ʃ�丮���� �õ��ϼ���.\n");
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
