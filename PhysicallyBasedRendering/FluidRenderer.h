#pragma once

#include "Renderer.h"
#include "FluidSimulationImporter.h"

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
	// TODO 이것은 debug용 나중에 지울것임
	ShaderProgram* quadShader;
	ShaderProgram* particleSphereShader;
	ShaderProgram* depthBlurShader;

	Texture colorTex;
	Texture depthTex;
	Texture depthBlurTex[2];
	Texture depthBlurDepthTex[2];

	int depthWidth = 1024;
	int depthHeight = 1024;

	FrameBufferObject depthFBO;
	FrameBufferObject depthBlurFBO[2];

	VertexArrayObject vao;

	GLfloat* fluidVertices;
	FluidSimulationImporter importer;
};