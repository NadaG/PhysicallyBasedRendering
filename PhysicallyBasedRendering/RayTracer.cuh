#pragma once

#define DLLExport extern "C" __declspec( dllexport )

#include <glm\glm.hpp>
#include <cuda_runtime.h>
#include <glm\gtc\matrix_transform.hpp>
#include <vector>

using glm::vec2;
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
	
	glm::vec2 v0uv;
	glm::vec2 v1uv;
	glm::vec2 v2uv;

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

	//Sphere()
	//{
	//	origin = vec3();
	//	radius = 1.0f;
	//	materialId = 0;
	//}
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

	// alpha�� ������ ������
	float refractivity;
	float reflectivity;

	int texStartIdx;
	int texWidth;
	int texHeight;
};

struct AABB
{
	glm::vec3 bounds[2];
};

DLLExport
void RayTrace(
	glm::vec4* data, 
	const int gridX,
	const int gridY,
	glm::mat4 view,
	OctreeNode* root,
	const vector<AABB>& objects,
	const vector<Triangle>& triangles, 
	const vector<Sphere>& spheres,
	const vector<Light>& lights, 
	const vector<Material>& materials,
	const vector<float>& textures
);