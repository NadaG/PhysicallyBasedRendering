#version 400 core

out vec3 color;
in vec3 gFacetNormal;
in vec3 gTriDistance;
in vec3 gPatchDistance;
in float gPrimitive;

uniform vec3 lightDir;

float amplify(float d, float scale, float offset)
{
	d = scale * d + offset;
	d = clamp(d, 0, 1);
	d = 1 - exp2(-2*d*d);
	return d;
}

void main()
{
	vec3 N = normalize(gFacetNormal);
	vec3 L = -lightDir;
	float df = max(dot(N, L), 0);
	color = vec3(0.2, 0.2, 0.2) + df * vec3(0.5, 0.5, 0.5);

	float d1 = min(min(gTriDistance.x, gTriDistance.y), gTriDistance.z);
	float d2 = min(min(gPatchDistance.x, gPatchDistance.y), gPatchDistance.z);
	color = amplify(d1, 40, -0.5) * amplify(d2, 60, -0.5) * color;

	//color = vec3(1.0, 1.0, 1.0);
}