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

	// gl_Position에 들어간 vertex에 대해서는 x, y, z에 대해서는 w(w는 기존의 z값임)값으로 나누겠다는 말이다.
	// w로 나누는 과정을 perspective divide라고 부른다.
	// perspective 4행 3열의 값은 기존의 z값을 살려 depth test에 사용하겠다는 말이다.
	gl_Position = vec4(vertexPos, 1.0);
}