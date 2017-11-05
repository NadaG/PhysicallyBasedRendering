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

	// TODO filter �����ϱ�
	// scale ���� ��� ���ϴ°� ����?
	// �Ÿ��� ���ؼ� �����ϸ�
	float blurScale = 0.01;
	// �� ���̿� ���ؼ� �����ϸ�
	float blurDepthFalloff = 0.01;

	// TODO x, y�� ���ؼ� �ϴ� ���� �³�?
	for(float x = -10; x <= 10; x++)
	{
		for(float y = -10; y <= 10; y++)
		{
			// (sampler, lod)
			// textureSize width, height��??
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