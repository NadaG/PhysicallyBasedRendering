#include "VertexArrayObject.h"

VertexArrayObject::~VertexArrayObject()
{
	/*glDeleteVertexArrays(1, &vao);
	glDeleteBuffers(1, &vbo);
	glDeleteBuffers(1, &ibo);*/
}

void VertexArrayObject::GenVAOVBOIBO()
{
	glGenVertexArrays(1, &vao);
	glGenBuffers(1, &vbo);
	glGenBuffers(1, &ibo);
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
	// 이게 어쩌면 오류를 만들고 있을 수도
	glBindVertexArray(vao);
	glBindBuffer(GL_ARRAY_BUFFER, vbo);
	glEnableVertexAttribArray(vertexAttribPointerId);
	glVertexAttribPointer(
		vertexAttribPointerId, 
		size, 
		GL_FLOAT, 
		GL_FALSE, 
		sizeof(GLfloat) * stride, 
		(void*)(vertexAttribPointerOffset*sizeof(GLfloat)));
	vertexAttribPointerId++;
	vertexAttribPointerOffset += size;
}