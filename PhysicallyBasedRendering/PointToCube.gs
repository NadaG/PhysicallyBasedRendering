#version 400 core

// primitive�� input���� �ϰ� �� �ٸ� primitive�� output���� �ϴ� ���̴�

// gs input					vertex count
// points					1
// lines					2
// lines_adjacency			4
// triangles				3
// triangles_adjacency		6

// shader�� 2�� ȣ���� ���� �ִܴ�.
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

in vec3 vColor[];

out vec3 fColor;

uniform mat4 model[6];
uniform mat4 view;
uniform mat4 projection;

void main()
{
	fColor = vColor[0];

	for(int i = 0; i < 6; i++)
	{
		gl_Position = projection * view * (gl_in[0].gl_Position + model[i] * vec4(1.0, -1.0, 0.0, 1.0));
		EmitVertex();

		gl_Position = projection * view * (gl_in[0].gl_Position + model[i] * vec4(-1.0, -1.0, 0.0, 1.0));
		EmitVertex();

		gl_Position = projection * view * (gl_in[0].gl_Position + model[i] * vec4(1.0, 1.0, 0.0, 1.0));
		EmitVertex();

		gl_Position = projection * view * (gl_in[0].gl_Position + model[i] * vec4(-1.0, 1.0, 0.0, 1.0));
		EmitVertex();

		EndPrimitive();
	}
}