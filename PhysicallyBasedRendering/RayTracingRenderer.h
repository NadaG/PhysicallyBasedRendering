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

private:

	int writeFileNum = 0;

	glm::vec3 cameraInitPos;

	cudaGraphicsResource* cuda_pbo_resource;

	GLuint rayTracePBO;

	Texture2D rayTracingTex;

	PNGExporter pngExporter;

	std::vector<Triangle> triangles;
	std::vector<Light> lights;
};