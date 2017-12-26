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

	//PhongShaderProgram phongShader;
	ShaderProgram* pbrShader;
	ShaderProgram* lightShader;

	Texture2D aoTex;
	Texture2D albedoTex;
	Texture2D metallicTex;
	Texture2D normalTex;
	Texture2D roughnessTex;
	Texture2D emissionTex;
};