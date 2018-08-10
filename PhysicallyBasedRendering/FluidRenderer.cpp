#include "FluidRenderer.h"

void FluidRenderer::InitializeRender()
{
	backgroundColor = glm::vec4(0.0f, 0.0f, 0.0f, 1.0f);

	pbrShader = new ShaderProgram("PBR.vs", "PBR.fs");
	pbrShader->Use();
	pbrShader->SetUniform1i("albedoMap", 1);

	particleDepthShader = new ShaderProgram("ParticleSphere.vs", "ParticleDepth.fs");
	particleDepthShader->Use();

	particleThicknessShader = new ShaderProgram("ParticleSphere.vs", "particleThickness.fs");
	particleThicknessShader->Use();

	blurShader = new ShaderProgram("Quad.vs", "DepthBlur.fs");
	blurShader->Use();
	blurShader->SetUniform1i("map", 0);
	blurShader->SetUniform1i("neighborNum", 5);
	blurShader->SetUniform1f("blurScale", 0.1f);
	blurShader->SetUniform1f("blurDepthFalloff", 100.0f);

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

	phongShader = new ShaderProgram("Quad.vs", "NormalPhong.fs");
	phongShader->Use();
	phongShader->SetUniform1i("normalMap", 0);

	////////////////////////
	//textureShader = new ShaderProgram("Basic.vs", "Basic.fs");
	//textureShader->Use();
	//textureShader->SetUniform1i("map", 0);

	//tmpTex.LoadTexture("ExportData/tmp.png");
	//tmpTex.SetParameters(GL_NEAREST, GL_NEAREST, GL_REPEAT, GL_REPEAT);
	////////////////////////

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

	normalTex.LoadTexture("ExportData/fluid_marchingcube1/0113.png");
	normalTex.SetParameters(GL_NEAREST, GL_NEAREST, GL_REPEAT, GL_REPEAT);

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

	depthFBO.GenFrameBufferObject();
	// rbo는 texture로 쓰이지 않을 것이라는 것을 뜻함
	// 이 힌트를 미리 줌으로써 가속화를 할 수 있음
	depthFBO.BindRenderBuffer(GL_DEPTH_ATTACHMENT, tmpDepthRBO);
	depthFBO.BindTexture(GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, &colorTex);
	depthFBO.BindTexture(GL_COLOR_ATTACHMENT1, GL_TEXTURE_2D, &depthTex);
	depthFBO.DrawBuffers();

	if (depthFBO.CheckStatus() == GL_FRAMEBUFFER_COMPLETE)
	{
		cout << "depth FBO complete" << endl;
	}

	thicknessFBO.GenFrameBufferObject();

	thicknessFBO.BindRenderBuffer(GL_DEPTH_ATTACHMENT, tmpDepthRBO);
	thicknessFBO.BindTexture(GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, &thicknessTex);
	thicknessFBO.DrawBuffers();

	if (thicknessFBO.CheckStatus() == GL_FRAMEBUFFER_COMPLETE)
	{
		cout << "thickness FBO complete" << endl;
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

	boundarySize = glm::vec3(30.0f, 30.0f, 30.0f);
	
	FluidCube* cubes = new FluidCube[1];

	/*cubes[0].size.x = 20;
	cubes[0].size.y = 20;
	cubes[0].size.z = 25;
	cubes[0].pos.x = -8.0f;
	cubes[0].pos.y = 0.0f;
	cubes[0].pos.z = -8.0f;

	cubes[1].size.x = 20;
	cubes[1].size.y = 30;
	cubes[1].size.z = 25;
	cubes[1].pos.x = 8.0f;
	cubes[1].pos.y = 0.0f;
	cubes[1].pos.z = 8.0f;*/

	cubes[0].size.x = 40;
	cubes[0].size.y = 30;
	cubes[0].size.z = 40;
	cubes[0].pos.x = 0.0f;
	cubes[0].pos.y = 0.0f;
	cubes[0].pos.z = 0.0f;

	// simulation 공간을 약간 작게 해주어야 marching cube가 제대로 그려짐

	fluidVAO.GenVAOVBOIBO();

	// DLL
	importer.Initialize(boundarySize * 0.8f, cubes, 1);
	fluidVertices = new GLfloat[importer.particleNum * 6];
	fluidVAO.VertexBufferData(sizeof(GLfloat)*importer.particleNum * 6, fluidVertices);

	// CLIENT
	/*clientImporter.Initialize(boundarySize, cubes, 1);
	fluidVertices = new GLfloat[clientImporter.particleNum * 6];
	fluidVAO.VertexBufferData(sizeof(GLfloat)*clientImporter.particleNum * 6, fluidVertices);*/

	// position
	fluidVAO.VertexAttribPointer(3, 6);
	// color
	fluidVAO.VertexAttribPointer(3, 6);

	currentFrame = 0;
	float resolutionRatio = 3.0f;
	// 128장 그린거 5.0, 0.75였음
	mc.BuildingGird(
		boundarySize.x,
		boundarySize.y,
		boundarySize.z,
		boundarySize.x*resolutionRatio,
		boundarySize.y*resolutionRatio,
		boundarySize.z*resolutionRatio,
		0.2f);

	isRenderOnDefaultFBO = false;
	targetFrame = 210;

	/*float* data = new float[1024 * 1024 * 3];
	for (int i = 0; i < 1024 * 1024 * 3; i++)
		data[i] = 125.0f;

	NEM.LoadModel();
	NEM.UseModel(data);

	delete[] data;*/
}

void FluidRenderer::Render()
{
	if (currentFrame >= 5000 && !isRenderOnDefaultFBO)
		return;

	// DLL
	importer.Update(fluidVertices);
	fluidVAO.VertexBufferData(sizeof(GLfloat)*importer.particleNum * 6, fluidVertices);
	
	// CLIENT
	/*clientImporter.Update(fluidVertices);
	fluidVAO.VertexBufferData(sizeof(GLfloat)*clientImporter.particleNum * 6, fluidVertices);*/

	if (isRenderOnDefaultFBO && currentFrame == targetFrame)
	{
		MarchingCubeFluidNormalRender("tmp.obj");
		//ScreenSpaceFluidNormalRender();
		Sleep(1000.0f);
		
		/*char tmp[1024];
		sprintf(tmp, "%04d", currentFrame);
		string outfile = "";

		outfile += "ExportData/fluid_marchingcube6/";
		outfile += tmp;
		outfile += ".png";

		outfile = "Decoded/decode295000.png";*/

		//PhongRenderUsingNormalMap("Decoded/decode430000.png");
		//PhongRenderUsingNormalMap("ExportData/fluid_marchingcube6/0226.png");
	}
	else if (!isRenderOnDefaultFBO/* && currentFrame == targetFrame*/)
	{
		char tmp[1024];
		sprintf(tmp, "%04d", currentFrame);
		string outfile = "";

		ScreenSpaceFluidNormalRender();

		outfile += "fluid_screenspace5/";
		outfile += tmp;
		outfile += ".png";
		pngExporter.WritePngFile(outfile, pngTex, GL_RGB);
		cout << currentFrame << "번째 screen space 프레임 그리는 중" << endl;
		Sleep(2000.0f);

		// mesh file export
		outfile = "";
		outfile += "Obj/DroppingFluid/";
		/*outfile += tmp;*/
		outfile += "tmp.obj";
		MarchingCubeFluidNormalRender(outfile);

		outfile = "";
		outfile += "fluid_marchingcube5/";
		outfile += tmp;
		outfile += ".png";
		pngExporter.WritePngFile(outfile, pngTex, GL_RGB);
		cout << currentFrame << "번째 marching cube 프레임 그리는 중" << endl;
		Sleep(2000.0f);



		//Deep Learning
		//cout << "screen space start!" << endl;

		//ScreenSpaceFluidNormalRender();

		//cout << "screen space end!" << endl;

		//NEM.LoadModel();
		//NEM.UseModel(pngTex.GetTexImage(GL_RGB));

		//cout << "model out end!" << endl;

		//Sleep(10000.0f);
	}

	currentFrame++;
}

void FluidRenderer::ScreenSpaceFluidNormalRender()
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
		model = glm::mat4();
		model = glm::translate(model, glm::vec3(0.0f, -12.0f, -10.0f));
		model = glm::rotate(model, -1.57f, glm::vec3(1.0f, 0.0f, 0.0f));
		model = glm::scale(model, glm::vec3(30.0f, 30.0f, 30.0f));
		pbrShader->SetUniformMatrix4f("model", model);

		objs[i].DrawModel();
	}*/
	// world 그리기 끝

	// 파티클들 depth map 그리기
	glViewport(0, 0, depthWidth, depthHeight);

	depthFBO.Use();
	depthFBO.Clear(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a);
	particleDepthShader->Use();

	particleDepthShader->SetUniformMatrix4f("view", view);
	particleDepthShader->SetUniformMatrix4f("projection", projection);
	particleDepthShader->SetUniform1f("near", depthNear);
	particleDepthShader->SetUniform1f("far", depthFar);

	DrawFluids(glm::distance(camera->GetPosition(), glm::vec3()));
	// 파티클들 depth map 그리기 끝

	// 왜인지 thickness map이 제대로 안됨
	// 파티클들 thickness map 그리기
	thicknessFBO.Use();
	thicknessFBO.Clear(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a);
	glEnable(GL_BLEND);
	glDisable(GL_DEPTH_TEST);
	glBlendFunc(GL_ONE, GL_ONE);

	particleThicknessShader->Use();
	particleThicknessShader->SetUniformMatrix4f("view", view);
	particleThicknessShader->SetUniformMatrix4f("projection", projection);
	
	DrawFluids(glm::distance(camera->GetPosition(), glm::vec3(0.0f, camera->GetPosition().y, 0.0f)));
	glEnable(GL_DEPTH_TEST);
	glDisable(GL_BLEND);
	// 파티클들 thickness map 그리기 끝

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
	if (isRenderOnDefaultFBO)
	{
		UseDefaultFBO();
		ClearDefaultFBO();
	}
	else
	{
		pngFBO.Use();
		pngFBO.Clear(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a);
	}

	glViewport(0, 0, WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);

	surfaceShader->Use();
	surfaceShader->SetUniformMatrix4f("projection", projection);
	surfaceShader->SetUniformMatrix4f("view", view);
	surfaceShader->SetUniformVector3f("eyePos", camera->GetWorldPosition());
	surfaceShader->SetUniformVector3f("lightDir", glm::normalize(glm::vec3(0.0f, -1.0f, 0.0f)));

	worldColorTex.Bind(GL_TEXTURE0);
	depthBlurTex[0].Bind(GL_TEXTURE1);
	thicknessBlurTex[0].Bind(GL_TEXTURE2);
	colorTex.Bind(GL_TEXTURE3);
	worldDepthTex.Bind(GL_TEXTURE4);

	depthTex.Bind(GL_TEXTURE5);

	quad.DrawModel();
}

