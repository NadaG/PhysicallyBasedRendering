#include "FluidRenderer.h"

void FluidRenderer::InitializeRender(GLenum cap, glm::vec4 color)
{
	glEnable(cap);
	glClearColor(color.r, color.g, color.b, color.a);

	pbrShader = new ShaderProgram("PBR.vs", "PBR.fs");
	pbrShader->Use();

	quadShader = new ShaderProgram("Quad.vs", "Quad.fs");
	quadShader->Use();
	quadShader->SetUniform1i("depthMap", 0);

	particleSphereShader = new ShaderProgram("ParticleSphere.vs", "ParticleSphere.fs");
	particleSphereShader->Use();
	particleSphereShader->SetUniform1f("far", depthFar);

	depthBlurShader = new ShaderProgram("Quad.vs", "DepthBlur.fs");
	depthBlurShader->Use();
	depthBlurShader->SetUniform1i("depthMap", 0);

	surfaceShader = new ShaderProgram("Quad.vs", "Surface.fs");
	surfaceShader->Use();
	surfaceShader->SetUniform1i("bluredDepthMap", 0);
	surfaceShader->SetUniform1i("worldMap", 1);
	surfaceShader->SetUniform1f("near", depthNear);
	surfaceShader->SetUniform1f("far", depthFar);

	///////////////////
	tmpDepthRBO.GenRenderBufferObject(depthWidth, depthHeight);

	colorTex.LoadTexture(GL_RGBA32F, depthWidth, depthHeight, GL_RGBA, GL_FLOAT);
	colorTex.SetParameters(GL_NEAREST, GL_NEAREST, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);

	depthTex.LoadTexture(GL_RGBA32F, depthWidth, depthHeight, GL_RGBA, GL_FLOAT);
	depthTex.SetParameters(GL_NEAREST, GL_NEAREST, GL_REPEAT, GL_REPEAT);

	thicknessTex.LoadTexture(GL_RGBA32F, depthWidth, depthHeight, GL_RGBA, GL_FLOAT);
	thicknessTex.SetParameters(GL_NEAREST, GL_NEAREST, GL_REPEAT, GL_REPEAT);

	///////////////////
	pbrDepthTex.LoadDepthTexture(depthWidth, depthHeight);
	pbrDepthTex.SetParameters(GL_NEAREST, GL_NEAREST, GL_REPEAT, GL_REPEAT);

	pbrColorTex.LoadTexture(GL_RGBA32F, WindowManager::GetInstance()->width, WindowManager::GetInstance()->height, GL_RGBA, GL_FLOAT);
	pbrColorTex.SetParameters(GL_NEAREST, GL_NEAREST, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);

	depthFBO.GenFrameBufferObject();
	// rbo�� texture�� ������ ���� ���̶�� ���� ����
	// �� ��Ʈ�� �̸� �����ν� ����ȭ�� �� �� ����
	depthFBO.BindRenderBuffer(GL_DEPTH_ATTACHMENT, tmpDepthRBO);
	depthFBO.BindTexture(GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, colorTex);
	depthFBO.BindTexture(GL_COLOR_ATTACHMENT1, GL_TEXTURE_2D, depthTex);
	depthFBO.BindTexture(GL_COLOR_ATTACHMENT2, GL_TEXTURE_2D, thicknessTex);
	depthFBO.DrawBuffers();

	if (depthFBO.CheckStatus() == GL_FRAMEBUFFER_COMPLETE)
	{
		cout << "depth FBO complete" << endl;
	}

	pbrFBO.GenFrameBufferObject();
	pbrFBO.BindTexture(GL_DEPTH_ATTACHMENT, GL_TEXTURE_2D, pbrDepthTex);
	pbrFBO.BindTexture(GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, pbrColorTex);
	pbrFBO.DrawBuffers();

	for (int i = 0; i < 2; i++)
	{
		depthBlurTex[i].LoadTexture(GL_RGBA32F, depthWidth, depthHeight, GL_RGBA, GL_FLOAT);
		depthBlurTex[i].SetParameters(GL_NEAREST, GL_NEAREST, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);

		depthBlurTmpDepthTex[i].LoadDepthTexture(depthWidth, depthHeight);
		depthBlurTmpDepthTex[i].SetParameters(GL_NEAREST, GL_NEAREST, GL_REPEAT, GL_REPEAT);

		depthBlurFBO[i].GenFrameBufferObject();
		depthBlurFBO[i].BindTexture(GL_DEPTH_ATTACHMENT, GL_TEXTURE_2D, depthBlurTmpDepthTex[i]);
		depthBlurFBO[i].BindTexture(GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, depthBlurTex[i]);
	}

	importer.Initialize();
	fluidVertices = new GLfloat[importer.particleNum * 6];

	fluidVAO.GenVAOVBOIBO();
	fluidVAO.VertexBufferData(sizeof(GLfloat)*importer.particleNum * 6, fluidVertices);
	
	// position
	fluidVAO.VertexAttribPointer(3, 6);
	// color
	fluidVAO.VertexAttribPointer(3, 6);
}

