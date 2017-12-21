#pragma once

#include "Renderer.h"
#include "SmokeSceneManager.h"
#include "SmokeSimulationImporter.h"

class VolumeRenderer : public Renderer
{
public:
	VolumeRenderer(SceneManager* sceneManager)
		:Renderer(sceneManager)
	{}
	virtual ~VolumeRenderer() {};

	void InitializeRender();
	void Render();
	void TerminateRender();

	void DrawSmoke();

private:

	ShaderProgram* pointShader;

	VertexArrayObject smokeVAO;
	GLfloat* vertices;

	const int pointNum = 5;
};