#version 330 core

out vec3 color;

in vec3 worldPos;
in vec3 normal;

uniform vec3 lightDir;
uniform vec3 eyePos;

void main()
{
	vec3 lightColor = vec3(1.0, 1.0, 1.0);

	vec3 ambient = vec3(0.2, 0.2, 0.2);

	vec3 diffuseColor = vec3(0.1, 0.3, 0.5);
	vec3 diffuse = diffuseColor * max(0, dot(normalize(normal), -normalize(lightDir)));

	vec3 eyeDir = normalize(eyePos);


	vec3 specularColor = vec3(0.1, 0.3, 0.8);
	vec3 specular = specularColor * max(0, pow(dot(normalize(reflect(lightDir, normal)), eyeDir), 32));

	color = ambient + diffuse + specular;
	// -1 ~ 1
	//color = 0.5 * normal + vec3(0.5);
}