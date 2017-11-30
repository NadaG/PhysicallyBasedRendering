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
		debugQuadShader = new ShaderProgram("Quad.vs", "Quad.fs");
	}
	virtual ~Renderer() { debugQuadShader->Delete(); delete debugQuadShader; };

	void Initialize(GLFWwindow* window);
	
	virtual void InitializeRender() = 0;
	virtual void Render() = 0;
	virtual void TerminateRender() = 0;

protected:
	void UseDefaultFrameBufferObject();
	void RenderObjects(ShaderProgram* shader, vector<SceneObject> objs);
	void RenderObject(ShaderProgram* shader, SceneObject obj);

	glm::vec4 backgroundColor;
	GLFWwindow* window;

	SceneManager* sceneManager;

	ShaderProgram* debugQuadShader;
};