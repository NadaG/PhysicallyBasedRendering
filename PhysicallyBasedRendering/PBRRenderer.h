#pragma once

#include "Renderer.h"

class PBRRenderer : public Renderer
{
public:
	PBRRenderer() {};
	virtual ~PBRRenderer() {};

	void InitializeRender();
	void Render();
	void TerminateRender();

private:
	ShaderProgram* pbrShader;
	ShaderProgram* lightShader;

	Texture aoTex;
	Texture albedoTex;
	Texture heightTex;
	Texture metallicTex;
	Texture normalTex;
	Texture roughnessTex;
};