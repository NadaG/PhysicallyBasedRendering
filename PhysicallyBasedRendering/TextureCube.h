#pragma once

#include "Texture.h"

class TextureCube : public Texture
{
public:
	void Bind(GLenum texture);
};