#version 330 core

in vec3 eyeSpacePos;

layout(location = 0) out vec3 color;
layout(location = 1) out vec3 depth;

float radius = 1.0;

uniform mat4 projection;

uniform float near;
uniform float far;

// ���⼭ depth ���� depth map�� �ִ� 0~1 ������ ���̴�.
// ������ ���� ���� �ִ� ���� z-near�� z-far�� ���� ���������� ���� ���� �ƴϴ�.
// ���������� ���� �������� ���� ������ �Ÿ��� ����� ���� ū ������ �ξ� ����� ������ ���� �����ϰ� ����ϱ� ���ؼ��̴�. 
float LinearizeDepth(float depth)
{
	float z = depth * 2.0 - 1.0;
	return (2.0 * near * far) / (far + near - z * (far - near));
}

void main()
{
	vec3 n;
	n.xy = vec2(gl_PointCoord.x, gl_PointCoord.y);
	n.xy = n.xy * 2.0 - 1.0;
	float r2 = dot(n.xy, n.xy);

	// discard�� �ϸ� depth test�� ������ �ʰ� �ƹ� ���� ĥ���� �ʰ� �ȴ�.
	// �� �Ϲ����� ��쿡���� �� �ȼ��� ���� ���̰� �ȴٴ� ���̴�.
	if(r2 > 1.0)
	{ 
		discard;
		return;
	}

	n.z = sqrt(1.0 - r2);

	// eye space������ �� �ȼ��� ��ġ
	vec4 pixelPos = vec4(eyeSpacePos + n * radius, 1.0);
	vec4 clipSpacePos = projection * pixelPos;
	
	float tmpDepth = clipSpacePos.z / clipSpacePos.w;
	depth = vec3(LinearizeDepth(tmpDepth) / far);
	// normal ���� Ȯ���ϱ� ����
	color = n;
}