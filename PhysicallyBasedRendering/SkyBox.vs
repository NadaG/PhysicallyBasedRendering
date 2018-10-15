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
	// vertexPos의 범위는 x, y, z 모두 -1~1이다
	outUV = vertexPos;
	
	vec4 pos = projection * mat4(mat3(view)) * vec4(vertexPos, 1.0);

	// projection matrix가 곱해지면 생성된 w값은 eyespace에서의 z값(깊이값)이다.
	// projection matrix의 특성상 ndc로 바꾸기 위해서는 eyespace의 z(w값)값으로 나누어 주어야 한다.
	// gl_Position의 z에 담긴 값이 depth test에 사용된다.
	// 이 예에서는 gl_Position.z가 w로 나누어져서 gl_Position.z가 1이 된다.
	gl_Position = pos.xyww;
}