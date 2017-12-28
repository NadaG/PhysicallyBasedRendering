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
		equirectangularToCubemapShader = new ShaderProgram("Cubemap.vs", "equirectangularToCubemap.fs");

		captureFBO.GenFrameBufferObject();
		captureFBO.BindDefaultDepthBuffer(2048, 2048);

		// 큐브의 한 면을 바라 볼 수 있도록 perpective matrix setting
		captureProjection = glm::perspective(glm::radians(90.0f), 1.0f, 0.1f, 10.0f);
		// 상하좌우앞뒤
		captureViews[0] = glm::lookAt(glm::vec3(0.0f), glm::vec3(1.0f, 0.0f, 0.0f), glm::vec3(0.0f, 1.0f, 0.0f));
		captureViews[1] = glm::lookAt(glm::vec3(0.0f), glm::vec3(-1.0f, 0.0f, 0.0f), glm::vec3(0.0f, 1.0f, 0.0f));
		captureViews[2] = glm::lookAt(glm::vec3(0.0f), glm::vec3(0.0f, 1.0f, 0.0f), glm::vec3(0.0f, 0.0f, 1.0f));
		captureViews[3] = glm::lookAt(glm::vec3(0.0f), glm::vec3(0.0f, -1.0f, 0.0f), glm::vec3(0.0f, 0.0f, -1.0f));
		captureViews[4] = glm::lookAt(glm::vec3(0.0f), glm::vec3(0.0f, 0.0f, -1.0f), glm::vec3(0.0f, 1.0f, 0.0f));
		captureViews[5] = glm::lookAt(glm::vec3(0.0f), glm::vec3(0.0f, 0.0f, 1.0f), glm::vec3(0.0f, 1.0f, 0.0f));
	}
	virtual ~Renderer() 
	{ 
		debugQuadShader->Delete(); delete debugQuadShader;
		equirectangularToCubemapShader->Delete(); delete equirectangularToCubemapShader;
	};

	void Initialize(GLFWwindow* window);
	
	virtual void InitializeRender() = 0;
	virtual void Render() = 0;
	virtual void TerminateRender() = 0;

protected:
	void UseDefaultFrameBufferObject();
	void RenderObjects(ShaderProgram* shader, vector<SceneObject> objs);
	void RenderObject(ShaderProgram* shader, SceneObject obj);
	
	void GenCubemapFromEquirectangular(TextureCube* texCube, Texture2D tex);

	glm::vec4 backgroundColor;
	GLFWwindow* window;

	SceneManager* sceneManager;

	ShaderProgram* debugQuadShader;

private:

	ShaderProgram* equirectangularToCubemapShader;
	FrameBufferObject captureFBO;

	glm::mat4 captureProjection;
	glm::mat4 captureViews[6];
};