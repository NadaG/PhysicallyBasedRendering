#include "FluidRenderer.h"

void FluidRenderer::InitializeRender()
{
	GLenum err;

	backgroundColor = glm::vec4(0.0f, 0.0f, 0.0f, 1.0f);

	pbrShader = new ShaderProgram("PBR.vs", "PBR.fs");
	pbrShader->Use();
	pbrShader->SetUniform1i("albedoMap", 1);

	particleDepthShader = new ShaderProgram("ParticleSphere.vs", "ParticleDepth.fs");
	particleDepthShader->Use();

	particleThicknessShader = new ShaderProgram("ParticleSphere.vs", "particleThickness.fs");
	particleThicknessShader->Use();

	particleColorShader = new ShaderProgram("ParticleSphere.vs", "ParticleColor.fs");
	particleColorShader->Use();

	depthBlurShader = new ShaderProgram("Quad.vs", "DepthBlur.fs");
	depthBlurShader->Use();
	depthBlurShader->SetUniform1i("map", 0);
	depthBlurShader->SetUniform1i("neighborNum", 5);
	depthBlurShader->SetUniform1f("blurScale", 0.1f);
	depthBlurShader->SetUniform1f("blurDepthFalloff", 100.0f);

	blurShader = new ShaderProgram("Quad.vs", "GaussianBlur.fs");
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
	surfaceShader->SetUniform1i("bluredColorMap", 6);
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

	particleColorTex.LoadTexture(GL_RGBA32F, depthWidth, depthHeight, GL_RGBA, GL_FLOAT);
	particleColorTex.SetParameters(GL_NEAREST, GL_NEAREST, GL_REPEAT, GL_REPEAT);

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

	particleColorFBO.GenFrameBufferObject();

	particleColorFBO.BindRenderBuffer(GL_DEPTH_ATTACHMENT, tmpDepthRBO);
	particleColorFBO.BindTexture(GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, &particleColorTex);
	particleColorFBO.DrawBuffers();

	if (particleColorFBO.CheckStatus() == GL_FRAMEBUFFER_COMPLETE)
	{
		cout << "color FBO complete" << endl;
	}

	pbrFBO.GenFrameBufferObject();
	pbrFBO.BindTexture(GL_DEPTH_ATTACHMENT, GL_TEXTURE_2D, &worldDepthTex);
	pbrFBO.BindTexture(GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, &worldColorTex);
	pbrFBO.DrawBuffers();

	if (pbrFBO.CheckStatus() == GL_FRAMEBUFFER_COMPLETE)
	{
		cout << "pbr fbo complete" << endl;
	}

	err = glGetError();
	if (err != GL_NO_ERROR)
		printf("d Error: %s\n", glewGetErrorString(err));

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

		particleColorBlurTex[i].LoadTexture(GL_RGBA32F, depthWidth, depthHeight, GL_RGBA, GL_FLOAT);
		particleColorBlurTex[i].SetParameters(GL_NEAREST, GL_NEAREST, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);

		particleColorBlurFBO[i].GenFrameBufferObject();
		particleColorBlurFBO[i].BindDefaultDepthBuffer(depthWidth, depthHeight);
		particleColorBlurFBO[i].BindTexture(GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, &particleColorBlurTex[i]);
	}

	boundarySize = glm::vec3(30.0f, 30.0f, 30.0f);
	//
	const int cubeNum = 1;
	FluidCube* cubes = new FluidCube[cubeNum];
	/*cubes[0].size.x = 30;
	cubes[0].size.y = 20;
	cubes[0].size.z = 30;*/
	cubes[0].size.x = 25;
	cubes[0].size.y = 25;
	cubes[0].size.z = 25;
	cubes[0].pos.x = 0.0f;
	cubes[0].pos.y = 0.0f;
	cubes[0].pos.z = 0.0f;

	/*cubes[1].size.x = 40;
	cubes[1].size.y = 10;
	cubes[1].size.z = 40;
	cubes[1].pos.x = 0.0f;
	cubes[1].pos.y = -13.0f;
	cubes[1].pos.z = 0.0f;*/

	/*cubes[1].size.x = 5;
	cubes[1].size.y = 5;
	cubes[1].size.z = 5;
	cubes[1].pos.x = -4.0f;
	cubes[1].pos.y = 0.0f;
	cubes[1].pos.z = 6.0f;*/

	//// simulation 공간을 약간 작게 해주어야 marching cube가 제대로 그려짐

	//// DLL
	importer.Initialize(boundarySize * 1.0f, cubes, cubeNum);
	fluidVertices = new GLfloat[importer.particleNum * 6];

	//// CLIENT
	///*clientImporter.Initialize(boundarySize, cubes, 1);
	//fluidVertices = new GLfloat[clientImporter.particleNum * 6];*/

	fluidVAO.GenVAOVBOIBO();
	fluidVAO.VertexBufferData(sizeof(GLfloat) * importer.particleNum * 6, fluidVertices);
	fluidVAO.IndexBufferData(sizeof(GLuint) * importer.particleNum, fluidVertices);
	fluidVAO.VertexAttribPointer(3, 6);
	fluidVAO.VertexAttribPointer(3, 6);

	cout << "fluid vao 생성" << endl;

	fluidMeshVAO.GenVAOVBOIBO();
	fluidMeshVAO.VertexBufferData(0, 0);
	fluidMeshVAO.IndexBufferData(0, 0);
	fluidMeshVAO.VertexAttribPointer(3, 6);
	fluidMeshVAO.VertexAttribPointer(3, 6);
	glBindVertexArray(0);

	cout << "fluid mesh vao 생성" << endl;

	currentFrame = 0;

	const float resolution = 4.0f;
	mc.BuildingGird(boundarySize.x, boundarySize.y, boundarySize.z, 0.0f, 0.0f, 0.0f, resolution);

	/*float* data = new float[1024 * 1024 * 3];
	for (int i = 0; i < 1024 * 1024 * 3; i++)
		data[i] = 125.0f;

	NEM.LoadModel();
	NEM.UseModel(data);

	delete[] data;*/

	isRenderOnDefaultFBO = false;
	isScreenSpace = false;
	targetFrame = 188;

	lastFrame = 300;

	delete[] cubes;

	NEM.LoadModel();
}

