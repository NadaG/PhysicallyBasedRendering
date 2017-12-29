#pragma once

#include "Renderer.h"
#include "PhongShaderProgram.h"
#include "StarBurstSceneManager.h"

#include <memory>

// TODO path tracing and bloom here
class StarBurstRenderer : public Renderer
{
public:
	StarBurstRenderer(SceneManager* sceneManager)
		:Renderer(sceneManager), blurStep(3)
	{
		zNear = 0.01f;
		zFar = 100.0f;
	}
	virtual ~StarBurstRenderer() {};

	void InitializeRender();
	void Render();
	void TerminateRender();

private:

	const int blurStep;

	FrameBufferObject worldFBO;
	FrameBufferObject brightFBO;
	FrameBufferObject pingpongBlurFBO[2];

	Texture2D worldMap;
	Texture2D brightMap;
	Texture2D pingpongBlurMap[2];

	ShaderProgram* pbrShader;
	ShaderProgram* lightShader;
	ShaderProgram* blurShader;
	ShaderProgram* bloomShader;
	ShaderProgram* brightShader;

	shared_ptr<ShaderProgram> skyboxShader;

	Texture2D aoTex;
	Texture2D albedoTex;
	Texture2D metallicTex;
	Texture2D normalTex;
	Texture2D roughnessTex;
	Texture2D emissionTex;

	TextureCube* hdrSkyBoxTex;
	Texture2D hdrTex;
};