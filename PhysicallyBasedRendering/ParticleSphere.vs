#version 330 core
layout(location = 0) in vec3 vertexPos;
layout(location = 1) in vec3 vertexColor;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

out vec3 eyeSpacePos;

void main()
{
	eyeSpacePos = vec3(view * vec4(vertexPos, 1.0));
	gl_Position = projection * view * vec4(vertexPos, 1.0);
}