void FluidRenderer::Render()
{
	if (currentFrame >= lastFrame && !isRenderOnDefaultFBO)
		return;

	// DLL
	importer.Update(fluidVertices);
	fluidVAO.VertexBufferData(sizeof(GLfloat)*importer.particleNum * 6, fluidVertices);
	
	//cout << importer.particleNum << endl;
	// CLIENT
	/*clientImporter.Update(fluidVertices);*/

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_R))
	{
		isScreenSpace = true;
	}

	if (InputManager::GetInstance()->IsKey(GLFW_KEY_T))
	{
		isScreenSpace = false;
		cout << "current frame: " << currentFrame << endl;
	}

	if (isRenderOnDefaultFBO/* && currentFrame == targetFrame*/ && currentFrame < lastFrame)
	{
		if(isScreenSpace)
			ScreenSpaceFluidNormalRender();
		else
			MarchingCubeFluidNormalRender("", false);
		
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
	else if (!isRenderOnDefaultFBO && currentFrame == targetFrame)
	{
		char currentFrameStr[512];
		sprintf(currentFrameStr, "%04d", currentFrame);
		string outfile = "";

		ScreenSpaceFluidNormalRender();

		cout << "screen space fluid normal render 끝남" << endl;

		outfile += "fluid_screenspace3/";
		outfile += currentFrameStr;
		outfile += ".png";
		pngExporter.WritePngFile(outfile, pngTex, GL_RGB);
		cout << currentFrame << "번째 screen space 프레임 그리는 중" << endl;
		Sleep(2000.0f);

		cout << "png export 끝남" << endl;

		// mesh file export
		outfile = "";
		outfile += "Obj/Anisotropic/";
		outfile += currentFrameStr;
		outfile += ".obj";
		//outfile += "tmp.obj";

		MarchingCubeFluidNormalRender(outfile, false);
		
		outfile = "";
		outfile += "fluid_marchingcube3/";
		outfile += currentFrameStr;
		outfile += ".png";
		pngExporter.WritePngFile(outfile, pngTex, GL_RGB);
		cout << currentFrame << "번째 marching cube 프레임 그리는 중" << endl;
		Sleep(2000.0f);

		//PhongRenderUsingNormalMap("ExportData/model_output/denoised200.png");
		//PhongRenderUsingNormalMap("ExportData/model_output/original200.png");
		
		//Deep Learning
		/*cout << currentFrame << " screen space start!" << endl;
		ScreenSpaceFluidNormalRender();
		cout << currentFrame << " screen space end!" << endl;
		NEM.AppendNoisyImage(pngTex.GetTexImage(GL_RGB));

		Sleep(100.0f);*/
	}

	/*if (!isRenderOnDefaultFBO && (currentFrame == lastFrame))
	{
		cout << "use model start" << endl;
		NEM.UseModel("ExportData/model_output/original", "ExportData/model_output/denoised", currentFrame);
		cout << "use model end" << endl;
	}*/

	currentFrame++;
}

