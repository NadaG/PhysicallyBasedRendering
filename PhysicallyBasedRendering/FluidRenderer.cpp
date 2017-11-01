#include "FluidRenderer.h"

void FluidRenderer::InitializeRender(GLenum cap, glm::vec4 color)
{
	glEnable(cap);
	glClearColor(color.r, color.g, color.b, color.a);

	quadShader = new ShaderProgram("DebugQuad.vs", "DebugQuad.fs");
	quadShader->Use();
	quadShader->SetUniform1i("depthMap", 0);
	quadShader->SetUniform1i("colorMap", 1);

	particleSphereShader = new ShaderProgram("ParticleSphere.vs", "ParticleSphere.fs");
	particleSphereShader->Use();

	depthBlurShader = new ShaderProgram("DebugQuad.vs", "DepthBlur.fs");
	depthBlurShader->Use();
	depthBlurShader->SetUniform1i("depthMap", 0);

	depthTex.LoadDepthTexture(depthWidth, depthHeight);
	depthTex.SetParameters(GL_NEAREST, GL_NEAREST, GL_REPEAT, GL_REPEAT);

	colorTex.LoadTexture(GL_RGBA, depthWidth, depthHeight, GL_RGBA, GL_FLOAT);
	colorTex.SetParameters(GL_NEAREST, GL_NEAREST, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);

	depthFBO.GenFrameBufferObject();
	// rbo�� texture�� ������ ���� ���̶�� ���� ����
	// �� ��Ʈ�� �̸� �����ν� ����ȭ�� �� �� ����
	depthFBO.BindTexture(GL_DEPTH_ATTACHMENT, GL_TEXTURE_2D, depthTex);
	depthFBO.BindTexture(GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, colorTex);
	depthFBO.DrawBuffers();

	for (int i = 0; i < 2; i++)
	{
		depthBlurTex[i].LoadTexture(GL_RGBA, depthWidth, depthHeight, GL_RGBA, GL_FLOAT);
		depthBlurTex[i].SetParameters(GL_NEAREST, GL_NEAREST, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);

		depthBlurDepthTex[i].LoadDepthTexture(depthWidth, depthHeight);
		depthBlurDepthTex[i].SetParameters(GL_NEAREST, GL_NEAREST, GL_REPEAT, GL_REPEAT);

		depthBlurFBO[i].GenFrameBufferObject();
		depthBlurFBO[i].BindTexture(GL_DEPTH_ATTACHMENT, GL_TEXTURE_2D, depthBlurDepthTex[i]);
		depthBlurFBO[i].BindTexture(GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, depthBlurTex[i]);
	}

	importer.Initialize();
	fluidVertices = new GLfloat[importer.particleNum * 6];

	vao.GenVAOVBOIBO();

	vao.VertexBufferData(sizeof(GLfloat)*importer.particleNum * 6, fluidVertices);
	
	// position
	vao.VertexAttribPointer(3, 6);
	// color
	vao.VertexAttribPointer(3, 6);
}

void FluidRenderer::Render()
{
	importer.Update(fluidVertices);

	vao.VertexBufferData(sizeof(GLfloat)*importer.particleNum * 6, fluidVertices);

	SceneObject& camera = SceneManager::GetInstance()->cameraObj;
	SceneObject& quad = SceneManager::GetInstance()->quadObj;

	float depthNear = 0.01f;
	float depthFar = 50.0f;

	glViewport(0, 0, depthWidth, depthHeight);

	depthFBO.Use();
	particleSphereShader->Use();

	glm::mat4 projection = glm::perspective(
		glm::radians(45.0f),
		WindowManager::GetInstance()->width / WindowManager::GetInstance()->height,
		depthNear,
		depthFar);

	glm::mat4 view = glm::lookAt(
		camera.GetWorldPosition(),
		glm::vec3(0.0f, camera.GetPosition().y, 0.0f),
		glm::vec3(0.0f, 1.0f, 0.0f)
	);

	particleSphereShader->SetUniformMatrix4f("view", view);
	particleSphereShader->SetUniformMatrix4f("projection", projection);
	particleSphereShader->SetUniformVector3f("lightPos", glm::vec3(0.0f, 0.0f, 3.0f));

	vao.Bind();
	glPointSize(50);
	glDrawArrays(GL_POINTS, 0, importer.particleNum);

	// TODO
	// ���� depth texture�� ��ǲ���� 1�� fbo�� blur �׸��� �׸�
	// �� �� 1�� fbo�� �ƿ�ǲ texture�� ��ǲ���� 2�� fbo�� blur �׸��� �׸�
	
	depthBlurFBO[0].Use();
	glViewport(0, 0, depthWidth, depthHeight);
	
	quadShader->Use();
	quadShader->SetUniform1f("near", depthNear);
	quadShader->SetUniform1f("far", depthFar);

	depthTex.Bind(GL_TEXTURE0);

	quad.Draw();

	UseDefaultFrameBufferObject();
	glViewport(0, 0, WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);
	
	depthBlurShader->Use();
	depthBlurTex[0].Bind(GL_TEXTURE0);

	quad.Draw();

	//glViewport(0, 0, WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);
	//UseDefaultFrameBufferObject();
	//quadShader->Use();

	//depthTex.Bind(GL_TEXTURE0);
	//depthBlurTex[0].Bind(GL_TEXTURE0);
	//colorTex.Bind(GL_TEXTURE1);
	//quadShader->SetUniform1f("near", depthNear);
	//quadShader->SetUniform1f("far", depthFar);

	//quad.Draw();

	glfwSwapBuffers(window);
}

void FluidRenderer::TerminateRender()
{
	quadShader->Delete();
	delete quadShader;

	particleSphereShader->Delete();
	delete particleSphereShader;

	SceneManager::GetInstance()->TerminateObjects();
}