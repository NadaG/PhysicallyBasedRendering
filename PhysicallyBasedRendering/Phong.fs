#version 330 core

out vec3 color;

in vec3 worldPos;
in vec3 outNormal;
in vec2 outUV;

uniform vec3 lightDir;
uniform vec3 eyePos;

uniform vec3 ambientColor;
uniform vec3 diffuseColor;
uniform vec3 specularColor;

uniform float specularExpo;

//uniform sampler2D normalMap;

void main()
{
	vec3 pixelNormal = outNormal;
	//vec3 pixelNormal = texture(normalMap, outUV);

	vec3 lightColor = vec3(1.0, 1.0, 1.0);
	vec3 eyeDir = normalize(eyePos);

	vec3 ambient = ambientColor;
	vec3 diffuse = diffuseColor * max(0, dot(normalize(pixelNormal), -normalize(lightDir)));
	vec3 specular = specularColor * max(0, pow(dot(normalize(reflect(lightDir, normalize(pixelNormal))), eyeDir), specularExpo));

	color = ambient + diffuse + specular;

	// -1 ~ 1
	//color = 0.5 * normal + vec3(0.5);
}