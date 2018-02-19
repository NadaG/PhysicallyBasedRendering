#include "Texture2D.h"

void Texture2D::Bind(GLenum texture)
{
	// ������ ��!
	// ���ڷ� ���� �ؽ��Ĵ� shader�� ���� �ؽ��� GL_TEXTURE0 �� �̰�
	// this->texture�� �ؽ��Ĵ� glBindTexture�� �� ����� ���̵��̴�
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