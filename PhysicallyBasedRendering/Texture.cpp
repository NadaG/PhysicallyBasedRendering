#include "Texture.h"
#include "dds.h"

Texture::Texture(char const * path)
{
	LoadTexture(path);
}

// internal format은 gpu에서 사용될 포맷을 말하고
// format은 client에서 사용되는 포맷을 말한다
// 따라서 데이터의 크기는 format과 type에 의해서 결정된다.(물론 width와 height도 결정)
void Texture::LoadTexture(const GLint& internalformat, const GLsizei& width, const GLsizei& height, const GLenum& format, const GLenum& type)
{
	glGenTextures(1, &texture);
	Bind(this->texture);
	glTexImage2D(GL_TEXTURE_2D, 0, internalformat, width, height, 0, format, type, 0);
	this->format = format;
	this->type = type;
	this->width = width;
	this->height = height;
}



void Texture::LoadTexture(const string& s)
{
	glGenTextures(1, &texture);
	glBindTexture(GL_TEXTURE_2D, texture);

	int width, height, nrComponents;
	unsigned char* data = stbi_load(s.c_str(), &width, &height, &nrComponents, 0);

	if (data)
	{
		GLenum format;
		if (nrComponents == 1)
			format = GL_RED;
		else if (nrComponents == 3)
			format = GL_RGB;
		else if (nrComponents == 4)
			format = GL_RGBA;

		// 보통 이미지의 경우 unsigned byte로 저장하고
		glTexImage2D(GL_TEXTURE_2D, 0, format, width, height, 0, format, GL_UNSIGNED_BYTE, data);
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

		// 보통 이미지의 경우 unsigned byte로 저장하고
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
	// depth texture의 경우 float으로 저장한다는 것을 주의!
	glTexImage2D(GL_TEXTURE_2D, 0, GL_DEPTH_COMPONENT, width, height, 0, GL_DEPTH_COMPONENT, GL_FLOAT, NULL);
}

void Texture::TexImage(float* a)
{
	glGetTexImage(GL_TEXTURE_2D, 0, format, type, a);
}

//void Texture::Bind(GLenum texture)
//{
//	// 주의할 것!
//	// 인자로 들어온 텍스쳐는 shader에 보낼 텍스쳐 GL_TEXTURE0 등 이고
//	// this->texture의 텍스쳐는 glBindTexture할 때 사용할 아이디이다
//	glActiveTexture(texture);
//	glBindTexture(GL_TEXTURE_2D, this->texture);
//}

void Texture::GenerateMipmap()
{
	glBindTexture(GL_TEXTURE_CUBE_MAP, this->texture);
	glGenerateMipmap(GL_TEXTURE_CUBE_MAP);
}
