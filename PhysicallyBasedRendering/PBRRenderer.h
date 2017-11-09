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
	FrameBufferObject captureFBO;
	RenderBufferObject captureRBO;

	ShaderProgram* pbrShader;
	ShaderProgram* lightShader;
	ShaderProgram* equirectangularToCubemapShader;
	ShaderProgram* irradianceShader;
	ShaderProgram* backgroundShader;

	Texture aoTex;
	Texture albedoTex;
	Texture heightTex;
	Texture metallicTex;
	Texture normalTex;
	Texture roughnessTex;
};