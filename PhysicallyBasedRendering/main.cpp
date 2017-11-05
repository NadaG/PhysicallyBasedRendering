#include "FluidRenderer.h"
#include "PBRRenderer.h"
#include "WindowManager.h"
#include "Debug.h"

using namespace std;

bool isPBRScene = false;

int main(int argc, char **argv)
{
	WindowManager::GetInstance()->WindowHint(GLFW_SAMPLES, 4);
	WindowManager::GetInstance()->WindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
	WindowManager::GetInstance()->WindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
	WindowManager::GetInstance()->WindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
	WindowManager::GetInstance()->WindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
	GLFWwindow* window = WindowManager::GetInstance()->CreateMyWindow(1024, 1024, "OpenGL");

	InputManager::GetInstance()->Initialize(window);

	Renderer* renderer;
	if (isPBRScene)
		renderer = new PBRRenderer();
	else
		renderer = new FluidRenderer();
	renderer->Initialize(window);

	if (isPBRScene)
		SceneManager::GetInstance()->InitializeObjects();
	else
		SceneManager::GetInstance()->InitializeObjectsFluid();
	
	renderer->InitializeRender();

	do
	{
		SceneManager::GetInstance()->Update();
		renderer->Render();
		InputManager::GetInstance()->PollEvents();
	}
	while (InputManager::GetInstance()->IsKey(GLFW_KEY_ESCAPE) != GLFW_PRESS && 
		!WindowManager::GetInstance()->WindowShouldClose());

	renderer->TerminateRender();

	delete renderer;

	WindowManager::GetInstance()->Terminate();

	return 0;
}

//3 channel
//albedo, microsurface, metallic
//refracted light(diffuse)
//depth and color would be very
//
//metallic(conductvie) reflect many lights and energy less lost
//dielectric(insulation) refract many lights lost many energy and wide
//
//refracted light�� ��ü�� ������ ���� ���̴�.
//���� albedo���� ��������.
//�ȿ� ���ڰ� ���� ��� refracted light�� ������ �پ���(metallic)
//�ȿ� ���ڰ� ���� ��� refracted light�� ������ ��������.
//
//reflected light�� �� ��ü�� ������ ������,
//�ֳĸ� refracted light�� ��ü���� ������ ��������� reflected light�� �ƴϱ� �����̴�.
//roughness channel�̳� glossiness channel�� ǥ���Ѵ�.
//roughness channel������ �Ͼ���ϼ��� ��ĥ�ٴ� ���̴�.
//smoothness