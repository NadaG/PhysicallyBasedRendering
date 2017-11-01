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
	void LoadDepthTexture(const float& width, const float& height);
	
	void SetParameters(const GLint& minFilter, const GLint& magFilter, const GLint& wrapS, const GLint& wrapT);
	const GLuint& GetTexture() const { return texture; }

	void Bind(GLenum texture);

private:
	GLuint texture;
};