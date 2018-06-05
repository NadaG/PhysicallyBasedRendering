#include "FluidRenderer.h"

void FluidRenderer::InitializeRender()
{
	backgroundColor = glm::vec4(1.0f, 1.0f, 1.0f, 1.0f);

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
	surfaceShader->SetUniform1i("normalMap", 3);
	surfaceShader->SetUniform1i("worldDepthMap", 4);
	surfaceShader->SetUniform1i("debugMap", 5);
	surfaceShader->SetUniform1f("near", depthNear);
	surfaceShader->SetUniform1f("far", depthFar);
	surfaceShader->SetUniformVector4f("backgroundColor", backgroundColor);

	marchingCubeFluidShader = new ShaderProgram("Basic.vs", "MarchingCubeFluid.fs");
	marchingCubeFluidShader->Use();

	////////////////////////???
	//textureShader = new ShaderProgram("Basic.vs", "Basic.fs");
	//textureShader->Use();
	//textureShader->SetUniform1i("map", 0);

	//tmpTex.LoadTexture("ExportData/tmp.png");
	//tmpTex.SetParameters(GL_NEAREST, GL_NEAREST, GL_REPEAT, GL_REPEAT);
	////////////////////////???

	///////////////////
	floorAlbedoTex.LoadTexture("Texture/Floor/albedo.png");
	floorAlbedoTex.SetParameters(GL_NEAREST, GL_NEAREST, GL_CLAMP_TO_BORDER, GL_CLAMP_TO_BORDER);

	///////////////////
	tmpDepthRBO.GenRenderBufferObject();
	tmpDepthRBO.RenderBufferStorage(GL_DEPTH_COMPONENT, depthWidth, depthHeight);

	colorTex.LoadTexture(GL_RGBA32F, depthWidth, depthHeight, GL_RGBA, GL_FLOAT);
	colorTex.SetParameters(GL_NEAREST, GL_NEAREST, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);

	depthTex.LoadTexture(GL_RGBA32F, depthWidth, depthHeight, GL_RGBA, GL_FLOAT);
	depthTex.SetParameters(GL_NEAREST, GL_NEAREST, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);

	thicknessTex.LoadTexture(GL_RGBA32F, depthWidth, depthHeight, GL_RGBA, GL_FLOAT);
	thicknessTex.SetParameters(GL_NEAREST, GL_NEAREST, GL_REPEAT, GL_REPEAT);

	///////////////////
	worldDepthTex.LoadDepthTexture(depthWidth, depthHeight);
	worldDepthTex.SetParameters(GL_NEAREST, GL_NEAREST, GL_REPEAT, GL_REPEAT);

	worldColorTex.LoadTexture(GL_RGBA32F, 
		WindowManager::GetInstance()->width, 
		WindowManager::GetInstance()->height, 
		GL_RGBA, 
		GL_FLOAT);
	worldColorTex.SetParameters(GL_NEAREST, GL_NEAREST, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);

	pngTex.LoadTexture(
		GL_RGBA32F,
		WindowManager::GetInstance()->width,
		WindowManager::GetInstance()->height,
		GL_RGBA,
		GL_FLOAT);
	pngTex.SetParameters(GL_LINEAR, GL_LINEAR, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);

	depthThicknessFBO.GenFrameBufferObject();
	// rbo는 texture로 쓰이지 않을 것이라는 것을 뜻함
	// 이 힌트를 미리 줌으로써 가속화를 할 수 있음
	depthThicknessFBO.BindRenderBuffer(GL_DEPTH_ATTACHMENT, tmpDepthRBO);
	depthThicknessFBO.BindTexture(GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, &colorTex);
	depthThicknessFBO.BindTexture(GL_COLOR_ATTACHMENT1, GL_TEXTURE_2D, &depthTex);
	depthThicknessFBO.BindTexture(GL_COLOR_ATTACHMENT2, GL_TEXTURE_2D, &thicknessTex);
	depthThicknessFBO.DrawBuffers();

	if (depthThicknessFBO.CheckStatus() == GL_FRAMEBUFFER_COMPLETE)
	{
		cout << "depth FBO complete" << endl;
	}

	pbrFBO.GenFrameBufferObject();
	pbrFBO.BindTexture(GL_DEPTH_ATTACHMENT, GL_TEXTURE_2D, &worldDepthTex);
	pbrFBO.BindTexture(GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, &worldColorTex);
	pbrFBO.DrawBuffers();

	if (pbrFBO.CheckStatus() == GL_FRAMEBUFFER_COMPLETE)
	{
		cout << "pbr fbo complete" << endl;
	}

	pngFBO.GenFrameBufferObject();
	pngFBO.BindDefaultDepthBuffer(depthWidth, depthHeight);
	pngFBO.BindTexture(GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, &pngTex);
	pngFBO.DrawBuffers();

	for (int i = 0; i < 2; i++)
	{
		depthBlurTex[i].LoadTexture(GL_RGBA32F, depthWidth, depthHeight, GL_RGBA, GL_FLOAT);
		depthBlurTex[i].SetParameters(GL_NEAREST, GL_NEAREST, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);

		depthBlurFBO[i].GenFrameBufferObject();
		depthBlurFBO[i].BindDefaultDepthBuffer(depthWidth, depthHeight);
		depthBlurFBO[i].BindTexture(GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, &depthBlurTex[i]);

		thicknessBlurTex[i].LoadTexture(GL_RGBA32F, depthWidth, depthHeight, GL_RGBA, GL_FLOAT);
		thicknessBlurTex[i].SetParameters(GL_NEAREST, GL_NEAREST, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);

		thicknessBlurFBO[i].GenFrameBufferObject();
		thicknessBlurFBO[i].BindDefaultDepthBuffer(depthWidth, depthHeight);
		thicknessBlurFBO[i].BindTexture(GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, &thicknessBlurTex[i]);
	}

	boundarySize = glm::vec3(20.0f, 25.0f, 20.0f);
	importer.Initialize(boundarySize);
	fluidVertices = new GLfloat[importer.particleNum * 6];

	fluidVAO.GenVAOVBOIBO();
	fluidVAO.VertexBufferData(sizeof(GLfloat)*importer.particleNum * 6, fluidVertices);
	
	// position
	fluidVAO.VertexAttribPointer(3, 6);
	// color
	fluidVAO.VertexAttribPointer(3, 6);

	currentFrame = 0;
	float resolutionRatio = 1.0f;
	mc.BuildingGird(
		boundarySize.x,
		boundarySize.y,
		boundarySize.z,
		boundarySize.x*resolutionRatio,
		boundarySize.y*resolutionRatio,
		boundarySize.z*resolutionRatio,
		0.001f);

}

