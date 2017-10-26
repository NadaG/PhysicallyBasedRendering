#pragma once

#include <gl/glew.h>

class RenderBufferObject
{
public:
	
	RenderBufferObject() {};
	RenderBufferObject(const unsigned int& width, const unsigned int& height);

	const GLuint& GetRBO() const { return rbo; }
	void GenRenderBufferObject(const unsigned int& width, const unsigned int& height);

private:

	GLuint rbo;
};