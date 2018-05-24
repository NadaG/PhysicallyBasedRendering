#include "RayTracingSceneManager.h"

void RayTracingSceneManager::InitializeObjects()
{
	quadObj.LoadModel(QUAD);
	movingCamera->WorldTranslate(glm::vec3(0.0f, 20.0f, 110.0f));

	Light light;
	light.pos = glm::vec3(0.0f, 30.0f, 50.0f);
	light.color = glm::vec3(1.0f, 1.0f, 1.0f);
	lights.push_back(light);

	Material fluidMat, planeMat, sphereMat, lightMat, areaLightMat, planeMat2;
	fluidMat.ambient = glm::vec3(0.0f, 0.0f, 0.0f);
	fluidMat.diffuse = glm::vec3(0.2f, 0.2f, 0.3f);
	fluidMat.specular = glm::vec3(0.2f, 0.2f, 0.3f);
	fluidMat.refractivity = 0.8f;
	fluidMat.reflectivity = 0.0f;
	materials.push_back(fluidMat);

	planeMat.ambient = glm::vec3(0.1f, 0.1f, 0.1f);
	planeMat.diffuse = glm::vec3(0.5f, 0.5f, 0.5f);
	planeMat.specular = glm::vec3(0.2f, 0.2f, 0.2f);
	planeMat.refractivity = 0.0f;
	planeMat.reflectivity = 0.8f;
	materials.push_back(planeMat);

	sphereMat.ambient = glm::vec3(0.1f, 0.1f, 0.1f);
	sphereMat.diffuse = glm::vec3(0.2f, 0.3f, 0.9f);
	sphereMat.specular = glm::vec3(0.9f, 0.2f, 0.2f);
	sphereMat.refractivity = 0.0f;
	sphereMat.reflectivity = 0.0f;
	sphereMat.texId = 0;
	materials.push_back(sphereMat);

	lightMat.ambient = glm::vec3(1.0f, 1.0f, 0.0f);
	lightMat.diffuse = glm::vec3(0.0f, 0.0f, 0.0f);
	lightMat.specular = glm::vec3(0.0f, 0.0f, 0.0f);
	lightMat.refractivity = 0.0f;
	lightMat.reflectivity = 0.0f;
	materials.push_back(lightMat);

	areaLightMat.ambient = glm::vec3(0.2f, 0.2f, 0.2f);
	areaLightMat.diffuse = glm::vec3(0.0f, 0.0f, 0.0f);
	areaLightMat.specular = glm::vec3(0.0f, 0.0f, 0.0f);
	areaLightMat.emission = glm::vec3(1.0f, 1.0f, 1.0f);
	areaLightMat.refractivity = 0.0f;
	areaLightMat.reflectivity = 0.0f;
	materials.push_back(areaLightMat);

	planeMat2.ambient = glm::vec3(0.1f, 0.5f, 0.1f);
	planeMat2.diffuse = glm::vec3(0.5f, 0.7f, 0.5f);
	planeMat2.specular = glm::vec3(0.2f, 0.2f, 0.2f);
	planeMat2.refractivity = 0.0f;
	planeMat2.reflectivity = 0.8f;
	materials.push_back(planeMat2);

	/*sphereMat2.ambient = glm::vec3(0.3f, 0.1f, 0.1f);
	sphereMat2.diffuse = glm::vec3(0.9f, 0.3f, 0.3f);
	sphereMat2.specular = glm::vec3(0.9f, 0.2f, 0.2f);
	sphereMat2.refractivity = 0.0f;
	sphereMat2.reflectivity = 0.0f;
	materials.push_back(sphereMat2);*/

	// light
	Sphere sphere;
	sphere.origin = light.pos;
	sphere.radius = 1.0f;
	sphere.materialId = 3;
	spheres.push_back(sphere);

	/*sphere.origin = glm::vec3(0.0f, 20.0f, 0.0f);
	sphere.radius = 5.0f;
	sphere.materialId = 2;
	spheres.push_back(sphere);*/

	glm::mat4 sphereModel = glm::mat4();
	sphereModel = glm::translate(sphereModel, glm::vec3(0.0f, 15.0f, 0.0f));
	sphereModel = glm::rotate(sphereModel, 0.0f, glm::vec3(0.0f, 1.0f, 0.0f));
	sphereModel = glm::scale(sphereModel, glm::vec3(15.0f, 15.0f, 15.0f));
	InsertTriangles(LoadMeshTriangles("Obj/Sphere.obj", sphereModel, 2));

	glm::mat4 planeModel = glm::mat4();
	planeModel = glm::translate(planeModel, glm::vec3(0.0f, -5.0f, 0.0f));
	planeModel = glm::scale(planeModel, glm::vec3(100.0f, 1.0f, 100.0f));
	InsertTriangles(LoadPlaneTriangles(planeModel, 1));

	planeModel = glm::mat4();
	planeModel = glm::translate(planeModel, glm::vec3(0.0f, 0.0f, -50.0f));
	planeModel = glm::rotate(planeModel, 1.57079f, glm::vec3(1.0f, 0.0f, 0.0f));
	planeModel = glm::scale(planeModel, glm::vec3(50.0f, 1.0f, 50.0f));
	InsertTriangles(LoadPlaneTriangles(planeModel, 5));

	/*planeModel = glm::mat4();
	planeModel = glm::translate(planeModel, glm::vec3(0.0f, 10.0f, -40.0f));
	planeModel = glm::rotate(planeModel, 1.07079f, glm::vec3(1.0f, 0.0f, 0.0f));
	planeModel = glm::scale(planeModel, glm::vec3(20.0f, 1.0f, 20.0f));
	InsertTriangles(LoadPlaneTriangles(planeModel, 4));*/
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

	//// for demo
	//if (InputManager::GetInstance()->IsKey(GLFW_KEY_1))
	//{
	//	if (spheres.size() == 1)
	//	{
	//		// sphere
	//		Sphere sphere;
	//		sphere.origin = glm::vec3(20.0f, 10.0f, 25.0f);
	//		sphere.radius = 5.0f;
	//		sphere.materialId = 2;
	//		spheres.push_back(sphere);
	//	}
	//}

	//// for demo
	//if (InputManager::GetInstance()->IsKey(GLFW_KEY_2))
	//{
	//	if (spheres.size() == 2)
	//	{
	//		glm::mat4 torusModel = glm::mat4();
	//		torusModel = glm::translate(torusModel, glm::vec3(-20.0f, 20.0f, 0.0f));
	//		torusModel = glm::scale(torusModel, glm::vec3(5.0f, 5.0f, 5.0f));
	//		InsertTriangles(LoadMeshTriangles("Obj/torus.obj", torusModel, 0));
	//	}
	//}

	//// for demo
	//if (InputManager::GetInstance()->IsKey(GLFW_KEY_3))
	//{
	//}

	//// for demo
	//if (InputManager::GetInstance()->IsKey(GLFW_KEY_4))
	//{
	//	materials[0].refractivity -= 0.01f;
	//}

	//// for demo
	//if (InputManager::GetInstance()->IsKey(GLFW_KEY_5))
	//{
	//	materials[0].refractivity += 0.01f;
	//}

	//// for demo
	//if (InputManager::GetInstance()->IsKey(GLFW_KEY_6))
	//{
	//	materials[2].reflectivity -= 0.01f;
	//}

	//// for demo
	//if (InputManager::GetInstance()->IsKey(GLFW_KEY_7))
	//{
	//	materials[2].reflectivity += 0.01f;
	//}
}



