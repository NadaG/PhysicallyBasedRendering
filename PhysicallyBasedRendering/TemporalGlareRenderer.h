#pragma once

#include "Renderer.h"
#include "TemporalGlareSceneManager.h"

#include <memory>

// TODO path tracing and bloom here
// Renderer������ ������ ShaderProgram�� Object �迭�� �ְ�
// ShaderProgram�� vertex shader, fragment shader�� �����ϴ� ������ ������
// ShaderProgram�� use�ϰ� object�� render�ϴ� ������ �ִ�.
class TemporalGlareRenderer : public Renderer
{
public:
	TemporalGlareRenderer(SceneManager* sceneManager)
		:Renderer(sceneManager)
	{
		zNear = 0.01f;
		zFar = 100.0f;
	}
	virtual ~TemporalGlareRenderer() {};

	void InitializeRender();
	void Render();
	void TerminateRender();

	void GenerateFibersVAO();
	void GeneratePupilVAO();
	void GenerateParticlesVAO();

	// DEBUG
	void GenerateCosTex();
	//

private:

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

	Texture2D ftMultipliedTex;
	Texture2D iftMultipliedTex;

	VertexArrayObject lensFibersVAO;
	VertexArrayObject lensPupilVAO;
	VertexArrayObject lensParticlesVAO;

	// DEBUG
	Texture2D cosTex;
	Texture2D cosFourierTex;
	//

	PNGExporter pngExporter;
	int writeFileNum = 0;

	FourierTransform ft;

	int lensParticlesNum = 0;
	const int lensFibersNum = 300;
	const int lensPupilTrianglesNum = 500;

	const float pupilRadius = 0.7f;
	const float lensFiberInRadius = 0.5f;
	const float lensFiberOutRadius = 5.0f;

	const float lambda = 0.1f;
	const float d = 0.1f;
};