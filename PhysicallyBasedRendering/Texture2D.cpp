#include "Texture2D.h"

void Texture2D::Bind(GLenum texture)
{
	// 주의할 것!
	// 인자로 들어온 텍스쳐는 shader에 보낼 텍스쳐 GL_TEXTURE0 등 이고
	// this->texture의 텍스쳐는 glBindTexture할 때 사용할 아이디이다
	glActiveTexture(texture);
	glBindTexture(GL_TEXTURE_2D, this->texture);
}

void Texture2D::SetParameters(const GLint& minFilter, const GLint& magFilter, const GLint& wrapS, const GLint& wrapT)
{
	glBindTexture(GL_TEXTURE_2D, this->texture);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, minFilter);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, magFilter);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, wrapS);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, wrapT);
}