#pragma once

#include "Renderer.h"
#include "PhongShaderProgram.h"
#include "StarBurstSceneManager.h"

#include <memory>

// TODO path tracing and bloom here
// Renderer������ ������ ShaderProgram�� Object �迭�� �ְ�
// ShaderProgram�� vertex shader, fragment shader�� �����ϴ� ������ ������
// ShaderProgram�� use�ϰ� object�� render�ϴ� ������ �ִ�.
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

	// TODO ShaderProgram Class���� VertexShader class�� FragmentShader class�� �δ� ���� �´ٰ� ����
	// ���� VertexShader ���� class���� input texture�� uniform�� ���ǵǾ� �־���Ѵٰ� ����.
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