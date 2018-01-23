#include "RayTracingRenderer.h"

void RayTracingRenderer::InitializeRender()
{
	UseDefaultFrameBufferObject();
	rayTracingShader = new ShaderProgram("Quad.vs", "RayTracing.fs");
	rayTracingShader->Use();
}

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

	// world 그리기
	rayTracingShader->Use();
	rayTracingShader->SetUniformMatrix4f("view", view);
	// 왜 반대로 되는 걸까??
	rayTracingShader->SetUniformVector3f("lightPos", glm::vec3(5.0f, 0.0f, -10.0f));
	quad.DrawModel();
}

void RayTracingRenderer::TerminateRender()
{
	rayTracingShader->Delete();
	delete rayTracingShader;
}