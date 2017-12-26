#pragma once

#include<assimp\Importer.hpp>
#include<assimp\scene.h>
#include<assimp\postprocess.h>
#include<assimp\material.h>
#include<glm\glm.hpp>
#include<string>
#include<cstdio>
#include<vector>

#include "VertexArrayObject.h"

using std::string;
using std::vector;

enum MeshType
{
	QUAD = 0,
	CUBE = 1
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

	glm::vec3 albedo;

	//GLuint vao, vbo, ibo;
	VertexArrayObject vao;

public:
	Mesh();
	virtual ~Mesh();

	void SetMesh(aiMesh* mesh);

	// file name을 통해 mesh를 생성
	void LoadMesh(const string& fileName);
	void LoadMesh(MeshType meshType);
	
	void GenerateAndSetVAO();
	void SetAllColor(const glm::vec3& color);

	void Draw();

	void Terminate();

	const glm::vec3& GetAlbedo() { return albedo; }

	const Vertex& GetVertice(int index) { return vertices[index]; }
	const int& GetVertexNum() { return vertexNum; }
	GLuint* GetIndices() { return indices; }
	const GLuint& GetIndexNum() { return indexNum; }
};