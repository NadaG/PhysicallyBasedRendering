#pragma once

#include "Renderer.h"
#include "RayTracingSceneManager.h"

#include "RayTracer.cuh"

class RayTracingRenderer : public Renderer
{
public:
	RayTracingRenderer(SceneManager* sceneManager)
		:Renderer(sceneManager), gridX(16), gridY(16), sampleNum(16)
	{}
	virtual ~RayTracingRenderer() {};

	void InitializeRender();
	void Render();
	void TerminateRender();

	void OfflineRender(const string outfile);

private:
	int writeFileNum = 0;

	cudaGraphicsResource* cuda_pbo_resource;
	GLuint rayTracePBO;
	Texture2D rayTracingTex;

	PNGExporter pngExporter;

	vector<AABB> objects;

	const int gridX;
	const int gridY;

	const int sampleNum;

	vector<float> vec;
};