void FluidRenderer::Render()
{
	/*glEnable(GL_DEPTH_TEST);
	glClearColor(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	SceneObject& quad = sceneManager->quadObj;
	glViewport(0, 0, depthWidth, depthHeight);
	
	UseDefaultFBO();
	ClearDefaultFBO();

	textureShader->Use();

	tmpTex.Bind(GL_TEXTURE0);
	textureShader->SetUniformMatrix4f("model", glm::mat4());
	textureShader->SetUniformMatrix4f("view", glm::mat4());
	textureShader->SetUniformMatrix4f("projection", glm::mat4());

	quad.DrawModel();

	return;*/

	if (currentFrame >= 520)
		return;

	importer.Update(fluidVertices);
	fluidVAO.VertexBufferData(sizeof(GLfloat)*importer.particleNum * 6, fluidVertices);

	char tmp[1024];
	sprintf(tmp, "%04d", currentFrame);
	string outfile = "";
	
	ScreenSpaceFluidRender();

	outfile += "fluid_screenspace/";
	outfile += tmp;
	outfile += ".png";
	pngExporter.WritePngFile(outfile, pngTex, GL_RGB);
	cout << currentFrame << "번째 screen space 프레임 그리는 중" << endl;
	Sleep(5000.0f);

	mc.ComputeDensity(fluidVertices, importer.particleNum);
	fluidMesh = mc.ExcuteMarchingCube();
	MarchingCubeRender();

	outfile = "";
	outfile += "fluid_marchingcube/";
	outfile += tmp;
	outfile += ".png";
	pngExporter.WritePngFile(outfile, pngTex, GL_RGB);
	cout << currentFrame << "번째 marching cube 프레임 그리는 중" << endl;
	Sleep(5000.0f);

	delete fluidMesh;

	currentFrame++;
}

