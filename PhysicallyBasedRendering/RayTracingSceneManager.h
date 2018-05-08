#pragma once

#include "SceneManager.h"
#include "Octree.cuh"

class RayTracingSceneManager : public SceneManager
{
public:

	RayTracingSceneManager() {}
	virtual ~RayTracingSceneManager() {}

	void InitializeObjects();
	void Update();

	std::vector<Triangle> triangles;
	std::vector<Light> lights;
	std::vector<Material> materials;

	void LoadPlane();
	void LoadMaterial();

	void BuildOctree();

	OctreeNode* root;

private:

	glm::vec3 cameraInitPos;
	Texture2D frontTex;
};