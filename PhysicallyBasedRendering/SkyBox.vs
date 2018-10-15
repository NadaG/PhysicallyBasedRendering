#version 330 core
layout(location = 0) in vec3 vertexPos;
layout(location = 1) in vec3 vertexNormal;
layout(location = 2) in vec2 vertexUV;
layout(location = 3) in vec3 vertexColor;
layout(location = 4) in vec3 vertexTangent;

out vec3 outUV;

uniform mat4 projection;
uniform mat4 view;

void main()
{
	// vertexPos�� ������ x, y, z ��� -1~1�̴�
	outUV = vertexPos;
	
	vec4 pos = projection * mat4(mat3(view)) * vec4(vertexPos, 1.0);

	// projection matrix�� �������� ������ w���� eyespace������ z��(���̰�)�̴�.
	// projection matrix�� Ư���� ndc�� �ٲٱ� ���ؼ��� eyespace�� z(w��)������ ������ �־�� �Ѵ�.
	// gl_Position�� z�� ��� ���� depth test�� ���ȴ�.
	// �� �������� gl_Position.z�� w�� ���������� gl_Position.z�� 1�� �ȴ�.
	gl_Position = pos.xyww;
}