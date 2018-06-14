#version 330 core

uniform sampler2D map;
uniform vec3 backgroundColor;

uniform int neighborNum;

// �Ÿ��� ���ؼ� �����ϸ�
uniform float blurScale;
// �� ���̿� ���ؼ� �����ϸ�
uniform float blurDepthFalloff;

in vec2 outUV;

out vec3 color;

void main()
{
	float depth = texture(map, outUV).r;

	if(texture(map, outUV).g == 1.0)
		discard;

	float sum = 0;
	float wsum = 0;

	
	for(float x = -neighborNum; x <= neighborNum; x++)
	{
		for(float y = -neighborNum; y <= neighborNum; y++)
		{
			vec2 blurDir = vec2(x, y) / textureSize(map, 0);
			float sample = texture(map, outUV + blurDir).x;

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