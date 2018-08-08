#include "RayTracingSceneManager.h"

void RayTracingSceneManager::InitializeObjects()
{
	quadObj.LoadModel(QUAD);
	// fluid
	//movingCamera->WorldTranslate(glm::vec3(10.0f, 20.0f, 110.0f));
	// path tracing
	movingCamera->WorldTranslate(glm::vec3(0.0f, 20.0f, 150.0f));
	//movingCamera->ModelRotate(glm::vec3(0.0f, 1.0f, 0.0f), 3.141592f);

	// 0, 1, 2, 3, 4
	Material fluidMat, planeMat, sphereMat, lightMat, areaLightMat;
	fluidMat.ambient = 1.0f;
	fluidMat.albedo = glm::vec3(0.0f, 0.0f, 0.0f);
	fluidMat.refractiveIndex = 1.2f;
	fluidMat.metallic = 0.0f;
	fluidMat.roughness = 0.2f;
	materials.push_back(fluidMat);

	// 줄무늬 텍스쳐
	planeMat.ambient = 1.0f;
	planeMat.albedo = glm::vec3(1.0f, 1.0f, 1.0f);
	planeMat.metallic = 0.0f;
	planeMat.roughness = 0.5f;
	planeMat.texId = 1;
	materials.push_back(planeMat);

	// PBR 텍스쳐
	sphereMat.ambient = 1.0f;
	sphereMat.albedo = glm::vec3(0.1f, 0.1f, 0.1f);
	sphereMat.metallic = 0.0f;
	sphereMat.roughness = 0.2f;
	sphereMat.texId = 0;
	materials.push_back(sphereMat);

	// light 텍스쳐
	lightMat.ambient = 1.0f;
	lightMat.albedo = glm::vec3(1.0f, 1.0f, 0.0f);
	lightMat.emission = glm::vec3(1.0f, 1.0f, 0.0f);
	lightMat.metallic = 0.2f;
	lightMat.roughness = 0.2f;
	materials.push_back(lightMat);

	areaLightMat.ambient = 1.0f;
	areaLightMat.albedo = glm::vec3(0.2f, 0.2f, 0.2f);
	areaLightMat.emission = glm::vec3(1.0f, 1.0f, 1.0f);
	materials.push_back(areaLightMat);

	// 5, 6, 7, 8
	Material redPlaneMat, greenPlaneMat, bluePlaneMat, flatPlaneMat;

	redPlaneMat.ambient = 1.0f;
	redPlaneMat.albedo = glm::vec3(0.0f, 0.0f, 0.0f);
	redPlaneMat.emission = glm::vec3(50.0f, 0.0f, 0.0f);
	redPlaneMat.metallic = 0.1f;
	redPlaneMat.roughness = 0.8f;
	materials.push_back(redPlaneMat);

	greenPlaneMat.ambient = 1.0f;
	greenPlaneMat.albedo = glm::vec3(0.0f, 0.0f, 0.0f);
	greenPlaneMat.emission = glm::vec3(0.0f, 50.0f, 0.0f);
	greenPlaneMat.metallic = 0.1f;
	greenPlaneMat.roughness = 1.0f;
	materials.push_back(greenPlaneMat);

	bluePlaneMat.ambient = 1.0f;
	bluePlaneMat.albedo = glm::vec3(0.0f, 0.0f, 0.0f);
	bluePlaneMat.emission = glm::vec3(0.0f, 0.0f, 50.0f);
	bluePlaneMat.metallic = 0.1f;
	bluePlaneMat.roughness = 0.8f;
	materials.push_back(bluePlaneMat);

	flatPlaneMat.ambient = 1.0f;
	flatPlaneMat.albedo = glm::vec3(0.3f, 0.3f, 0.3f);
	flatPlaneMat.emission = glm::vec3(0.5f, 0.5f, 0.5f);
	flatPlaneMat.metallic = 0.1f;
	flatPlaneMat.roughness = 0.8f;
	materials.push_back(flatPlaneMat);

	LoadPathTracingScene();
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

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_G))
	{
		lights[0].pos += glm::vec3(0.0f, moveSpeed, 0.0f);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_B))
	{
		lights[0].pos += glm::vec3(0.0f, -moveSpeed, 0.0f);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_V))
	{
		lights[0].pos += glm::vec3(-moveSpeed, 0.0f, 0.0f);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_N))
	{
		lights[0].pos += glm::vec3(moveSpeed, 0.0f, 0.0f);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_F))
	{
		lights[0].pos += glm::vec3(0.0f, 0.0f, moveSpeed);
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_H))
	{
		lights[0].pos += glm::vec3(0.0f, 0.0f, -moveSpeed);
	}

	spheres[lightSphereId].origin = lights[0].pos;
}

