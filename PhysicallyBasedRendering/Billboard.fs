#version 330 core

out vec3 color;

in vec2 outUV;

void main()
{
	if(outUV.x > 0.5)
		color = vec3(1.0, 0.0, 0.0);
	else
		color = vec3(0.0, 1.0, 0.0);
}