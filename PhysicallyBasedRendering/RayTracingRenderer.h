#pragma once

#include "Renderer.h"
#include "RayTracingSceneManager.h"

#include "RayTracer.cuh"

class RayTracingRenderer : public Renderer
{
public:
	RayTracingRenderer(SceneManager* sceneManager)
		:Renderer(sceneManager), gridX(8), gridY(8), sampleNum(1)
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

	vector<Triangle> triangles;
	vector<Sphere> spheres;
	vector<Light> lights;
	vector<Material> materials;

	Object* camera;
};