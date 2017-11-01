#version 330 core

uniform sampler2D depthMap;

in vec2 outUV;

out vec3 color;

void main()
{
	float depth = texture(depthMap, outUV).r;

	float sum = 0;
	float wsum = 0;

	// 거리에 대해서 스케일링
	float blurScale = 0.01f;
	// 값 차이에 대해서 스케일링
	float blurDepthFalloff = 0.01f;

	// (sampler, lod)
	vec2 blurDir = vec2(1.0, 0.0) / textureSize(depthMap, 0);

	for(float x = -2; x <= 2; x++)
	{
		float sample = texture(depthMap, outUV + x * blurDir).x;

		float r = x * blurScale;
		float w = exp(-r*r);

		float r2 = (sample - depth) * blurDepthFalloff;
		float g = exp(-r2*r2);

		sum += sample * w * g;
		wsum += w * g;
	}

	if(wsum > 0.0)
		sum /= wsum;

	color = vec3(sum);
}