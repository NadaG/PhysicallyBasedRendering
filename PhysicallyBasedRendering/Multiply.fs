#version 440 core

const float pi = 3.141592653;

in vec2 outUV;

out vec3 color;

uniform sampler2D apertureTex;
uniform sampler2D fresnelDiffractionTex;

void main()
{	
	float value = texture(apertureTex, outUV).r;

	color = vec3(value);
}