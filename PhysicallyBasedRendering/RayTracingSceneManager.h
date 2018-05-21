#pragma once

#include "SceneManager.h"
#include "Octree.cuh"

class RayTracingSceneManager : public SceneManager
{
public:

	RayTracingSceneManager():moveSpeed(0.5f), rotateSpeed(0.05f), lightSphereId(0) {}
	virtual ~RayTracingSceneManager() {}

	void InitializeObjects();
	void Update();

	std::vector<Triangle> triangles;
	std::vector<Sphere> spheres;
	std::vector<Light> lights;
	std::vector<Material> materials;
	std::vector<float> textures;

	vector<Triangle> LoadPlaneTriangles(glm::mat4 model, const int materialId);
	vector<Triangle> LoadMeshTriangles(const string meshfile, glm::mat4 model, const int materialId);

	void InsertTriangles(vector<Triangle> triangles);

	void LoadFluidScene(const string meshfile);

	OctreeNode* root;

private:

	// for demo

	const int lightSphereId;

	const float moveSpeed;
	const float rotateSpeed;
};