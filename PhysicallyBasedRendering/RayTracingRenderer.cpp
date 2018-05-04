#include "RayTracingRenderer.h"

#include <chrono>
#include <cuda_runtime.h>
#include <cuda_gl_interop.h>

using namespace std::chrono;

void RayTracingRenderer::InitializeRender()
{
	debugQuadShader->Use();
	// 셰이더는 이 텍스쳐를 그리겠다고 지정했음
	debugQuadShader->BindTexture(&rayTracingTex, "map");

	rayTracingTex.LoadTexture(
		GL_RGBA16F,
		WindowManager::GetInstance()->width,
		WindowManager::GetInstance()->height,
		GL_RGBA,
		GL_FLOAT);
	rayTracingTex.SetParameters(GL_LINEAR, GL_LINEAR, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);

	/*albedoTex.LoadTexture("Texture/SkyBox/front.jpg");
	albedoTex.SetParameters(GL_LINEAR, GL_LINEAR, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);

	unsigned char* frontArray = albedoTex.GetTexImage(GL_RGB, GL_UNSIGNED_BYTE);

	for (int i = 0; i < 30 * 30; i++)
	{
		albedoTexArray.push_back((float)frontArray[i] / 255.0f);
	}

	delete[] frontArray;*/

	glGenBuffers(1, &rayTracePBO);
	glBindBuffer(GL_PIXEL_UNPACK_BUFFER, rayTracePBO);
	glBufferData(
		GL_PIXEL_UNPACK_BUFFER, 
		WindowManager::GetInstance()->width * WindowManager::GetInstance()->height * sizeof(GLfloat) * 4, 
		0, 
		GL_STREAM_DRAW);

	cudaGraphicsGLRegisterBuffer(&cuda_pbo_resource, rayTracePBO, cudaGraphicsMapFlagsWriteDiscard);

	vector<Triangle> triangles = dynamic_cast<RayTracingSceneManager*>(sceneManager)->triangles;
	AABB aabb;
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
	objects.push_back(aabb);
}

// glm의 cross(a, b)는 오른손으로 a방향에서 b방향으로 감싸쥘 때의 엄지방향이다.
void RayTracingRenderer::Render()
{
	milliseconds bms = duration_cast<milliseconds>(system_clock::now().time_since_epoch());

	Object* camera = sceneManager->movingCamera;

	vector<Triangle> triangles = dynamic_cast<RayTracingSceneManager*>(sceneManager)->triangles;
	vector<Light> lights = dynamic_cast<RayTracingSceneManager*>(sceneManager)->lights;
	vector<Material> materials = dynamic_cast<RayTracingSceneManager*>(sceneManager)->materials;

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
	RayTrace(output, view, objects, triangles, lights, materials);

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
	SceneObject& quad = sceneManager->quadObj;
	quad.DrawModel();

	// draw on png
	if (writeFileNum < 5)
	{
		if(writeFileNum == 0)
			pngExporter.WritePngFile("bab.png", rayTracingTex);
		writeFileNum++;
	}
	milliseconds ams = duration_cast<milliseconds>(system_clock::now().time_since_epoch());
	cout << ams.count() - bms.count() << " milliseconds" << endl;
}

void RayTracingRenderer::TerminateRender()
{
}