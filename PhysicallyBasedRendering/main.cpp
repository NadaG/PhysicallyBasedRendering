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

	// TO Refacto ��򰡷� ����������
	glewExperimental = true;
	if (glewInit() != GLEW_OK)
	{
		fprintf(stderr, "Failed to initialize GLEW\n");
		return 0;
	}

	// TO Refacto ��ü�� ���� ���� �� �̵� � �����ϴ� SceneManager�� �����
	// SubJect�� �д�. InputManager�� RenderManager�� observer�� SceneManager�� objects ��ü���� ���۷�����
	// ������ ������ SceneManager���� ����� �� ���� update�ȴ�.
	// ��ü���� �̵��� InputManager���� �����ϸ� InputManager�� �߻�ȭ�� �ٲ���Ѵ�.
	Renderer* renderer;
	SceneManager* sceneManager;

	// Factory ������ �̿��ϸ� ������ �и��� �� ���� �� ����
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