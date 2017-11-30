#pragma once

#include <gl/glew.h>

class RenderBufferObject
{
public:
	
	RenderBufferObject() {};

	const GLuint& GetRBO() const { return rbo; }
	void GenRenderBufferObject();
	void RenderBufferStorage(const GLenum& internalformat, const unsigned int& width, const unsigned int& height);

private:

	GLuint rbo;
};