#version 330 core

in vec3 eyeSpacePos;
in vec3 particleColor;

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

	color = particleColor;
}