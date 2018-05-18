#pragma once

#define DLLExport extern "C" __declspec( dllexport )

#include <glm\glm.hpp>
#include <cuda_runtime.h>
#include <glm\gtc\matrix_transform.hpp>
#include <vector>

using glm::vec3;
using glm::vec4;
using glm::normalize;
using glm::cross;
using glm::dot;
using std::vector;

struct OctreeNode;

struct Triangle
{
	glm::vec3 v0;
	glm::vec3 v1;
	glm::vec3 v2;

	glm::vec3 normal;

	glm::vec3 v0normal;
	glm::vec3 v1normal;
	glm::vec3 v2normal;

	int materialId;
	int meshId;

	Triangle()
	{
		v0 = glm::vec3();
		v1 = glm::vec3();
		v2 = glm::vec3();

		normal = glm::vec3();

		materialId = 0;
		meshId = 0;
	}

	Triangle(glm::vec3 v0, glm::vec3 v1, glm::vec3 v2)
	{
		this->v0 = v0;
		this->v1 = v0;
		this->v2 = v0;

		normal = glm::vec3();

		materialId = 0;
		meshId = 0;
	}
};

struct Sphere
{
	glm::vec3 origin;
	float radius;

	int materialId;

	Sphere()
	{
		origin = glm::vec3(0.0f);
		radius = 1.0f;
		materialId = 0;
	}
};

struct Light
{
	glm::vec3 pos;
	glm::vec3 color;
};

struct Material
{
	glm::vec3 ambient;
	glm::vec3 diffuse;
	glm::vec3 specular;

	// alpha가 높으면 불투명
	float refractivity;
	float reflectivity;
};

struct AABB
{
	glm::vec3 bounds[2];
};

void RayTrace(
	glm::vec4* data, 
	glm::mat4 view,
	OctreeNode* root,
	const vector<AABB>& objects,
	const vector<Triangle>& triangles, 
	const vector<Sphere>& spheres,
	const vector<Light>& lights, 
	const vector<Material>& materials,
	bool isDepthTwo);