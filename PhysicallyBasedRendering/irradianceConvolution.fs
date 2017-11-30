#version 330 core
out vec3 color;

in vec3 worldPos;

uniform samplerCube skybox;

const float PI = 3.14159265359;

void main()
{
	// ���⼭ worldPos�� ť����� �߾����κ��� Ư�� �������� ���ͷ� �� �� �ִ� ������ -1 ~ 1
	// ���� ť��� �߾ӿ� ���� �ִٰ� �������� �� normal vector�̱⵵ �ϴ�
	// TBN�� N�̱⵵ �ϰ�
	// �ƹ�ư �ȼ� ���� �ſ� �پ��� N, up, right�� ������ �ٵ� N�� �������� �ؼ� �ݱ� ��ŭ ���ø��Ѵ�	
	// ���ø��ؼ� ���� ��հ��� �ٽ� �ش� ��ġ ť����� ������ �����Ѵ�
	// �̷��� �ϸ� �ش� ������ ���� diffuse color�� ������ �Ǵ� ���̴�.
	// � ��ü�� ���� ���� �� �� ������ ���� ��� ������ ���� ����� ���� �ƴ϶� 
	// �ݴ�� �� ������ ���� �̸� ����� �� ����ϴ� ����̴�.

	// TBN ���͸� ���س´�
	vec3 N = normalize(worldPos);
	vec3 irradiance = vec3(0.0);

	vec3 up = vec3(0.0, 1.0, 0.0);
	vec3 right = cross(up, N);
	up = cross(N, right);

	// 0.025 radian, 1 radian�� �� 50����� ���� ����Ϸ�
	float sampleDelta = 0.025;
	float nrSamples = 0.0;

	for(float phi = 0.0; phi < 2.0 * PI; phi += sampleDelta)
	{
		for(float theta = 0.0; theta < 0.5 * PI; theta += sampleDelta)
		{
			// spherical to cartesian �����̶�� �����ϸ� ����
			vec3 tangentSample = vec3(sin(theta) * cos(phi), sin(theta) * sin(phi), cos(theta));

			// �� ���� TBN * tangentSample�� ���ٰ� ���� �ȴ�.
			vec3 sampleVec = tangentSample.x * right + tangentSample.y * up + tangentSample.z * N;

			irradiance += texture(skybox, sampleVec).rgb * cos(theta) * sin(theta);
			nrSamples++;
		}
	}

	irradiance = PI * irradiance * (1.0 / float(nrSamples));

	color = texture(skybox, worldPos).rgb;
}