#pragma once

#include <GL/glew.h>
#include <vector>

#include "RenderBufferObject.h"
#include "Texture.h"
#include "PixelBufferObject.h"

using std::vector;

class FrameBufferObject
{
public:

	FrameBufferObject() {};

	const GLuint& GetFBO() { return fbo; }
	void GenFrameBufferObject();
	void BindRenderBuffer(GLenum attachment, RenderBufferObject rbo);
	void BindTexture(GLenum attachment, GLenum texture, Texture* textureobj);

	void BindDefaultDepthBuffer(const int width, const int height);

	void Use();
	void Clear(const float& r, const float& g, const float& b, const float& a);

	void DrawBuffers();

	const GLenum& CheckStatus();

	bool IsComplete();

private:

	GLuint fbo;
	vector<GLenum> attachments;

};