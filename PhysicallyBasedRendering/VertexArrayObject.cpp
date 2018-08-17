#include "VertexArrayObject.h"

VertexArrayObject::~VertexArrayObject()
{
	/*glDeleteVertexArrays(1, &vao);
	glDeleteBuffers(1, &vbo);
	glDeleteBuffers(1, &ibo);*/
}

void VertexArrayObject::GenVAOVBOIBO()
{
	hasIBO = true;
	GenVAOVBO();
	glGenBuffers(1, &ibo);
}

void VertexArrayObject::GenVAOVBO()
{
	hasIBO = false;
	glGenVertexArrays(1, &vao);
	glGenBuffers(1, &vbo);
}

void VertexArrayObject::VertexBufferData(const GLsizeiptr& size, const GLvoid* data)
{
	glBindVertexArray(vao);
	glBindBuffer(GL_ARRAY_BUFFER, vbo);
	glBufferData(GL_ARRAY_BUFFER, size, data, GL_STATIC_DRAW);
}

void VertexArrayObject::IndexBufferData(const GLsizeiptr& size, const GLvoid* data)
{
	glBindVertexArray(vao);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ibo);
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, size, data, GL_STATIC_DRAW);
}

void VertexArrayObject::VertexAttribPointer(const GLuint& size, const GLuint& stride)
{
	glVertexAttribPointer(
		vertexAttribPointerId,
		size,
		GL_FLOAT,
		GL_FALSE,
		sizeof(GLfloat) * stride,
		(void*)(vertexAttribPointerOffset * sizeof(GLfloat)));
	glEnableVertexAttribArray(vertexAttribPointerId);
	vertexAttribPointerId++;
	vertexAttribPointerOffset += size;
}