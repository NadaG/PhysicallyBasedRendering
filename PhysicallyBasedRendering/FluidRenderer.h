#pragma once

#include "Renderer.h"
#include "FluidSimulationImporter.h"
#include "FluidSceneManager.h"
#include "MarchingCube.h"

class FluidRenderer : public Renderer
{
public:
	FluidRenderer(SceneManager* sceneManager)
		:Renderer(sceneManager)
	{}
	virtual ~FluidRenderer() {};

	void InitializeRender();
	void Render();

	void ScreenSpaceFluidRender();
	void MarchingCubeRender();

	void TerminateRender(); 

private:
	ShaderProgram* particleDepthShader;
	ShaderProgram* particleThicknessShader;

	ShaderProgram* blurShader;

	ShaderProgram* surfaceShader;
	ShaderProgram* pbrShader;

	ShaderProgram* marchingCubeFluidShader;

	////debug용임
	//ShaderProgram* textureShader;
	//Texture2D tmpTex;

	// floor
	Texture2D floorAlbedoTex;

	// world
	Texture2D worldColorTex;
	Texture2D worldDepthTex;

	// debug용임 normal 값 저장
	Texture2D colorTex;

	Texture2D depthTex;
	Texture2D thicknessTex;
	
	RenderBufferObject tmpDepthRBO;
	
	// blur
	Texture2D depthBlurTex[2];
	Texture2D thicknessBlurTex[2];

	const int depthWidth = 1024;
	const int depthHeight = 1024;

	const int blurNum = 2;

	const float depthNear = 0.01f;
	const float depthFar = 100.0;

	const float sceneNaer = 0.01f;
	const float sceneFar = 100.0f;

	FrameBufferObject pbrFBO;
	FrameBufferObject depthThicknessFBO;
	FrameBufferObject depthBlurFBO[2];
	FrameBufferObject thicknessBlurFBO[2];

	FrameBufferObject pngFBO;

	VertexArrayObject fluidVAO;

	GLfloat* fluidVertices;
	FluidSimulationImporter importer;

	int currentFrame;

	MarchingCube mc;

	PNGExporter pngExporter;

	Texture2D pngTex;

private:

	glm::vec3 boundarySize;

	Mesh* fluidMesh;

	void DrawFluids(const float& dist);
};