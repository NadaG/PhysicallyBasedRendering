#pragma once

#define BOOST_PYTHON_STATIC_LIB
#define BOOST_LIB_NAME "boost_numpy3"

#include "Renderer.h"
#include "FluidSimulationImporter.h"
#include "FluidSimulationClient.h"
#include "FluidSceneManager.h"
#include "MarchingCube.h"

#include <boost/config/auto_link.hpp>
#include <boost/python.hpp>
#include <boost/python/numpy.hpp>

namespace py = boost::python;
namespace np = boost::python::numpy;

struct FluidCube
{
	float3 pos;
	int3 size;
};

class FluidRenderer : public Renderer
{
public:
	FluidRenderer(SceneManager* sceneManager)
		:Renderer(sceneManager)
	{}
	virtual ~FluidRenderer() {};

	void InitializeRender();
	void Render();

	void InitializePython();

	void ScreenSpaceFluidNormalRender();
	void MarchingCubeFluidNormalRender(const string& meshfile);

	void PhongRenderUsingNormalMap(const string& imgfile);

	void TerminateRender(); 

private:
	ShaderProgram* particleDepthShader;
	ShaderProgram* particleThicknessShader;

	ShaderProgram* blurShader;

	ShaderProgram* surfaceShader;
	ShaderProgram* pbrShader;

	ShaderProgram* marchingCubeFluidShader;

	ShaderProgram* phongShader;

	////debug용임
	//ShaderProgram* textureShader;
	//Texture2D tmpTex;

	// floor
	Texture2D floorAlbedoTex;

	// world
	Texture2D worldColorTex;
	Texture2D worldDepthTex;

	// debug용임 normal 값 저장
	Texture2D colorTex;

	Texture2D depthTex;
	Texture2D thicknessTex;

	Texture2D normalTex;
	
	RenderBufferObject tmpDepthRBO;
	
	// blur
	Texture2D depthBlurTex[2];
	Texture2D thicknessBlurTex[2];

	const int depthWidth = 1024;
	const int depthHeight = 1024;

	const int blurNum = 2;

	const float depthNear = 0.01f;
	const float depthFar = 200.0;

	const float sceneNaer = 0.01f;
	const float sceneFar = 200.0f;

	const float pointSize = 1000.0f;

	FrameBufferObject pbrFBO;
	
	FrameBufferObject depthFBO;
	FrameBufferObject thicknessFBO;

	FrameBufferObject depthBlurFBO[2];
	FrameBufferObject thicknessBlurFBO[2];

	FrameBufferObject pngFBO;

	VertexArrayObject fluidVAO;

	GLfloat* fluidVertices;
	FluidSimulationImporter importer;
	FluidSimulationClient clientImporter;

	int currentFrame;

	MarchingCube mc;

	PNGExporter pngExporter;

	Texture2D pngTex;

private:

	bool isRenderOnDefaultFBO;
	int targetFrame;

	glm::vec3 boundarySize;

	void DrawFluids(const float cameraDist);
};