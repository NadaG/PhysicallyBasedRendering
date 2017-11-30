#version 330 core

in vec3 eyeSpacePos;

layout(location = 0) out vec3 color;
layout(location = 1) out vec3 depth;

float radius = 1.0;

uniform mat4 projection;

uniform float near;
uniform float far;

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

	if(r2 > 1.0)
	{ 
		discard;
		return;
	}

	n.z = sqrt(1.0 - r2);

	vec4 pixelPos = vec4(eyeSpacePos + n * radius, 1.0);
	vec4 clipSpacePos = projection * pixelPos;
	
	// clipSpace pos z는 linear 한거 같지만
	// clipSpace pos w로 나누면 non linear가 되는거 같다
	// 범위는 모두 near~far
	//float tmpDepth = clipSpacePos.z / clipSpacePos.w;
	float tmpDepth = clipSpacePos.z;

	//depth = vec3(LinearizeDepth(tmpDepth) / far);
	depth = vec3(tmpDepth / far);
	
	// normal 값을 확인하기 위해
	color = n;
}