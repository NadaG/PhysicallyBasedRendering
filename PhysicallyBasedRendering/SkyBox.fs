#version 330 core

out vec4 color;

in vec3 outUV;

uniform samplerCube skybox;
uniform bool isHDR;

void main()
{
	// -1~1 ť��� samplerCube�� 1:1 ���εȴ�.
	color = texture(skybox, outUV);
	//color = vec4(1.0, 0.0, 0.0, 1.0);

	//if(isHDR)
	//{
	//	color = color / (color + vec4(1.0));
	//	color = pow(color, vec4(1.0/2.2));
	//}
}