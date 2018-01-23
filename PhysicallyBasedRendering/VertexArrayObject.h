#pragma once

#include<GL/glew.h>

#include "Debug.h"

class VertexArrayObject
{
public:
	VertexArrayObject()
		:drawMode(GL_POINTS){}
	virtual ~VertexArrayObject();

	void GenVAOVBOIBO();

	void VertexBufferData(const GLsizeiptr& size, const GLvoid* data);
	void IndexBufferData(const GLsizeiptr& size, const GLvoid* data);

	void Bind() { glBindVertexArray(vao); }

	// VertexBufferDate ���� �ҷ��� ��
	void VertexAttribPointer(const GLuint& size, const GLuint& stride);

	void SetDrawMode(const GLenum drawMode) { this->drawMode = drawMode; }

	const GLenum GetDrawMode() const { return drawMode; }

private:
	GLuint vertexAttribPointerId = 0;
	GLuint vertexAttribPointerOffset = 0;

	GLuint vao;
	GLuint ibo;
	GLuint vbo;

	GLenum drawMode;
};