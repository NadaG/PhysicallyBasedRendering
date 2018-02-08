#version 330 core

out vec3 color;

in vec2 outUV;

const float pi = 3.141592653;

void main()
{
	// TODO 이건 그냥 막 넣은거임
	float lambda = 0.3f;
	float d = 0.1f;

	float x = outUV.x - 0.5f;
	float y = outUV.y - 0.5f;
	float value = cos(pi / (lambda * d) * (x*x + y*y));
	color = vec3(value);
}