#version 400 core

// primitive를 input으로 하고 또 다른 primitive를 output으로 하는 셰이더

// gs input					vertex count
// points					1
// lines					2
// lines_adjacency			4
// triangles				3
// triangles_adjacency		6

// shader를 2번 호출할 수도 있단다.
// layout(triangles, invocations = 2) in;
layout(points) in;

// points
// line_strip
// triangle_strip
layout(triangle_strip, max_vertices = 36) out;

// in gl_PerVertex
// {
//	 vec4 gl_Position;
//   float gl_PointSize;
//   float gl_ClipDistance[]; 
// } gl_in[]

in vec3 vWorldPos[];
in vec3 vNormal[];

out vec3 worldPos;
out vec3 normal;

uniform mat4 model[6];
uniform mat4 view;
uniform mat4 projection;

void main()
{
	// EmitVertex를 하지 않을 경우 vertex를 그리지 않음
	for(int i = 0; i < 6; i++)
	{
		normal = normalize(cross(
		vec3(gl_in[0].gl_Position + model[i] * vec4(1.0, -1.0, 0.0, 1.0)) - 
		vec3(gl_in[0].gl_Position + model[i] * vec4(-1.0, -1.0, 0.0, 1.0)), 
		vec3(gl_in[0].gl_Position + model[i] * vec4(1.0, 1.0, 0.0, 1.0)) - 
		vec3(gl_in[0].gl_Position + model[i] * vec4(-1.0, -1.0, 0.0, 1.0))));

		// normal = vec3(1.0, 0.0, 0.0);

		gl_Position = projection * view * (gl_in[0].gl_Position + model[i] * vec4(1.0, -1.0, 0.0, 1.0));
		worldPos = vec3(gl_in[0].gl_Position + model[i] * vec4(1.0, -1.0, 0.0, 1.0));
		EmitVertex();

		gl_Position = projection * view * (gl_in[0].gl_Position + model[i] * vec4(-1.0, -1.0, 0.0, 1.0));
		worldPos = vec3(gl_in[0].gl_Position + model[i] * vec4(-1.0, -1.0, 0.0, 1.0));
		EmitVertex();

		gl_Position = projection * view * (gl_in[0].gl_Position + model[i] * vec4(1.0, 1.0, 0.0, 1.0));
		worldPos = vec3(gl_in[0].gl_Position + model[i] * vec4(1.0, 1.0, 0.0, 1.0));
		EmitVertex();

		gl_Position = projection * view * (gl_in[0].gl_Position + model[i] * vec4(-1.0, 1.0, 0.0, 1.0));
		worldPos = vec3(gl_in[0].gl_Position + model[i] * vec4(-1.0, 1.0, 0.0, 1.0));
		EmitVertex();
		
		EndPrimitive();
	}
}