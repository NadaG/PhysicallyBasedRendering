#include "FluidRenderer.h"

void FluidRenderer::InitializeRender()
{
	UseDefaultFrameBufferObject();

	pbrShader = new ShaderProgram("PBR.vs", "PBR.fs");
	pbrShader->Use();
	pbrShader->SetUniform1i("albedoMap", 1);

	particleDepthShader = new ShaderProgram("ParticleSphere.vs", "ParticleDepth.fs");
	particleDepthShader->Use();

	particleThicknessShader = new ShaderProgram("ParticleSphere.vs", "particleThickness.fs");
	particleThicknessShader->Use();

	blurShader = new ShaderProgram("Quad.vs", "Blur.fs");
	blurShader->Use();
	blurShader->SetUniform1i("map", 0);

	surfaceShader = new ShaderProgram("Quad.vs", "Surface.fs");
	surfaceShader->Use();
	surfaceShader->SetUniform1i("worldMap", 0);
	surfaceShader->SetUniform1i("bluredDepthMap", 1);
	surfaceShader->SetUniform1i("thicknessMap", 2);
	surfaceShader->SetUniform1f("near", depthNear);
	surfaceShader->SetUniform1f("far", depthFar);

	///////////////////
	floorAlbedoTex.LoadTexture("Texture/Floor/albedo.png");
	floorAlbedoTex.SetParameters(GL_NEAREST, GL_NEAREST, GL_CLAMP_TO_BORDER, GL_CLAMP_TO_BORDER);

	///////////////////
	tmpDepthRBO.GenRenderBufferObject(GL_DEPTH_COMPONENT, depthWidth, depthHeight);

	colorTex.LoadTexture(GL_RGBA32F, depthWidth, depthHeight, GL_RGBA, GL_FLOAT);
	colorTex.SetParameters(GL_NEAREST, GL_NEAREST, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);

	depthTex.LoadTexture(GL_RGBA32F, depthWidth, depthHeight, GL_RGBA, GL_FLOAT);
	depthTex.SetParameters(GL_NEAREST, GL_NEAREST, GL_REPEAT, GL_REPEAT);

	thicknessTex.LoadTexture(GL_RGBA32F, depthWidth, depthHeight, GL_RGBA, GL_FLOAT);
	thicknessTex.SetParameters(GL_NEAREST, GL_NEAREST, GL_REPEAT, GL_REPEAT);

	///////////////////
	worldDepthTex.LoadDepthTexture(depthWidth, depthHeight);
	worldDepthTex.SetParameters(GL_NEAREST, GL_NEAREST, GL_REPEAT, GL_REPEAT);

	worldColorTex.LoadTexture(GL_RGBA32F, WindowManager::GetInstance()->width, WindowManager::GetInstance()->height, GL_RGBA, GL_FLOAT);
	worldColorTex.SetParameters(GL_NEAREST, GL_NEAREST, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);

	depthThicknessFBO.GenFrameBufferObject();
	// rbo는 texture로 쓰이지 않을 것이라는 것을 뜻함
	// 이 힌트를 미리 줌으로써 가속화를 할 수 있음
	depthThicknessFBO.BindRenderBuffer(GL_DEPTH_ATTACHMENT, tmpDepthRBO);
	depthThicknessFBO.BindTexture(GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, colorTex);
	depthThicknessFBO.BindTexture(GL_COLOR_ATTACHMENT1, GL_TEXTURE_2D, depthTex);
	depthThicknessFBO.BindTexture(GL_COLOR_ATTACHMENT2, GL_TEXTURE_2D, thicknessTex);
	depthThicknessFBO.DrawBuffers();

	if (depthThicknessFBO.CheckStatus() == GL_FRAMEBUFFER_COMPLETE)
	{
		cout << "depth FBO complete" << endl;
	}

	pbrFBO.GenFrameBufferObject();
	pbrFBO.BindTexture(GL_DEPTH_ATTACHMENT, GL_TEXTURE_2D, worldDepthTex);
	pbrFBO.BindTexture(GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, worldColorTex);
	pbrFBO.DrawBuffers();

	for (int i = 0; i < 2; i++)
	{
		depthBlurTex[i].LoadTexture(GL_RGBA32F, depthWidth, depthHeight, GL_RGBA, GL_FLOAT);
		depthBlurTex[i].SetParameters(GL_NEAREST, GL_NEAREST, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);

		depthBlurFBO[i].GenFrameBufferObject();
		depthBlurFBO[i].BindDefaultDepthBuffer();
		depthBlurFBO[i].BindTexture(GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, depthBlurTex[i]);

		thicknessBlurTex[i].LoadTexture(GL_RGBA32F, depthWidth, depthHeight, GL_RGBA, GL_FLOAT);
		thicknessBlurTex[i].SetParameters(GL_NEAREST, GL_NEAREST, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);

		thicknessBlurFBO[i].GenFrameBufferObject();
		thicknessBlurFBO[i].BindDefaultDepthBuffer();
		thicknessBlurFBO[i].BindTexture(GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, thicknessBlurTex[i]);
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

	SceneObject& camera = sceneManager->cameraObj;
	SceneObject& quad = sceneManager->quadObj;
	vector<SceneObject>& objs = sceneManager->sceneObjs;

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

	// world 그리기
	glViewport(0, 0, WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);

	pbrFBO.Use();
	pbrShader->Use();
	
	pbrShader->SetUniformMatrix4f("view", view);
	pbrShader->SetUniformMatrix4f("projection", projection);

	pbrShader->SetUniformVector3f("lightPos", glm::vec3(10.0f, 0.0f, 0.0f));
	pbrShader->SetUniformVector3f("eyePos", camera.GetWorldPosition());
	pbrShader->SetUniformVector3f("lightColor", glm::vec3(0.8f, 0.8f, 0.8f));
	floorAlbedoTex.Bind(GL_TEXTURE1);

	for (int i = 0; i < objs.size(); i++)
	{
		glm::mat4 model = objs[i].GetModelMatrix();
		pbrShader->SetUniformMatrix4f("model", model);
		objs[i].Draw();
	}
	// world 그리기 끝

	// 파티클들 depth map 그리기
	glViewport(0, 0, depthWidth, depthHeight);

	depthThicknessFBO.Use();
	particleDepthShader->Use();

	particleDepthShader->SetUniformMatrix4f("view", view);
	particleDepthShader->SetUniformMatrix4f("projection", projection);
	particleDepthShader->SetUniform1f("near", depthNear);
	particleDepthShader->SetUniform1f("far", depthFar);

	DrawFluids(glm::distance(camera.GetPosition(), glm::vec3(0.0f, camera.GetPosition().y, 0.0f)));
	// 파티클들 depth map 그리기 끝

	// 파티클들 thickness map 그리기
	glEnable(GL_BLEND);
	glDisable(GL_DEPTH_TEST);
	glBlendFunc(GL_ONE, GL_ONE);

	particleThicknessShader->Use();
	particleThicknessShader->SetUniformMatrix4f("view", view);
	particleThicknessShader->SetUniformMatrix4f("projection", projection);
	
	DrawFluids(glm::distance(camera.GetPosition(), glm::vec3(0.0f, camera.GetPosition().y, 0.0f)));
	glDisable(GL_BLEND);
	glEnable(GL_DEPTH_TEST);
	// 파티클들 thickness map 그리기 끝

	// depth, thickness blur 시작
	blurShader->Use();
	glViewport(0, 0, depthWidth, depthHeight);
	for (int i = 0; i < blurNum * 2; i++)
	{
		depthBlurFBO[(i + 1) % 2].Use();
		if (i)
			depthBlurTex[i % 2].Bind(GL_TEXTURE0);
		else
			depthTex.Bind(GL_TEXTURE0);
		quad.Draw();

		thicknessBlurFBO[(i + 1) % 2].Use();
		if (i)
			thicknessBlurTex[i % 2].Bind(GL_TEXTURE0);
		else
			thicknessTex.Bind(GL_TEXTURE0);
		quad.Draw();
	}
	// depth, thickness blur 끝

	// quad 그리기
	UseDefaultFrameBufferObject();
	glViewport(0, 0, WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);

	surfaceShader->Use();
	surfaceShader->SetUniformMatrix4f("projection", projection);
	surfaceShader->SetUniformMatrix4f("view", view);
	surfaceShader->SetUniformVector3f("eyePos", camera.GetWorldPosition());
	surfaceShader->SetUniformVector3f("lightDir", glm::vec3(0.0f, -1.0f, 0.0f));

	worldColorTex.Bind(GL_TEXTURE0);
	depthBlurTex[0].Bind(GL_TEXTURE1);
	thicknessBlurTex[0].Bind(GL_TEXTURE2);

	quad.Draw();
	// quad 그리기 끝

	glfwSwapBuffers(window);
}

void FluidRenderer::TerminateRender()
{
	particleDepthShader->Delete();
	delete particleDepthShader;

	particleThicknessShader->Delete();
	delete particleThicknessShader;

	blurShader->Delete();
	delete blurShader;

	surfaceShader->Delete();
	delete surfaceShader;

	pbrShader->Delete();
	delete pbrShader;

	sceneManager->TerminateObjects();
}

void FluidRenderer::DrawFluids(const float& dist)
{
	fluidVAO.Bind();
	glPointSize(15000 / (dist*dist));
	glDrawArrays(GL_POINTS, 0, importer.particleNum);
}