void FluidRenderer::MarchingCubeFluidNormalRender(const string& meshfile)
{
	cout << importer.particleNum << endl;
	float* densities = mc.ComputeParticleDensity(fluidVertices, importer.particleNum);
	
	mc.ComputeAnisotropicKernelGridDensity(fluidVertices, densities, importer.particleNum);
	//mc.ComputeSphericalKernelGridDensity(fluidVertices, densities, importer.particleNum);

	mc.ExcuteMarchingCube(meshfile);

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
	if (isRenderOnDefaultFBO)
	{
		UseDefaultFBO();
		ClearDefaultFBO();
	}
	else
	{
		pngFBO.Use();
		pngFBO.Clear(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a);
	}

	marchingCubeFluidShader->Use();
	marchingCubeFluidShader->SetUniformMatrix4f("model", model);
	marchingCubeFluidShader->SetUniformMatrix4f("view", view);
	marchingCubeFluidShader->SetUniformMatrix4f("projection", projection);

	marchingCubeFluidShader->SetUniformVector3f("L", glm::vec3(0.0f, 100.0f, -10.0f));
	marchingCubeFluidShader->SetUniformVector3f("eyePos", camera->GetWorldPosition());

	Model m;
	m.Load(meshfile);
	cout << "model load end" << endl;
	m.Draw();
	cout << "model draw end" << endl;

	delete[] densities;
}

