#pragma once

#include "Renderer.h"
#include "PBRSceneManager.h"

class PBRRenderer : public Renderer
{
public:
	PBRRenderer(SceneManager* sceneManager)
		:Renderer(sceneManager)
	{}
	virtual ~PBRRenderer() {};

	void InitializeRender();
	void Render();
	void TerminateRender();

private:
	ShaderProgram* pbrShader;
	ShaderProgram* lightShader;

	Texture aoTex;
	Texture albedoTex;
	Texture heightTex;
	Texture metallicTex;
	Texture normalTex;
	Texture roughnessTex;
};