#include "Texture2D.h"

void Texture2D::Bind(GLenum texture)
{
	// 주의할 것!
	// 인자로 들어온 텍스쳐는 shader에 보낼 텍스쳐 GL_TEXTURE0 등 이고
	// this->texture의 텍스쳐는 glBindTexture할 때 사용할 아이디이다
	glActiveTexture(texture);
	glBindTexture(GL_TEXTURE_2D, this->texture);
}