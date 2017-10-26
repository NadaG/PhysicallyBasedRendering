#version 330 core
layout(location = 0) in vec3 vertexPos;
layout(location = 1) in vec3 vertexNormal;
layout(location = 2) in vec2 vertexUV;
layout(location = 3) in vec3 vertexColor;
layout(location = 4) in vec3 vertexTangent;

out vec2 outUV;

void main()
{
	outUV = vertexUV;

	// gl_Position�� �� vertex�� ���ؼ��� x, y, z�� ���ؼ��� w(w�� ������ z����)������ �����ڴٴ� ���̴�.
	// w�� ������ ������ perspective divide��� �θ���.
	// perspective 4�� 3���� ���� ������ z���� ��� depth test�� ����ϰڴٴ� ���̴�.
	gl_Position = vec4(vertexPos, 1.0);
}