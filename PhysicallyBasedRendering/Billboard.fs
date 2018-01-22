#version 330 core

out vec3 color;

in vec2 outUV;

const float PI = 3.14159265359;
const float e = 2.7182818284;

// 평균 값과 분산 값이 있어야 함
// 중간 값은 0.5, 0.5
void main()
{
	// 1/(분산*루트(2*PI))*제곱(e, -제곱(x - 중간 값 ,2)/(2*제곱(분산,2)))
	float deviation = 0.05;

	float gaussian = 1 / (deviation * sqrt(2 * PI)) * pow(e, -length(outUV - vec2(0.5, 0.5))*length(outUV - vec2(0.5, 0.5)) / (2 * deviation * deviation));

	color = vec3(gaussian);
}