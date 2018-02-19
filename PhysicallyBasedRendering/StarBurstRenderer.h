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
		:Renderer(sceneManager), blurStep(0)
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
	ShaderProgram* glareShader;
	ShaderProgram* primitiveShader;
	ShaderProgram* fresnelDiffractionShader;
	ShaderProgram* multiplyShader;

	FrameBufferObject apertureFBO;
	FrameBufferObject fresnelDiffractionFBO;
	FrameBufferObject multipliedFBO;

	Texture2D apertureTex;
	Texture2D fresnelDiffractionTex;
	Texture2D multipliedTex;

	shared_ptr<ShaderProgram> skyboxShader;

	Texture2D aoTex;
	Texture2D albedoTex;
	Texture2D metallicTex;
	Texture2D normalTex;
	Texture2D roughnessTex;
	Texture2D emissionTex;

	TextureCube* hdrSkyBoxTex;
	Texture2D hdrTex;

	VertexArrayObject lensFibersVAO;
	VertexArrayObject lensPupilVAO;
	VertexArrayObject lensParticlesVAO;

	PNGExporter pngExporter;
	int writeFileNum = 0;

	int lensParticlesNum = 0;
	const int lensFibersNum = 300;
	const int lensPupilTrianglesNum = 500;

	const float pupilRadius = 0.7f;
	const float lensFiberInRadius = 0.5f;
	const float lensFiberOutRadius = 5.0f;

	const float lambda = 0.1f;
	const float d = 0.01f;
};