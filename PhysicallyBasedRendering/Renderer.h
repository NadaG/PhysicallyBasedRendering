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

using std::vector;

class Renderer
{
public:
	Renderer() {};
	virtual ~Renderer() {};

	void Initialize(GLFWwindow* window);
	
	virtual void InitializeRender(GLenum cap, glm::vec4 color) = 0;
	virtual void Render() = 0;
	virtual void TerminateRender() = 0;

protected:
	void UseDefaultFrameBufferObject();

	glm::vec4 backgroundColor;
	GLFWwindow* window;

private:
	ShaderProgram* basicShader;
	ShaderProgram* pbrShader;
	ShaderProgram* depthShader;
	ShaderProgram* quadShader;
	ShaderProgram* particleSphereShader;

	RenderBufferObject depthRBO;
	Texture depthTex;
	int depthWidth = 1024;
	int depthHeight = 1024;

	Texture aoTex;
	Texture albedoTex;
	Texture heightTex;
	Texture metallicTex;
	Texture normalTex;
	Texture roughnessTex;

	FrameBufferObject depthFBO;
};