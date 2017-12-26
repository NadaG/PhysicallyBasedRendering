#pragma once

#include "Renderer.h"
#include "PhongShaderProgram.h"
#include "StarBurstSceneManager.h"

// TODO path tracing and bloom here
class StarBurstRenderer : public Renderer
{
public:
	StarBurstRenderer(SceneManager* sceneManager)
		:Renderer(sceneManager)
	{}
	virtual ~StarBurstRenderer() {};

	void InitializeRender();
	void Render();
	void TerminateRender();

private:

	PhongShaderProgram phongShader;
};