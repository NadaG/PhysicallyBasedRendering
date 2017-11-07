#pragma once

#include<GL\glew.h>
#include<GL\glfw3.h>
#include<cstdio>
#include<glm/glm.hpp>
#include<vector>

#include "SceneManager.h"
#include "WindowManager.h"
#include "ShaderProgram.h"

#include "FrameBufferObject.h"

#include "Debug.h"

using std::vector;

class Renderer
{
public:
	Renderer(SceneManager* sceneManager) 
	{
		this->sceneManager = sceneManager;
	}
	virtual ~Renderer() {};

	void Initialize(GLFWwindow* window);
	
	virtual void InitializeRender() = 0;
	virtual void Render() = 0;
	virtual void TerminateRender() = 0;

protected:
	void UseDefaultFrameBufferObject();
	void RenderObjects(ShaderProgram* shader, vector<SceneObject> objs);

	glm::vec4 backgroundColor;
	GLFWwindow* window;

	SceneManager* sceneManager;
};