void FluidRenderer::PhongRenderUsingNormalMap(const string &imgfile)
{
	glEnable(GL_DEPTH_TEST);
	glClearColor(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	normalTex.UpdateTexture(imgfile);

	SceneObject quadObj = sceneManager->quadObj;
	Object* camera = sceneManager->movingCamera;
	
	glm::mat4 projection = glm::mat4();
	glm::mat4 view = glm::mat4();
	glm::mat4 model = glm::mat4();

	glViewport(0, 0, depthWidth, depthHeight);
	UseDefaultFBO();
	ClearDefaultFBO();

	phongShader->Use();

	phongShader->SetUniformVector3f("ambientColor", glm::vec3(0.1f, 0.1f, 0.1f));
	phongShader->SetUniformVector3f("diffuseColor", glm::vec3(0.2f, 0.4f, 0.7f));
	phongShader->SetUniformVector3f("specularColor", glm::vec3(0.005f, 0.01f, 0.03f));

	phongShader->SetUniformMatrix4f("model", model);
	phongShader->SetUniformMatrix4f("view", view);
	phongShader->SetUniformMatrix4f("projection", projection);

	phongShader->SetUniformVector3f("lightDir", glm::vec3(0.0f, 0.0f, -1.0f));
	phongShader->SetUniformVector3f("eyePos", glm::vec3(0.0f, 0.0f, 50.0f));

	normalTex.Bind(GL_TEXTURE0);

	quadObj.DrawModel();
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
	//clientImporter.Quit();
}

void FluidRenderer::DrawFluids(const float cameraDist)
{
	fluidVAO.Bind();
	glPointSize(pointSize / cameraDist);

	// DLL
	glDrawArrays(GL_POINTS, 0, importer.particleNum);
	
	// CLIENT
	// glDrawArrays(GL_POINTS, 0, clientImporter.particleNum);
}