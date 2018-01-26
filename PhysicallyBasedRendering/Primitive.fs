#version 330 core

out vec3 color;

in vec3 outColor;

void main()
{
	color = outColor;

	color = vec3(1.0, 1.0, 1.0);
}