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

#include "Texture2D.h"
#include "TextureCube.h"

using std::string;
using std::ifstream;
using std::cout;
using std::cin;
using std::endl;

class ShaderProgram
{
private:
	GLuint LoadShader(const char* shaderFilePath, int shaderType);

protected:
	ShaderProgram(){}

	// main에서 여러 개의 ShaderLoader 객체를 사용할 수 있도록 하기
	GLuint shaderProgramID;

	GLuint vertexShaderID;
	GLuint tessellationControlShaderID;
	GLuint tessellationEvaluationShaderID;
	GLuint geometryShaderID;
	GLuint fragmentShaderID;

	vector<Texture*> inputTextures;

	

public:

	ShaderProgram(const char* vertex_file_path, const char* fragment_file_path);
	ShaderProgram(const char* vertex_file_path, const char* geometry_file_path, const char* fragment_file_path);
	ShaderProgram(
		const char* vertex_file_path, 
		const char* tessellation_control_file_path, 
		const char* tessellation_evaluation_file_path, 
		const char* geometry_file_path, 
		const char* fragment_file_path);
	virtual ~ShaderProgram();

	GLuint GetShaderProgramID() { return shaderProgramID; }

	void LoadShaders(const char* vertex_file_path, const char* fragment_file_path);
	void LoadShaders(const char* vertex_file_path, const char* geometry_file_path, const char* fragment_file_path);
	void LoadShaders(
		const char* vertex_file_path,
		const char* tessellation_control_file_path,
		const char* tessellation_evaluation_file_path,
		const char* geometry_file_path,
		const char* fragment_file_path);
	
	void Use();

	void SetUniform1f(string name, float value);
	void SetUniform1i(string name, int value);

	void SetUniformMatrix4f(string name, glm::mat4 &mat);
	void SetUniformMatrix3f(string name, glm::mat3 &mat);

	void SetUniformVector4f(string name, glm::vec4 vec);
	void SetUniformVector4f(string name, float x, float y, float z, float w);

	void SetUniformVector3f(string name, glm::vec3 vec);
	void SetUniformVector3f(string name, float x, float y, float z);

	void SetUniformVector2f(string name, glm::vec2 vec);
	void SetUniformVector2f(string name, float x, float y);

	void SetUniformBool(string name, bool b);

	// TODO 텍스쳐를 어디다 두어야 할지 생각해봐야함
	void BindTexture(Texture* texture, string name);

	void Delete();
};