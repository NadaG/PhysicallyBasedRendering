#include "RayTracingRenderer.h"
#include "LectureSceneRenderer.h"
#include "PBRRenderer.h"
#include "LTCRenderer.h"
#include "FluidRenderer.h"

#include "WindowManager.h"
#include "Debug.h"
#include "RayTracer.cuh"

#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

using namespace std;

enum Scene
{
	PBR_SCENE = 0,
	FLUID_SCENE = 1,
	LTC_SCENE = 2,
	SMOKE_SCENE = 3,
	STARBURST_SCENE = 4,
	TEMPORALGLARE_SCENE = 5,
	RAYTRACING_SCENE = 6
};

// TODO movement 셋팅하고 사용하는 부분 너무 복잡함, 함수로 빼내던가 해야함
// TODO scene object update하고 render 하는 부분 이상함, renderer에서 여러 object를 다 가져와야하는 문제 해결
// TODO shader 불러오고 사용하고 그리는 부분 중복되는 부분이 너무 많은데 그 부분들 수정하기

int main(int argc, char **argv)
{
	

	/*OctreeNode octree;
	octree.bnd.bounds[0] = glm::vec3(-30, -30, -30);
	octree.bnd.bounds[1] = glm::vec3(30, 30, 30);

	Subdivide(&octree);

	Subdivide(octree.children[0]);

	cout << octree.children[0]->children[0]->bnd.bounds[0].x << octree.children[0]->children[0]->bnd.bounds[0].y << octree.children[0]->children[0]->bnd.bounds[0].z << endl;*/

	Scene scene = RAYTRACING_SCENE;

	WindowManager::GetInstance()->Initialize();

	WindowManager::GetInstance()->WindowHint(GLFW_SAMPLES, 4);
	WindowManager::GetInstance()->WindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
	WindowManager::GetInstance()->WindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
	WindowManager::GetInstance()->WindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
	WindowManager::GetInstance()->WindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
	GLFWwindow* window = WindowManager::GetInstance()->CreateMyWindow(1024, 1024, "OpenGL");

	InputManager::GetInstance()->Initialize(window);

	//TO Refacto 어딘가로 버려버릴것
	glewExperimental = GL_TRUE;

	if (glewInit() != GLEW_OK)
	{
		fprintf(stderr, "Failed to initialize GLEW\n");
		return 0;
	}

	Renderer* renderer;
	SceneManager* sceneManager;

	// 처음에 1280 에러가 하나 나오는데 그것은 신경쓰지 않아도 됨
	GLenum err = glGetError();
	if (err != GL_NO_ERROR)
		printf("Error: %s\n", glewGetErrorString(err));

	switch (scene)
	{
	case RAYTRACING_SCENE:
	{
		sceneManager = new RayTracingSceneManager();
		renderer = new RayTracingRenderer(sceneManager);
		break;
	}
	case FLUID_SCENE:
	{
		sceneManager = new FluidSceneManager();
		renderer = new FluidRenderer(sceneManager);
		break;
	}
	case LTC_SCENE:
	{
		sceneManager = new LTCSceneManager();
		renderer = new LTCRenderer(sceneManager);
		break;
	}
	case PBR_SCENE:
	{
		sceneManager = new PBRSceneManager();
		renderer = new PBRRenderer(sceneManager);
		break;
	}
	default:
		sceneManager = new RayTracingSceneManager();
		renderer = new RayTracingRenderer(sceneManager);
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
		glfwSwapBuffers(window);
	} 
	while (InputManager::GetInstance()->IsKey(GLFW_KEY_ESCAPE) != GLFW_PRESS &&
		!WindowManager::GetInstance()->WindowShouldClose());

	renderer->TerminateRender();

	delete renderer;
	delete sceneManager;

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