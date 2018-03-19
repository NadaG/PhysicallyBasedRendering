#pragma once

#include "SceneManager.h"

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

private:

	glm::vec3 cameraInitPos;

};