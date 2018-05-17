#include "RayTracingSceneManager.h"

void RayTracingSceneManager::InitializeObjects()
{
	quadObj.LoadModel(QUAD);
	movingCamera->WorldTranslate(glm::vec3(15.0f, 20.0f, 90.0f));

	Light light;
	light.pos = glm::vec3(100.0f, 100.0f, 0.0f);
	light.color = glm::vec3(1.0f, 1.0f, 1.0f);
	lights.push_back(light);

	Material fluidMat, planeMat, sphereMat, sphereMat2;
	fluidMat.ambient = glm::vec3(0.0f, 0.0f, 0.2f);
	fluidMat.diffuse = glm::vec3(0.2f, 0.2f, 0.4f);
	fluidMat.specular = glm::vec3(0.2f, 0.2f, 0.2f);
	fluidMat.refractivity = 0.5f;
	fluidMat.reflectivity = 0.0f;
	materials.push_back(fluidMat);

	planeMat.ambient = glm::vec3(0.2f, 0.5f, 0.2f);
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
	sphereMat2.reflectivity = 0.0f;
	materials.push_back(sphereMat2);

	Sphere sphere;
	sphere.origin = glm::vec3(20.0f, 10.0f, 25.0f);
	sphere.radius = 3.0f;
	sphere.materialId = 3;
	spheres.push_back(sphere);

	glm::mat4 sphereModel = glm::mat4();
	sphereModel = glm::translate(sphereModel, glm::vec3(10.0f, 10.0f, 0.0f));
	sphereModel = glm::scale(sphereModel, glm::vec3(10.0f, 10.0f, 10.0f));

	
	InsertTriangles(LoadMeshTriangles("Obj/PouringFluid/0250.obj", glm::mat4(), 0));
	InsertTriangles(LoadMeshTriangles("Obj/sphere.obj", sphereModel, 3));

	glm::mat4 planeModel = glm::mat4();
	planeModel = glm::scale(planeModel, glm::vec3(100.0f, 1.0f, 100.0f));
	planeModel = glm::translate(planeModel, glm::vec3(0.0f, -5.0f, 0.0f));
	InsertTriangles(LoadPlaneTriangles(planeModel, 1));
}

void RayTracingSceneManager::Update()
{
	if (InputManager::GetInstance()->IsKey(GLFW_KEY_J))
	{
		movingCamera->ModelTranslate(glm::vec3(-moveSpeed, 0.0f, 0.0f));
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_L))
	{
		movingCamera->ModelTranslate(glm::vec3(moveSpeed, 0.0f, 0.0f));
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_I))
	{
		movingCamera->ModelTranslate(glm::vec3(0.0f, 0.0f, -moveSpeed));
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_K))
	{
		movingCamera->ModelTranslate(glm::vec3(0.0f, 0.0f, moveSpeed));
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_U))
	{
		movingCamera->ModelTranslate(glm::vec3(0.0f, moveSpeed, 0.0f));
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_O))
	{
		movingCamera->ModelTranslate(glm::vec3(0.0f, -moveSpeed, 0.0f));
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_A))
	{
		movingCamera->ModelRotate(glm::vec3(0.0f, 1.0f, 0.0f), rotateSpeed);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_D))
	{
		movingCamera->ModelRotate(glm::vec3(0.0f, 1.0f, 0.0f), -rotateSpeed);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_W))
	{
		movingCamera->ModelRotate(glm::vec3(1.0f, 0.0f, 0.0f), rotateSpeed);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_S))
	{
		movingCamera->ModelRotate(glm::vec3(1.0f, 0.0f, 0.0f), -rotateSpeed);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_Q))
	{
		movingCamera->ModelRotate(glm::vec3(0.0f, 0.0f, 1.0f), rotateSpeed);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_E))
	{
		movingCamera->ModelRotate(glm::vec3(0.0f, 0.0f, 1.0f), -rotateSpeed);
	}
}

