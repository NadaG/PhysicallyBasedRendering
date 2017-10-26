#include "RenderBufferObject.h"

RenderBufferObject::RenderBufferObject(const unsigned int & width, const unsigned int & height)
{
	GenRenderBufferObject(width, height);
}

void RenderBufferObject::GenRenderBufferObject(const unsigned int & width, const unsigned int & height)
{
	glGenRenderbuffers(1, &rbo);
	glBindRenderbuffer(GL_RENDERBUFFER, rbo);
	glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT, width, height);
}