vector<Triangle> RayTracingSceneManager::LoadPlaneTriangles(glm::mat4 model, const int materialId)
{
	// 밑에 깔린 plane임
	Triangle halfPlane1, halfPlane2;
	halfPlane1.v0 = glm::vec3(model * vec4(-1.0f, 0.0f, 1.0f, 1.0f));
	halfPlane1.v1 = glm::vec3(model * vec4(1.0f, 0.0f, 1.0f, 1.0f));
	halfPlane1.v2 = glm::vec3(model * vec4(-1.0f, 0.0f, -1.0f, 1.0f));
	halfPlane1.normal = model * glm::vec4(0.0f, 1.0f, 0.0f, 0.0f);

	halfPlane1.v0normal = halfPlane1.normal;
	halfPlane1.v0uv = vec2(0.0f, 0.0f);
	halfPlane1.v1normal = halfPlane1.normal;
	halfPlane1.v1uv = vec2(1.0f, 0.0f);
	halfPlane1.v2normal = halfPlane1.normal;
	halfPlane1.v2uv = vec2(0.0f, 1.0f);
	halfPlane1.materialId = materialId;
	triangles.push_back(halfPlane1);

	halfPlane2.v0 = glm::vec3(model * vec4(1.0f, 0.0f, 1.0f, 1.0f));
	halfPlane2.v1 = glm::vec3(model * vec4(1.0f, 0.0f, -1.0f, 1.0f));
	halfPlane2.v2 = glm::vec3(model * vec4(-1.0f, 0.0f, -1.0f, 1.0f));
	halfPlane2.normal = model * glm::vec4(0.0f, 1.0f, 0.0f, 0.0f);

	halfPlane2.v0normal = halfPlane2.normal;
	halfPlane2.v0uv = vec2(1.0f, 0.0f);
	halfPlane2.v1normal = halfPlane2.normal;
	halfPlane2.v1uv = vec2(1.0f, 1.0f);
	halfPlane2.v2normal = halfPlane2.normal;
	halfPlane2.v2uv = vec2(0.0f, 1.0f);
	halfPlane2.materialId = materialId;
	triangles.push_back(halfPlane2);

	return triangles;
}

