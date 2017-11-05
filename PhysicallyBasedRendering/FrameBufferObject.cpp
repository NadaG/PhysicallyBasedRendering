#include "FrameBufferObject.h"

void FrameBufferObject::GenFrameBufferObject()
{
	glGenFramebuffers(1, &fbo);
	glBindFramebuffer(GL_FRAMEBUFFER, fbo);
}

// �����Ұ�!!!
// ����� rbo�� depth�� ����ϰ� ����
void FrameBufferObject::BindRenderBuffer(GLenum attachment, RenderBufferObject rbo)
{
	glBindFramebuffer(GL_FRAMEBUFFER, fbo);
	glFramebufferRenderbuffer(
		GL_FRAMEBUFFER, 
		attachment,
		GL_RENDERBUFFER, 
		rbo.GetRBO());
}

// depth map�� �׸��� ���� texture binding �̾���
void FrameBufferObject::BindTexture(GLenum attachment, GLenum textarget, Texture texture)
{
	glBindFramebuffer(GL_FRAMEBUFFER, fbo);
	glFramebufferTexture2D(
		GL_FRAMEBUFFER, 
		attachment, 
		textarget, 
		texture.GetTexture(), 
		0);
	attachments.push_back(attachment);
}

void FrameBufferObject::BindDefaultDepthBuffer()
{
	glBindFramebuffer(GL_FRAMEBUFFER, fbo);
	glFramebufferRenderbuffer(
		GL_FRAMEBUFFER,
		GL_DEPTH_ATTACHMENT,
		GL_RENDERBUFFER,
		-1);
}

void FrameBufferObject::Use()
{
	glBindFramebuffer(GL_FRAMEBUFFER, fbo);
	// clear color ������ �� ��
	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
	// ���õ� ������ color buffer�� Ŭ����
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

// �����Ұ�!!!
// depth attachment�� ���� draw�� �־��� �ʿ� ����
void FrameBufferObject::DrawBuffers()
{
	glBindFramebuffer(GL_FRAMEBUFFER, fbo);
	int attaSize = attachments.size();
	GLuint* atts = new GLuint[attaSize];
	for (int i = 0; i < attaSize; i++)
	{
		atts[i] = attachments[i];
	}
	glDrawBuffers(attaSize, atts);
	delete atts;
}

const GLenum& FrameBufferObject::CheckStatus()
{
	glBindFramebuffer(GL_FRAMEBUFFER, fbo);
	return glCheckFramebufferStatus(GL_FRAMEBUFFER);
}
