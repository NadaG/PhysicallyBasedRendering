#version 330 core

in vec2 outUV;
in vec3 worldPos;
in vec3 outNormal;

out vec3 color;

uniform sampler2D aoMap;
uniform sampler2D albedoMap;
uniform sampler2D heightMap;
uniform sampler2D metallicMap;
uniform sampler2D normalMap;
uniform sampler2D roughnessMap;

uniform vec3 lightPositions[4];
uniform vec3 lightColors[4];

uniform vec3 eyePos;

const float PI = 3.14159265359;

// mix function lerp�� ����ϴ�
// mix(x, y, a)�̸� x*(1-a) + y*a�� �����Ѵ�

vec3 getNormalFromMap()
{
	// tangent space������ normal, ���� -1���� 1
	vec3 tangentNormal = texture(normalMap, outUV).xyz * 2.0 - 1.0;

	vec3 Q1 = dFdx(worldPos);
	vec3 Q2 = dFdy(worldPos);
	vec2 st1 = dFdx(outUV);
	vec2 st2 = dFdy(outUV);

	// (e1, e2) = (u1, v1, u2, v2) * (T, B)�� �ΰ� ����ķ� Ǯ� T ���ϸ� ��
	vec3 N = normalize(outNormal);
	vec3 T = normalize(Q1*st2.t - Q2*st1.t);
	vec3 B = -normalize(cross(N, T));
	mat3 TBN = mat3(T, B, N);

	return normalize(TBN * tangentNormal);
}

float DistributionGGX(vec3 N, vec3 H, float roughness)
{
	float a = roughness * roughness;
	float a2 = a * a;
	float NdotH = max(dot(N, H), 0.0);
	float NdotH2 = NdotH * NdotH;

	float nominator = a2;
	float denominator = (NdotH2 * (a2 - 1.0) + 1.0);
	denominator = PI * denominator * denominator;

	return nominator / denominator;
}

float GeometrySchlickGGX(float NdotV, float roughness)
{
	float r = (roughness + 1.0);
	float k = (r * r) / 8.0;

	float nominator = NdotV;
	float denominator = NdotV * (1.0 - k) + k;

	return nominator / denominator;
}

// geometry shadowing ���� � ǥ������ �� �� �ٸ� ǥ�鿡 ���� ���� ���ϴ� ���
// geometry obstruction ���� � ǥ�鿡�� ������ �� �� �ٸ� ǥ�鿡 ���� ���� ���ϴ� ���
// �� �ΰ����� ��� ����ؾ� �ؼ� ggx1 * ggx2
// 0.8�� �� ������, 0.8�� �� �����ٸ� �ᱹ�� 0.8 * 0.8
float GeometrySmith(vec3 N, vec3 V, vec3 L, float roughness)
{
	float NdotV = max(dot(N, V), 0.0);
	float NdotL = max(dot(N, L), 0.0);

	float ggx2 = GeometrySchlickGGX(NdotV, roughness);
	float ggx1 = GeometrySchlickGGX(NdotL, roughness);

	return ggx1 * ggx2;
}

// cosTheta�� ���� ���� ū ���� ����
// �� 90���� ����� ������ �� ���� ���� �����ٴ� ���̴�.
// 90�̸� �׳� 1��
// ������ �������� ���� �������� F0���� �������
vec3 fresnelSchlick(float cosTheta, vec3 F0)
{
	return F0 + (1.0 - F0) * pow(1.0 - cosTheta, 5.0);
}

void main()
{
	// gamma correction
	// ����� ���� �� ��� �ν��ϹǷ� 
	// ��¦ ��Ӱ� ����� ����
	vec3 albedo = pow(texture(albedoMap, outUV).rgb, vec3(2.2));

	float metallic = texture(metallicMap, outUV).r;
	float roughness = texture(roughnessMap, outUV).r;
	//float ao = texture(aoMap, outUV).r;

	vec3 N = getNormalFromMap();
	vec3 V = normalize(eyePos - worldPos);

	// �ݼ��� �ƴҰ�� 0.04�̰� �ݼ��� ��� albedo�� ����� ������ lerp
	vec3 F0 = vec3(0.04);
	F0 = mix(F0, albedo, metallic);

	vec3 Lo = vec3(0.0);
	for(int i = 0; i < 4; i++)
	{
		// world space light position
		vec3 L = normalize(lightPositions[i] - worldPos);
		vec3 H = normalize(V + L);

		float distance = length(lightPositions[i] - worldPos);
		// �ܼ��� �Ÿ��� �־ attenuation�� �۵��ϴ� ���� �ƴ϶�
		// ���������� ǥ���Ǳ� ������ �׷����̴�.
		float attenuation = 1.0 / (distance * distance);

		// light color�� attenuate �� �� radiance�� ����
		vec3 radiance = lightColors[i] * attenuation;

		// ���� fresnel ������ ����� ������ ���ؼ��� ��Ȯ�� ������
		// ���� 90���� ���� ���� �� ������ �Ӽ�? ���� ���� ���� ������ �����̴�.
		// half vector�� view vector�� ������ ���ȴ�.
		vec3 F = fresnelSchlick(max(dot(H,V), 0.0), F0);
		// �ܼ��� N�� H, roughness�� ���� �Լ��̴�.
		// �󸶳� ���� H(micro) �� N(macro)�� �����Ŀ� ���� ���� Ŀ����.
		float NDF = DistributionGGX(N, H, roughness);
		// 
		float G = GeometrySmith(N, V, L, roughness);

		vec3 nominator = F * NDF * G;

		float denominator = 4 * max(dot(N,V), 0.0) * max(dot(N,L), 0.0) + 0.001;
		vec3 specular = nominator / denominator;

		// specular�� ���� F �Լ��� ������ ���� ���� ����?? ���� �� �𸣰���
		// F �Լ����� �̿��ؼ� kS�� kD�� ����
		// kD�� color�� �������� PI�� ��������
		vec3 kS = F;
		vec3 kD = vec3(1.0) - kS;

		kD *= 1.0 - metallic;

		float NdotL = max(dot(N,L), 0.0);

		Lo += (kD * albedo / PI + specular) * radiance * NdotL;
	}

	vec3 ambient = vec3(0.03) * albedo;

	color = ambient + Lo;

	color = color / (color + vec3(1.0));
	color = pow(color, vec3(1.0/2.2));
}