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
	cudaMemset(output, 0, WindowManager::GetInstance()->width * WindowManager::GetInstance()->height);

	glm::mat4 view;
	//view = glm::lookAt(
		//camera->GetWorldPosition(), 
		//camera->GetWorldPosition() - glm::vec3(camera->GetRotate() * glm::vec4(cameraInitPos, 0.0f)), 
		//glm::vec3(glm::vec4(0.0f, 1.0f, 0.0f, 0.0f)));
	view = glm::inverse(camera->GetModelMatrix());

	// 여기서 render가 다 일어남
	RayTrace(output, view);

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