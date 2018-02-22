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

	// TODO ShaderProgram Class���� VertexShader class�� FragmentShader class�� �δ� ���� �´ٰ� ����
	// ���� VertexShader ���� class���� input texture�� uniform�� ���ǵǾ� �־���Ѵٰ� ����.
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