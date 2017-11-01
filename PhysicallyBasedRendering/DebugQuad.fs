#version 330 core

in vec2 outUV;

out vec3 color;

uniform sampler2D depthMap;
uniform sampler2D colorMap;

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
	float depthValue = texture(depthMap, outUV).r;
	float depthColor = LinearizeDepth(depthValue) / far;
	// 값이 선형적으로 변하는 것처럼 만들기 위한 감마 보정
	// 자극이 적을 때는 살짝의 자극으로도 자극이 된다는 베버의 법칙에 근거함
	depthColor = pow(depthColor, 0.5);
	color = vec3(depthColor);
	//color = texture(colorMap, outUV).rgb;
}