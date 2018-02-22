#version 400 core

out vec3 color;

in vec2 outUV;

uniform sampler2D worldMap;
uniform sampler2D blurredBrightMap;
uniform float exposure;

void main()
{
	const float gamma = 2.2;
	vec3 worldColor = texture(worldMap, outUV).rgb;
	vec3 bloomColor = texture(blurredBrightMap, outUV).rgb;

	worldColor += bloomColor;

	vec3 result = vec3(1.0) - exp(-worldColor*exposure);

	result = pow(result, vec3(1.0 / gamma));
	color = result;
}