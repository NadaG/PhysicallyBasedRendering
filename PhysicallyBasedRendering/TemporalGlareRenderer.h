#pragma once

#include "Renderer.h"
#include "TemporalGlareSceneManager.h"

#include <memory>

class TemporalGlareRenderer : public Renderer
{
public:
	TemporalGlareRenderer(SceneManager* sceneManager)
		:Renderer(sceneManager), 
		scale(400000.0f),
		n(32.0),
		d(0.017f),
		centerLambda(0.000000575),
		minLambda(0.000000380),
		lambdaDelta((0.000000770 - 0.000000380) / 32.0),
		lensParticlesNum(0),
		lensFibersNum(300),
		lensPupilTrianglesNum(500)
	{
		zNear = 0.01f;
		zFar = 100.0f;
	}
	virtual ~TemporalGlareRenderer() {};

	vector<vec3> LoadColorMatchingFunction();
	void ExportSpecturmPSF(vector<vec3>, fftw_complex*);
	void ExportSumPSF();
	void ExportMiddlePSF();

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

	PNGExporter pngExporter;
	int writeFileNum = 0;

	FourierTransform ft;

	int lensParticlesNum = 0;
	const int lensFibersNum = 300;
	const int lensPupilTrianglesNum = 500;

	const float pupilRadius = 0.7f;
	const float lensFiberInRadius = 0.5f;
	const float lensFiberOutRadius = 5.0f;

	// m(미터)를 기준으로 됨!!!
	// scaling 된 후 0.1
	double centerLambda = 0.000000575;
	double minLambda = 0.000000380;
	double lambdaDelta = (0.000000770 - 0.000000380) / 32.0;
	const double n = 32.0;

	// pulil과 cornea사이의 거리
	// scaling 된 후 5000
	float d = 0.017f;

	float retinaDiameter = 0.003f;

	//const double scalingFactor = 300000.0;
	const float scale;
};