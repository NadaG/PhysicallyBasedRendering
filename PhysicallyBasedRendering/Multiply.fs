#version 440 core

const float pi = 3.141592653;

in vec2 outUV;

out vec3 color;

uniform sampler2D apertureTex;
uniform sampler2D fresnelDiffractionTex;

float Fresnel(float value)
{
	float lambda = 0.3f;
	float d = 0.1f;

	float x = (outUV.x - 0.5f)*0.5f;
	float y = (outUV.y - 0.5f)*0.5f;
	float ret = cos(pi / (lambda * d) * (x*x + y*y)) * value;
	
	return ret;
}

void main()
{	
	float value = texture(apertureTex, outUV).r ;

	color = vec3(Fresnel(value));
}