#include "Texture.h"
#include "dds.h"

#include "Debug.h"

Texture::Texture(char const * path)
{
	LoadFixedTexture(path);
}

// internal format은 gpu 내부에서 사용될 포맷을 말하고
// format은 client에서 사용되는 포맷을 말한다, 즉 데이터가 어떤 형태로 들어왔냐는 format이다.
// 퍼포먼스를 해칠 수 있기 때문에 이 두개를 compatible하도록 만드는 것이 중요하단다. 
// 따라서 데이터의 크기는 format과 type에 의해서 결정된다.(물론 width와 height도 결정)
// format은 RGB냐 RGBA냐 등을 말하고, type은 unsigned byte냐 int냐 float이냐를 말한다.
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
		// input할 데이터의 format, 혹은 output할 데이터의 format
		// input할 데이터의 type은 GL_UNSIGNED_BYTE임
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
		
		// 보통 이미지의 경우 unsigned byte로 저장하고
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
		// input할 데이터의 format, 혹은 output할 데이터의 format
		// input할 데이터의 type은 GL_UNSIGNED_BYTE임
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

		// tgba32f 타입의 변수로 텍스쳐 메모리에 저장
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
	// depth texture의 경우 float으로 저장한다는 것을 주의!
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
	// glGetTexImage는 한 픽셀에 대해 internal four-component에 상관없이 4개의 value를 반환함

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
	// glGetTexImage는 한 픽셀에 대해 internal four-component에 상관없이 4개의 value를 반환함

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

	// glGetTexImage는 한 픽셀에 대해 internal four-component에 상관없이 4개의 value를 반환함
	if (format == GL_RGB)
		data = new unsigned char[width * height * 3];
	else
		data = new unsigned char[width * height * 4];

	glGetTexImage(GL_TEXTURE_2D, 0, format, type, data);

	return data;
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