vector<Triangle> RayTracingSceneManager::LoadPlaneTriangles(glm::mat4 model, const int materialId)
{
	vector<Triangle> triangles;

	// 밑에 깔린 plane임
	Triangle halfPlane1, halfPlane2;
	halfPlane1.v0 = glm::vec3(model * vec4(-1.0f, 0.0f, 1.0f, 1.0f));
	halfPlane1.v1 = glm::vec3(model * vec4(1.0f, 0.0f, 1.0f, 1.0f));
	halfPlane1.v2 = glm::vec3(model * vec4(-1.0f, 0.0f, -1.0f, 1.0f));
	halfPlane1.normal = glm::normalize(model * glm::vec4(0.0f, 1.0f, 0.0f, 0.0f));

	halfPlane1.v0normal = halfPlane1.normal;
	halfPlane1.v0uv = vec2(0.0f, 0.0f);
	halfPlane1.v1normal = halfPlane1.normal;
	halfPlane1.v1uv = vec2(1.0f, 0.0f);
	halfPlane1.v2normal = halfPlane1.normal;
	halfPlane1.v2uv = vec2(0.0f, 1.0f);

	halfPlane1.tangent = glm::normalize(halfPlane1.v2 - halfPlane1.v0);
	halfPlane1.bitangent = glm::cross(halfPlane1.tangent, halfPlane1.normal);

	halfPlane1.materialId = materialId;
	triangles.push_back(halfPlane1);

	///////////////////////////////////////////////////////////////////////////

	halfPlane2.v0 = glm::vec3(model * vec4(1.0f, 0.0f, 1.0f, 1.0f));
	halfPlane2.v1 = glm::vec3(model * vec4(1.0f, 0.0f, -1.0f, 1.0f));
	halfPlane2.v2 = glm::vec3(model * vec4(-1.0f, 0.0f, -1.0f, 1.0f));
	halfPlane2.normal = glm::normalize(model * glm::vec4(0.0f, 1.0f, 0.0f, 0.0f));

	halfPlane2.v0normal = halfPlane2.normal;
	halfPlane2.v0uv = vec2(1.0f, 0.0f);
	halfPlane2.v1normal = halfPlane2.normal;
	halfPlane2.v1uv = vec2(1.0f, 1.0f);
	halfPlane2.v2normal = halfPlane2.normal;
	halfPlane2.v2uv = vec2(0.0f, 1.0f);

	halfPlane2.tangent = glm::normalize(halfPlane1.v2 - halfPlane1.v0);
	halfPlane2.bitangent = glm::cross(halfPlane1.tangent, halfPlane1.normal);

	halfPlane2.materialId = materialId;
	triangles.push_back(halfPlane2);

	return triangles;
}

void RayTracingSceneManager::InsertTriangles(const vector<Triangle>& triangles)
{
	this->triangles.insert(this->triangles.end(), triangles.begin(), triangles.end());
}

