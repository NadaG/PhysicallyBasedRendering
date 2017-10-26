#include "Mesh.h"

Mesh::Mesh()
{
}

Mesh::~Mesh()
{
}

void Mesh::LoadMesh(const string& fileName)
{
	float scale = 3.0f;
	// aiprocess_triangulate는 triangle 형태가 아닌 model load 할 때 triangle로 불러들이는 것
	// flipuvs는 y값은 flip하는 것
	// scene의 mMeshes에는 모든 mesh들이 저장되어 있다
	// scene은 mRootNode를 가지고 있고 각 노드에는 mesh가 있다
	Assimp::Importer importer;
	const aiScene *scene = importer.ReadFile(fileName, aiProcess_Triangulate | aiProcess_FlipUVs);
	if (!scene || scene->mFlags & AI_SCENE_FLAGS_INCOMPLETE || !scene->mRootNode)
	{
		printf("모델 파일을 불러올 수 없습니다. \n");
		getchar();
	}
	else
	{
		// vertex num, index num 총합 구하기
		int tmpVertexNum = 0, tmpIndexNum = 0;
		for (int i = 0; i < scene->mNumMeshes; i++)
		{
			tmpVertexNum += scene->mMeshes[i]->mNumVertices;
			tmpIndexNum += scene->mMeshes[i]->mNumFaces * 3;
		}
		vertexNum = tmpVertexNum;
		indexNum = tmpIndexNum;

		vertices = new Vertex[vertexNum];
		indices = new GLuint[indexNum];

		int offset = 0;
		for (int i = 0; i < scene->mNumMeshes; i++)
		{
			// vertices지 positions가 아니라는 것을 주의할 것
			for (int j = 0; j < scene->mMeshes[i]->mNumVertices; j++)
			{
				vertices[j + offset].position.x = scene->mMeshes[i]->mVertices[j].x;
				vertices[j + offset].position.y = scene->mMeshes[i]->mVertices[j].y;
				vertices[j + offset].position.z = scene->mMeshes[i]->mVertices[j].z;

				if (scene->mMeshes[i]->HasNormals())
				{
					vertices[j + offset].normal.x = scene->mMeshes[i]->mNormals[j].x;
					vertices[j + offset].normal.y = scene->mMeshes[i]->mNormals[j].y;
					vertices[j + offset].normal.z = scene->mMeshes[i]->mNormals[j].z;
				}

				if (scene->mMeshes[i]->HasTextureCoords(0))
				{
					vertices[j + offset].uv.x = scene->mMeshes[i]->mTextureCoords[0][j].x;
					vertices[j + offset].uv.y = scene->mMeshes[i]->mTextureCoords[0][j].y;
				}
			}
			offset += scene->mMeshes[i]->mNumVertices;
		}

		int indexOffset = 0;
		offset = 0;
		for (int i = 0; i < scene->mNumMeshes; i++)
		{
			for (int j = 0; j < scene->mMeshes[i]->mNumFaces; j++)
			{
				indices[j * 3 + offset] = indexOffset + scene->mMeshes[i]->mFaces[j].mIndices[0];
				indices[j * 3 + offset + 1] = indexOffset + scene->mMeshes[i]->mFaces[j].mIndices[1];
				indices[j * 3 + offset + 2] = indexOffset + scene->mMeshes[i]->mFaces[j].mIndices[2];
			}
			offset += scene->mMeshes[i]->mNumFaces * 3;
			indexOffset += scene->mMeshes[i]->mNumVertices;
		}
	}
}

void Mesh::LoadMesh(MeshType meshType)
{
	switch (meshType)
	{
	case QUAD:
	{
		vertexNum = 4;
		indexNum = 6;
		vertices = new Vertex[vertexNum];
		indices = new GLuint[indexNum];

		// 왼쪽 위
		vertices[0].position = glm::vec3(-1.0f, 1.0f, 0.0f);
		vertices[0].uv = glm::vec2(0.0f, 1.0f);

		// 왼쪽 아래
		vertices[1].position = glm::vec3(-1.0f, -1.0f, 0.0f);
		vertices[1].uv = glm::vec2(0.0f, 0.0f);

		// 오른쪽 위
		vertices[2].position = glm::vec3(1.0f, 1.0f, 0.0f);
		vertices[2].uv = glm::vec2(1.0f, 1.0f);

		// 오른쪽 아래
		vertices[3].position = glm::vec3(1.0f, -1.0f, 0.0f);
		vertices[3].uv = glm::vec2(1.0f, 0.0f);

		indices[0] = 0;
		indices[1] = 2;
		indices[2] = 3;
		indices[3] = 1;
		indices[4] = 0;
		indices[5] = 3;

		break;
	}
	default:
		break;
	}
}

void Mesh::GenerateAndSetVAO()
{
	glGenVertexArrays(1, &vao);
	glGenBuffers(1, &vbo);
	glGenBuffers(1, &ibo);

	glBindVertexArray(vao);
	glBindBuffer(GL_ARRAY_BUFFER, vbo);
	glBufferData(GL_ARRAY_BUFFER, sizeof(Vertex) * vertexNum, vertices, GL_STATIC_DRAW);

	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ibo);
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(GLuint) * indexNum, indices, GL_STATIC_DRAW);

	// position
	glEnableVertexAttribArray(0);
	glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 14, (void*)0);

	// normal
	glEnableVertexAttribArray(1);
	glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 14, (void*)(3 * sizeof(GLfloat)));

	// coordinate
	glEnableVertexAttribArray(2);
	glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 14, (void*)(6 * sizeof(GLfloat)));

	// color
	glEnableVertexAttribArray(3);
	glVertexAttribPointer(3, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 14, (void*)(8 * sizeof(GLfloat)));

	// tangent
	glEnableVertexAttribArray(4);
	glVertexAttribPointer(4, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 14, (void*)(11 * sizeof(GLfloat)));
}

void Mesh::Draw()
{
	// 마지막 인자를 0으로 함으로써 단순히 현재 bind된 vao에 bind된 index buffer대로
	glBindVertexArray(vao);
	glDrawElements(GL_TRIANGLES, indexNum, GL_UNSIGNED_INT, 0);
}

void Mesh::Terminate()
{
	delete vertices;
	delete indices;
}