vector<Triangle> RayTracingSceneManager::LoadPlaneTriangles(glm::mat4 model, const int materialId)
{
	// 밑에 깔린 plane임
	Triangle halfPlane1, halfPlane2;
	halfPlane1.v0 = glm::vec3(model * glm::vec4(-1.0f, 0.0f, 1.0f, 1.0f));
	halfPlane1.v1 = glm::vec3(model * glm::vec4(1.0f, 0.0f, 1.0f, 1.0f));
	halfPlane1.v2 = glm::vec3(model * glm::vec4(-1.0f, 0.0f, -1.0f, 1.0f));
	halfPlane1.normal = model * glm::vec4(0.0f, 1.0f, 0.0f, 0.0f);

	halfPlane1.v0normal = halfPlane1.normal;
	halfPlane1.v1normal = halfPlane1.normal;
	halfPlane1.v2normal = halfPlane1.normal;
	halfPlane1.materialId = materialId;
	triangles.push_back(halfPlane1);

	halfPlane2.v0 = glm::vec3(model * glm::vec4(1.0f, 0.0f, 1.0f, 1.0f));
	halfPlane2.v1 = glm::vec3(model * glm::vec4(1.0f, 0.0f, -1.0f, 1.0f));
	halfPlane2.v2 = glm::vec3(model * glm::vec4(-1.0f, 0.0f, -1.0f, 1.0f));
	halfPlane2.normal = model * glm::vec4(0.0f, 1.0f, 0.0f, 0.0f);

	halfPlane2.v0normal = halfPlane2.normal;
	halfPlane2.v1normal = halfPlane2.normal;
	halfPlane2.v2normal = halfPlane2.normal;
	halfPlane2.materialId = materialId;
	triangles.push_back(halfPlane2);

	return triangles;
}

void RayTracingSceneManager::InsertTriangles(vector<Triangle> triangles)
{
	this->triangles.insert(this->triangles.end(), triangles.begin(), triangles.end());

	glm::vec3 bmin;
	glm::vec3 bmax;
	for (int i = 0; i < this->triangles.size(); ++i)
	{
		bmin.x = min(min(min(this->triangles[i].v0.x, this->triangles[i].v1.x), this->triangles[i].v2.x), bmin.x);
		bmin.y = min(min(min(this->triangles[i].v0.y, this->triangles[i].v1.y), this->triangles[i].v2.y), bmin.y);
		bmin.z = min(min(min(this->triangles[i].v0.z, this->triangles[i].v1.z), this->triangles[i].v2.z), bmin.z);

		bmax.x = max(max(max(this->triangles[i].v0.x, this->triangles[i].v1.x), this->triangles[i].v2.x), bmax.x);
		bmax.y = max(max(max(this->triangles[i].v0.y, this->triangles[i].v1.y), this->triangles[i].v2.y), bmax.y);
		bmax.z = max(max(max(this->triangles[i].v0.z, this->triangles[i].v1.z), this->triangles[i].v2.z), bmax.z);
	}
}

vector<Triangle> RayTracingSceneManager::LoadMeshTriangles(const string meshfile, glm::mat4 model, const int materialId)
{
	SceneObject obj;
	obj.LoadModel(meshfile.c_str());

	vector<Triangle> triangles = obj.GetTriangles();

	for (int i = 0; i < triangles.size(); i++)
	{
		triangles[i].v0 = glm::vec3(model * glm::vec4(triangles[i].v0, 1.0f));
		triangles[i].v1 = glm::vec3(model * glm::vec4(triangles[i].v1, 1.0f));
		triangles[i].v2 = glm::vec3(model * glm::vec4(triangles[i].v2, 1.0f));
		triangles[i].normal = glm::normalize(glm::vec3(model * glm::vec4(triangles[i].normal, 0.0f)));
		triangles[i].v0normal = glm::normalize(glm::vec3(model * glm::vec4(triangles[i].v0normal, 0.0f)));
		triangles[i].v1normal = glm::normalize(glm::vec3(model * glm::vec4(triangles[i].v1normal, 0.0f)));
		triangles[i].v2normal = glm::normalize(glm::vec3(model * glm::vec4(triangles[i].v2normal, 0.0f)));
		triangles[i].materialId = materialId;
	}

	return triangles;
}

//vector<Triangle> RayTracingSceneManager::BackFaceCulling(vector<Triangle> triangles, glm::mat4 model)
//{
//	vector<Triangle> culledFaces;
//
//	for (int i = 0; i < triangles.size(); ++i)
//	{
//		vec3 viewSpaceNormal = model * glm::vec4(triangles[i].normal, 1.0f);
//		vec3 v0WorldPosition = model * glm::vec4(triangles[i].v0, 1.0f);
//		if (glm::dot(viewSpaceNormal, v0WorldPosition - movingCamera->GetWorldPosition()) <= 0.0f)
//			culledFaces.push_back(triangles[i]);
//	}
//	return culledFaces;
//}

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