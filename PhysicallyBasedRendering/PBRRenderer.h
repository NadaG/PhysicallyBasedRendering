#pragma once

#include "Renderer.h"

class PBRRenderer : public Renderer
{
public:
	PBRRenderer() {};
	virtual ~PBRRenderer() {};

	void InitializeRender(GLenum cap, glm::vec4 color);
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