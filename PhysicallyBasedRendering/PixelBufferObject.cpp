#include "PixelBufferObject.h"

void PixelBufferObject::GenPixelBufferObject(const int width, const int height)
{
	glGenBuffers(1, &pbo);
	glBindBuffer(GL_PIXEL_UNPACK_BUFFER, pbo);
	glBufferData(GL_PIXEL_UNPACK_BUFFER, width*height * 4, 0, GL_DYNAMIC_COPY);

	cudaGLRegisterBufferObject(pbo);
}