void RayTracingSceneManager::InsertTriangles(vector<Triangle> triangles)
{
	this->triangles.insert(this->triangles.end(), triangles.begin(), triangles.end());
}

void RayTracingSceneManager::LoadFluidScene(const string meshfile)
{
	triangles.clear();

	glm::mat4 planeModel = glm::mat4();
	planeModel = glm::translate(planeModel, glm::vec3(0.0f, -5.0f, 0.0f));
	planeModel = glm::scale(planeModel, glm::vec3(100.0f, 1.0f, 100.0f));
	InsertTriangles(LoadPlaneTriangles(planeModel, 1));

	planeModel = glm::mat4();
	planeModel = glm::translate(planeModel, glm::vec3(0.0f, 0.0f, -50.0f));
	planeModel = glm::rotate(planeModel, 1.57079f, glm::vec3(1.0f, 0.0f, 0.0f));
	planeModel = glm::scale(planeModel, glm::vec3(100.0f, 1.0f, 100.0f));
	InsertTriangles(LoadPlaneTriangles(planeModel, 1));

	glm::mat4 sphereModel = glm::mat4();
	sphereModel = glm::translate(sphereModel, glm::vec3(10.0f, 20.0f, 0.0f));
	sphereModel = glm::scale(sphereModel, glm::vec3(10.0f, 10.0f, 10.0f));
	InsertTriangles(LoadMeshTriangles("Obj/sphere.obj", sphereModel, 2));

	sphereModel = glm::mat4();
	sphereModel = glm::translate(sphereModel, glm::vec3(25.0f, 25.0f, 0.0f));
	sphereModel = glm::scale(sphereModel, glm::vec3(5.0f, 5.0f, 5.0f));
	InsertTriangles(LoadMeshTriangles("Obj/sphere.obj", sphereModel, 2));

	InsertTriangles(LoadMeshTriangles(meshfile, glm::mat4(), 0));
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