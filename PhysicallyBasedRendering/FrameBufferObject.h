#pragma once

#include <GL/glew.h>
#include <vector>

#include "RenderBufferObject.h"
#include "Texture.h"

using std::vector;

class FrameBufferObject
{
public:

	FrameBufferObject() {};

	const GLuint& GetFBO() { return fbo; }
	void GenFrameBufferObject();
	void BindRenderBuffer(GLenum attachment, RenderBufferObject rbo);
	void BindTexture(GLenum attachment, GLenum texture, Texture textureobj);

	void Use();

	void DrawBuffers();

	const GLenum& CheckStatus();

private:

	GLuint fbo;
	vector<GLenum> attachments;

};