#version 330 core

out vec3 color;

in vec3 outUV;

uniform samplerCube skybox;
uniform bool isHDR;

void main()
{
	// -1~1 ť��� samplerCube�� 1:1 ���εȴ�.
	color = texture(skybox, outUV).rgb;

	if(isHDR)
	{
		color = color / (color + vec3(1.0));
		color = pow(color, vec3(1.0/2.2));
	}
}