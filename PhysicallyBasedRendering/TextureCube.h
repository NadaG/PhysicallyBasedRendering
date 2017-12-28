#pragma once

#include "Texture.h"

class TextureCube : public Texture
{
public:
	void Bind(GLenum texture);

	void LoadTexture(const string& s);
	void LoadTextureCubeMap(const GLint& internalformat, const GLsizei& width, const GLsizei& height, const GLenum& format, const GLenum& type);
	void LoadTextureCubeMap(vector<string> faces, const GLint& internalformat, const GLenum& format, const GLenum& type);
	
	void SetParameters(const GLint& minFilter, const GLint& magFilter, const GLint& wrapS, const GLint& wrapT, const GLint& wrapR);

private:
};