#include "RenderBufferObject.h"

RenderBufferObject::RenderBufferObject(const unsigned int & width, const unsigned int & height)
{
	GenRenderBufferObject(GL_DEPTH_COMPONENT, width, height);
}

void RenderBufferObject::GenRenderBufferObject(const GLenum& internalformat, const unsigned int & width, const unsigned int & height)
{
	glGenRenderbuffers(1, &rbo);
	glBindRenderbuffer(GL_RENDERBUFFER, rbo);
	glRenderbufferStorage(GL_RENDERBUFFER, internalformat, width, height);
}