void FluidRenderer::Render()
{
	glEnable(GL_DEPTH_TEST);

	importer.Update(fluidVertices);

	fluidVAO.VertexBufferData(sizeof(GLfloat)*importer.particleNum * 6, fluidVertices);

	SceneObject& camera = SceneManager::GetInstance()->cameraObj;
	SceneObject& quad = SceneManager::GetInstance()->quadObj;
	vector<SceneObject>& objs = SceneManager::GetInstance()->sceneObjs;

	glm::mat4 model = objs[0].GetModelMatrix();

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

	// ���� �׸���
	glViewport(0, 0, WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);

	pbrFBO.Use();
	pbrShader->Use();

	pbrShader->SetUniformMatrix4f("model", model);
	pbrShader->SetUniformMatrix4f("view", view);
	pbrShader->SetUniformMatrix4f("projection", projection);
	
	pbrShader->SetUniformVector3f("lightPos", glm::vec3(10.0f, 0.0f, 0.0f));
	pbrShader->SetUniformVector3f("eyePos", camera.GetWorldPosition());
	pbrShader->SetUniformVector3f("lightColor", glm::vec3(0.8f, 0.8f, 0.8f));

	objs[0].Draw();
	// ���� �׸��� ��

	// ��ƼŬ�� depth map �׸���
	glViewport(0, 0, depthWidth, depthHeight);

	depthFBO.Use();
	particleSphereShader->Use();

	particleSphereShader->SetUniformMatrix4f("view", view);
	particleSphereShader->SetUniformMatrix4f("projection", projection);
	particleSphereShader->SetUniformVector3f("lightPos", glm::vec3(10.0f, 0.0f, 0.0f));

	particleSphereShader->SetUniform1f("near", depthNear);
	particleSphereShader->SetUniform1f("far", depthFar);

	fluidVAO.Bind();
	// TODO ���� �ȼ��� ����ϱ� ������ �ָ��� ���� ���� �ȼ��̶� �� ������ ���̰�
	// �����̼� ���� �� �ָ� ������ ����
	// �� ������ �ذ��ϱ� ���� model matrix�� ����ؾ� �ϴ°�? �ƴϸ� �ܼ��� �Ÿ��� ���� point size�� �ٸ��� �ؾ� �ϴ°�
	float dist = glm::distance(camera.GetPosition(), glm::vec3(0.0f, camera.GetPosition().y, 0.0f));
	glPointSize(15000 / (dist*dist));
	glDrawArrays(GL_POINTS, 0, importer.particleNum);
	// ��ƼŬ�� depth map �׸��� ��

	// blur �׸���
	depthBlurFBO[0].Use();
	glViewport(0, 0, depthWidth, depthHeight);
	
	quadShader->Use();
	quadShader->SetUniform1f("near", depthNear);
	quadShader->SetUniform1f("far", depthFar);

	depthTex.Bind(GL_TEXTURE0);

	quad.Draw();

	for (int i = 0; i < blurNum; i++)
	{
		depthBlurFBO[(i + 1) % 2].Use();

		depthBlurShader->Use();
		depthBlurTex[i % 2].Bind(GL_TEXTURE0);
		
		quad.Draw();
	}
	// blur ��

	// quad �׸���
	UseDefaultFrameBufferObject();
	glViewport(0, 0, WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);

	surfaceShader->Use();
	surfaceShader->SetUniformMatrix4f("projection", projection);
	surfaceShader->SetUniformMatrix4f("view", view);
	surfaceShader->SetUniformVector3f("eyePos", camera.GetWorldPosition());
	surfaceShader->SetUniformVector3f("lightDir", glm::vec3(0.0f, -1.0f, 0.0f));

	depthBlurTex[0].Bind(GL_TEXTURE0);
	pbrColorTex.Bind(GL_TEXTURE1);
	

	quad.Draw();
	// quad �׸��� ��

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