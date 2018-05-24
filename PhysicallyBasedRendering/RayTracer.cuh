#pragma once

#define DLLExport extern "C" __declspec( dllexport )

#include <glm\glm.hpp>
#include <cuda_runtime.h>
#include <glm\gtc\matrix_transform.hpp>
#include <vector>
#include <curand_kernel.h>
#include "Texture2D.h"

using glm::vec2;
using glm::vec3;
using glm::vec4;

using glm::dvec2;

using glm::normalize;
using glm::cross;
using glm::dot;
using std::vector;

struct OctreeNode;

struct Triangle
{
	vec3 v0;
	vec3 v1;
	vec3 v2;

	vec3 normal;

	vec3 v0normal;
	vec3 v1normal;
	vec3 v2normal;
	
	vec2 v0uv;
	vec2 v1uv;
	vec2 v2uv;

	int materialId;
	int meshId;

	Triangle()
	{
		v0 = vec3();
		v1 = vec3();
		v2 = vec3();

		normal = vec3();

		materialId = 0;
		meshId = 0;
	}

	Triangle(vec3 v0, vec3 v1, vec3 v2)
	{
		this->v0 = v0;
		this->v1 = v0;
		this->v2 = v0;

		normal = vec3();

		materialId = 0;
		meshId = 0;
	}
};

struct Sphere
{
	vec3 origin;
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
	vec3 pos;
	vec3 color;
};

//struct Rect
//{
//	vec3  center;
//	vec3  dirx;
//	vec3  diry;
//	float halfx;
//	float halfy;
//
//	vec4  plane;
//};



struct Material
{
	vec3 ambient;
	vec3 diffuse;
	vec3 specular;
	vec3 emission;

	// alpha가 높으면 불투명
	float refractivity;
	float reflectivity;

	int texId;

	Material()
	{
		ambient = vec3(0.0f);
		diffuse = vec3(0.0f);
		specular = vec3(0.0f);
		emission = vec3(0.0f);
		
		refractivity = 0.0f;
		reflectivity = 0.0f;

		texId = -1;
	}
};

struct AABB
{
	vec3 bounds[2];
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
	const vector<Material>& materials
);

void LoadCudaTextures();