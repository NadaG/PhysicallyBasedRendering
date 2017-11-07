#pragma once

#include "Renderer.h"
#include "FluidSimulationImporter.h"
#include "FluidSceneManager.h"

class FluidRenderer : public Renderer
{
public:
	FluidRenderer(SceneManager* sceneManager)
		:Renderer(sceneManager)
	{}
	virtual ~FluidRenderer() {};

	void InitializeRender();
	void Render();
	void TerminateRender(); 

private:
	ShaderProgram* particleDepthShader;
	ShaderProgram* particleThicknessShader;

	ShaderProgram* blurShader;

	ShaderProgram* surfaceShader;
	ShaderProgram* pbrShader;

	// floor
	Texture floorAlbedoTex;

	// world
	Texture worldColorTex;
	Texture worldDepthTex;

	// debugøÎ¿” 
	Texture colorTex;

	Texture depthTex;
	Texture thicknessTex;
	
	RenderBufferObject tmpDepthRBO;
	
	// blur
	Texture depthBlurTex[2];
	Texture thicknessBlurTex[2];
	
	const int depthWidth = 1024;
	const int depthHeight = 1024;

	const int blurNum = 2;

	const float depthNear = 1.0f;
	const float depthFar = 60.0;

	FrameBufferObject pbrFBO;
	FrameBufferObject depthThicknessFBO;
	FrameBufferObject depthBlurFBO[2];
	FrameBufferObject thicknessBlurFBO[2];

	VertexArrayObject fluidVAO;

	GLfloat* fluidVertices;
	FluidSimulationImporter importer;

private:

	void DrawFluids(const float& dist);
};