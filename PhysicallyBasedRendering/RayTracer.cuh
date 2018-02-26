#pragma once

#include <glm\glm.hpp>
#include <cuda_runtime.h>
#include <glm\gtc\matrix_transform.hpp>

using glm::vec3;
using glm::vec4;
using glm::normalize;
using glm::cross;
using glm::dot;

struct Triangle
{
	glm::vec3 v0;
	glm::vec3 v1;
	glm::vec3 v2;
};

void RayTrace(glm::vec4* data, glm::mat4 mat);