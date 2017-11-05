#version 330 core

in vec2 outUV;

out vec3 color;

uniform sampler2D depthMap;

void main()
{
	float depthValue = texture(depthMap, outUV).r;

	if(depthValue == 0.0f)
		discard;

	color = vec3(depthValue);
}