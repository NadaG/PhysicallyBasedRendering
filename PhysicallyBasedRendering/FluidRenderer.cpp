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
	quadShader->SetUniform1i("colorMap", 1);

	particleSphereShader = new ShaderProgram("ParticleSphere.vs", "ParticleSphere.fs");
	particleSphereShader->Use();
	particleSphereShader->SetUniform1f("far", depthFar);

	depthBlurShader = new ShaderProgram("Quad.vs", "DepthBlur.fs");
	depthBlurShader->Use();
	depthBlurShader->SetUniform1i("depthMap", 0);

	normalShader = new ShaderProgram("Quad.vs", "Normal.fs");
	normalShader->Use();
	normalShader->SetUniform1i("bluredDepthMap", 0);
	normalShader->SetUniform1i("worldMap", 1);
	normalShader->SetUniform1f("near", depthNear);
	normalShader->SetUniform1f("far", depthFar);

	///////////////////
	tmpDepthRBO.GenRenderBufferObject(depthWidth, depthHeight);

	colorTex.LoadTexture(GL_RGBA32F, depthWidth, depthHeight, GL_RGBA, GL_FLOAT);
	colorTex.SetParameters(GL_NEAREST, GL_NEAREST, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);

	depthTex.LoadTexture(GL_RGBA32F, depthWidth, depthHeight, GL_RGBA, GL_FLOAT);
	depthTex.SetParameters(GL_NEAREST, GL_NEAREST, GL_REPEAT, GL_REPEAT);

	///////////////////
	pbrDepthTex.LoadDepthTexture(depthWidth, depthHeight);
	pbrDepthTex.SetParameters(GL_NEAREST, GL_NEAREST, GL_REPEAT, GL_REPEAT);

	pbrColorTex.LoadTexture(GL_RGBA32F, WindowManager::GetInstance()->width, WindowManager::GetInstance()->height, GL_RGBA, GL_FLOAT);
	pbrColorTex.SetParameters(GL_NEAREST, GL_NEAREST, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);

	depthFBO.GenFrameBufferObject();
	// rbo는 texture로 쓰이지 않을 것이라는 것을 뜻함
	// 이 힌트를 미리 줌으로써 가속화를 할 수 있음
	depthFBO.BindRenderBuffer(GL_DEPTH_ATTACHMENT, tmpDepthRBO);
	depthFBO.BindTexture(GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, colorTex);
	depthFBO.BindTexture(GL_COLOR_ATTACHMENT1, GL_TEXTURE_2D, depthTex);
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

	vao.GenVAOVBOIBO();
	vao.VertexBufferData(sizeof(GLfloat)*importer.particleNum * 6, fluidVertices);
	
	// position
	vao.VertexAttribPointer(3, 6);
	// color
	vao.VertexAttribPointer(3, 6);
}

void FluidRenderer::Render()
{
	glEnable(GL_DEPTH_TEST);

	importer.Update(fluidVertices);

	vao.VertexBufferData(sizeof(GLfloat)*importer.particleNum * 6, fluidVertices);

	SceneObject& camera = SceneManager::GetInstance()->cameraObj;
	SceneObject& quad = SceneManager::GetInstance()->quadObj;
	vector<SceneObject>& objs = SceneManager::GetInstance()->sceneObjs;
	vector<SceneObject>& lights = SceneManager::GetInstance()->lightObjs;

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

	// 공룡 그리기
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
	// 공룡 그리기 끝

	// 파티클들 depth map 그리기
	glViewport(0, 0, depthWidth, depthHeight);

	depthFBO.Use();
	particleSphereShader->Use();

	particleSphereShader->SetUniformMatrix4f("view", view);
	particleSphereShader->SetUniformMatrix4f("projection", projection);
	particleSphereShader->SetUniformVector3f("lightPos", glm::vec3(10.0f, 0.0f, 0.0f));

	particleSphereShader->SetUniform1f("near", depthNear);
	particleSphereShader->SetUniform1f("far", depthFar);

	vao.Bind();
	// TODO 고정 픽셀을 사용하기 때문에 멀리서 보면 같은 픽셀이라서 더 조밀해 보이고
	// 가까이서 보면 더 멀리 떨어져 보임
	// 이 문제를 해결하기 위해 model matrix를 사용해야 하는가? 아니면 단순히 거리에 따라 point size를 다르게 해야 하는가
	float dist = glm::distance(camera.GetPosition(), glm::vec3(0.0f, camera.GetPosition().y, 0.0f));
	glPointSize(800 / dist);
	glDrawArrays(GL_POINTS, 0, importer.particleNum);
	// 파티클들 depth map 그리기 끝

	// blur 그리기
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
	// blur 끝

	// quad 그리기
	UseDefaultFrameBufferObject();
	glViewport(0, 0, WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);

	normalShader->Use();
	normalShader->SetUniformMatrix4f("projection", projection);
	normalShader->SetUniformMatrix4f("view", view);
	normalShader->SetUniformVector3f("eyePos", camera.GetWorldPosition());
	normalShader->SetUniformVector3f("lightDir", glm::vec3(0.0f, -1.0f, 0.0f));

	//depthBlurTex[1].Bind(GL_TEXTURE0);
	//colorTex.Bind(GL_TEXTURE0);
	depthBlurTex[0].Bind(GL_TEXTURE0);
	//depthTex.Bind(GL_TEXTURE0);
	//colorTex.Bind(GL_TEXTURE0);

	quad.Draw();
	// quad 그리기 끝

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