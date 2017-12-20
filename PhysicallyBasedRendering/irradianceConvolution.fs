#version 330 core
out vec3 color;

in vec3 worldPos;

uniform samplerCube skybox;

const float PI = 3.14159265359;

void main()
{
	// 여기서 worldPos는 큐브맵의 중앙으로부터 특정 점까지의 벡터로 볼 수 있다 범위는 -1 ~ 1
	// 또한 큐브맵 중앙에 구가 있다고 생각했을 때 normal vector이기도 하다
	// TBN의 N이기도 하고
	// 아무튼 픽셀 별로 매우 다양한 N, up, right가 생성될 텐데 N을 방향으로 해서 반구 만큼 샘플링한다	
	// 샘플링해서 구한 평균값을 다시 해당 위치 큐브맵의 색으로 셋팅한다
	// 이렇게 하면 해당 점으로 오는 diffuse color가 설정이 되는 것이다.
	// 어떤 물체의 색을 구할 때 그 점으로 오는 모든 방향의 빛을 계산한 것이 아니라 
	// 반대로 그 뱡향의 색을 미리 계산한 후 사용하는 방식이다.

	// TBN 벡터를 구해냈다
	vec3 N = normalize(worldPos);
	vec3 irradiance = vec3(0.0);

	vec3 up = vec3(0.0, 1.0, 0.0);
	vec3 right = cross(up, N);
	up = cross(N, right);

	// 0.025 radian, 1 radian이 약 50도라는 것을 기억하렴
	float sampleDelta = 0.025;
	float nrSamples = 0.0;

	for(float phi = 0.0; phi < 2.0 * PI; phi += sampleDelta)
	{
		for(float theta = 0.0; theta < 0.5 * PI; theta += sampleDelta)
		{
			// spherical to cartesian 공식이라고 생각하면 편함
			vec3 tangentSample = vec3(sin(theta) * cos(phi), sin(theta) * sin(phi), cos(theta));

			// 이 식은 TBN * tangentSample과 같다고 보면 된다.
			vec3 sampleVec = tangentSample.x * right + tangentSample.y * up + tangentSample.z * N;

			irradiance += texture(skybox, sampleVec).rgb * cos(theta) * sin(theta);
			nrSamples++;
		}
	}

	irradiance = PI * irradiance * (1.0 / float(nrSamples));

	color = texture(skybox, worldPos).rgb;
}