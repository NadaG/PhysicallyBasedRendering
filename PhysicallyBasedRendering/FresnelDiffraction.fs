#version 330 core

out vec3 color;

in vec2 outUV;

const float pi = 3.141592653;

uniform float d;
uniform float lambda;
uniform float scalingFactor;

void main()
{
	//float x = (outUV.x - 0.5f) / (lambda * d) * scalingFactor;
	//float y = (outUV.y - 0.5f) / (lambda * d) * scalingFactor;
	//float x = (outUV.x - 0.5f) * scalingFactor;
	//float y = (outUV.y - 0.5f) * scalingFactor;
	// -0.5에서 0.5사이로 값을 맞춤
	float x = outUV.x - 0.5f;
	float y = outUV.y - 0.5f;
	float real = cos(pi / (lambda * d) * (x*x + y*y));
	float img = sin(pi / (lambda * d) * (x*x + y*y));

	real /= 5;
	img /= 5;

	float value = sqrt(real*real + img*img);

	color = vec3(real, real, real);
}