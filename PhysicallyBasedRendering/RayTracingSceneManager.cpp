#include "RayTracingSceneManager.h"

void RayTracingSceneManager::InitializeObjects()
{
	quadObj.LoadModel(QUAD);
	//movingCamera->Translate(glm::vec3(50.0f, 20.0f, 200.0f));
	movingCamera->Translate(glm::vec3(0.0f, 5.0f, 100.0f));

	SceneObject obj;
	//obj.LoadModel("Obj/Fluid/0200.obj");
	//obj.LoadModel("Obj/StreetLight.obj");
	//obj.LoadModel("Obj/street_lamp.obj");
	obj.LoadModel("Obj/torus.obj");

	sceneObjs.push_back(obj);

	cameraInitPos = movingCamera->GetWorldPosition();

	Light light;
	light.pos = glm::vec3(0.0f, 100.0f, 0.0f);
	light.color = glm::vec3(1.0f, 1.0f, 1.0f);
	lights.push_back(light);

	glm::mat4 translateMat = glm::translate(glm::vec3(0.0f, 0.0f, 0.0f));
	glm::mat4 scaleMat = glm::scale(glm::vec3(1.0f, 1.0f, 1.0f));
	triangles = sceneObjs[0].GetTriangles();

	for (int i = 0; i < triangles.size(); i++)
	{
		triangles[i].v0 = glm::vec3(translateMat * scaleMat * glm::vec4(triangles[i].v0, 1.0f));
		triangles[i].v1 = glm::vec3(translateMat * scaleMat * glm::vec4(triangles[i].v1, 1.0f));
		triangles[i].v2 = glm::vec3(translateMat * scaleMat * glm::vec4(triangles[i].v2, 1.0f));
	}
}

void RayTracingSceneManager::Update()
{
	if (InputManager::GetInstance()->IsKey(GLFW_KEY_J))
	{
		glm::vec3 dir = glm::vec3(-0.2f, 0.0f, 0.0f);
		dir = glm::vec4(dir, 0.0f) * movingCamera->GetRotate();
		movingCamera->Translate(glm::vec3(dir));
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_L))
	{
		glm::vec3 dir = glm::vec3(0.2f, 0.0f, 0.0f);
		dir = glm::vec4(dir, 0.0f) * movingCamera->GetRotate();
		movingCamera->Translate(glm::vec3(dir));
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_I))
	{
		glm::vec3 dir = glm::vec3(0.0f, 0.0f, -0.2f);
		dir = glm::vec4(dir, 0.0f) * movingCamera->GetRotate();
		movingCamera->Translate(glm::vec3(dir));
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_K))
	{
		glm::vec3 dir = glm::vec3(0.0f, 0.0f, 0.2f);
		dir = glm::vec4(dir, 0.0f) * movingCamera->GetRotate();
		movingCamera->Translate(glm::vec3(dir));
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_U))
	{
		glm::vec3 dir = glm::vec3(0.0f, 0.2f, 0.0f);
		dir = glm::vec4(dir, 0.0f) * movingCamera->GetRotate();
		movingCamera->Translate(glm::vec3(dir));
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_O))
	{
		glm::vec3 dir = glm::vec3(0.0f, -0.2f, 0.0f);
		dir = glm::vec4(dir, 0.0f) * movingCamera->GetRotate();
		movingCamera->Translate(glm::vec3(dir));
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_A))
	{
		movingCamera->Rotate(glm::vec3(0.0f, 1.0f, 0.0f), -0.005f);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_D))
	{
		movingCamera->Rotate(glm::vec3(0.0f, 1.0f, 0.0f), 0.005f);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_W))
	{
		movingCamera->Rotate(glm::vec3(1.0f, 0.0f, 0.0f), 0.005f);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_S))
	{
		movingCamera->Rotate(glm::vec3(1.0f, 0.0f, 0.0f), -0.005f);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_Q))
	{
		movingCamera->Rotate(glm::vec3(0.0f, 0.0f, 1.0f), -0.005f);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_E))
	{
		movingCamera->Rotate(glm::vec3(0.0f, 0.0f, 1.0f), 0.005f);
	}
}

void RayTracingSceneManager::LoadPlane()
{
	const float halfWidth = 200.0f;
	const float planeY = -5.0f;

	// 오른손 좌표계로 삼각형의 앞면이 그려진다.
	Triangle halfPlane1, halfPlane2;
	halfPlane1.v0 = glm::vec3(-halfWidth, planeY, halfWidth);
	halfPlane1.v1 = glm::vec3(halfWidth, planeY, halfWidth);
	halfPlane1.v2 = glm::vec3(-halfWidth, planeY, -halfWidth);
	halfPlane1.normal = glm::vec3(0.0f, 1.0f, 0.0f);

	triangles.push_back(halfPlane1);

	halfPlane2.v0 = glm::vec3(halfWidth, planeY, halfWidth);
	halfPlane2.v1 = glm::vec3(halfWidth, planeY, -halfWidth);
	halfPlane2.v2 = glm::vec3(-halfWidth, planeY, -halfWidth);
	halfPlane2.normal = glm::vec3(0.0f, 1.0f, 0.0f);
	triangles.push_back(halfPlane2);
}

void RayTracingSceneManager::LoadMaterial()
{
	///
	Material defaultMat;
	defaultMat.ambient = glm::vec3(0.2f, 0.2f, 0.2f);
	defaultMat.diffuse = glm::vec3(0.2f, 0.2f, 0.6f);
	defaultMat.specular = glm::vec3(0.2f, 0.2f, 0.7f);
}

// quaternion은 

// quaternion에 대해서 값은 다음과 같다.
// x = RotationAxis.x * sin(RotationAngle / 2)
// y = RotationAxis.y * sin(RotationAngle / 2)
// z = RotationAxis.z * sin(RotationAngle / 2)
// w = cos(RotationAngle / 2)

// [0.7, 0, 0, 0.7]이라는 quaternion이 있을 경우
// 2 * acos(w) = RotationAngle이라는 것을 알고
// 2 * acos(w)의 값은 1.57정도이므로
// 이 quaternion이 표현한 회전은 90도 회전이다.
// 또한 y, z 값이 0이므로 단순히 x축에 대한 회전이라는 것을 알 수 있다.

// LookAt 함수에 대해서 공부함
// Result[0][0] = s.x;
// Result[1][0] = s.y;
// Result[2][0] = s.z;
// Result[0][1] = u.x;
// Result[1][1] = u.y;
// Result[2][1] = u.z;
// Result[0][2] = -f.x;
// Result[1][2] = -f.y;
// Result[2][2] = -f.z;
// Result[3][0] = -dot(s, eye);
// Result[3][1] = -dot(u, eye);
// Result[3][2] = dot(f, eye);