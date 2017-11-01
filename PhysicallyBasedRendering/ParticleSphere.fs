#version 330 core

in vec3 eyeSpacePos;

layout(location = 0) out vec3 color;
layout(location = 1) out float depth;

float radius = 0.01;

uniform vec3 lightPos;
uniform mat4 projection;

void main()
{
	vec3 n;
	n.xy = vec2(gl_PointCoord.x, gl_PointCoord.y);
	n.xy = n.xy * 2.0 - 1.0;
	float r2 = dot(n.xy, n.xy);

	// discard�� �ϸ� depth test�� ������ �ʰ� �ƹ� ���� ĥ���� �ʰ� �ȴ�.
	// �� �Ϲ����� ��쿡���� �� �ȼ��� ���� ���̰� �ȴٴ� ���̴�.
	if(r2 > 1.0)
		discard;
	n.z = -sqrt(1.0 - r2);

	vec4 pixelPos = vec4(eyeSpacePos + n*radius, 1.0);
	vec4 clipSpacePos = projection * pixelPos;
	depth = clipSpacePos.z / clipSpacePos.w;

	float diffuse = max(0.0, dot(n, -lightPos));
	color = vec3(0.3, 0.7, 1.0) * diffuse;
}