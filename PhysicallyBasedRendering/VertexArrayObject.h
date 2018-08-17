#pragma once

#include<GL/glew.h>

#include "Debug.h"

class VertexArrayObject
{
public:
	VertexArrayObject()
		:drawMode(GL_POINTS) { hasIBO = false; }
	virtual ~VertexArrayObject();

	void GenVAOVBOIBO();
	void GenVAOVBO();

	void VertexBufferData(const GLsizeiptr& size, const GLvoid* data);
	void IndexBufferData(const GLsizeiptr& size, const GLvoid* data);

	void Bind() { glBindVertexArray(vao); }

	// VertexBufferData를 먼저 불러주어야 함
	void VertexAttribPointer(const GLuint& size, const GLuint& stride);

	const GLenum GetDrawMode() const { return drawMode; }

	const GLuint VBO() { return vbo; }
	const GLuint IBO() { return ibo; }

private:
	bool hasIBO;

	GLuint vertexAttribPointerId = 0;
	GLuint vertexAttribPointerOffset = 0;

	GLuint vao;
	GLuint ibo;
	GLuint vbo;

	GLenum drawMode;
};