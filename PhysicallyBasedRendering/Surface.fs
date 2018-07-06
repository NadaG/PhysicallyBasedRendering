#version 330 core

uniform sampler2D worldMap;
uniform sampler2D bluredDepthMap;
uniform sampler2D thicknessMap;
uniform sampler2D normalMap;
uniform sampler2D worldDepthMap;

uniform sampler2D debugMap;

uniform mat4 projection;
uniform mat4 view;

uniform vec3 lightDir;
uniform vec3 eyePos;

uniform float near;
uniform float far;

in vec2 outUV;
in vec3 normal;

out vec3 color;

float fresnel(vec3 n, vec3 v)
{
	float F0 = 0.0;
	float cosTheta = dot(normalize(n), normalize(v));

	return F0 + (1 - F0)*pow(1 - cosTheta, 5);
}

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

float LinearizeDepth(float depth)
{
	float z = depth * 2.0 - 1.0;
	return (2.0 * near * far) / (far + near - z * (far - near));
}

void main()
{
	//float tmpDepth = texture(debugMap, outUV).r;
	//tmpDepth = LinearizeDepth(tmpDepth) / far;
	//color = vec3(tmpDepth, tmpDepth, tmpDepth);

	//color = texture(debugMap, outUV).rgb;
	//return;

	vec3 depth = texture(bluredDepthMap, outUV).rgb;
	vec3 worldColor = texture(worldMap, outUV).rgb;
	float worldDepth = texture(worldDepthMap, outUV).r;
	
	// depth가 없는 곳에서는, 즉 물이 없는 곳에서는 배경 색이 보임
	if(depth.r == 1.0f || depth.r == 0.0f || LinearizeDepth(worldDepth) / far < depth.r)
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
	//n = normalize(texture(normalMap, outUV).rgb);

	vec3 lightPosNorm = normalize(vec3(view*vec4(lightDir, 0.0)));
	
	vec3 reflectDir = normalize(reflect(-lightPosNorm, n));

	vec3 eyeDir = normalize(posEye - vec3(view*vec4(eyePos, 1.0)));

	vec3 ambient = vec3(0.1, 0.1, 0.5);
	vec3 diffuse = vec3(0.3, 0.3, 0.7) * max(dot(-lightPosNorm, n), 0);
	vec3 specular = vec3(0.1, 0.1, 0.1) * pow(max(dot(reflectDir, eyeDir), 0), 32);
	
	float thickness = texture(thicknessMap, outUV).r;
	// 각 채널마다 thickness에 k를 곱해도 됨
	float I = 1 / (exp(1 * thickness));
	
	//color = ambient + diffuse + specular * fresnel(n, eyeDir) + worldColor * I;

	// normal rendering
	color = n * 0.5f + vec3(0.5f);

	// point rendering
	//color = vec3(0.0, 0.0, 1.0);
}