void RayTracingSceneManager::LoadFluidScene(const string meshfile)
{
	triangles.clear();
	lights.clear();
	spheres.clear();

	const float planeSize = 50.0f;

	// light
	Light light;
	light.pos = glm::vec3(0.0f, 20.0f, 20.0f);
	light.color = glm::vec3(500.0f, 500.0f, 500.0f);
	lights.push_back(light);

	Sphere sphere;
	sphere.origin = light.pos;
	sphere.radius = 1.0f;
	sphere.materialId = 3;
	spheres.push_back(sphere);

	// Ray Tracing
	// floor
	//glm::mat4 planeModel = glm::mat4();
	//planeModel = glm::translate(planeModel, glm::vec3(0.0f, 1.0f, 0.0f));
	//planeModel = glm::scale(planeModel, glm::vec3(100.0f, 1.0f, 100.0f));
	//InsertTriangles(LoadPlaneTriangles(planeModel, 1));

	//// back
	//planeModel = glm::mat4();
	//planeModel = glm::translate(planeModel, glm::vec3(0.0f, 1.0f, -50.0f));
	//planeModel = glm::rotate(planeModel, 1.57079f, glm::vec3(1.0f, 0.0f, 0.0f));
	//planeModel = glm::scale(planeModel, glm::vec3(100.0f, 1.0f, 100.0f));
	//InsertTriangles(LoadPlaneTriangles(planeModel, 1));

	// rusted iron sphere 1
	glm::mat4 sphereModel = glm::mat4();
	sphereModel = glm::translate(sphereModel, glm::vec3(30.0f, 20.0f, 0.0f));
	sphereModel = glm::scale(sphereModel, glm::vec3(10.0f, 10.0f, 10.0f));
	InsertTriangles(LoadMeshTriangles("Obj/Sphere.obj", sphereModel, 2));

	//// rusted iron sphere 2
	//sphereModel = glm::mat4();
	//sphereModel = glm::translate(sphereModel, glm::vec3(25.0f, 25.0f, 0.0f));
	//sphereModel = glm::scale(sphereModel, glm::vec3(5.0f, 5.0f, 5.0f));
	//InsertTriangles(LoadMeshTriangles("Obj/Sphere.obj", sphereModel, 2));

	// Path Tracing
	// floor
	glm::mat4 planeModel = glm::mat4();
	planeModel = glm::translate(planeModel, glm::vec3(0.0f, 0.9f, 0.0f));
	planeModel = glm::scale(planeModel, glm::vec3(planeSize, 1.0f, planeSize));
	InsertTriangles(LoadPlaneTriangles(planeModel, 8));

	// g, back 
	planeModel = glm::mat4();
	planeModel = glm::translate(planeModel, glm::vec3(0.0f, 0.0f, -50.0f));
	planeModel = glm::rotate(planeModel, 1.57079f, glm::vec3(1.0f, 0.0f, 0.0f));
	planeModel = glm::scale(planeModel, glm::vec3(planeSize, 1.0f, planeSize));
	InsertTriangles(LoadPlaneTriangles(planeModel, 6));

	// r, left
	planeModel = glm::mat4();
	planeModel = glm::translate(planeModel, glm::vec3(45.0f, 0.0f, 0.0f));
	planeModel = glm::rotate(planeModel, 1.57079f, glm::vec3(0.0f, 0.0f, 1.0f));
	planeModel = glm::scale(planeModel, glm::vec3(planeSize, 1.0f, planeSize));
	InsertTriangles(LoadPlaneTriangles(planeModel, 7));

	// b, right
	planeModel = glm::mat4();
	planeModel = glm::translate(planeModel, glm::vec3(-45.0f, 0.0f, 0.0f));
	planeModel = glm::rotate(planeModel, 1.57079f, glm::vec3(0.0f, 0.0f, -1.0f));
	planeModel = glm::scale(planeModel, glm::vec3(planeSize, 1.0f, planeSize));
	InsertTriangles(LoadPlaneTriangles(planeModel, 5));

	// fluid
	InsertTriangles(LoadMeshTriangles(meshfile, glm::mat4(), 0));
	//InsertTriangles(LoadMeshTriangles(meshfile, glm::translate( glm::vec3(0.0f, 0.0f, -30.0f)), 0));
}

