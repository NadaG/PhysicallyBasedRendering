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

// mix function lerp와 비슷하다
// mix(x, y, a)이면 x*(1-a) + y*a를 리턴한다

vec3 getNormalFromMap()
{
	// tangent space에서의 normal, 값은 -1에서 1
	vec3 tangentNormal = texture(normalMap, outUV).xyz * 2.0 - 1.0;

	vec3 Q1 = dFdx(worldPos);
	vec3 Q2 = dFdy(worldPos);
	vec2 st1 = dFdx(outUV);
	vec2 st2 = dFdy(outUV);

	// (e1, e2) = (u1, v1, u2, v2) * (T, B)로 두고 역행렬로 풀어서 T 구하면 됨
	vec3 N = normalize(outNormal);
	vec3 T = normalize(Q1*st2.t - Q2*st1.t);
	vec3 B = -normalize(cross(N, T));
	mat3 TBN = mat3(T, B, N);

	return normalize(TBN * tangentNormal);
}

// cosTheta가 작을 수록 큰 값이 들어간다
// 즉 90도에 가까운 곳에서 볼 수록 빛이 쎄진다는 것이다.
// 90이면 그냥 1임
// 각도가 높아지면 점점 약해지고 F0값에 가까워짐
vec3 fresnelSchlick(float cosTheta, vec3 F0)
{
	return F0 + (1.0 - F0) * pow(1.0 - cosTheta, 5.0);
}

void main()
{
	// gamma correction
	// 사람의 눈은 더 밝게 인식하므로 
	// 살짝 어둡게 만드는 것임
	vec3 albedo = pow(texture(albedoMap, outUV).rgb, vec3(2.2));

	float metallic = texture(metallicMap, outUV).r;
	float roughness = texture(roughnessMap, outUV).r;
	float ao = texture(aoMap, outUV).r;

	vec3 N = getNormalFromMap();
	vec3 V = normalize(eyePos - worldPos);

	// 금속이 아닐경우 0.04이고 금속일 경우 albedo에 가까워 지도록 lerp
	vec3 F0 = vec3(0.04);
	F0 = mix(F0, albedo, metallic);

	vec3 Lo = vec3(0.0);
	for(int i = 0; i < 4; i++)
	{
		// world space light position
		vec3 L = normalize(lightPositions[i] - worldPos);
		vec3 H = normalize(V + L);

		float distance = length(lightPositions[i] - worldPos);
		// 단순히 거리가 멀어서 attenuation이 작동하는 것이 아니라
		// 점광원으로 표현되기 때문에 그런것이다.
		float attenuation = 1.0 / (distance * distance);

		// light color가 attenuate 된 후 radiance로 들어간다
		vec3 radiance = lightColors[i] * attenuation;

		vec3 F = fresnelSchlick(max(dot(H,V), 0.0), F0);

		vec3 nominator = F;

		float denominator = 4 * max(dot(N,V), 0.0) * max(dot(N,L), 0.0) + 0.001;
		vec3 specular = nominator / denominator;

		// specular된 양은 F 함수가 리턴한 값과 같음
		vec3 kS = F;
		vec3 kD = vec3(1.0) - kS;

		kD *= 1.0 - metallic;

		float NdotL = max(dot(N,L), 0.0);

		Lo += (kD * albedo / PI + specular) * radiance * NdotL;
	}

	vec3 ambient = vec3(0.03) * albedo * ao;

	color = ambient + Lo;

	color = color / (color + vec3(1.0));
	color = pow(color, vec3(1.0/2.2));
}