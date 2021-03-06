#version 330 core
layout(location = 0) in vec3 vertexPos;
layout(location = 1) in vec3 vertexNormal;
layout(location = 2) in vec2 vertexUV;
layout(location = 3) in vec3 vertexColor;
layout(location = 4) in vec3 vertexTangent;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

out vec3 outPos;
out vec3 outNormal;
out vec2 outUV;

void main()
{
	outUV = vertexUV;
	gl_Position = projection * view * model * vec4(vertexPos, 1.0);
	
	outNormal = normalize(vec3(view * model * vec4( vertexNormal, 0.0)));
	//outNormal =  vec3(model * vec4(vertexNormal, 1.0));
	//outNormal = vertexNormal;

	outPos = vec3(model * vec4(vertexPos, 1.0));
}