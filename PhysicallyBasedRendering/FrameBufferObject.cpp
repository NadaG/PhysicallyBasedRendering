#include "FrameBufferObject.h"

void FrameBufferObject::GenFrameBufferObject()
{
	glGenFramebuffers(1, &fbo);
	glBindFramebuffer(GL_FRAMEBUFFER, fbo);
}

// 주의할것!!!
// 여기는 rbo를 depth로 사용하고 있음
void FrameBufferObject::BindRenderBuffer(GLenum attachment, RenderBufferObject rbo)
{
	glBindFramebuffer(GL_FRAMEBUFFER, fbo);
	glFramebufferRenderbuffer(
		GL_FRAMEBUFFER, 
		attachment,
		GL_RENDERBUFFER, 
		rbo.GetRBO());
}

// depth map을 그리기 위한 texture binding 이었음
void FrameBufferObject::BindTexture(GLenum attachment, GLenum textarget, Texture* texture)
{
	glBindFramebuffer(GL_FRAMEBUFFER, fbo);
	glFramebufferTexture2D(
		GL_FRAMEBUFFER, 
		attachment, 
		textarget, 
		texture->GetTexture(), 
		0);
	attachments.push_back(attachment);
}

void FrameBufferObject::BindDefaultDepthBuffer(const int width, const int height)
{
	GLuint rbo;
	glGenRenderbuffers(1, &rbo);
	glBindRenderbuffer(GL_RENDERBUFFER, rbo);
	glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT, width, height);
	glBindFramebuffer(GL_FRAMEBUFFER, fbo);
	glFramebufferRenderbuffer(
		GL_FRAMEBUFFER,
		GL_DEPTH_ATTACHMENT,
		GL_RENDERBUFFER,
		rbo);
}

void FrameBufferObject::Use()
{
	glBindFramebuffer(GL_FRAMEBUFFER, fbo);
}

void FrameBufferObject::Clear(const float & r, const float & g, const float & b, const float& a)
{
	glBindFramebuffer(GL_FRAMEBUFFER, fbo);
	// clear color 셋팅을 한 후
	glClearColor(r, g, b, a);
	// 셋팅된 값으로 color buffer를 클리어
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

// 주의할것!!!
// depth attachment는 따로 draw에 넣어줄 필요 없음
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
