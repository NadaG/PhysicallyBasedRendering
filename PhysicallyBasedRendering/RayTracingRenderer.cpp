#include "RayTracingRenderer.h"

#include<cuda_runtime.h>
#include<cuda_gl_interop.h>

void RayTracingRenderer::InitializeRender()
{
	UseDefaultFrameBufferObject();
	rayTracingShader = new ShaderProgram("Quad.vs", "RayTracing.fs");
	rayTracingShader->Use();

	rayTracingFBO.GenFrameBufferObject();
	rayTracingFBO.BindDefaultDepthBuffer(WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);

	rayTracingTex.LoadTexture(
		GL_RGBA16F,
		WindowManager::GetInstance()->width,
		WindowManager::GetInstance()->height,
		GL_RGBA,
		GL_FLOAT);
	rayTracingTex.SetParameters(GL_LINEAR, GL_LINEAR, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);
	
	rayTracingFBO.BindTexture(GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, &rayTracingTex);
	rayTracingFBO.DrawBuffers();

	float* data = new float[3];
	// parameter로 데이터 불러오기
	TestFunction(data);

	glGenBuffers(1, &testPBO);
	glBindBuffer(GL_PIXEL_UNPACK_BUFFER, testPBO);
	glBufferData(
		GL_PIXEL_UNPACK_BUFFER, 
		WindowManager::GetInstance()->width * WindowManager::GetInstance()->height * sizeof(GLfloat) * 4, 
		0, 
		GL_STREAM_DRAW);

	cudaGraphicsResource* cuda_pbo_resource;
	cudaGraphicsGLRegisterBuffer(&cuda_pbo_resource, testPBO, cudaGraphicsMapFlagsWriteDiscard);

	// render start //
	cudaGraphicsMapResources(1, &cuda_pbo_resource, 0);

	float* output;
	size_t num_bytes;
	cudaGraphicsResourceGetMappedPointer((void**)&output, &num_bytes, cuda_pbo_resource);
	
	// 각 픽셀마다 rgba
	cudaMemset(output, 0, WindowManager::GetInstance()->width * WindowManager::GetInstance()->height * 4);

	pboTest(output);

	cudaGraphicsUnmapResources(1, &cuda_pbo_resource, 0);
	// render end // 

	glBindBuffer(GL_PIXEL_UNPACK_BUFFER, testPBO);
	glBindTexture(GL_TEXTURE_2D, rayTracingTex.GetTexture());
	glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, WindowManager::GetInstance()->width, WindowManager::GetInstance()->height,
		GL_RGBA, GL_FLOAT, 0);
	glBindBuffer(GL_PIXEL_UNPACK_BUFFER, 0);
}

// glm의 cross(a, b)는 오른손으로 a방향에서 b방향으로 감싸쥘 때의 엄지방향이다.
void RayTracingRenderer::Render()
{
	glViewport(0, 0, WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);

	Object* camera = sceneManager->movingCamera;
	SceneObject& quad = sceneManager->quadObj;

	glm::mat4 projection = glm::perspective(
		glm::radians(45.0f),
		WindowManager::GetInstance()->width / WindowManager::GetInstance()->height,
		0.01f,
		100.0f);

	glm::mat4 view = glm::lookAt(
		camera->GetWorldPosition(),
		camera->GetWorldPosition() + glm::vec3(glm::vec4(0.0f, 0.0f, -5.0f, 0.0f) * camera->GetRotate()),
		glm::vec3(0.0f, 1.0f, 0.0f)
	);

	view = glm::mat4();

	// world 그리기
	rayTracingShader->Use();
	rayTracingShader->SetUniformMatrix4f("view", view);
	rayTracingShader->SetUniformVector3f("lightPos", glm::vec3(5.0f, 0.0f, -5.0f));
	
	UseDefaultFrameBufferObject();
	quad.DrawModel();
	
	/*rayTracingFBO.Use();
	quad.DrawModel();*/

	if (writeFileNum < 5)
	{
		if(writeFileNum == 0)
			pngExporter.WritePngFile("bab.png", rayTracingTex);
		if (writeFileNum == 1)
			pngExporter.WritePngFile("bab1.png", rayTracingTex);
		writeFileNum++;
	}
}

void RayTracingRenderer::TerminateRender()
{
	rayTracingShader->Delete();
	delete rayTracingShader;
}