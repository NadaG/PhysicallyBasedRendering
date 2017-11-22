#version 330 core

out vec3 color;

in vec3 vertexUV;

uniform samplerCube skybox;

void main()
{
	color = vec3(1.0, 0.0, 0.0);
}