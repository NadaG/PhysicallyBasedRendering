#version 330 core

out vec3 color;

uniform vec3 inColor;

in vec3 worldPos;
in vec3 normal;

uniform vec3 lightDir;

void main()
{
	vec3 lightColor = vec3(1.0, 1.0, 1.0);

	vec3 ambient = vec3(0.2, 0.2, 0.2);

	vec3 diffuse = vec3(0.0, 0.0, 0.0);
	vec3 specular = vec3(0.0, 0.0, 0.0);

	color = ambient + diffuse + specular;
}