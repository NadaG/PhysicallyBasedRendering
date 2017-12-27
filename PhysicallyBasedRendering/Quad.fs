#version 330 core

in vec2 outUV;

out vec3 color;

// TODO depth map�� �ƴ϶� �ܼ��� �Ϲ����� map��....
uniform sampler2D map;

void main()
{
	color = texture(map, outUV).rgb;
}