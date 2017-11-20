#include "LTCRenderer.h"

void LTCRenderer::InitializeRender()
{
	UseDefaultFrameBufferObject();
	ltcShader = new ShaderProgram("Quad.vs", "LTC.fs");
	ltcShader->Use();
}

void LTCRenderer::Render()
{
	glViewport(0, 0, WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);

	SceneObject& camera = sceneManager->cameraObj;
	SceneObject& quad = sceneManager->quadObj;

	glm::mat4 projection = glm::perspective(
		glm::radians(45.0f),
		WindowManager::GetInstance()->width / WindowManager::GetInstance()->height,
		0.01f,
		100.0f);

	glm::mat4 view = glm::lookAt(
		camera.GetWorldPosition(),
		camera.GetWorldPosition() + glm::vec3(glm::vec4(0.0f, 0.0f,-5.0f, 0.0f) * camera.GetRotate()),
		glm::vec3(0.0f, 1.0f, 0.0f)
	);

	// world ±×¸®±â
	ltcShader->Use();

	ltcShader->SetUniform1f("roughness", 0.1);
	ltcShader->SetUniformVector3f("dcolor", glm::vec3(1.0));
	ltcShader->SetUniformVector3f("scolor", glm::vec3(1.0));

	ltcShader->SetUniformVector3f("rectCenter", glm::vec3(0.0f, 2.0f, 0.0f));
	ltcShader->SetUniform1f("intensity", 1.0);
	ltcShader->SetUniform1f("width", 8.0);
	ltcShader->SetUniform1f("height", 8.0);
	ltcShader->SetUniform1f("rotx", 0.0);
	ltcShader->SetUniform1f("roty", 0.0);
	ltcShader->SetUniform1f("rotz", 0.0);

	ltcShader->SetUniformBool("twoSided", false);

	//uniform sampler2D ltc_mat;
	//uniform sampler2D ltc_mag;

	ltcShader->SetUniformMatrix4f("view", view);
	ltcShader->SetUniformVector2f("resolution", glm::vec2(
		WindowManager::GetInstance()->width,
		WindowManager::GetInstance()->height));

	quad.Draw();
}

void LTCRenderer::TerminateRender()
{
	ltcShader->Delete();
	delete ltcShader;
}