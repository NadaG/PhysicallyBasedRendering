#version 330 core

in vec2 outUV;

out vec3 color;

uniform sampler2D depthMap;
uniform sampler2D colorMap;

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
	float depthValue = texture(depthMap, outUV).r;
	float depthColor = LinearizeDepth(depthValue) / far;
	// ���� ���������� ���ϴ� ��ó�� ����� ���� ���� ����
	// �ڱ��� ���� ���� ��¦�� �ڱ����ε� �ڱ��� �ȴٴ� ������ ��Ģ�� �ٰ���
	depthColor = pow(depthColor, 0.5);
	color = vec3(depthColor);
	//color = texture(colorMap, outUV).rgb;
}