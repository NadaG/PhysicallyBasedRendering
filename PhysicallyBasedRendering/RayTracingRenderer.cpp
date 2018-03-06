#include "RayTracingRenderer.h"

#include<cuda_runtime.h>
#include<cuda_gl_interop.h>

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

	cameraInitPos = sceneManager->movingCamera->GetWorldPosition();

	Light light;
	light.pos = glm::vec3(10.0f, -5.0f, 0.0f);
	light.color = glm::vec3(0.0f, 1.0f, 0.0f);
	lights.push_back(light);

	/*light.pos = glm::vec3(0.0f, 10.0f, 0.0f);
	light.color = glm::vec3(1.0f, 0.0f, 0.0f);
	lights.push_back(light);*/

	triangles = sceneManager->sceneObjs[0].GetTriangles();

	const float halfWidth = 20.0f;

	Triangle halfPlane1, halfPlane2;
	halfPlane1.v0 = glm::vec3(-halfWidth, 3.0f,  halfWidth);
	halfPlane1.v1 = glm::vec3(-halfWidth, 3.0f, -halfWidth);
	halfPlane1.v2 = glm::vec3( halfWidth, 3.0f,  halfWidth);
	halfPlane1.normal = glm::vec3(0.0f, 1.0f, 0.0f);
	triangles.push_back(halfPlane1);

	halfPlane2.v0 = glm::vec3( halfWidth, 3.0f,  halfWidth);
	halfPlane2.v1 = glm::vec3(-halfWidth, 3.0f, -halfWidth);
	halfPlane2.v2 = glm::vec3( halfWidth, 3.0f, -halfWidth);
	halfPlane2.normal = glm::vec3(0.0f, 1.0f, 0.0f);
	triangles.push_back(halfPlane2);
}

// glm의 cross(a, b)는 오른손으로 a방향에서 b방향으로 감싸쥘 때의 엄지방향이다.
void RayTracingRenderer::Render()
{
	Object* camera = sceneManager->movingCamera;

	glViewport(0, 0, WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);
	UseDefaultFBO();
	ClearDefaultFBO();
	
	// render start //
	cudaGraphicsMapResources(1, &cuda_pbo_resource, 0);

	//float4* output;
	glm::vec4* output;
	size_t num_bytes;
	cudaGraphicsResourceGetMappedPointer((void**)&output, &num_bytes, cuda_pbo_resource);

	// 각 픽셀마다 rgba
	cudaMemset(output, 0, WindowManager::GetInstance()->width * WindowManager::GetInstance()->height * 16);

	glm::mat4 view;
	// camera의 model matrix의 inverse가 바로 view matrix
	// y가 뒤바뀌는 이유
	view = glm::inverse(camera->GetModelMatrix());

	// 여기서 render가 다 일어남
	RayTrace(output, view, triangles, lights);

	cudaGraphicsUnmapResources(1, &cuda_pbo_resource, 0);

	glBindBuffer(GL_PIXEL_UNPACK_BUFFER, rayTracePBO);
	glBindTexture(GL_TEXTURE_2D, rayTracingTex.GetTexture());
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
}

void RayTracingRenderer::TerminateRender()
{
}