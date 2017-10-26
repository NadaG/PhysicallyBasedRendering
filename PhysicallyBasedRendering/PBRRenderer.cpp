#include "PBRRenderer.h"

void PBRRenderer::InitializeRender(GLenum cap, glm::vec4 color)
{
	glEnable(cap);
	backgroundColor = color;
	glClearColor(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a);

	pbrShader = new ShaderProgram("PBR.vs", "PBR.fs");
	pbrShader->Use();
	pbrShader->SetUniform1i("aoMap", 0);
	pbrShader->SetUniform1i("albedoMap", 1);
	pbrShader->SetUniform1i("heightMap", 2);
	pbrShader->SetUniform1i("metallicMap", 3);
	pbrShader->SetUniform1i("normalMap", 4);
	pbrShader->SetUniform1i("roughnessMap", 5);

	aoTex.LoadTexture("Texture/Rock/ao.png");
	aoTex.SetParameters(GL_LINEAR_MIPMAP_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT);

	albedoTex.LoadTexture("Texture/Rock/albedo.png");
	albedoTex.SetParameters(GL_LINEAR_MIPMAP_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT);

	heightTex.LoadTexture("Texture/Rock/height.jpg");
	heightTex.SetParameters(GL_LINEAR_MIPMAP_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT);

	metallicTex.LoadTexture("Texture/Rock/metallic.png");
	metallicTex.SetParameters(GL_LINEAR_MIPMAP_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT);

	normalTex.LoadTexture("Texture/Rock/normal.png");
	normalTex.SetParameters(GL_LINEAR_MIPMAP_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT);

	roughnessTex.LoadTexture("Texture/Rock/roughness.png");
	roughnessTex.SetParameters(GL_LINEAR_MIPMAP_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT);
}

void PBRRenderer::Render()
{
	vector<SceneObject>& objs = SceneManager::GetInstance()->sceneObjs;
	SceneObject& camera = SceneManager::GetInstance()->cameraObj;

	glViewport(0, 0, WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);
	UseDefaultFrameBufferObject();
	pbrShader->Use();

	for (int i = 0; i < objs.size(); i++)
	{
		glm::mat4 projection = glm::perspective(
			glm::radians(45.0f),
			WindowManager::GetInstance()->width / WindowManager::GetInstance()->height,
			0.1f,
			30.0f);

		glm::mat4 view = glm::lookAt(
			camera.GetWorldPosition(),
			glm::vec3(0.0f, camera.GetPosition().y, 0.0f),
			glm::vec3(0.0f, 1.0f, 0.0f)
		);

		glm::mat4 model = objs[i].GetModelMatrix();

		pbrShader->Use();
		pbrShader->SetUniformMatrix4f("model", model);
		pbrShader->SetUniformMatrix4f("view", view);
		pbrShader->SetUniformMatrix4f("projection", projection);

		pbrShader->SetUniformVector3f("lightPos", glm::vec3(10.0f, 0.0f, 0.0f));
		pbrShader->SetUniformVector3f("lightColor", glm::vec3(0.5f));
		pbrShader->SetUniformVector3f("eyePos", camera.GetWorldPosition());

		aoTex.Bind(GL_TEXTURE0);
		albedoTex.Bind(GL_TEXTURE1);
		heightTex.Bind(GL_TEXTURE2);
		metallicTex.Bind(GL_TEXTURE3);
		normalTex.Bind(GL_TEXTURE4);
		roughnessTex.Bind(GL_TEXTURE5);

		objs[i].Draw();
	}

	glfwSwapBuffers(window);
}

void PBRRenderer::TerminateRender()
{
	pbrShader->Delete();
	delete pbrShader;

	SceneManager::GetInstance()->TerminateObjects();
}
