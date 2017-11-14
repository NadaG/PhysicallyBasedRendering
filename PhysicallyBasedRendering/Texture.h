#pragma once

#include <GL/glew.h>
#include <iostream>

#include "stb_image.h"

using std::cout;
using std::endl;

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

	void LoadTexture(char const* path);
	void LoadTexture(const GLint& internalformat, const GLsizei& width, const GLsizei& height, const GLenum& format, const GLenum& type);
	void LoadTextureCubeMap(const GLint& internalformat, const GLsizei& width, const GLsizei& height, const GLenum& format, const GLenum& type);
	
	// depth�� �޴� texture, ������ depth�� �����Ǿ� �ְ�, Ÿ���� float�̴�.
	void LoadDepthTexture(const float& width, const float& height);
	
	// ����ϰ� void*�� �ұ�?
	// float �޸� �Ҵ��� �����ϴ� �ʿ��� ���־����
	void TexImage(float* a);

	void SetParameters(const GLint& minFilter, const GLint& magFilter, const GLint& wrapS, const GLint& wrapT);
	void SetParameters(const GLint& minFilter, const GLint& magFilter, const GLint& wrapS, const GLint& wrapT, const GLint& wrapR);

	const GLuint& GetTexture() const { return texture; }

	void Bind(GLenum texture);
	// TO refacto
	void BindCubemap(GLenum texture);

private:
	GLuint texture;

	GLsizei width, height;
	GLenum type, format;
};