void FluidRenderer::ScreenSpaceFluidRender()
{
	glEnable(GL_DEPTH_TEST);
	glClearColor(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	Object* camera = sceneManager->movingCamera;
	SceneObject& quad = sceneManager->quadObj;
	SceneObject& cube = sceneManager->skyboxObj;
	vector<SceneObject>& objs = sceneManager->sceneObjs;

	glm::mat4 projection = glm::perspective(
		glm::radians(45.0f),
		WindowManager::GetInstance()->width / WindowManager::GetInstance()->height,
		depthNear,
		depthFar);

	glm::mat4 view = glm::inverse(camera->GetModelMatrix());
	// world 그리기
	glViewport(0, 0, WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);

	pbrFBO.Use();
	pbrFBO.Clear(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a);
	pbrShader->Use();

	pbrShader->SetUniformMatrix4f("view", view);
	pbrShader->SetUniformMatrix4f("projection", projection);

	pbrShader->SetUniformVector3f("lightPos", glm::vec3(10.0f, 0.0f, 0.0f));
	pbrShader->SetUniformVector3f("eyePos", camera->GetWorldPosition());
	pbrShader->SetUniformVector3f("lightColor", glm::vec3(0.8f, 0.8f, 0.8f));
	floorAlbedoTex.Bind(GL_TEXTURE1);

	/*for (int i = 0; i < 1; i++)
	{
		glm::mat4 model = objs[i].GetModelMatrix();
		pbrShader->SetUniformMatrix4f("model", model);
		objs[i].DrawModel();
	}*/
	// world 그리기 끝

	// 파티클들 depth map 그리기
	glViewport(0, 0, depthWidth, depthHeight);

	depthThicknessFBO.Use();
	depthThicknessFBO.Clear(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a);
	particleDepthShader->Use();

	particleDepthShader->SetUniformMatrix4f("view", view);
	particleDepthShader->SetUniformMatrix4f("projection", projection);
	particleDepthShader->SetUniform1f("near", depthNear);
	particleDepthShader->SetUniform1f("far", depthFar);

	DrawFluids(28.0f);
	// 파티클들 depth map 그리기 끝

	//// 왜인지 thickness map이 제대로 안됨
	//// 파티클들 thickness map 그리기
	//glEnable(GL_BLEND);
	//glDisable(GL_DEPTH_TEST);
	//glBlendFunc(GL_ONE, GL_ONE);

	//particleThicknessShader->Use();
	//particleThicknessShader->SetUniformMatrix4f("view", view);
	//particleThicknessShader->SetUniformMatrix4f("projection", projection);
	//
	//DrawFluids(glm::distance(camera->GetPosition(), glm::vec3(0.0f, camera->GetPosition().y, 0.0f)));
	//glEnable(GL_DEPTH_TEST);
	//glDisable(GL_BLEND);
	//// 파티클들 thickness map 그리기 끝

	// depth, thickness blur 시작
	blurShader->Use();
	glViewport(0, 0, depthWidth, depthHeight);
	for (int i = 0; i < blurNum * 2; i++)
	{
		int a = (i + 1) % 2, b = i % 2;

		depthBlurFBO[a].Use();
		depthBlurFBO[a].Clear(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a);
		if (i)
			depthBlurTex[b].Bind(GL_TEXTURE0);
		else
			depthTex.Bind(GL_TEXTURE0);
		quad.DrawModel();

		thicknessBlurFBO[a].Use();
		thicknessBlurFBO[a].Clear(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a);
		if (i)
			thicknessBlurTex[b].Bind(GL_TEXTURE0);
		else
			thicknessTex.Bind(GL_TEXTURE0);
		quad.DrawModel();
	}
	// depth, thickness blur 끝

	// quad 그리기
	/*UseDefaultFBO();
	ClearDefaultFBO();*/
	pngFBO.Use();
	pngFBO.Clear(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a);

	glViewport(0, 0, WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);

	surfaceShader->Use();
	surfaceShader->SetUniformMatrix4f("projection", projection);
	surfaceShader->SetUniformMatrix4f("view", view);
	surfaceShader->SetUniformVector3f("eyePos", camera->GetWorldPosition());
	surfaceShader->SetUniformVector3f("lightDir", glm::normalize(glm::vec3(1.0f, -1.0f, 0.0f)));

	worldColorTex.Bind(GL_TEXTURE0);
	depthBlurTex[0].Bind(GL_TEXTURE1);
	thicknessBlurTex[0].Bind(GL_TEXTURE2);
	colorTex.Bind(GL_TEXTURE3);
	worldDepthTex.Bind(GL_TEXTURE4);

	depthTex.Bind(GL_TEXTURE5);

	quad.DrawModel();
}

void FluidRenderer::MarchingCubeRender()
{
	glEnable(GL_DEPTH_TEST);
	glClearColor(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	SceneObject quadObj = sceneManager->quadObj;
	Object* camera = sceneManager->movingCamera;

	glm::mat4 projection = glm::perspective(
		glm::radians(45.0f),
		WindowManager::GetInstance()->width / WindowManager::GetInstance()->height,
		sceneNaer,
		sceneFar);
	glm::mat4 view = glm::inverse(camera->GetModelMatrix());
	glm::mat4 model = glm::mat4();

	glViewport(0, 0, depthWidth, depthHeight);
	/*UseDefaultFBO();
	ClearDefaultFBO();*/
	pngFBO.Use();
	pngFBO.Clear(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a);

	marchingCubeFluidShader->Use();
	marchingCubeFluidShader->SetUniformMatrix4f("model", model);
	marchingCubeFluidShader->SetUniformMatrix4f("view", view);
	marchingCubeFluidShader->SetUniformMatrix4f("projection", projection);

	marchingCubeFluidShader->SetUniformVector3f("L", glm::vec3(0.0f, 100.0f, -10.0f));
	marchingCubeFluidShader->SetUniformVector3f("eyePos", camera->GetWorldPosition());

	fluidMesh->Draw();
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
	importer.Quit();
}

void FluidRenderer::DrawFluids(const float& dist)
{
	fluidVAO.Bind();
	glPointSize(15000 / (dist*dist));
	glDrawArrays(GL_POINTS, 0, importer.particleNum);
}