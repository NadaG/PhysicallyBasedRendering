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

	//color = vec4(aperture, aperture, aperture, 1.0f);
	
	//float radius = sqrt((outUV.x-0.5f)*(outUV.x-0.5f) + (outUV.y-0.5f)*(outUV.y-0.5f));
	float fresnelValue = Fresnel(aperture);

	//color = vec4(aperture, aperture, aperture, 1.0f);
	color = vec4(fresnelValue, fresnelValue, fresnelValue, 1.0f);
}