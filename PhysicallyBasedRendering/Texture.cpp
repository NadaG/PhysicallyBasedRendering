#include "Texture.h"
#include "dds.h"

#include "Debug.h"

Texture::Texture(char const * path)
{
	LoadFixedTexture(path);
}

// internal format�� gpu ���ο��� ���� ������ ���ϰ�
// format�� client���� ���Ǵ� ������ ���Ѵ�, �� �����Ͱ� � ���·� ���ԳĴ� format�̴�.
// �����ս��� ��ĥ �� �ֱ� ������ �� �ΰ��� compatible�ϵ��� ����� ���� �߿��ϴܴ�. 
// ���� �������� ũ��� format�� type�� ���ؼ� �����ȴ�.(���� width�� height�� ����)
// format�� RGB�� RGBA�� ���� ���ϰ�, type�� unsigned byte�� int�� float�̳ĸ� ���Ѵ�.
void Texture::LoadTexture(const GLint& internalformat, const GLsizei& width, const GLsizei& height, const GLenum& format, const GLenum& type)
{
	glGenTextures(1, &texture);
	glBindTexture(GL_TEXTURE_2D, texture);
	glTexImage2D(GL_TEXTURE_2D, 0, internalformat, width, height, 0, format, type, 0);
	glGenerateMipmap(GL_TEXTURE_2D);

	this->texture = texture;
	this->internalformat = internalformat;
	this->width = width;
	this->height = height;
}

void Texture::LoadFixedTexture(const string& s)
{
	glGenTextures(1, &texture);
	glBindTexture(GL_TEXTURE_2D, texture);

	int width, height, nrComponents;
	unsigned char* data = stbi_load(s.c_str(), &width, &height, &nrComponents, 4);
	nrComponents = 4;

	if (data)
	{
		// input�� �������� format, Ȥ�� output�� �������� format
		// input�� �������� type�� GL_UNSIGNED_BYTE��
		GLenum format;
		if (nrComponents == 1)
		{
			format = GL_RED;
		}
		else if (nrComponents == 3)
		{
			format = GL_RGB;
		}
		else if (nrComponents == 4)
		{
			format = GL_RGBA;
		}
		
		// ���� �̹����� ��� unsigned byte�� �����ϰ�
		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA32F, width, height, 0, format, GL_UNSIGNED_BYTE, data);
		glGenerateMipmap(GL_TEXTURE_2D);

		this->width = width;
		this->height = height;

		stbi_image_free(data);
	}
	else
	{
		cout << "Texture failed to load at path: " << s << endl;
		cout << stbi_failure_reason();
		stbi_image_free(data);
	}
}

void Texture::LoadTexture(const string & s)
{
	glGenTextures(1, &texture);
	glBindTexture(GL_TEXTURE_2D, texture);

	int width, height, nrComponents;
	unsigned char* data = stbi_load(s.c_str(), &width, &height, &nrComponents, 0);

	if (data)
	{
		// input�� �������� format, Ȥ�� output�� �������� format
		// input�� �������� type�� GL_UNSIGNED_BYTE��
		GLenum format;
		if (nrComponents == 1)
		{
			format = GL_RED;
		}
		else if (nrComponents == 3)
		{
			format = GL_RGB;
		}
		else if (nrComponents == 4)
		{
			format = GL_RGBA;
		}

		// tgba32f Ÿ���� ������ �ؽ��� �޸𸮿� ����
		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA32F, width, height, 0, format, GL_UNSIGNED_BYTE, data);
		glGenerateMipmap(GL_TEXTURE_2D);

		this->width = width;
		this->height = height;

		stbi_image_free(data);
	}
	else
	{
		cout << "Texture failed to load at path: " << s << endl;
		cout << stbi_failure_reason();
		stbi_image_free(data);
	}
}

