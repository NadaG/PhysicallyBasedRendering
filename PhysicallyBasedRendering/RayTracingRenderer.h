#pragma once

#include "Renderer.h"
#include "RayTracingSceneManager.h"

#include "Test.cuh"

class RayTracingRenderer : public Renderer
{
public:
	RayTracingRenderer(SceneManager* sceneManager)
		:Renderer(sceneManager)
	{}
	virtual ~RayTracingRenderer() {};

	void InitializeRender();
	void Render();
	void TerminateRender();

private:

	int writeFileNum = 0;

	FrameBufferObject rayTracingFBO;
	Texture2D rayTracingTex;

	ShaderProgram* rayTracingShader;
	PNGExporter pngExporter;
};