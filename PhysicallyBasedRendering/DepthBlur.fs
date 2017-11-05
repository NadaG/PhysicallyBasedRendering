#version 330 core

uniform sampler2D depthMap;

in vec2 outUV;

out vec3 color;

void main()
{
	float depth = texture(depthMap, outUV).r;

	if(depth == 0.0)
		discard;

	float sum = 0;
	float wsum = 0;

	// TODO filter 수정하기
	// scale 값은 어떻게 정하는게 좋지?
	// 거리에 대해서 스케일링
	float blurScale = 0.01;
	// 값 차이에 대해서 스케일링
	float blurDepthFalloff = 0.01;

	// TODO x, y에 대해서 하는 것이 맞나?
	for(float x = -10; x <= 10; x++)
	{
		for(float y = -10; y <= 10; y++)
		{
			// (sampler, lod)
			// textureSize width, height는??
			vec2 blurDir = vec2(x, y) / textureSize(depthMap, 0);
			float sample = texture(depthMap, outUV + blurDir).x;

			if(sample == 0.0f)
				continue;

			float r = x * blurScale;
			float w = exp(-r*r);

			float r2 = (sample - depth) * blurDepthFalloff;
			float g = exp(-r2*r2);

			sum += sample * w * g;
			wsum += w * g;
		}
	}

	if(wsum > 0.0)
		sum /= wsum;

	color = vec3(sum);
}