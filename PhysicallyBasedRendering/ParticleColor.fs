#version 330 core

in vec3 worldSpacePos;
// 인자로 색을 넘겨줄 수 있음, 하지만 지금 사용 안 함
in vec3 particleColor;

uniform samplerCube skyboxMap;

uniform mat4 view;
uniform mat4 projection;

uniform vec3 cameraPos;

layout(location = 0) out vec3 color;

void main()
{
	vec3 n;
	n.xy = vec2(gl_PointCoord.x, gl_PointCoord.y);
	n.xy = n.xy * 2.0 - 1.0;
	float r2 = dot(n.xy, n.xy);

	if(r2 > 1.0)
	{ 
		discard;
		return;
	}
	
	n.z = sqrt(1.0 - r2);
	
	// 이것은 world space n이 아님!!!!
	vec3 worldSpaceN = vec3(inverse(projection) * inverse(view) * vec4(n, 0.0));

	vec3 I = normalize(worldSpacePos - cameraPos);

    vec3 reflectRay = reflect(I, normalize(worldSpaceN));
	vec3 refractRay = refract(I, normalize(worldSpaceN), 1.0f);

    //color = texture(skyboxMap, refractRay).rgb;
	color = vec3(0.5f, 0.1f, 0.1f);
}