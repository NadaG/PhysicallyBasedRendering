#version 330 core

out vec3 color;

in vec3 fColor;

uniform vec3 inColor;

void main()
{
	color = fColor;
}