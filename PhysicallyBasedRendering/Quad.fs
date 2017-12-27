#version 330 core

in vec2 outUV;

out vec3 color;

// TODO depth map이 아니라 단순히 일반적인 map임....
uniform sampler2D map;

void main()
{
	color = texture(map, outUV).rgb;
}