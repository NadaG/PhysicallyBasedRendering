#pragma once

#include "Texture2D.h"
#include "TextureCube.h"

#include "ShaderProgram.h"

enum MaterialTexture
{
	ALBEDO_TEX = 0,
	DIFFUSE_TEX = 1
};

class Material
{
public:
	Material();
	virtual ~Material();

	void BindShader(ShaderProgram* const shader);

private:

	ShaderProgram* shader;
};