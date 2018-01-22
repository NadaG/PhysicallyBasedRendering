#version 330 core

out vec3 color;

in vec2 outUV;

const float PI = 3.14159265359;
const float e = 2.7182818284;

// ��� ���� �л� ���� �־�� ��
// �߰� ���� 0.5, 0.5
void main()
{
	// 1/(�л�*��Ʈ(2*PI))*����(e, -����(x - �߰� �� ,2)/(2*����(�л�,2)))
	float deviation = 0.05;

	float gaussian = 1 / (deviation * sqrt(2 * PI)) * pow(e, -length(outUV - vec2(0.5, 0.5))*length(outUV - vec2(0.5, 0.5)) / (2 * deviation * deviation));

	color = vec3(gaussian);
}