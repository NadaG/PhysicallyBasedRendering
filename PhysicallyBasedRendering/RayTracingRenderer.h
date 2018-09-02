#pragma once

#include "Renderer.h"
#include "RayTracingSceneManager.h"

#include "RayTracer.cuh"


class RayTracingRenderer : public Renderer
{
public:
	RayTracingRenderer(SceneManager* sceneManager)
		:Renderer(sceneManager), gridX(4), gridY(4), sampleNum(1)
	{}
	virtual ~RayTracingRenderer() {};

	void InitializeRender();

	void Render();
	void TerminateRender();

	void OfflineRender(const string outfile);


private:
	int writeFileNum = 0;

	ShaderProgram* phongShader;

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
	vector<SceneObject> sceneObjs;

	int frame = 0;

	Object* camera;
};