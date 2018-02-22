#version 330 core

in vec2 outUV;

out vec3 color;

const float PI = 3.141592653;

void main()
{
	float waveNum = 40.0f;
	color = vec3(clamp(cos(outUV.x*PI*2*waveNum), 0, 1));
	color = vec3(cos(outUV.x*PI*2*waveNum));
}