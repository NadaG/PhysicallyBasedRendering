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
	ShaderProgram* cubeReflectShader;

	Texture aoTex;
	Texture albedoTex;
	Texture heightTex;
	Texture metallicTex;
	Texture normalTex;
	Texture roughnessTex;

	Texture hdrSkyboxTex;
	Texture irradianceSkyboxTex;

	Texture hdrTex;

	FrameBufferObject captureFBO;
	RenderBufferObject captureRBO;

	glm::mat4 captureProjection;
	glm::mat4 captureViews[6];
};