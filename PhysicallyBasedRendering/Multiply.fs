#version 330 core

const float pi = 3.141592653;

in vec2 outUV;

out vec4 color;

uniform sampler2D apertureTex;
uniform sampler2D fresnelDiffractionTex;

uniform float lambda;
uniform float d;

float Fresnel(float aperture)
{
	float x = (outUV.x - 0.5f);
	float y = (outUV.y - 0.5f);
	
	float real = cos(pi / (lambda * d) * (x*x + y*y));
	float img = sin(pi / (lambda * d) * (x*x + y*y));

	return aperture * real;
}

void main()
{	
	float aperture = texture(apertureTex, outUV).r;
	//float fresnelValue = texture(fresnelDiffractionTex, outUV).r;

	float fresnelValue = Fresnel(1 - aperture);
	//if(radius < 0.35f)
	//	color = vec4(vec3(Fresnel(1 - value)), 1.0f);
	//else
	//	color = vec4(0.0, 0.0f, 0.0f, 1.0f);

	color = vec4(aperture, aperture, aperture, 1.0f);
	//color = vec4(multipliedFresnelValue, multipliedFresnelValue, multipliedFresnelValue, 1.0f);
}