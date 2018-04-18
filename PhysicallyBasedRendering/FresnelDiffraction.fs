#version 330 core

out vec3 color;

in vec2 outUV;

const float pi = 3.141592653;

uniform float d;
uniform float lambda;

void main()
{
	float x = (outUV.x - 0.5f) / (lambda * d);
	float y = (outUV.y - 0.5f) / (lambda * d);
	float value = clamp(cos(pi / (lambda * d) * (x*x + y*y)), 0.0, 1.0);

	color = vec3(1.0, 0.0, 0.0);
}