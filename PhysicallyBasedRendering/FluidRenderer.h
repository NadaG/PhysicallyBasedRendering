#pragma once

#include "Renderer.h"

class FluidRenderer : public Renderer
{
public:
	FluidRenderer() {};
	virtual ~FluidRenderer() {};

	void InitializeRender(GLenum cap, glm::vec4 color);
	void Render();
	void TerminateRender();

private:
	ShaderProgram* depthShader;
	ShaderProgram* quadShader;
	ShaderProgram* particleSphereShader;

	RenderBufferObject depthRBO;
	Texture depthTex;
	int depthWidth = 1024;
	int depthHeight = 1024;

	FrameBufferObject depthFBO;

	GLuint vbo, vao;
	GLfloat* v;
};