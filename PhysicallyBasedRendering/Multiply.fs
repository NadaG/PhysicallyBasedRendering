#version 440 core

const float pi = 3.141592653;

in vec2 outUV;

out vec3 color;

uniform sampler2D apertureTex;
uniform sampler2D fresnelDiffractionTex;

float Fresnel(float value)
{
	float lambda = 0.001f;
	float d = 0.001f;

	float x = (outUV.x - 0.5f);
	float y = (outUV.y - 0.5f);
	float ret = cos(pi / (lambda * d) * (x*x + y*y)) * value;
	
	if(value <= 0.000)
		return 1.0;
	return ret;
}

void main()
{	
	float value = texture(apertureTex, outUV).r;

	float radius = sqrt((outUV.x-0.5f)*(outUV.x-0.5f) + (outUV.y-0.5f)*(outUV.y-0.5f));

	if(radius < 0.35f)
		color = vec3(Fresnel(1 - value));
	else
		color = vec3(0.0);
}