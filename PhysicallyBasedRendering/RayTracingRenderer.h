#pragma once

#include "Renderer.h"
#include "RayTracingSceneManager.h"

#include "RayTracer.cuh"

class RayTracingRenderer : public Renderer
{
public:
	RayTracingRenderer(SceneManager* sceneManager)
<<<<<<< HEAD
		:Renderer(sceneManager), gridX(32), gridY(32), sampleNum(64)
=======
		:Renderer(sceneManager), gridX(32), gridY(32), sampleNum(1)
>>>>>>> 75f980fb391e4045d90d82579a06b61f1bc0076b
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