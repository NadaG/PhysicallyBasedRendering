#version 330 core
layout(location = 0) in vec3 vertexPos;
layout(location = 1) in vec3 vertexNormal;
layout(location = 2) in vec2 vertexUV;
layout(location = 3) in vec3 vertexColor;
layout(location = 4) in vec3 vertexTangent;

out vec3 outColor;

void main()
{
	// TODO 원래는 vertexColor를 보내야 함
	outColor = vertexNormal;
	gl_Position = vec4(vertexPos, 1.0);
}