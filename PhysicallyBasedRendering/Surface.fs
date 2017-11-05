#version 330 core

uniform sampler2D worldMap;
uniform sampler2D bluredDepthMap;
uniform sampler2D thicknessMap;

uniform mat4 projection;
uniform mat4 view;

uniform vec3 lightDir;
uniform vec3 eyePos;

uniform float near;
uniform float far;

in vec2 outUV;

out vec3 color;

vec3 getEyePos(sampler2D tex, vec2 uv)
{
	float depth = texture(tex, uv).x;

	// uv 좌표는 0부터 1까지
	// 변경되고 나서는 -1 부터 1까지
	float x = uv.x * 2 - 1;
	float y = uv.y * 2 - 1;
	float z = depth;

	vec4 posEye = inverse(projection) * vec4(x, y, z, 1.0);
	posEye.xyz /= posEye.w;

	return posEye.xyz;
}

void main()
{
	vec3 depth = texture(bluredDepthMap, outUV).rgb;
	vec3 worldColor = texture(worldMap, outUV).rgb;
	// depth가 없는 곳에서는, 즉 물이 없는 곳에서는 배경 색이 보임
	if(depth.r == 0.0f)
	{
		color = worldColor;
		return;
	}

	vec3 posEye = getEyePos(bluredDepthMap, outUV);
	vec2 texelSize = 1.0 / textureSize(bluredDepthMap, 0);

	vec3 ddx = getEyePos(bluredDepthMap, outUV + vec2(texelSize.x, 0)) - posEye;
	vec3 ddx2 = posEye - getEyePos(bluredDepthMap, outUV + vec2(-texelSize.x, 0));
	if(abs(ddx.z) > abs(ddx2.z))
	{
		ddx = ddx2;
	}

	vec3 ddy = getEyePos(bluredDepthMap, outUV + vec2(0, texelSize.y)) - posEye;
	vec3 ddy2 = posEye - getEyePos(bluredDepthMap, outUV + vec2(0, -texelSize.y));
	if(abs(ddy2.z) < abs(ddy.z))
	{
		ddy = ddy2;
	}

	vec3 n = normalize(cross(ddx, ddy));
	vec3 lightPosNorm = normalize(vec3(view*vec4(lightDir, 0.0)));
	
	vec3 reflectDir = normalize(reflect(-lightPosNorm, n));

	vec3 eyeDir = normalize(posEye - vec3(view*vec4(eyePos, 1.0)));

	vec3 ambient = vec3(0.1, 0.1, 0.2);
	vec3 diffuse = vec3(0.1, 0.1, 0.6) * max(dot(-lightPosNorm, n), 0);
	vec3 specular = vec3(0.8, 0.8, 0.8) * pow(max(dot(reflectDir, eyeDir), 0), 16);
	
	float thickness = texture(thicknessMap, outUV).r;
	// 각 채널마다 thickness에 k를 곱해도 됨
	float I = 1 / (exp(5 * thickness));
	
	color = ambient + diffuse + specular + worldColor * I;
}