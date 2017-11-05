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
//refracted light는 물체의 성질에 따른 것이다.
//따라서 albedo에서 정해진다.
//안에 전자가 많을 경우 refracted light의 비중이 줄어들고(metallic)
//안에 전자가 적을 경우 refracted light의 비중이 높아진다.
//
//reflected light는 빛 자체의 색만을 가진다,
//왜냐면 refracted light는 물체에서 색깔이 흡수되지만 reflected light는 아니기 때문이다.
//roughness channel이나 glossiness channel로 표현한다.
//roughness channel에서는 하얀색일수록 거칠다는 뜻이다.
//smoothness