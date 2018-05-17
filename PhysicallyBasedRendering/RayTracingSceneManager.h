#pragma once

#include "SceneManager.h"
#include "Octree.cuh"

class RayTracingSceneManager : public SceneManager
{
public:

	RayTracingSceneManager():moveSpeed(1.0f), rotateSpeed(0.1f) {}
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

	//vector<Triangle> BackFaceCulling(vector<Triangle> triangles, glm::mat4 model);

	OctreeNode* root;

private:

	const float moveSpeed;
	const float rotateSpeed;
};