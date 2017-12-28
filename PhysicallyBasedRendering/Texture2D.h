#pragma once

#include "Texture.h"

class Texture2D : public Texture
{
public:

	void Bind(GLenum texture);

	void SetParameters(const GLint& minFilter, const GLint& magFilter, const GLint& wrapS, const GLint& wrapT);

private:
};