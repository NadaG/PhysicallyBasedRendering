#include "TextureCube.h"

void TextureCube::Bind(GLenum texture)
{
	glActiveTexture(texture);
	glBindTexture(GL_TEXTURE_CUBE_MAP, this->texture);
}