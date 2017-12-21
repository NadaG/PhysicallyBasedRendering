#include "VolumeRenderer.h"

void VolumeRenderer::InitializeRender()
{
	backgroundColor = glm::vec4(1.0f, 0.0f, 1.0f, 0.0f);

	pointShader = new ShaderProgram("ParticleSphere.vs", "Phong.fs", "PointToCube.gs");
	pointShader->Use();

	vertices = new GLfloat[pointNum * 6];

	for (int i = 0; i < pointNum; i++)
	{
		// pos
		vertices[i * 6 + 0] = i * 3.0f;
		vertices[i * 6 + 1] = 0.0f;
		vertices[i * 6 + 2] = 0.0f;
		// color
		vertices[i * 6 + 3] = 1.0f;
		vertices[i * 6 + 4] = 0.0f;
		vertices[i * 6 + 5] = 0.0f;
	}

	smokeVAO.GenVAOVBOIBO();
	smokeVAO.VertexBufferData(sizeof(GLfloat) * pointNum * 6, vertices);

	// position 
	smokeVAO.VertexAttribPointer(3, 6);
	smokeVAO.VertexAttribPointer(3, 6);
}

const float cubeLength = 1.0f;

void VolumeRenderer::Render()
{
	UseDefaultFrameBufferObject();
	glViewport(0, 0, WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);

	glEnable(GL_DEPTH_TEST);
	glClearColor(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	SceneObject& camera = sceneManager->cameraObj;
	SceneObject& quad = sceneManager->quadObj;
	vector<SceneObject>& objs = sceneManager->sceneObjs;

	glm::mat4 projection = glm::perspective(
		glm::radians(45.0f),
		WindowManager::GetInstance()->width / WindowManager::GetInstance()->height,
		0.1f,
		100.0f);

	glm::mat4 view = glm::lookAt(
		camera.GetWorldPosition(),
		glm::vec3(0.0f, camera.GetPosition().y, 0.0f),
		glm::vec3(0.0f, 1.0f, 0.0f)
	);

	pointShader->Use();

	pointShader->SetUniformMatrix4f("view", view);
	pointShader->SetUniformMatrix4f("projection", projection);

	pointShader->SetUniformMatrix4f("model[0]", glm::translate(glm::vec3(0.0f, 0.0f, cubeLength)));
	pointShader->SetUniformMatrix4f("model[1]", glm::translate(glm::vec3(0.0f, 0.0f, -cubeLength)));
	
	pointShader->SetUniformMatrix4f("model[2]", 
		glm::rotate(glm::radians(90.0f), glm::vec3(0.0f, 1.0f, 0.0f)) * glm::translate(glm::vec3(0.0f, 0.0f, cubeLength)));
	pointShader->SetUniformMatrix4f("model[3]", 
		glm::rotate(glm::radians(90.0f), glm::vec3(0.0f, 1.0f, 0.0f)) * glm::translate(glm::vec3(0.0f, 0.0f, cubeLength)));
	pointShader->SetUniformMatrix4f("model[4]", 
		glm::rotate(glm::radians(90.0f), glm::vec3(1.0f, 0.0f, 0.0f)) * glm::translate(glm::vec3(0.0f, 0.0f, cubeLength)));
	pointShader->SetUniformMatrix4f("model[5]", 
		glm::rotate(glm::radians(90.0f), glm::vec3(1.0f, 0.0f, 0.0f)) * glm::translate(glm::vec3(0.0f, 0.0f, -cubeLength)));
	
	/*pointShader->SetUniformMatrix4f("model[2]", 
		glm::rotate(glm::radians(90.0f), glm::vec3(0.0f, 1.0f, 0.0f)) * glm::translate(glm::vec3(0.0f, 0.0f, cubeLength)));
	pointShader->SetUniformMatrix4f("model[3]", 
		glm::rotate(glm::radians(90.0f), glm::vec3(0.0f, 1.0f, 0.0f)) * glm::translate(glm::vec3(0.0f, 0.0f, -cubeLength)));
	pointShader->SetUniformMatrix4f("model[4]", 
		glm::rotate(glm::radians(90.0f), glm::vec3(1.0f, 0.0f, 0.0f)) * glm::translate(glm::vec3(0.0f, 0.0f, cubeLength)));
	pointShader->SetUniformMatrix4f("model[5]", 
		glm::rotate(glm::radians(90.0f), glm::vec3(1.0f, 0.0f, 0.0f)) * glm::translate(glm::vec3(0.0f, 0.0f, -cubeLength)));*/
	//pointShader->SetUniformMatrix4f("model", glm::mat4());
	//Debug::GetInstance()->Log(glm::translate(glm::vec3(0.0f, 1.5f, 0.0f)));

	DrawSmoke();
}

void VolumeRenderer::TerminateRender()
{
	pointShader->Delete();
	delete pointShader;
}

void VolumeRenderer::DrawSmoke()
{
	smokeVAO.Bind();
	glPointSize(10);
	glDrawArrays(GL_POINTS, 0, pointNum);
}
