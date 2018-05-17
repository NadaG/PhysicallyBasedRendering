#include "RayTracingRenderer.h"

#include <chrono>
#include <cuda_runtime.h>
#include <cuda_gl_interop.h>

using namespace std::chrono;

void RayTracingRenderer::InitializeRender()
{
	debugQuadShader->Use();
	debugQuadShader->BindTexture(&rayTracingTex, "map");

	rayTracingTex.LoadTexture(
		GL_RGBA16F,
		WindowManager::GetInstance()->width,
		WindowManager::GetInstance()->height,
		GL_RGBA,
		GL_FLOAT);
	rayTracingTex.SetParameters(GL_LINEAR, GL_LINEAR, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);

	glGenBuffers(1, &rayTracePBO);
	glBindBuffer(GL_PIXEL_UNPACK_BUFFER, rayTracePBO);
	glBufferData(
		GL_PIXEL_UNPACK_BUFFER, 
		WindowManager::GetInstance()->width * WindowManager::GetInstance()->height * sizeof(GLfloat) * 4, 
		0, 
		GL_STREAM_DRAW);

	cudaGraphicsGLRegisterBuffer(&cuda_pbo_resource, rayTracePBO, cudaGraphicsMapFlagsWriteDiscard);

	vector<Triangle> triangles = dynamic_cast<RayTracingSceneManager*>(sceneManager)->triangles;
	vector<Sphere> spheres = dynamic_cast<RayTracingSceneManager*>(sceneManager)->spheres;
	AABB aabb;
	aabb.bounds[0] = glm::vec3(0.0f);
	aabb.bounds[1] = glm::vec3(0.0f);
	for (int i = 0; i < triangles.size(); i++)
	{
		aabb.bounds[0].x = 
			min(min(min(triangles[i].v0.x, triangles[i].v1.x), triangles[i].v2.x), aabb.bounds[0].x);
		aabb.bounds[0].y = 
			min(min(min(triangles[i].v0.y, triangles[i].v1.y), triangles[i].v2.y), aabb.bounds[0].y);
		aabb.bounds[0].z = 
			min(min(min(triangles[i].v0.z, triangles[i].v1.z), triangles[i].v2.z), aabb.bounds[0].z);

		aabb.bounds[1].x =
			max(max(max(triangles[i].v0.x, triangles[i].v1.x), triangles[i].v2.x), aabb.bounds[1].x);
		aabb.bounds[1].y =
			max(max(max(triangles[i].v0.y, triangles[i].v1.y), triangles[i].v2.y), aabb.bounds[1].y);
		aabb.bounds[1].z =
			max(max(max(triangles[i].v0.z, triangles[i].v1.z), triangles[i].v2.z), aabb.bounds[1].z);
	}
	
	for (int i = 0; i < spheres.size(); i++)
	{
		aabb.bounds[0].x = min(spheres[i].origin.x - spheres[i].radius, aabb.bounds[0].x);
		aabb.bounds[0].y = min(spheres[i].origin.y - spheres[i].radius, aabb.bounds[0].y);
		aabb.bounds[0].z = min(spheres[i].origin.z - spheres[i].radius, aabb.bounds[0].z);

		aabb.bounds[1].x = max(spheres[i].origin.x + spheres[i].radius, aabb.bounds[1].x);
		aabb.bounds[1].y = max(spheres[i].origin.y + spheres[i].radius, aabb.bounds[1].y);
		aabb.bounds[1].z = max(spheres[i].origin.z + spheres[i].radius, aabb.bounds[1].z);
	}

	objects.push_back(aabb);

	/*char tmp[1024];
	for (int i = 0; i < 500; i++)
	{
		sprintf(tmp, "%04d", i);
		string infile = "";
		string outfile = "";
		infile += "Obj/PouringFluid/";
		infile += tmp;
		infile += ".obj";
		dynamic_cast<RayTracingSceneManager*>(sceneManager)->LoadMesh(infile);

		outfile += "fluid_raytracing/new";
		outfile += tmp;
		outfile += ".png";
		OfflineRender(outfile);
		cout << i << "번째 프레임 그리는 중" << endl;
		Sleep(5000.0f);
	}*/


	/*dynamic_cast<RayTracingSceneManager*>(sceneManager)->LoadMesh("Obj/PouringFluid/0000.obj");
	OfflineRender("0000000.png");
	Sleep(1000.0f);*/
}

