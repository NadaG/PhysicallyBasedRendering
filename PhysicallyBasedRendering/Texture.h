#pragma once

#include <GL/glew.h>
#include <iostream>
#include <string>
#include <vector>

#include "stb_image.h"

using std::cout;
using std::endl;

using std::vector;
using std::string;

enum TextureType
{
	ALBEDO = 0,
	METALLIC = 1,
	NORMAL = 2,
	ROUGHNESS = 3,
	HEIGHT = 4,
	AO = 5
};

class Texture
{
public:
	Texture() {};
	Texture(char const* path);

	// rgba32f�� �� �ؽ��ĸ� �ҷ����� �Լ�
	void LoadFixedTexture(const string& s);
	void LoadTexture(const string& s);
	void LoadTextureDDS(const string& s);
	void LoadTexture(
		const GLint& internalformat,
		const GLsizei& width,
		const GLsizei& height,
		const GLenum& format,
		const GLenum& type);


	void UpdateTexture(const string& s);
	void UpdateTexture(float* data, GLenum format, GLenum type);

	// depth�� �޴� texture, ������ depth�� �����Ǿ� �ְ�, Ÿ���� float�̴�.
	void LoadDepthTexture(const float& width, const float& height);

	// delete�� ȣ���� �ʿ��� �ذ��ϵ��� ��
	float* GetTexImage(GLenum format) const;
	float* GetTexImage(GLenum format, const int lod) const;

	unsigned char* GetTexImage(const GLenum& format, const GLenum& type) const;

	const GLuint& GetTexture() const { return texture; }

	virtual void Bind(GLenum texture) = 0;
	
	void GenerateMipmap();

	const GLsizei GetWidth() const { return width; }
	const GLsizei GetHeight() const { return height; }
	
	const GLint GetInternalFormat() const { return internalformat; }

protected:
	GLuint texture;

	GLsizei width, height;
	GLint internalformat;
};