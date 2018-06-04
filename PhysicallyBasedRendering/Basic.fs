#version 330 core

out vec3 color;

in vec3 outPos;
in vec3 outNormal;
in vec2 outUV;

uniform vec3 inColor;

void main()
{
	color = outNormal;
}