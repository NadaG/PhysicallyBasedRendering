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

void RayTrace(glm::vec4* data, glm::mat4 mat, const vector<Triangle> &triangles, const vector<Light>& lights);