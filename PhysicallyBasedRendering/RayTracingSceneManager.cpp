#include "RayTracingSceneManager.h"

void RayTracingSceneManager::InitializeObjects()
{
	quadObj.LoadModel(QUAD);
	movingCamera->Translate(glm::vec3(15.0f, 20.0f, 90.0f));
	//movingCamera->Translate(glm::vec3(0.0f, 5.0f, 30.0f));

	//SceneObject obj;
	//obj.LoadModel("Obj/Fluid/0200.obj");
	//obj.LoadModel("Obj/PouringFluid/0250.obj");
	//obj.LoadModel("Obj/StreetLight.obj");
	//obj.LoadModel("Obj/street_lamp.obj");
	//obj.LoadModel("Obj/torus.obj");

	cameraInitPos = movingCamera->GetWorldPosition();

	Light light;
	light.pos = glm::vec3(0.0f, 100.0f, 0.0f);
	light.color = glm::vec3(1.0f, 1.0f, 1.0f);
	lights.push_back(light);

	LoadMesh("Obj/PouringFluid/0250.obj");

	Material fluidMat, planeMat, sphereMat, sphereMat2;
	fluidMat.ambient = glm::vec3(0.0f, 0.0f, 0.04f);
	fluidMat.diffuse = glm::vec3(0.0f, 0.0f, 0.0f);
	fluidMat.specular = glm::vec3(0.2f, 0.2f, 0.2f);
	fluidMat.refractivity = 0.9f;
	fluidMat.reflectivity = 0.9f;
	materials.push_back(fluidMat);

	planeMat.ambient = glm::vec3(0.2f, 0.2f, 0.2f);
	planeMat.diffuse = glm::vec3(0.2f, 0.2f, 0.2f);
	planeMat.specular = glm::vec3(0.2f, 0.2f, 0.2f);
	planeMat.refractivity = 0.0f;
	planeMat.reflectivity = 0.0f;
	materials.push_back(planeMat);

	sphereMat.ambient = glm::vec3(0.3f, 0.1f, 0.1f);
	sphereMat.diffuse = glm::vec3(0.9f, 0.3f, 0.3f);
	sphereMat.specular = glm::vec3(0.9f, 0.2f, 0.2f);
	sphereMat.refractivity = 0.0f;
	sphereMat.reflectivity = 0.0f;
	materials.push_back(sphereMat);

	sphereMat2.ambient = glm::vec3(0.3f, 0.1f, 0.1f);
	sphereMat2.diffuse = glm::vec3(0.9f, 0.3f, 0.3f);
	sphereMat2.specular = glm::vec3(0.9f, 0.2f, 0.2f);
	sphereMat2.refractivity = 0.0f;
	sphereMat2.reflectivity = 0.5f;
	materials.push_back(sphereMat2);

	Sphere sphere;
	sphere.origin = glm::vec3(20.0f, 10.0f, 25.0f);
	sphere.radius = 3.0f;
	sphere.materialId = 3;
	spheres.push_back(sphere);
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

void RayTracingSceneManager::LoadPlane(glm::vec3 pos)
{
	const float halfWidth = 150.0f;
	const float planeY = pos.y;
	const float planeZ = pos.z;

	// 오른손 좌표계로 삼각형의 앞면이 그려진다.
	Triangle halfPlane1, halfPlane2, halfPlane3, halfPlane4;
	halfPlane1.v0 = glm::vec3(-halfWidth, planeY, halfWidth);
	halfPlane1.v1 = glm::vec3(halfWidth, planeY, halfWidth);
	halfPlane1.v2 = glm::vec3(-halfWidth, planeY, -halfWidth);
	halfPlane1.normal = glm::vec3(0.0f, 1.0f, 0.0f);
	halfPlane1.materialId = 1;
	triangles.push_back(halfPlane1);

	halfPlane2.v0 = glm::vec3(halfWidth, planeY, halfWidth);
	halfPlane2.v1 = glm::vec3(halfWidth, planeY, -halfWidth);
	halfPlane2.v2 = glm::vec3(-halfWidth, planeY, -halfWidth);
	halfPlane2.normal = glm::vec3(0.0f, 1.0f, 0.0f);
	halfPlane2.materialId = 1;
	triangles.push_back(halfPlane2);

	// 오른손 좌표계로 삼각형의 앞면이 그려진다.
	halfPlane3.v0 = glm::vec3(-halfWidth, -halfWidth, planeZ);
	halfPlane3.v1 = glm::vec3(halfWidth, halfWidth, planeZ);
	halfPlane3.v2 = glm::vec3(-halfWidth, halfWidth, planeZ);
	halfPlane3.normal = glm::vec3(0.0f, 0.0f, 1.0f);
	halfPlane3.materialId = 1;
	triangles.push_back(halfPlane3);

	halfPlane4.v0 = glm::vec3(-halfWidth, -halfWidth, planeZ);
	halfPlane4.v1 = glm::vec3(halfWidth, -halfWidth, planeZ);
	halfPlane4.v2 = glm::vec3(halfWidth, halfWidth, planeZ);
	halfPlane4.normal = glm::vec3(0.0f, 0.0f, 1.0f);
	halfPlane4.materialId = 1;
	triangles.push_back(halfPlane4);
}

void RayTracingSceneManager::LoadMesh(const string meshfile)
{
	triangles.clear();
	
	SceneObject obj;
	obj.LoadModel(meshfile.c_str());

	SceneObject sphereObj;
	sphereObj.LoadModel("Obj/Sphere.obj");

	// model matrix
	//vector<Triangle> allTriangles = obj.GetTriangles();
	//triangles = BackFaceCulling(allTriangles, translateMat * scaleMat);
	vector<Triangle> fluidTriangles = obj.GetTriangles();
	glm::mat4 translateMat = glm::translate(glm::vec3(0.0f, 0.0f, 0.0f));
	glm::mat4 scaleMat = glm::scale(glm::vec3(1.0f, 1.0f, 1.0f));

	for (int i = 0; i < fluidTriangles.size(); i++)
	{
		fluidTriangles[i].v0 = glm::vec3(translateMat * scaleMat * glm::vec4(fluidTriangles[i].v0, 1.0f));
		fluidTriangles[i].v1 = glm::vec3(translateMat * scaleMat * glm::vec4(fluidTriangles[i].v1, 1.0f));
		fluidTriangles[i].v2 = glm::vec3(translateMat * scaleMat * glm::vec4(fluidTriangles[i].v2, 1.0f));
		fluidTriangles[i].materialId = 0;
	}

	vector<Triangle> sphereTriangles = sphereObj.GetTriangles();
	translateMat = glm::translate(glm::vec3(15.0f, 25.0f, -20.0f));
	scaleMat = glm::scale(glm::vec3(10.0f, 10.0f, 10.0f));

	for (int i = 0; i < sphereTriangles.size(); i++)
	{
		sphereTriangles[i].v0 = glm::vec3(translateMat * scaleMat * glm::vec4(sphereTriangles[i].v0, 1.0f));
		sphereTriangles[i].v1 = glm::vec3(translateMat * scaleMat * glm::vec4(sphereTriangles[i].v1, 1.0f));
		sphereTriangles[i].v2 = glm::vec3(translateMat * scaleMat * glm::vec4(sphereTriangles[i].v2, 1.0f));
		sphereTriangles[i].materialId = 2;
	}

	triangles.insert(triangles.end(), fluidTriangles.begin(), fluidTriangles.end());
	triangles.insert(triangles.end(), sphereTriangles.begin(), sphereTriangles.end());
	
	glm::vec3 bmin;
	glm::vec3 bmax;
	for (int i = 0; i < triangles.size(); ++i)
	{
		bmin.x = min(min(min(triangles[i].v0.x, triangles[i].v1.x), triangles[i].v2.x), bmin.x);
		bmin.y = min(min(min(triangles[i].v0.y, triangles[i].v1.y), triangles[i].v2.y), bmin.y);
		bmin.z = min(min(min(triangles[i].v0.z, triangles[i].v1.z), triangles[i].v2.z), bmin.z);

		bmax.x = max(max(max(triangles[i].v0.x, triangles[i].v1.x), triangles[i].v2.x), bmax.x);
		bmax.y = max(max(max(triangles[i].v0.y, triangles[i].v1.y), triangles[i].v2.y), bmax.y);
		bmax.z = max(max(max(triangles[i].v0.z, triangles[i].v1.z), triangles[i].v2.z), bmax.z);
	}

	LoadPlane(bmin);
}

vector<Triangle> RayTracingSceneManager::BackFaceCulling(vector<Triangle> triangles, glm::mat4 model)
{
	vector<Triangle> culledFaces;

	for (int i = 0; i < triangles.size(); ++i)
	{
		vec3 viewSpaceNormal = model * glm::vec4(triangles[i].normal, 1.0f);
		vec3 v0WorldPosition = model * glm::vec4(triangles[i].v0, 1.0f);
		if (glm::dot(viewSpaceNormal, v0WorldPosition - movingCamera->GetWorldPosition()) <= 0.0f)
			culledFaces.push_back(triangles[i]);
	}
	return culledFaces;
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