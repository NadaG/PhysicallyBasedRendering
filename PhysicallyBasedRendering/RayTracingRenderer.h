#pragma once

#include "Renderer.h"
#include "RayTracingSceneManager.h"

#include "RayTracer.cuh"

class RayTracingRenderer : public Renderer
{
public:
	RayTracingRenderer(SceneManager* sceneManager)
		:Renderer(sceneManager)
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

	Texture2D albedoTex;
	vector<float> albedoTexArray;

	PNGExporter pngExporter;

	vector<AABB> objects;
};