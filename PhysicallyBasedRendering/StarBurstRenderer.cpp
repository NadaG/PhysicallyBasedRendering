#include "StarBurstRenderer.h"

void StarBurstRenderer::InitializeRender()
{
	phongShader.Use();
	phongShader.LoadPhongMesh();
}

void StarBurstRenderer::Render()
{
	glEnable(GL_DEPTH_TEST);
	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	vector<SceneObject>& sceneObj = sceneManager->sceneObjs;
	SceneObject& camera = sceneManager->cameraObj;

	glViewport(0, 0, WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);
	UseDefaultFrameBufferObject();

	glm::mat4 projection = glm::perspective(
		glm::radians(45.0f),
		WindowManager::GetInstance()->width / WindowManager::GetInstance()->height,
		0.1f,
		30.0f);

	// TODO 마우스 오른쪽 버튼을 누른 채로 카메라 회전을 조절하고 키보드로 움직이게 하자
	glm::mat4 view = glm::lookAt(
		camera.GetWorldPosition(),
		glm::vec3(0.0f, camera.GetPosition().y, 0.0f),
		glm::vec3(0.0f, 1.0f, 0.0f)
	);

	phongShader.Use();

	phongShader.SetUniformMatrix4f("model", glm::mat4());
	phongShader.SetUniformMatrix4f("view", view);
	phongShader.SetUniformMatrix4f("projection", projection);

	phongShader.SetUniformVector3f("lightDir", glm::vec3(1.0f, 0.0f, 0.0f));
	phongShader.SetUniformVector3f("eyePos", camera.GetWorldPosition());

	phongShader.SetUniformVector3f("ambientColor", glm::vec3(0.2, 0.2, 0.2));
	phongShader.SetUniformVector3f("diffuseColor", glm::vec3(0.2, 0.2, 0.2));
	phongShader.SetUniformVector3f("specularColor", glm::vec3(0.2, 0.2, 0.2));
	phongShader.SetUniform1f("specularExpo", 12);
	phongShader.SetUniformVector3f("transmission", glm::vec3(0.2, 0.2, 0.2));

	/*for (int i = 0; i < sceneObj.size(); i++)
		sceneObj[i].Draw();
*/
	sceneObj[1].Draw();

	//phongShader.DrawPhongMesh();
}

void StarBurstRenderer::TerminateRender()
{
	phongShader.Delete();
}