#pragma once

#include<GL/glew.h>

#include "Debug.h"

class VertexArrayObject
{
public:
	VertexArrayObject(){}
	virtual ~VertexArrayObject();

	void GenVAOVBOIBO();

	void VertexBufferData(const GLsizeiptr& size, const GLvoid* data);
	void IndexBufferData(const GLsizeiptr& size, const GLvoid* data);

	void Bind() { glBindVertexArray(vao); }

	void VertexAttribPointer(const GLuint& size, const GLuint& stride);

private:
	GLuint vertexAttribPointerId = 0;
	GLuint vertexAttribPointerOffset = 0;

	GLuint vao;
	GLuint ibo;
	GLuint vbo;
};