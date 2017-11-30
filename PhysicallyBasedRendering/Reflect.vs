#version 330 core
layout(location = 0) in vec3 vertexPos;
layout(location = 1) in vec3 vertexNormal;
layout(location = 2) in vec2 vertexUV;
layout(location = 3) in vec3 vertexColor;
layout(location = 4) in vec3 vertexTangent;

out vec3 worldNormal;
out vec3 worldPos;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

void main()
{
	worldNormal = mat3(transpose(inverse(model))) * vertexNormal;
	worldPos = vec3(model * vec4(vertexPos, 1.0));
	gl_Position = projection * view * model * vec4(vertexPos, 1.0);
}