void Texture::LoadTextureDDS(const string & s)
{
	glGenTextures(1, &texture);
	glBindTexture(GL_TEXTURE_2D, texture);

	int width, height, nrComponents;
	float* data = LoadDDS(s.c_str(), &width, &height, &nrComponents);
	
	if (data)
	{
		GLenum format;
		if (nrComponents == 1)
			format = GL_RED;
		else if (nrComponents == 3)
			format = GL_RGB;
		else if (nrComponents == 4)
			format = GL_RGBA;

		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA32F, width, height, 0, format, GL_FLOAT, data);
		glGenerateMipmap(GL_TEXTURE_2D);

		this->width = width;
		this->height = height;

		stbi_image_free(data);
	}
	else
	{
		cout << "Texture failed to load at path: " << s << endl;
		cout << stbi_failure_reason();
		stbi_image_free(data);
	}
}

void Texture::LoadDepthTexture(const float& width, const float& height)
{
	glGenTextures(1, &texture);
	glBindTexture(GL_TEXTURE_2D, texture);
	// depth texture�� ��� float���� �����Ѵٴ� ���� ����!
	glTexImage2D(GL_TEXTURE_2D, 0, GL_DEPTH_COMPONENT, width, height, 0, GL_DEPTH_COMPONENT, GL_FLOAT, NULL);
}

void Texture::UpdateTexture(float* data, GLenum format, GLenum type)
{
	glBindTexture(GL_TEXTURE_2D, texture);
	glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, width, height, format, type, data);
}

float* Texture::GetTexImage(GLenum format) const
{
	glBindTexture(GL_TEXTURE_2D, texture);

	float* data;
	int channel = 0;
	// glGetTexImage�� �� �ȼ��� ���� internal four-component�� ������� 4���� value�� ��ȯ��

	switch (format)
	{
	case GL_R:
		channel = 1;
		break;
	case GL_RGB:
		channel = 3;
		break;
	case GL_RGBA:
		channel = 4;
		break;
	}
	data = new float[width * height * channel];

	glGetTexImage(GL_TEXTURE_2D, 0, format, GL_FLOAT, data);

	return data;
}

float * Texture::GetTexImage(GLenum format, const int lod) const
{
	glBindTexture(GL_TEXTURE_2D, texture);

	float* data;
	int channel = 0;
	// glGetTexImage�� �� �ȼ��� ���� internal four-component�� ������� 4���� value�� ��ȯ��

	switch (format)
	{
	case GL_R:
		channel = 1;
		break;
	case GL_RGB:
		channel = 3;
		break;
	case GL_RGBA:
		channel = 4;
		break;
	}
	data = new float[width * height * channel];

	glGetTexImage(GL_TEXTURE_2D, lod, format, GL_FLOAT, data);

	return data;
}

unsigned char* Texture::GetTexImage(const GLenum& format, const GLenum& type) const
{
	glBindTexture(GL_TEXTURE_2D, texture);

	unsigned char* data;

	// glGetTexImage�� �� �ȼ��� ���� internal four-component�� ������� 4���� value�� ��ȯ��
	if (format == GL_RGB)
		data = new unsigned char[width * height * 3];
	else
		data = new unsigned char[width * height * 4];

	glGetTexImage(GL_TEXTURE_2D, 0, format, type, data);

	return data;
}

//void Texture::Bind(GLenum texture)
//{
//	// ������ ��!
//	// ���ڷ� ���� �ؽ��Ĵ� shader�� ���� �ؽ��� GL_TEXTURE0 �� �̰�
//	// this->texture�� �ؽ��Ĵ� glBindTexture�� �� ����� ���̵��̴�
//	glActiveTexture(texture);
//	glBindTexture(GL_TEXTURE_2D, this->texture);
//}

void Texture::GenerateMipmap()
{
	glBindTexture(GL_TEXTURE_CUBE_MAP, this->texture);
	glGenerateMipmap(GL_TEXTURE_CUBE_MAP);
}
