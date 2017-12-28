#version 400 core

in vec2 outUV;

layout (location = 0) out vec3 color;

uniform sampler2D map;

void main()
{
	vec3 inColor = texture(map, outUV).rgb;

	float brightness = dot(inColor, vec3(0.2126, 0.7152, 0.0722));
	
	if(brightness > 0.5)
		color = inColor;
	else
		color = vec3(0.0, 0.0, 0.0);
}