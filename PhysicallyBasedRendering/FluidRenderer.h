#pragma once

#include "Renderer.h"
#include "FluidSimulationImporter.h"

class FluidRenderer : public Renderer
{
public:
	FluidRenderer() {};
	virtual ~FluidRenderer() {};

	void InitializeRender();
	void Render();
	void TerminateRender(); 

private:
	ShaderProgram* depthShader;
	// TODO 이것은 debug용 나중에 지울것임
	ShaderProgram* quadShader;
	ShaderProgram* particleDepthShader;
	ShaderProgram* particleThicknessShader;

	ShaderProgram* depthBlurShader;
	ShaderProgram* surfaceShader;
	ShaderProgram* pbrShader;

	// world
	Texture worldColorTex;
	Texture worldDepthTex;

	// debug용임 
	Texture colorTex;

	Texture depthTex;
	Texture thicknessTex;
	
	RenderBufferObject tmpDepthRBO;
	
	// blur
	Texture depthBlurTex[2];
	Texture depthBlurTmpDepthTex[2];

	const int depthWidth = 1024;
	const int depthHeight = 1024;

	const int blurNum = 2;

	const float depthNear = 1.0f;
	const float depthFar = 40.0;

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