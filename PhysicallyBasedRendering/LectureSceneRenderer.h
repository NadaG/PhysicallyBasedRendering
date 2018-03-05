#pragma once

#include "Renderer.h"
#include "LectureSceneManager.h"

class LectureSceneRenderer : public Renderer
{
public:
	LectureSceneRenderer(SceneManager* sceneManager)
		:Renderer(sceneManager)
	{}
	virtual ~LectureSceneRenderer() {};

	void InitializeRender();
	void Render();
	void TerminateRender();

private:

};