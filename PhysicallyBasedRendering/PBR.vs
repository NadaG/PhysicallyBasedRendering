#version 330 core
layout(location = 0) in vec3 vertexPos;
layout(location = 1) in vec3 vertexNormal;
layout(location = 2) in vec2 vertexUV;
layout(location = 3) in vec3 vertexColor;
layout(location = 4) in vec3 vertexTangent;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

out vec2 outUV;
out vec3 worldPos;
out vec3 outNormal;

void main()
{
	gl_Position = projection * view * model * vec4(vertexPos, 1.0);

	outUV = vertexUV;
	worldPos = vec3(model * vec4(vertexPos, 1.0));
	outNormal = mat3(model) * vertexNormal;
}