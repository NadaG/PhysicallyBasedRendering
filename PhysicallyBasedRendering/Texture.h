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

	void LoadTexture(const string& s);
	void LoadTextureDDS(const string& s);
	void LoadTexture(const GLint& internalformat, const GLsizei& width, const GLsizei& height, const GLenum& format, const GLenum& type);

	void UpdateTexture(float* data);

	// depth를 받는 texture, 포맷이 depth로 고정되어 있고, 타입은 float이다.
	void LoadDepthTexture(const float& width, const float& height);

	// delete를 호출한 쪽에서 해결하도록 함
	float* TexImage();

	const GLuint& GetTexture() const { return texture; }

	virtual void Bind(GLenum texture) = 0;
	
	void GenerateMipmap();

	const GLsizei GetWidth() const { return width; }
	const GLsizei GetHeight() const { return height; }
	const GLenum GetType() const { return type; }
	const GLenum GetFormat() const { return format; }

protected:
	GLuint texture;

	GLsizei width, height;
	GLenum type, format;
	GLint internalformat;
};