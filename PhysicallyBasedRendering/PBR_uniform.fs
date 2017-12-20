#version 330 core

in vec2 outUV;
in vec3 worldPos;
in vec3 outNormal;

out vec3 color;

uniform vec3 albedo;
uniform float ao;
uniform float metallic;
uniform float roughness;

uniform samplerCube irradianceMap;
uniform samplerCube prefilterMap;
uniform sampler2D brdfLUT;

uniform vec3 lightPositions[4];
uniform vec3 lightColors[4];

uniform vec3 eyePos;

const float PI = 3.14159265359;

// mix function lerp�� ����ϴ�
// mix(x, y, a)�̸� x*(1-a) + y*a�� �����Ѵ�

// ggx distribution�̶�� �ܿ���
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

// smith geometry��� �ܿ���
// geometry shadowing ���� � ǥ������ �� �� �ٸ� ǥ�鿡 ���� ���� ���ϴ� ���
// geometry obstruction ���� � ǥ�鿡�� ������ �� �� �ٸ� ǥ�鿡 ���� ���� ���ϴ� ���
// �� �ΰ����� ��� �����ؾ� �ؼ� ggx1 * ggx2
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

vec3 fresnelSchlickRoughness(float cosTheta, vec3 F0, float roughness)
{
    return F0 + (max(vec3(1.0 - roughness), F0) - F0) * pow(1.0 - cosTheta, 5.0);
} 

void main()
{
	vec3 N = outNormal;
	vec3 V = normalize(eyePos - worldPos);
	vec3 R = reflect(-V, N);

	// �ݼ��� �ƴҰ�� 0.04�̰� �ݼ��� ��� albedo�� ����� ������ lerp
	vec3 F0 = vec3(0.04);
	// mix�� lerp�� ���ܴ�
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
		// ���� 90���� ���� ���� �� ������ �Ӽ�? ���� ���� ���� ������ �����̴�. ���ݻ� ������ �ƴ� �� �ʹ�
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

		// fresnel ��ü�� kS�̱� ������ �� �ٽ� kS�� ���� �ʿ䰡 ����
		Lo += (kD * albedo / PI + specular) * radiance * NdotL;
	}

	// ���� pbr
	// vec3 ambient = vec3(0.1) * albedo * ao;
	// color = ambient + Lo;

	vec3 F = fresnelSchlickRoughness(max(dot(N, V), 0.0), F0, roughness);
	vec3 kS = F;
    vec3 kD = 1.0 - kS;
    kD *= 1.0 - metallic;	  
	// �ܼ��� normal�� �̿��ؼ� irradiance�� ���Ѱ��̱� ������ ������ ���� �� ����
	// ������ ���̱� ���� light probe��� ���� ����Ѵٰ� ��
    vec3 irradiance = texture(irradianceMap, N).rgb;
    vec3 diffuse = irradiance * albedo;

	const float MAX_REFLECTION_LOD = 4.0;
	// 0�� ����� ���� base�� �����ٴ� ��, �� roughness�� �������� �ػ󵵰� ū map�� ����Ѵٴ� ���̴�.
	// �ֳ��ϸ� mipmap�� �� ���� texture�� ����� ���̹Ƿ�
	vec3 prefilterdColor = textureLod(prefilterMap, R, roughness * MAX_REFLECTION_LOD).rgb;
	// ���⼭�� N V�� �׳� N L�� �����ص� �ɰ� ����
	vec2 brdf = texture(brdfLUT, vec2(max(dot(N, V), 0.0), roughness)).rg;
	vec3 specular = prefilterdColor * (F * brdf.x + brdf.y);

	// ��濡�� ���� ���� ambient�� �ۿ��Ѵ�
    vec3 ambient = (kD * diffuse + specular) * ao;
    
	color = ambient + Lo;

	// hdr
	color = color / (color + vec3(1.0));
	// gamma correction
	color = pow(color, vec3(1.0/2.2));

	//ambient = ambient / (ambient + vec3(1.0));
	//ambient = pow(ambient, vec3(1.0/2.2));
	//color = ambient + Lo;

	//color = texture(brdfLUT, outUV).ggg;
	//color = texture(prefilterMap, outNormal).rgb;
}