#pragma once

#include "Renderer.h"
#include "PhongShaderProgram.h"
#include "StarBurstSceneManager.h"

#include <memory>

// TODO path tracing and bloom here
// Renderer에서는 각각의 ShaderProgram과 Object 배열이 있고
// ShaderProgram의 vertex shader, fragment shader를 선택하는 과정이 있으며
// ShaderProgram을 use하고 object를 render하는 과정이 있다.
class StarBurstRenderer : public Renderer
{
public:
	StarBurstRenderer(SceneManager* sceneManager)
		:Renderer(sceneManager), blurStep(2)
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

	// TODO ShaderProgram Class에서 VertexShader class와 FragmentShader class를 두는 것이 맞다고 본다
	// 또한 VertexShader 등의 class에서 input texture와 uniform이 정의되어 있어야한다고 본다.
	ShaderProgram* pbrShader;
	ShaderProgram* lightShader;
	ShaderProgram* blurShader;
	ShaderProgram* bloomShader;
	ShaderProgram* brightShader;

	Texture2D aoTex;
	Texture2D albedoTex;
	Texture2D metallicTex;
	Texture2D normalTex;
	Texture2D roughnessTex;
	Texture2D emissionTex;
};