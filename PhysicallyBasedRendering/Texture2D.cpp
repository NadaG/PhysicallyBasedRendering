#include "Texture2D.h"

void Texture2D::Bind(GLenum texture)
{
	// ������ ��!
	// ���ڷ� ���� �ؽ��Ĵ� shader�� ���� �ؽ��� GL_TEXTURE0 �� �̰�
	// this->texture�� �ؽ��Ĵ� glBindTexture�� �� ����� ���̵��̴�
	glActiveTexture(texture);
	glBindTexture(GL_TEXTURE_2D, this->texture);
}