void RayTracingSceneManager::LoadPathTracingScene()
{
	triangles.clear();
	lights.clear();
	spheres.clear();

	const float planeSize = 50.0f;

	// light
	Light light;
	light.pos = glm::vec3(0.0f, 20.0f, 20.0f);
	light.color = glm::vec3(1000.0f, 1000.0f, 1000.0f);
	lights.push_back(light);

	Sphere sphere;
	sphere.origin = light.pos;
	sphere.radius = 3.0f;
	sphere.materialId = 3;
	spheres.push_back(sphere);

	// floor
	glm::mat4 planeModel = glm::mat4();
	planeModel = glm::translate(planeModel, glm::vec3(0.0f, -planeSize/2, 0.0f));
	planeModel = glm::scale(planeModel, glm::vec3(planeSize, 1.0f, planeSize));
	InsertTriangles(LoadPlaneTriangles(planeModel, 1));

	// g
	planeModel = glm::mat4();
	planeModel = glm::translate(planeModel, glm::vec3(0.0f, 0.0f, -50.0f));
	planeModel = glm::rotate(planeModel, 1.57079f, glm::vec3(1.0f, 0.0f, 0.0f));
	planeModel = glm::scale(planeModel, glm::vec3(planeSize, 1.0f, planeSize));
	InsertTriangles(LoadPlaneTriangles(planeModel, 6));

	// r
	planeModel = glm::mat4();
	planeModel = glm::translate(planeModel, glm::vec3(45.0f, 0.0f, 0.0f));
	planeModel = glm::rotate(planeModel, 1.57079f, glm::vec3(0.0f, 0.0f, 1.0f));
	planeModel = glm::scale(planeModel, glm::vec3(planeSize, 1.0f, planeSize));
	InsertTriangles(LoadPlaneTriangles(planeModel, 7));

	// b
	planeModel = glm::mat4();
	planeModel = glm::translate(planeModel, glm::vec3(-45.0f, 0.0f, 0.0f));
	planeModel = glm::rotate(planeModel, 1.57079f, glm::vec3(0.0f, 0.0f, -1.0f));
	planeModel = glm::scale(planeModel, glm::vec3(planeSize, 1.0f, planeSize));
	InsertTriangles(LoadPlaneTriangles(planeModel, 5));
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

		glm::vec3 tangent, bitangent;

		glm::vec3 edge1 = triangles[i].v1 - triangles[i].v0;
		glm::vec3 edge2 = triangles[i].v2 - triangles[i].v0;
		glm::vec2 deltaUV1 = triangles[i].v1uv - triangles[i].v0uv;
		glm::vec2 deltaUV2 = triangles[i].v2uv - triangles[i].v0uv;

		GLfloat f = 1.0f / (deltaUV1.x * deltaUV2.y - deltaUV2.x * deltaUV1.y);

		tangent.x = f * (deltaUV2.y * edge1.x - deltaUV1.y * edge2.x);
		tangent.y = f * (deltaUV2.y * edge1.y - deltaUV1.y * edge2.y);
		tangent.z = f * (deltaUV2.y * edge1.z - deltaUV1.y * edge2.z);
		tangent = glm::normalize(tangent);

		bitangent.x = f * (-deltaUV2.x * edge1.x + deltaUV1.x * edge2.x);
		bitangent.y = f * (-deltaUV2.x * edge1.y + deltaUV1.x * edge2.y);
		bitangent.z = f * (-deltaUV2.x * edge1.z + deltaUV1.x * edge2.z);
		bitangent = glm::normalize(bitangent);

		triangles[i].tangent = tangent;
		triangles[i].bitangent = bitangent;
		
		triangles[i].materialId = materialId;
	}

	return triangles;
}


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