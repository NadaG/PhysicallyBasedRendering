#include "RenderBufferObject.h"

void RenderBufferObject::GenRenderBufferObject()
{
	glGenRenderbuffers(1, &rbo);
	glBindRenderbuffer(GL_RENDERBUFFER, rbo);
}

void RenderBufferObject::RenderBufferStorage(const GLenum & internalformat, const unsigned int & width, const unsigned int & height)
{
	glBindRenderbuffer(GL_RENDERBUFFER, rbo);
	glRenderbufferStorage(GL_RENDERBUFFER, internalformat, width, height);
}

void RenderBufferObject::Bind() const
{
	glBindRenderbuffer(GL_RENDERBUFFER, rbo);
}
