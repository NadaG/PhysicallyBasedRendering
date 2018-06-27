#version 330 core

out vec3 color;

in vec3 outPos;
in vec3 outNormal;
in vec2 outUV;

uniform vec3 L;
uniform vec3 lightColor;
uniform vec3 eyePos;


void main()
{
	// -1 ~ 1
	vec3 normal = outNormal * 0.5f + vec3(0.5f);
	
	vec3 ambient = vec3(0.0f, 0.01f, 0.1f);
	vec3 diffuse = vec3(0.2f, 0.2f, 0.5f);
	diffuse *= clamp(dot(normalize(L), normal), 0.0, 1.0);

	vec3 specular = vec3(0.4f, 0.0f, 0.0f);
	vec3 R = normalize(reflect(normalize(-L), normal));
	vec3 V = normalize(eyePos - outPos);
	specular *= pow(clamp(dot(V, R), 0.0, 1.0), 16);

	color = ambient + diffuse + specular;

	color = normal;
}