void FluidRenderer::ScreenSpaceFluidNormalRender()
{
	glEnable(GL_DEPTH_TEST);
	glClearColor(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	glBindBuffer(GL_ARRAY_BUFFER, fluidVAO.VBO());
	glBufferSubData(GL_ARRAY_BUFFER, 0, sizeof(GLfloat) * importer.particleNum * 6, fluidVertices);

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

	// 파티클들 color map 그리기
	glViewport(0, 0, depthWidth, depthHeight);

	particleColorFBO.Use();
	particleColorFBO.Clear(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a);
	particleColorShader->Use();

	particleColorShader->SetUniformMatrix4f("view", view);
	particleColorShader->SetUniformMatrix4f("projection", projection);

	DrawFluids(glm::distance(camera->GetPosition(), glm::vec3()));
	// 파티클들 color map 그리기 끝

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
	glViewport(0, 0, depthWidth, depthHeight);
	for (int i = 0; i < blurNum * 2; i++)
	{
		int a = (i + 1) % 2, b = i % 2;

		depthBlurShader->Use();
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

		blurShader->Use();
		blurShader->SetUniformBool("horizontal", i % 2);
		particleColorBlurFBO[a].Use();
		particleColorBlurFBO[a].Clear(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a);
		if (i)
			particleColorBlurTex[b].Bind(GL_TEXTURE0);
		else
			particleColorTex.Bind(GL_TEXTURE0);
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
	particleColorBlurTex[0].Bind(GL_TEXTURE6);
	//particleColorTex.Bind(GL_TEXTURE6);

	quad.DrawModel();
}

void FluidRenderer::MarchingCubeFluidNormalRender(const string meshfile, const bool isExport)
{
	cout << "particle num: " << importer.particleNum << endl;

	// 사용하는 부분 
	// ComputeParticleDensity 함수에 들어가는 fluidVertices와
	// ComputeScalarFieldUsingSphericalKernel 함수에 들어가는 fluidVertices의 형식에 맞추어 주시면 됩니다
	mc.ComputeParticleDensity(fluidVertices, importer.particleNum);
	//float* scalarField = mc.ComputeScalarFieldUsingSphericalKernel(fluidVertices, importer.particleNum);
	float* scalarField = mc.ComputeScalarFieldUsingAnisotropicKernel(fluidVertices, importer.particleNum);

	int vertexNum, indexNum;
	iso.GenerateSurface(scalarField, 0.2f,
		mc.nodeNumX, mc.nodeNumY, mc.nodeNumZ, 
		mc.nodeWidth, mc.nodeHeight, mc.nodeDepth,
		mc.initNodePosX, mc.initNodePosY, mc.initNodePosZ,
		vertexNum, indexNum);
	if (isExport)
		iso.ExportMesh(vertexNum, indexNum, meshfile);

	float* verts;
	GLuint* inds;
	verts = iso.GetVertices(vertexNum);
	inds = iso.GetIndices(indexNum);

	fluidMeshVAO.Bind();
	glBindBuffer(GL_ARRAY_BUFFER, fluidMeshVAO.VBO());
	glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * 6 * vertexNum, verts, GL_STATIC_DRAW);
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(GLuint) * indexNum, inds, GL_STATIC_DRAW);

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

	/*Model m;
	m.Load(meshfile);
	cout << "model load end" << endl;
	m.Draw();
	cout << "model draw end" << endl;*/

	DrawFluidMesh(indexNum);
	iso.DeleteSurface();

	delete[] scalarField;

	delete[] verts;
	delete[] inds;
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

	depthBlurShader->Delete();
	delete depthBlurShader;

	surfaceShader->Delete();
	delete surfaceShader;

	pbrShader->Delete();
	delete pbrShader;

	sceneManager->TerminateObjects();
	importer.Quit();

	//clientImporter.Quit();

	// 절대 delete[] fluidVertices 하지 말것!!
}

void FluidRenderer::DrawFluids(const float cameraDist)
{
	fluidVAO.Bind();
	glPointSize(pointSize / cameraDist);

	// DLL
	//fluidVAO.SetDrawMode(GL_POINTS);
	glDrawArrays(GL_POINTS, 0, importer.particleNum);
	
	// CLIENT
	// glDrawArrays(GL_POINTS, 0, clientImporter.particleNum);

}

void FluidRenderer::DrawFluidMesh(int indexNum)
{
	fluidMeshVAO.Bind();

	glDrawElements(GL_TRIANGLES, indexNum, GL_UNSIGNED_INT, 0);
}
