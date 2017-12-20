#version 330 core

out vec3 color;

in vec3 worldNormal;
in vec3 worldPos;

uniform vec3 eyePos;
uniform samplerCube skybox;

void main()
{
	vec3 ReflectI = normalize(worldPos - eyePos);
	vec3 Reflect = reflect(ReflectI, normalize(worldNormal));
	
	float ratio = 1.00 / 1.2;
	vec3 RefractI = normalize(worldPos - eyePos);
	vec3 Refract = refract(RefractI, normalize(worldNormal), ratio);

	//color = texture(skybox, Refract).rgb * 0.7 + texture(skybox, Reflect).rgb * 0.3;
	color = texture(skybox, Refract).rgb;
}