// glm의 cross(a, b)는 오른손으로 a방향에서 b방향으로 감싸쥘 때의 엄지방향이다.
void RayTracingRenderer::Render()
{
	//return;

	milliseconds bms = duration_cast<milliseconds>(system_clock::now().time_since_epoch());

	Object* camera = sceneManager->movingCamera;

	vector<Triangle> triangles = dynamic_cast<RayTracingSceneManager*>(sceneManager)->triangles;
	vector<Sphere> spheres = dynamic_cast<RayTracingSceneManager*>(sceneManager)->spheres;
	vector<Light> lights = dynamic_cast<RayTracingSceneManager*>(sceneManager)->lights;
	vector<Material> materials = dynamic_cast<RayTracingSceneManager*>(sceneManager)->materials;
	OctreeNode* root = dynamic_cast<RayTracingSceneManager*>(sceneManager)->root;

	glViewport(0, 0, WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);
	UseDefaultFBO();
	ClearDefaultFBO();

	// render start //
	cudaGraphicsMapResources(1, &cuda_pbo_resource, 0);

	//float4* output;
	glm::vec4* output;
	size_t num_bytes;
	// cuda memory로부터 cpu memory로 포인터 위치를 가져오는 건가?
	cudaGraphicsResourceGetMappedPointer((void**)&output, &num_bytes, cuda_pbo_resource);

	// 각 픽셀마다 rgba
	// count만큼의 크기의 device 메모리 영역(devPtr부터 시작)에 value로 값을 셋팅 
	cudaMemset(output, 0, WindowManager::GetInstance()->width * WindowManager::GetInstance()->height * 16);

	glm::mat4 view = camera->GetModelMatrix();
	// camera의 model matrix의 inverse가 바로 view matrix
	// view = glm::inverse(camera->GetModelMatrix());

	// 여기서 render가 다 일어남
	RayTrace(output, view, root, objects, triangles, spheres, lights, materials);

	cudaGraphicsUnmapResources(1, &cuda_pbo_resource, 0);

	glBindBuffer(GL_PIXEL_UNPACK_BUFFER, rayTracePBO);
	glBindTexture(GL_TEXTURE_2D, rayTracingTex.GetTexture());
	// pixels를 0으로 함으로써 연결된 PBO로 부터 픽셀 정보를 가져옴
	glTexSubImage2D(
		GL_TEXTURE_2D, 0, 0, 0,
		WindowManager::GetInstance()->width,
		WindowManager::GetInstance()->height,
		GL_RGBA, GL_FLOAT, 0);
	glBindBuffer(GL_PIXEL_UNPACK_BUFFER, 0);
	// render end // 

	SceneObject& quad = sceneManager->quadObj;
	quad.DrawModel();

	milliseconds ams = duration_cast<milliseconds>(system_clock::now().time_since_epoch());
	cout << ams.count() - bms.count() << " milliseconds" << endl;
}

void RayTracingRenderer::TerminateRender()
{
}

void RayTracingRenderer::OfflineRender(const string outfile)
{
	milliseconds bms = duration_cast<milliseconds>(system_clock::now().time_since_epoch());

	Object* camera = sceneManager->movingCamera;

	vector<Triangle> triangles = dynamic_cast<RayTracingSceneManager*>(sceneManager)->triangles;
	vector<Sphere> spheres = dynamic_cast<RayTracingSceneManager*>(sceneManager)->spheres;
	vector<Light> lights = dynamic_cast<RayTracingSceneManager*>(sceneManager)->lights;
	vector<Material> materials = dynamic_cast<RayTracingSceneManager*>(sceneManager)->materials;
	OctreeNode* root = dynamic_cast<RayTracingSceneManager*>(sceneManager)->root;

	glViewport(0, 0, WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);
	UseDefaultFBO();
	ClearDefaultFBO();

	// render start //
	cudaGraphicsMapResources(1, &cuda_pbo_resource, 0);

	//float4* output;
	glm::vec4* output;
	size_t num_bytes;
	// cuda memory로부터 cpu memory로 포인터 위치를 가져오는 건가?
	cudaGraphicsResourceGetMappedPointer((void**)&output, &num_bytes, cuda_pbo_resource);

	// 각 픽셀마다 rgba
	// count만큼의 크기의 device 메모리 영역(devPtr부터 시작)에 value로 값을 셋팅 
	cudaMemset(output, 0, WindowManager::GetInstance()->width * WindowManager::GetInstance()->height * 16);

	glm::mat4 view;
	// camera의 model matrix의 inverse가 바로 view matrix
	// y가 뒤바뀌는 이유
	view = glm::inverse(camera->GetModelMatrix());

	// 여기서 render가 다 일어남
	RayTrace(output, view, root, objects, triangles, spheres, lights, materials);

	cudaGraphicsUnmapResources(1, &cuda_pbo_resource, 0);

	glBindBuffer(GL_PIXEL_UNPACK_BUFFER, rayTracePBO);
	glBindTexture(GL_TEXTURE_2D, rayTracingTex.GetTexture());
	// pixels를 0으로 함으로써 연결된 PBO로 부터 픽셀 정보를 가져옴
	glTexSubImage2D(
		GL_TEXTURE_2D, 0, 0, 0,
		WindowManager::GetInstance()->width,
		WindowManager::GetInstance()->height,
		GL_RGBA, GL_FLOAT, 0);
	glBindBuffer(GL_PIXEL_UNPACK_BUFFER, 0);
	// render end // 

	// draw on fbo
	/*SceneObject& quad = sceneManager->quadObj;
	quad.DrawModel();*/

	// draw on png
	pngExporter.WritePngFile(outfile, rayTracingTex, GL_RGB);

	milliseconds ams = duration_cast<milliseconds>(system_clock::now().time_since_epoch());
	cout << ams.count() - bms.count() << " milliseconds" << endl;
}
