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

	void LoadTexture(char const* path);
	void LoadTexture(const GLint& internalformat, const GLsizei& width, const GLsizei& height, const GLenum& format, const GLenum& type);
	
	void LoadTextureCubeMap(const GLint& internalformat, const GLsizei& width, const GLsizei& height, const GLenum& format, const GLenum& type);
	void LoadTextureCubeMap(vector<string> faces, const GLint& internalformat, const GLenum& format, const GLenum& type);

	// depth를 받는 texture, 포맷이 depth로 고정되어 있고, 타입은 float이다.
	void LoadDepthTexture(const float& width, const float& height);
	
	// 깔끔하게 void*로 할까?
	// float 메모리 할당은 생성하는 쪽에서 해주어야함
	void TexImage(float* a);

	void SetParameters(const GLint& minFilter, const GLint& magFilter, const GLint& wrapS, const GLint& wrapT);
	void SetParameters(const GLint& minFilter, const GLint& magFilter, const GLint& wrapS, const GLint& wrapT, const GLint& wrapR);

	const GLuint& GetTexture() const { return texture; }

	virtual void Bind(GLenum texture) = 0;
	
	void GenerateMipmap();

protected:
	GLuint texture;

	GLsizei width, height;
	GLenum type, format;
};