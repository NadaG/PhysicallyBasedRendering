#include "ShaderProgram.h"

ShaderProgram::ShaderProgram(const char * vertex_file_path, const char * fragment_file_path)
{
	shaderProgramID = glCreateProgram();
	LoadShaders(vertex_file_path, fragment_file_path);
}

ShaderProgram::~ShaderProgram()
{
	glDetachShader(shaderProgramID, vertexShaderID);
	glDetachShader(shaderProgramID, fragmentShaderID);

	glDeleteShader(vertexShaderID);
	glDeleteShader(fragmentShaderID);
}

void ShaderProgram::LoadShaders(const char * vertex_file_path, const char * fragment_file_path)
{
	vertexShaderID = LoadShader(vertex_file_path, GL_VERTEX_SHADER);
	fragmentShaderID = LoadShader(fragment_file_path, GL_FRAGMENT_SHADER);
}

GLuint ShaderProgram::LoadShader(const char* shaderFilePath, int shaderType)
{
	// 쉐이더 생성
	GLuint shaderID = glCreateShader(shaderType);

	// 쉐이더 코드를 파일에서 읽기
	std::string shaderCode;
	std::ifstream shaderStream(shaderFilePath, std::ios::in);
	if (shaderStream.is_open())
	{
		std::string Line = "";
		while (getline(shaderStream, Line))
			shaderCode += "\n" + Line;
		shaderStream.close();
	}
	else
	{
		printf("파일 %s 를 읽을 수 없음. 정확한 디렉토리를 사용 중입니까 ? FAQ 를 우선 읽어보는 걸 잊지 마세요!\n", shaderFilePath);
		getchar();
		return -1;
	}

	GLint Result = GL_FALSE;
	int InfoLogLength;

	// 쉐이더를 컴파일
	printf("Compiling shader : %s\n", shaderFilePath);
	char const * sourcePointer = shaderCode.c_str();
	glShaderSource(shaderID, 1, &sourcePointer, NULL);
	glCompileShader(shaderID);

	// 쉐이더를 검사
	glGetShaderiv(shaderID, GL_COMPILE_STATUS, &Result);
	glGetShaderiv(shaderID, GL_INFO_LOG_LENGTH, &InfoLogLength);
	if (InfoLogLength > 0)
	{
		std::vector<char> shaderErrorMessage(InfoLogLength + 1);
		glGetShaderInfoLog(shaderID, InfoLogLength, NULL, &shaderErrorMessage[0]);
		printf("%s\n", &shaderErrorMessage[0]);
	}

	// 프로그램에 링크
	printf("Linking program\n");

	glAttachShader(shaderProgramID, shaderID);
	glLinkProgram(shaderProgramID);

	// 프로그램 검사
	glGetProgramiv(shaderProgramID, GL_LINK_STATUS, &Result);
	glGetProgramiv(shaderProgramID, GL_INFO_LOG_LENGTH, &InfoLogLength);
	if (InfoLogLength > 0)
	{
		std::vector<char> ProgramErrorMessage(InfoLogLength + 1);
		glGetProgramInfoLog(shaderProgramID, InfoLogLength, NULL, &ProgramErrorMessage[0]);
		printf("%s\n", &ProgramErrorMessage[0]);
	}

	return shaderID;
}

void ShaderProgram::Use()
{
	glUseProgram(shaderProgramID);
}

void ShaderProgram::SetUniform1f(string name, float value)
{
	glUniform1f(glGetUniformLocation(shaderProgramID, name.c_str()), value);
}

void ShaderProgram::SetUniform1i(string name, int value)
{
	glUniform1i(glGetUniformLocation(shaderProgramID, name.c_str()), value);
}

void ShaderProgram::SetUniformMatrix4f(string name, glm::mat4 &mat)
{
	glUniformMatrix4fv(glGetUniformLocation(shaderProgramID, name.c_str()), 1, GL_FALSE, &mat[0][0]);
}

void ShaderProgram::SetUniformVector4f(string name, glm::vec4 vec)
{
	glUniform4f(glGetUniformLocation(shaderProgramID, name.c_str()), vec.x, vec.y, vec.z, vec.w);
}

void ShaderProgram::SetUniformVector4f(string name, float x, float y, float z, float w)
{
	glUniform4f(glGetUniformLocation(shaderProgramID, name.c_str()), x, y, z, w);
}

void ShaderProgram::SetUniformVector3f(string name, glm::vec3 vec)
{
	glUniform3f(glGetUniformLocation(shaderProgramID, name.c_str()), vec.x, vec.y, vec.z);
}

void ShaderProgram::SetUniformVector3f(string name, float x, float y, float z)
{
	glUniform3f(glGetUniformLocation(shaderProgramID, name.c_str()), x, y, z);
}

void ShaderProgram::SetUniformVector2f(string name, glm::vec2 vec)
{
	glUniform2f(glGetUniformLocation(shaderProgramID, name.c_str()), vec.x, vec.y);
}

void ShaderProgram::SetUniformVector2f(string name, float x, float y)
{
	glUniform2f(glGetUniformLocation(shaderProgramID, name.c_str()), x, y);
}

void ShaderProgram::SetUniformBool(string name, bool b)
{
	if (b)
		glUniform1i(glGetUniformLocation(shaderProgramID, name.c_str()), 1);
	else
		glUniform1i(glGetUniformLocation(shaderProgramID, name.c_str()), 0);
}

void ShaderProgram::Delete()
{
	glDeleteShader(shaderProgramID);
}