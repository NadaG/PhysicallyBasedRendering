#pragma once

#include <GL\glew.h>
#include<cuda_gl_interop.h>

class PixelBufferObject
{
public:
	PixelBufferObject() {};

	const GLuint& GetPBO() const { return pbo; }
	void GenPixelBufferObject(const int width, const int height);

private:

	GLuint pbo;
};