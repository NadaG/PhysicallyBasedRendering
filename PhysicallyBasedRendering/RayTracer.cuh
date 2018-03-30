#pragma once

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

struct Triangle
{
	glm::vec3 v0;
	glm::vec3 v1;
	glm::vec3 v2;

	glm::vec3 normal;

	int matrialId = 0;

	Triangle()
	{
		v0 = glm::vec3();
		v1 = glm::vec3();
		v2 = glm::vec3();

		normal = glm::vec3();
	}

	Triangle(glm::vec3 v0, glm::vec3 v1, glm::vec3 v2)
	{
		this->v0 = v0;
		this->v1 = v0;
		this->v2 = v0;

		normal = glm::vec3();
	}
};

struct Light
{
	glm::vec3 pos;
	glm::vec3 color;
};

struct Material
{
	//////
	glm::vec3 ambient;
	glm::vec3 diffuse;
	glm::vec3 specular;
};

void RayTrace(
	glm::vec4* data, 
	glm::mat4 view,
	const vector<Triangle>& triangles, 
	const vector<Light>& lights, 
	const vector<Material>& materials);