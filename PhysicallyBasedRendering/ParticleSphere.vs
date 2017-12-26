#version 330 core

layout(location = 0) in vec3 vertexPos;
layout(location = 1) in vec3 vertexColor;

out vec3 eyeSpacePos;

uniform mat4 view;
uniform mat4 projection;

void main()
{
	gl_Position = projection * view * vec4(vertexPos, 1.0);
	eyeSpacePos = vec3(view * vec4(vertexPos, 1.0));
}