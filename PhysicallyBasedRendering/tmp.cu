//#include "RayTracingRenderer.h"
//#include "LectureSceneRenderer.h"
//#include "PBRRenderer.h"
//#include "LTCRenderer.h"
//#include "FluidRenderer.h"
//
//#include "WindowManager.h"
//#include "Debug.h"
//#include "RayTracer.cuh"
//
//#include "Octree.cuh"
//
//#define STB_IMAGE_IMPLEMENTATION
//#include "stb_image.h"
//
//using namespace std;
//
//enum Scene
//{
//	PBR_SCENE = 0,
//	FLUID_SCENE = 1,
//	LTC_SCENE = 2,
//	SMOKE_SCENE = 3,
//	STARBURST_SCENE = 4,
//	TEMPORALGLARE_SCENE = 5,
//	RAYTRACING_SCENE = 6
//};
//
//// TODO movement 셋팅하고 사용하는 부분 너무 복잡함, 함수로 빼내던가 해야함
//// TODO scene object update하고 render 하는 부분 이상함, renderer에서 여러 object를 다 가져와야하는 문제 해결
//// TODO shader 불러오고 사용하고 그리는 부분 중복되는 부분이 너무 많은데 그 부분들 수정하기
//
//struct BTNode
//{
//	int data = NULL;
//
//	BTNode *left = nullptr;
//	BTNode *right = nullptr;
//};
//
//
//BTNode* CreateNode(int data)
//{
//	BTNode *node = new BTNode;
//	node->data = data;
//
//	return node;
//}
//
//
//void InsertLeft(BTNode *parent, BTNode *left)
//{
//	if (parent->left != nullptr)
//		return;
//
//	parent->left = left;
//}
//
//void InsertRight(BTNode *parent, BTNode *right)
//{
//	if (parent->right != nullptr)
//		return;
//
//	parent->right = right;
//}
//
//void Traversal(BTNode *node)
//{
//	cout << "data : " << node->data << endl;
//
//	if (node->left != nullptr)
//		Traversal(node->left);
//	if (node->right != nullptr)
//		Traversal(node->right);
//
//}
//
//void DeleteTree(BTNode *node)
//{
//	if (node->left != nullptr)
//		DeleteTree(node->left);
//
//	if (node->right != nullptr)
//		DeleteTree(node->right);
//
//	delete node;
//}
//
//
//const int BTSize = sizeof(BTNode);
//
//BTNode* BTHostToDevice(BTNode *node)
//{
//	if (node == nullptr)
//		return nullptr;
//
//	node->left = BTHostToDevice(node->left);
//	node->right = BTHostToDevice(node->right);
//
//	BTNode* gnode;
//	cudaMalloc((void**)&gnode, BTSize);
//	cudaMemcpy(gnode, node, BTSize, cudaMemcpyHostToDevice);
//
//	return gnode;
//}
//
//BTNode* BTDeviceToHost(BTNode *node)
//{
//	if (node == nullptr)
//		return nullptr;
//
//	BTNode* cnode = new BTNode;
//	cudaMemcpy(cnode, node, BTSize, cudaMemcpyDeviceToHost);
//
//	cnode->left = BTDeviceToHost(cnode->left);
//	cnode->right = BTDeviceToHost(cnode->right);
//
//	return cnode;
//}
//
//__global__
//void Mull(BTNode *node)
//{
//	if (threadIdx.x == 0)
//		node->data = node->data * 0;
//	else if (threadIdx.x == 1)
//		node->left->data = node->left->data * 1;
//	else if (threadIdx.x == 2)
//		node->right->data = node->right->data * 2;
//}
//
//
//
//int main(int argc, char **argv)
//{
//	BTNode *node = CreateNode(1);
//
//	InsertLeft(node, CreateNode(2));
//	InsertRight(node, CreateNode(3));
//
//	Traversal(node);
//
//	BTNode *gnode = BTHostToDevice(node);
//
//	dim3 dimBlock(3, 1);
//	dim3 dimGrid(1, 1);
//	
//
//	Mull << < dimGrid, dimBlock >> >(gnode);
//	//Traversal(node);
//
//	//cudaMemcpy(node, gnode, BTSize, cudaMemcpyDeviceToHost);
//	/*cudaMemcpy(node->hostRight, gnode->deviceRight, BTSize, cudaMemcpyDeviceToHost);
//	if (gnode->deviceLeft == nullptr)
//		cout << "dd" << endl;*/
//	//cout << gnode->data << endl;
//	//cout << node->hostLeft << endl;
//
//	node = BTDeviceToHost(gnode);
//	Traversal(node);
//
//
//	tmpfunc();
//
//	/*Scene scene = RAYTRACING_SCENE;
//
//	WindowManager::GetInstance()->Initialize();
//
//	WindowManager::GetInstance()->WindowHint(GLFW_SAMPLES, 4);
//	WindowManager::GetInstance()->WindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
//	WindowManager::GetInstance()->WindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
//	WindowManager::GetInstance()->WindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
//	WindowManager::GetInstance()->WindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
//	GLFWwindow* window = WindowManager::GetInstance()->CreateMyWindow(1024, 1024, "OpenGL");
//
//	InputManager::GetInstance()->Initialize(window);
//
//	TO Refacto 어딘가로 버려버릴것
//	glewExperimental = true;
//
//	if (glewInit() != GLEW_OK)
//	{
//	fprintf(stderr, "Failed to initialize GLEW\n");
//	return 0;
//	}
//
//	Renderer* renderer;
//	SceneManager* sceneManager;
//
//	switch (scene)
//	{
//	case RAYTRACING_SCENE:
//	{
//	sceneManager = new RayTracingSceneManager();
//	renderer = new RayTracingRenderer(sceneManager);
//	break;
//	}
//	case FLUID_SCENE:
//	{
//	sceneManager = new FluidSceneManager();
//	renderer = new FluidRenderer(sceneManager);
//	break;
//	}
//	case LTC_SCENE:
//	{
//	sceneManager = new LTCSceneManager();
//	renderer = new LTCRenderer(sceneManager);
//	break;
//	}
//	case PBR_SCENE:
//	{
//	sceneManager = new PBRSceneManager();
//	renderer = new PBRRenderer(sceneManager);
//	break;
//	}
//	default:
//	sceneManager = new RayTracingSceneManager();
//	renderer = new RayTracingRenderer(sceneManager);
//	break;
//	}
//
//	sceneManager->InitializeObjects();
//
//	renderer->Initialize(window);
//	renderer->InitializeRender();
//
//	do
//	{
//	sceneManager->Update();
//	renderer->Render();
//	InputManager::GetInstance()->PollEvents();
//	glfwSwapBuffers(window);
//	}
//	while (InputManager::GetInstance()->IsKey(GLFW_KEY_ESCAPE) != GLFW_PRESS &&
//	!WindowManager::GetInstance()->WindowShouldClose());
//
//	renderer->TerminateRender();
//
//	delete renderer;
//	delete sceneManager;
//
//	WindowManager::GetInstance()->Terminate();
//
//
//
//	return 0;*/
//}
//
////3 channel
////albedo, microsurface, metallic
////refracted light(diffuse)
////depth and color would be very
////
////metallic(conductvie) reflect many lights and energy less lost
////dielectric(insulation) refract many lights lost many energy and wide
////
////refracted light는 물체의 성질에 따른 것이다.
////따라서 albedo에서 정해진다.
////안에 전자가 많을 경우 refracted light의 비중이 줄어들고(metallic)
////안에 전자가 적을 경우 refracted light의 비중이 높아진다.
////
////reflected light는 빛 자체의 색만을 가진다,
////왜냐면 refracted light는 물체에서 색깔이 흡수되지만 reflected light는 아니기 때문이다.
////roughness channel이나 glossiness channel로 표현한다.
////roughness channel에서는 하얀색일수록 거칠다는 뜻이다.
////smoothness