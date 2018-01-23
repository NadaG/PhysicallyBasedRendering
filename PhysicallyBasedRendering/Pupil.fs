#version 330 core

out vec3 color;

in vec2 outUV;

const float PI = 3.14159265359;
const float e = 2.7182818284;

float Gaussian(vec2 variable, vec2 average, float deviation)
{
	// 1/(�л�*��Ʈ(2*PI))*����(e, -����(x - �߰� �� ,2)/(2*����(�л�,2)))
	return 1 / (deviation * sqrt(2 * PI)) * 
	pow(e, -length(variable - average) * length(variable - average) / (2 * deviation * deviation));
}
// ��� ���� �л� ���� �־�� ��
// �߰� ���� 0.5, 0.5
void main()
{
	vec2 center = vec2(0.5, 0.5);
	// color = vec3(Gaussian(outUV, center, 0.05));

	float pupilSize = 0.3;

	if(distance(center, outUV) > pupilSize)
		color = vec3(0.0);
	else
		color = vec3(1.0);
}