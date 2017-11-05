#version 330 core

in vec3 eyeSpacePos;

layout(location = 0) out vec3 color;
layout(location = 1) out vec3 depth;
layout(location = 2) out vec3 thickness;

float radius = 1.0;

uniform vec3 lightPos;
uniform mat4 projection;

uniform float near;
uniform float far;
// pixel ������ ũ��� 
// view space������ ũ�⸦ ������ ��

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
	}

	n.z = sqrt(1.0 - r2);

	// eye space������ �� �ȼ��� ��ġ
	vec4 pixelPos = vec4(eyeSpacePos + n * radius, 1.0);
	vec4 clipSpacePos = projection * pixelPos;
	
	//clipSpacePos.z = (clipSpacePos.z - near) / (far - near);
	//clipSpacePos.z = clipSpacePos.z * 0.5;

	// �������� 0~1��
	float tmpDepth = clipSpacePos.z / clipSpacePos.w;
	// 0~1
	depth = vec3(tmpDepth);
	color = n;
	
	//depth = vec3(clipSpacePos);

	//depth = vec3((clipSpacePos.w+2*n.z) / far);
	
	//	float diffuse = max(0.0, dot(n, lightPos));
	//	color = vec3(0.3, 0.7, 1.0) * diffuse;

	//color = worldSpacePos;

	//thickness = 0.01;
}