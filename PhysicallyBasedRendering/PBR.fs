#version 330 core

in vec3 outColor;
in vec2 outUV;
in vec3 outPos;
in vec3 outNormal;

out vec3 color;

uniform sampler2D aoMap;
uniform sampler2D albedoMap;
uniform sampler2D heightMap;
uniform sampler2D metallicMap;
uniform sampler2D normalMap;
uniform sampler2D roughnessMap;

void main()
{
	color = outColor;
	//color = texture(normalMap, outUV).rgb;
}