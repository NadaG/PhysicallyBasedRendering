#version 330 core

layout(location = 0) in vec3 vertexPos;
layout(location = 1) in vec3 vertexColor;

// for geometry shader
out vec3 vWorldPos;
out vec3 vNormal;

void main()
{
	gl_Position = vec4(vertexPos, 1.0);
}