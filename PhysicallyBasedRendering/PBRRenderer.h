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
	const int skyboxResolution = 512;

	ShaderProgram* pbrShader;
	ShaderProgram* lightShader;
	ShaderProgram* equirectangularToCubemapShader;
	ShaderProgram* irradianceShader;
	ShaderProgram* skyboxShader;
	//ShaderProgram* cubeReflectShader;
	ShaderProgram* prefilterShader;
	ShaderProgram* brdfShader;

	Texture2D aoTex;
	Texture2D albedoTex;
	Texture2D metallicTex;
	Texture2D normalTex;
	Texture2D roughnessTex;

	TextureCube hdrSkyboxTex;
	TextureCube irradianceSkyboxTex;
	TextureCube prefilterSkyboxTex;

	Texture2D brdfTex;
	Texture2D hdrTex;

	FrameBufferObject captureFBO;
	RenderBufferObject captureRBO;

	glm::mat4 captureProjection;
	glm::mat4 captureViews[6];
};