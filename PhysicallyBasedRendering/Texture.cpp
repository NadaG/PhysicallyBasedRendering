#include "Texture.h"

Texture::Texture(char const * path)
{
	LoadTexture(path);
}

void Texture::LoadTexture(const GLint& internalformat, const GLsizei& width, const GLsizei& height, const GLenum& format, const GLenum& type)
{
	glGenTextures(1, &texture);
	Bind(this->texture); 
	glTexImage2D(GL_TEXTURE_2D, 0, internalformat, width, height, 0, format, type, 0);
}

void Texture::LoadTextureCubeMap(const GLint& internalformat, const GLsizei& width, const GLsizei& height, const GLenum& format, const GLenum& type)
{
	glGenTextures(1, &texture);
	Bind(this->texture);
	for (int i = 0; i < 6; i++)
	{
		glTexImage2D(
			GL_TEXTURE_CUBE_MAP_POSITIVE_X + i,
			0,
			internalformat,
			width,
			height,
			0,
			format,
			type,
			nullptr);
	}
}

void Texture::LoadTexture(char const * path)
{
	glGenTextures(1, &texture);
	glBindTexture(GL_TEXTURE_2D, texture);

	int width, height, nrComponents;
	unsigned char* data = stbi_load(path, &width, &height, &nrComponents, 0);

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

		stbi_image_free(data);
	}
	else
	{
		cout << "Texture failed to load at path: " << path << endl;
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

void Texture::SetParameters(const GLint& minFilter, const GLint& magFilter, const GLint& wrapS, const GLint& wrapT)
{
	glBindTexture(GL_TEXTURE_2D, texture);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, minFilter);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, magFilter);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, wrapS);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, wrapT);
}

void Texture::SetParameters(const GLint & minFilter, const GLint & magFilter, const GLint & wrapS, const GLint & wrapT, const GLint & wrapR)
{
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, minFilter);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, magFilter);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, wrapS);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, wrapT);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_R, wrapR);
}

void Texture::Bind(GLenum texture)
{
	glActiveTexture(texture);
	glBindTexture(GL_TEXTURE_2D, this->texture);
}

void Texture::BindCubemap(GLenum texture)
{
	glActiveTexture(texture);
	glBindTexture(GL_TEXTURE_CUBE_MAP, texture);
}