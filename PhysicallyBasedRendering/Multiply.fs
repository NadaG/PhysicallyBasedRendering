#version 330 core

const float pi = 3.141592653;

in vec2 outUV;

out vec4 color;

uniform sampler2D apertureTex;
uniform sampler2D fresnelDiffractionTex;

uniform float lambda;
uniform float d;

float Fresnel(float value)
{
	float x = (outUV.x - 0.5f);
	float y = (outUV.y - 0.5f);
	float ret = cos(pi / (lambda * d) * (x*x + y*y)) * value;

	return ret;
}

void main()
{	
	float value = texture(apertureTex, outUV).r;
	float fresnelValue = texture(fresnelDiffractionTex, outUV).r;

	float radius = sqrt((outUV.x-0.5f)*(outUV.x-0.5f) + (outUV.y-0.5f)*(outUV.y-0.5f));
		
	color = vec4(Fresnel(value));

	//if(radius < 0.35f)
	//	color = vec4(vec3(Fresnel(1 - value)), 1.0f);
	//else
	//	color = vec4(0.0, 0.0f, 0.0f, 1.0f);

	color = vec4(value, value, value, 1.0f);
}