#include "RayTracingRenderer.h"

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
	hello(data);
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
	
	rayTracingFBO.Use();
	quad.DrawModel();

	if (writeFileNum < 5)
	{
		if(writeFileNum == 0)
			pngExporter.WritePngFile("bab.png", rayTracingTex);
		if (writeFileNum == 1)
			pngExporter.WritePngFile("bab1.png", rayTracingTex);
		if (writeFileNum == 2)
			pngExporter.WritePngFile("bab2.png", rayTracingTex);
		writeFileNum++;
	}

}

void RayTracingRenderer::TerminateRender()
{
	rayTracingShader->Delete();
	delete rayTracingShader;
}