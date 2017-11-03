#version 330 core

uniform sampler2D depthMap;

in vec2 outUV;

out vec3 color;

void main()
{
	float depth = texture(depthMap, outUV).r;

	float sum = 0;
	float wsum = 0;

	// scale ���� ��� ���ϴ°� ����?
	// �Ÿ��� ���ؼ� �����ϸ�
	float blurScale = 1.0;
	// �� ���̿� ���ؼ� �����ϸ�
	float blurDepthFalloff = 1.0;

	// TODO x, y�� ���ؼ� �ϴ� ���� �³�?
	for(float x = -15; x <= 15; x++)
	{
		for(float y = -15; y <= 15; y++)
		{
			// (sampler, lod)
			// textureSize width, height��??
			vec2 blurDir = vec2(x, y) / textureSize(depthMap, 0);
			float sample = texture(depthMap, outUV + blurDir).x;

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