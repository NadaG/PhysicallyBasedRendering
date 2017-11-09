#include "FluidRenderer.h"
#include "PBRRenderer.h"
#include "WindowManager.h"
#include "Debug.h"

using namespace std;

enum Scene
{
	PBR_SCENE = 0,
	FLUID_SCENE = 1
};

int main(int argc, char **argv)
{
	Scene scene = PBR_SCENE;

	WindowManager::GetInstance()->WindowHint(GLFW_SAMPLES, 4);
	WindowManager::GetInstance()->WindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
	WindowManager::GetInstance()->WindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
	WindowManager::GetInstance()->WindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
	WindowManager::GetInstance()->WindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
	GLFWwindow* window = WindowManager::GetInstance()->CreateMyWindow(1024, 1024, "OpenGL");

	InputManager::GetInstance()->Initialize(window);

	// TO Refacto 어딘가로 버려버릴것
	glewExperimental = true;
	if (glewInit() != GLEW_OK)
	{
		fprintf(stderr, "Failed to initialize GLEW\n");
		return 0;
	}

	// TO Refacto 객체의 생성 삭제 씬 이동 등만 관리하는 SceneManager를 만들고
	// SubJect로 둔다. InputManager와 RenderManager는 observer로 SceneManager의 objects 객체들을 레퍼런스로
	// 가지고 있으며 SceneManager에서 변경될 때 마다 update된다.
	// 객체들의 이동은 InputManager에서 관리하며 InputManager는 추상화로 바꿔야한다.
	Renderer* renderer;
	SceneManager* sceneManager;

	// Factory 패턴을 이용하면 생성을 분리할 수 있을 거 같음
	switch (scene)
	{
		case PBR_SCENE:
		{
			sceneManager = new PBRSceneManager();
			renderer = new PBRRenderer(sceneManager);
			break;
		}
		case FLUID_SCENE:
		{	sceneManager = new FluidSceneManager();
			renderer = new FluidRenderer(sceneManager);
			break;
		}
		default:
			sceneManager = new PBRSceneManager();
			renderer = new PBRRenderer(sceneManager);
			break;
	}

	sceneManager->InitializeObjects();

	renderer->Initialize(window);
	renderer->InitializeRender();

	do
	{
		sceneManager->Update();
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