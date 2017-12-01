#pragma once

#include "Renderer.h"
#include "LTCSceneManager.h"

class LTCRenderer : public Renderer
{
public:
	LTCRenderer(SceneManager* sceneManager)
		:Renderer(sceneManager)
	{}
	virtual ~LTCRenderer() {};

	void InitializeRender();
	void Render();
	void TerminateRender();

private:
	ShaderProgram* ltcShader;

	Texture2D ltcTex;
};