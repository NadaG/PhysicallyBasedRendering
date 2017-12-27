#version 400 core

out vec3 color;

in vec2 outUV;

uniform sampler2D map;

uniform bool horizontal;
uniform float weight[5] = float[] (0.227027, 0.1945946, 0.1216216, 0.054054, 0.016216);

void main()
{
	vec2 texOffset = 1.0 / textureSize(map, 0);
	vec3 result = texture(map, outUV).rgb * weight[0];

	if(horizontal)
	{
		for(int i = 1; i < 5; ++i)
		{
			result += texture(map, outUV + vec2(texOffset.x * i, 0.0)).rgb * weight[i];
			result += texture(map, outUV - vec2(texOffset.x * i, 0.0)).rgb * weight[i];
		}
	}
	else
	{
		for(int i = 1; i < 5; ++i)
		{
			result += texture(map, outUV + vec2(0.0, texOffset.y * i)).rgb * weight[i];
			result += texture(map, outUV - vec2(0.0, texOffset.y * i)).rgb * weight[i];
		}
	}
	
	color = result;
}