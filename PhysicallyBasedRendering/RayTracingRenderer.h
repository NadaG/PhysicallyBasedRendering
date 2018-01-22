#pragma once

#include "Renderer.h"
#include "RayTracingSceneManager.h"

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

	ShaderProgram* rayTracingShader;
};