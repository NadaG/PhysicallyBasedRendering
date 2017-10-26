#version 330 core
layout(location = 0) in vec3 vertexPos;
layout(location = 1) in vec3 vertexNormal;
layout(location = 2) in vec2 vertexUV;
layout(location = 3) in vec3 vertexColor;
layout(location = 4) in vec3 vertexTangent;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

uniform vec3 lightPos;
uniform vec3 lightColor;

uniform vec3 eyePos;

out vec3 outColor;
out vec2 outUV;

void main()
{
	vec3 worldPos = vec3(model * vec4(vertexPos, 1.0));

	vec3 ambient, diffuse, specular;

	ambient = vec3(0.3, 0.3, 0.3);
	diffuse = vec3(0.0, 0.0, 0.0);
	specular = vec3(0.0, 0.0, 0.0);

	diffuse = lightColor * max(0.0, dot(normalize(vertexNormal), normalize(lightPos)));
	specular = lightColor * pow(max(0.0, dot(normalize(eyePos), normalize(reflect(-lightPos, normalize(vertexNormal))))), 32);

	outColor = ambient + diffuse + specular;
	outUV = vertexUV;

	gl_Position = projection * view * model * vec4(vertexPos, 1.0);
}