#include "SceneManager.h"

SceneManager* SceneManager::instance = nullptr;
void mouseButtonCallback(GLFWwindow* window, int button, int action, int mods);

SceneManager* SceneManager::GetInstance()
{
	if (instance == nullptr)
	{
		instance = new SceneManager();
	}

	return instance;
}

void SceneManager::InitializeObjects()
{
	float yDist = 3.0f;
	float xDist = 5.0f;
	for (int i = 0; i < 3; i++)
	{
		for (int j = 0; j < 3; j++)
		{
			glm::vec3 pos = glm::vec3((j - (3 / 2))*xDist, (i - 3 / 2)*yDist, 0.0f);
			SceneObject sphereObj;
			sphereObj.LoadMesh("Obj/Sphere.obj");
			sceneObjs.push_back(sphereObj);
			sceneObjs[i*3+j].Translate(pos);
		}
	}
	
	cameraObj.Translate(glm::vec3(0.0f, 0.0f, 15.0f));

	SceneObject lightObj;
	lightObj.LoadMesh("Obj/Sphere.obj");
	lightObjs.push_back(lightObj);
	lightObjs[0].Scale(glm::vec3(0.1f));
	lightObjs[0].SetColor(glm::vec3(0.0f, 1.0f, 0.0f));
}

void SceneManager::InitializeObjectsFluid()
{
	quadObj.LoadMesh(QUAD);

	cameraObj.Translate(glm::vec3(0.0f, 0.0f, 15.0f));
}

void SceneManager::Update()
{
	if (InputManager::GetInstance()->IsKey(GLFW_KEY_J))
	{
		cameraObj.Rotate(glm::vec3(0.0f, 1.0f, 0.0f), 0.01f);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_L))
	{
		cameraObj.Rotate(glm::vec3(0.0f, 1.0f, 0.0f), -0.01f);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_I))
	{
		cameraObj.Translate(glm::vec3(0.0f, 0.0f, -0.2f));
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_K))
	{
		cameraObj.Translate(glm::vec3(0.0f, 0.0f, 0.2f));
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_U))
	{
		cameraObj.Translate(glm::vec3(0.0f, 0.2f, 0.0f));
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_O))
	{
		cameraObj.Translate(glm::vec3(0.0f, -0.2f, 0.0f));
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_A))
	{
		glm::mat4 view = glm::lookAt(
			cameraObj.GetWorldPosition(),
			glm::vec3(0.0f, cameraObj.GetPosition().y, 0.0f),
			glm::vec3(0.0f, 1.0f, 0.0f)
		);

		glm::vec4 v = glm::inverse(view) * glm::vec4(-0.2f, 0.0f, 0.0f, 0.0f);
		lightObjs[0].Translate(v);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_D))
	{
		glm::mat4 view = glm::lookAt(
			cameraObj.GetWorldPosition(),
			glm::vec3(0.0f, cameraObj.GetPosition().y, 0.0f),
			glm::vec3(0.0f, 1.0f, 0.0f)
		);

		glm::vec4 v = glm::inverse(view) * glm::vec4(0.2f, 0.0f, 0.0f, 0.0f);
		lightObjs[0].Translate(v);
	}
}

void SceneManager::TerminateObjects()
{
	for (int i = 0; i < sceneObjs.size(); i++)
		sceneObjs[i].TerminateMesh();
	cameraObj.TerminateMesh();
}