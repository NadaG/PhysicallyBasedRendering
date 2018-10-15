#pragma once

#include "Renderer.h"
#include "FluidSimulationImporter.h"
#include "FluidSimulationClient.h"
#include "FluidSceneManager.h"
#include "MarchingCube.h"
#include "NormalEstimateModel.h"
#include "CIsoSurface.h"

#include <ctime>

enum FluidSceneType
{
	DAM_BREAK = 0,
	DAM_BREAK_VALIDATION = 1,
	
	DOUBLE_DAM_BREAK = 2,
	DOUBLE_DAM_BREAK_VALIDATION = 3,
	
	POURING_FLUID = 4,
	POURING_FLUID_VALIDATION = 5,
	
	SPHERE_CROWN = 6,
	SPHERE_CROWN_VALIDATION = 7
};

struct FluidCube
{
	float3 pos;
	int3 size;
};

class FluidRenderer : public Renderer
{
public:
	FluidRenderer(SceneManager* sceneManager)
		:Renderer(sceneManager), fluidSceneType(POURING_FLUID_VALIDATION)
	{}
	virtual ~FluidRenderer() {};

	void InitializeRender();
	void Render();

	void ScreenSpaceFluidNormalRender();
	void MarchingCubeFluidNormalRender(const string meshfile, const bool isExport);

	void PhongRenderUsingNormalMap(const string& imgfile);

	void TerminateRender(); 

private:
	ShaderProgram* particleColorShader;
	ShaderProgram* particleDepthShader;
	ShaderProgram* particleThicknessShader;

	ShaderProgram* depthBlurShader;
	ShaderProgram* blurShader;

	ShaderProgram* surfaceShader;
	ShaderProgram* pbrShader;

	ShaderProgram* marchingCubeFluidShader;

	ShaderProgram* phongShader;

	ShaderProgram* skyBoxShader;

	////debug용임
	//ShaderProgram* textureShader;
	//Texture2D tmpTex;

	// floor
	Texture2D floorAlbedoTex;

	// world
	Texture2D worldColorTex;
	Texture2D worldDepthTex;

	TextureCube skyBoxTex;

	// debug용임 normal 값 저장
	Texture2D colorTex;

	Texture2D particleColorTex;
	Texture2D depthTex;
	Texture2D thicknessTex;

	Texture2D normalTex;
	
	RenderBufferObject tmpDepthRBO;
	
	// blur
	Texture2D depthBlurTex[2];
	Texture2D thicknessBlurTex[2];
	Texture2D particleColorBlurTex[2];

	const int depthWidth = 1024;
	const int depthHeight = 1024;

	const int blurNum = 3;

	const float depthNear = 1.0f;
	const float depthFar = 200.0f;

	const float sceneNaer = 1.0f;
	const float sceneFar = 200.0f;

	const float pointSize = 1000.0f;

	FrameBufferObject pbrFBO;
	
	FrameBufferObject particleColorFBO;
	FrameBufferObject depthFBO;
	FrameBufferObject thicknessFBO;

	FrameBufferObject particleColorBlurFBO[2];
	FrameBufferObject depthBlurFBO[2];
	FrameBufferObject thicknessBlurFBO[2];

	FrameBufferObject pngFBO;

	VertexArrayObject fluidVAO;
	VertexArrayObject fluidMeshVAO;

	VertexArrayObject skyBoxVAO;

	GLfloat* fluidVertices;
	FluidSimulationImporter importer;
	FluidSimulationClient clientImporter;

	int currentFrame;

	MarchingCube mc;
	CIsoSurface<float> iso;

	PNGExporter pngExporter;

	Texture2D pngTex;

	NormalEstimateModel NEM;

	void GenerateSphereFluid(const int height, const vec3 pos, const vec3 vel);
	FluidCube* InitializeSphereCrownFluid(int& cubeNum);
	FluidCube* InitializeSphereCrownFluidValidation(int& cubeNum);

	FluidCube* InitializeDamBreakFluid(int& cubeNum);
	FluidCube* InitializeDamBreakFluidValidation(int& cubeNum);

	FluidCube* InitializeDoubleDamBreakFluid(int& cubeNum);
	FluidCube* InitializeDoubleDamBreakFluidValidation(int& cubeNum);

	FluidCube* InitializePouringFluid(int& cubeNum);
	void UpdatePouringFluid();
	FluidCube* InitializePouringFluidValidation(int& cubeNum);
	void UpdatePouringFluidValidation();

private:

	FluidSceneType fluidSceneType;

	// scene type
	string sceneTypeStr;
	// dynamic or static
	string sceneModeStr;
	bool isDynamicScene;

	bool isRenderOnDefaultFBO;
	bool isScreenSpace;

	int targetFrame;
	int lastFrame;

	glm::vec3 boundarySize;

	void DrawFluids(const float cameraDist);
	void DrawFluidMesh(const int indexNum);

	void LoadSkyBox();
};