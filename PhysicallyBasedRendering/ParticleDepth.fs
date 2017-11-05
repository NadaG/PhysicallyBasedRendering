#version 330 core

in vec3 eyeSpacePos;

layout(location = 0) out vec3 color;
layout(location = 1) out vec3 depth;

float radius = 1.0;

uniform mat4 projection;

uniform float near;
uniform float far;

// 여기서 depth 값은 depth map에 있는 0~1 사이의 값이다.
// 주의할 점은 여기 있는 값은 z-near와 z-far에 따라 선형적으로 계산된 값이 아니다.
// 선형적으로 값을 저장하지 않은 이유는 거리가 가까울 곳에 큰 비중을 두어 가까운 곳에서 더욱 정밀하게 계산하기 위해서이다. 
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

	// discard를 하면 depth test를 하지도 않고 아무 색도 칠하지 않게 된다.
	// 즉 일반적인 경우에서는 뒤 픽셀의 색이 보이게 된다는 것이다.
	if(r2 > 1.0)
	{ 
		discard;
		return;
	}

	n.z = sqrt(1.0 - r2);

	// eye space에서의 각 픽셀의 위치
	vec4 pixelPos = vec4(eyeSpacePos + n * radius, 1.0);
	vec4 clipSpacePos = projection * pixelPos;
	
	float tmpDepth = clipSpacePos.z / clipSpacePos.w;
	depth = vec3(LinearizeDepth(tmpDepth) / far);
	// normal 값을 확인하기 위해
	color = n;
}