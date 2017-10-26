#include "FrameBufferObject.h"

void FrameBufferObject::GenFrameBufferObject()
{
	glGenFramebuffers(1, &fbo);
	glBindFramebuffer(GL_FRAMEBUFFER, fbo);
}

void FrameBufferObject::BindRenderBuffer(GLenum attachment, RenderBufferObject rbo)
{
	glBindFramebuffer(GL_FRAMEBUFFER, fbo);
	glFramebufferRenderbuffer(
		GL_FRAMEBUFFER, 
		attachment,
		GL_RENDERBUFFER, 
		rbo.GetRBO());
	attachments.push_back(attachment);
}

// depth map을 그리기 위한 texture binding 이었음
void FrameBufferObject::BindTexture(GLenum attachment, GLenum textarget, Texture texture)
{
	glBindFramebuffer(GL_FRAMEBUFFER, fbo);
	glFramebufferTexture2D(
		GL_FRAMEBUFFER, 
		attachment, 
		textarget, 
		texture.GetTexture(), 
		0);
	glDrawBuffer(GL_NONE);
	glReadBuffer(GL_NONE);
	attachments.push_back(attachment);
}

void FrameBufferObject::Use()
{
	glBindFramebuffer(GL_FRAMEBUFFER, fbo);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
}

void FrameBufferObject::DrawBuffers()
{
	int attaSize = attachments.size();
	GLuint* atts = new GLuint[attaSize];
	for (int i = 0; i < attaSize; i++)
		atts[i] = attachments[i];
	glDrawBuffers(attaSize, atts);
	delete atts;
}