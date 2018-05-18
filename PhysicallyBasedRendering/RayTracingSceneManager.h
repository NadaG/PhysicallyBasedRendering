#pragma once

#include "SceneManager.h"
#include "Octree.cuh"

class RayTracingSceneManager : public SceneManager
{
public:

	RayTracingSceneManager():moveSpeed(0.5f), rotateSpeed(0.05f), lightSphereId(0), isDepthTwo(false) {}
	virtual ~RayTracingSceneManager() {}

	void InitializeObjects();
	void Update();

	std::vector<Triangle> triangles;
	std::vector<Sphere> spheres;
	std::vector<Light> lights;
	std::vector<Material> materials;

	vector<Triangle> LoadPlaneTriangles(glm::mat4 model, const int materialId);
	vector<Triangle> LoadMeshTriangles(const string meshfile, glm::mat4 model, const int materialId);

	void InsertTriangles(vector<Triangle> triangles);

	OctreeNode* root;
	bool isDepthTwo;

private:

	// for demo
	const int lightSphereId;

	const float moveSpeed;
	const float rotateSpeed;
};