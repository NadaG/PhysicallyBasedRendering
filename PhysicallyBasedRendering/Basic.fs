#version 330 core

out vec3 color;

in vec3 outPos;
in vec3 outNormal;
in vec2 outUV;

uniform vec3 inColor;

uniform sampler2D tex;

void main()
{
	// -1 ~ 1
	vec3 normal = outNormal * 0.5f + vec3(0.5f);
	color = normal;

	color = texture(tex, outUV).rgb;
}