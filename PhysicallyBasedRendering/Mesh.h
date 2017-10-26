#pragma once

#include<assimp\Importer.hpp>
#include<assimp\scene.h>
#include<assimp\postprocess.h>
#include<glm\glm.hpp>
#include<GL/glew.h>
#include<string>
#include<cstdio>
#include<vector>

#include "Debug.h"

using std::string;
using std::vector;

enum MeshType
{
	QUAD = 0
};

struct Vertex
{
	glm::vec3 position;
	glm::vec3 normal;
	glm::vec2 uv;
	glm::vec3 color;
	glm::vec3 tangent;
};

class Mesh
{
private:
	// each face information
	Vertex* vertices;
	GLuint* indices;
	int vertexNum;
	int indexNum;

	// Question color 정보는 보통 어디에? material information
	glm::vec3 ambientColor;
	glm::vec3 diffuseColor;
	glm::vec3 specularColor;

	GLuint vao, vbo, ibo;

public:
	Mesh();
	virtual ~Mesh();

	// file name을 통해 mesh를 생성
	void LoadMesh(const string& fileName);
	void LoadMesh(MeshType meshType);
	
	void GenerateAndSetVAO();
	
	void Draw();

	void Terminate();

	const glm::vec3& GetAmbient() { return ambientColor; }
	const glm::vec3& GetDiffuse() { return diffuseColor; }
	const glm::vec3& GetSpecular() { return specularColor; }
	
	const Vertex& GetVertice(int index) { return vertices[index]; }
	const int& GetVertexNum() { return vertexNum; }
	GLuint* GetIndices() { return indices; }
	const GLuint& GetIndexNum() { return indexNum; }
};