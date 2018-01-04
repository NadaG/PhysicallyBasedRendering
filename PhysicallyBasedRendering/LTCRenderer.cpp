#include "LTCRenderer.h"

void LTCRenderer::InitializeRender()
{
	UseDefaultFrameBufferObject();
	ltcShader = new ShaderProgram("Quad.vs", "LTC.fs");
	ltcShader->Use();
	ltcShader->SetUniform1i("ltc_mat", 0);

	ltcTex.LoadTextureDDS("Texture/brdf/ltc_mat.dds");
	
	ltcTex.SetParameters(GL_LINEAR_MIPMAP_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT);

	glm::mat3 debugMat = glm::mat3();
	debugMat[0][0] = 10.0f;
	debugMat[1][1] = 12.0f;
	debugMat[2][0] = 44.0f;
	debugMat[0][2] = 51.0f;

	debugMat = glm::inverse(debugMat);
}

float tmp = 0.0f;
void LTCRenderer::Render()
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
		camera->GetWorldPosition() + glm::vec3(glm::vec4(0.0f, 0.0f,-5.0f, 0.0f) * camera->GetRotate()),
		glm::vec3(0.0f, 1.0f, 0.0f)
	);

	// world ±×¸®±â
	ltcShader->Use();

	ltcShader->SetUniform1f("roughness", 0.25);
	ltcShader->SetUniformVector3f("dcolor", glm::vec3(1.0));
	ltcShader->SetUniformVector3f("scolor", glm::vec3(1.0));

	ltcShader->SetUniformVector3f("rectCenter", glm::vec3(0.0f, 5.0f, 0.0f));
	ltcShader->SetUniform1f("intensity", 1.0);
	ltcShader->SetUniform1f("width", 8.0);
	ltcShader->SetUniform1f("height", 8.0);
	ltcShader->SetUniform1f("rotx", 0.0);
	ltcShader->SetUniform1f("roty", tmp);
	ltcShader->SetUniform1f("rotz", 0.0);
	tmp += 0.01f;

	ltcShader->SetUniformBool("twoSided", true);
	
	ltcTex.Bind(GL_TEXTURE0);
	//uniform sampler2D ltc_mag;

	ltcShader->SetUniformMatrix4f("view", view);
	ltcShader->SetUniformVector2f("resolution", glm::vec2(
		WindowManager::GetInstance()->width,
		WindowManager::GetInstance()->height));

	quad.DrawModel();
}

void LTCRenderer::TerminateRender()
{
	ltcShader->Delete();
	delete ltcShader;
}