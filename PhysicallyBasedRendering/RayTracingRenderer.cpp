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

	cudaGraphicsResource* cuda_pbo_resource;
	cudaGraphicsGLRegisterBuffer(&cuda_pbo_resource, rayTracePBO, cudaGraphicsMapFlagsWriteDiscard);

	// render start //
	cudaGraphicsMapResources(1, &cuda_pbo_resource, 0);

	float4* output;
	size_t num_bytes;
	cudaGraphicsResourceGetMappedPointer((void**)&output, &num_bytes, cuda_pbo_resource);
	
	// �� �ȼ����� rgba
	cudaMemset(output, 0, WindowManager::GetInstance()->width * WindowManager::GetInstance()->height);

	// ���⼭ render�� �� �Ͼ
	RayTrace(output);

	cudaGraphicsUnmapResources(1, &cuda_pbo_resource, 0);
	// render end // 

	glBindBuffer(GL_PIXEL_UNPACK_BUFFER, rayTracePBO);
	glBindTexture(GL_TEXTURE_2D, rayTracingTex.GetTexture());
	glTexSubImage2D(
		GL_TEXTURE_2D, 0, 0, 0, 
		WindowManager::GetInstance()->width, 
		WindowManager::GetInstance()->height,
		GL_RGBA, GL_FLOAT, 0);
	glBindBuffer(GL_PIXEL_UNPACK_BUFFER, 0);
}

// glm�� cross(a, b)�� ���������� a���⿡�� b�������� ������ ���� ���������̴�.
void RayTracingRenderer::Render()
{
	glViewport(0, 0, WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);
	UseDefaultFBO();
	ClearDefaultFBO();
	
	SceneObject& quad = sceneManager->quadObj;

	quad.DrawModel();

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