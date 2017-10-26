#pragma once
#include <GL\glew.h>
#include <GL\freeglut.h>
#include <glm\glm.hpp>
#include <glm\gtc\matrix_transform.hpp>
#include <GL\glfw3.h>
#include <vector>
#include <string>
#include <fstream>
#include <iostream>

#include "Texture.h"

using std::string;
using std::ifstream;
using std::cout;
using std::cin;
using std::endl;

class ShaderProgram
{
private:
	// main에서 여러 개의 ShaderLoader 객체를 사용할 수 있도록 하기
	GLuint shaderProgramID;

	GLuint vertexShaderID;
	GLuint fragmentShaderID;

	Texture* albedo;
	Texture* metallic;
	Texture* normal;
	Texture* roughness;
	Texture* height;
	Texture* ao;

private:
	ShaderProgram();
	GLuint LoadShader(const char* shaderFilePath, int shaderType);

public:

	ShaderProgram(const char * vertex_file_path, const char * fragment_file_path);
	virtual ~ShaderProgram();

	GLuint GetShaderProgramID() { return shaderProgramID; }

	void LoadShaders(const char * vertex_file_path, const char * fragment_file_path);
	
	void Use();

	void SetUniform1f(string name, float value);
	void SetUniform1i(string name, int value);
	void SetUniformMatrix4f(string name, glm::mat4 mat);
	void SetUniformVector3f(string name, glm::vec3 vec);
	void SetUniformVector3f(string name, float x, float y, float z);

	// TODO 텍스쳐를 어디다 두어야 할지 생각해봐야함

	void Delete();
};