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
	// aiprocess_triangulate�� triangle ���°� �ƴ� model load �� �� triangle�� �ҷ����̴� ��
	// flipuvs�� y���� flip�ϴ� ��
	// scene�� mMeshes���� ��� mesh���� ����Ǿ� �ִ�
	// scene�� mRootNode�� ������ �ְ� �� ��忡�� mesh�� �ִ�
	Assimp::Importer importer;
	const aiScene *scene = importer.ReadFile(fileName, aiProcess_Triangulate | aiProcess_FlipUVs);
	if (!scene || scene->mFlags & AI_SCENE_FLAGS_INCOMPLETE || !scene->mRootNode)
	{
		printf("�� ������ �ҷ��� �� �����ϴ�. \n");
		getchar();
	}
	else
	{
		// vertex num, index num ���� ���ϱ�
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
			// vertices�� positions�� �ƴ϶�� ���� ������ ��
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

		// ���� ��
		vertices[0].position = glm::vec3(-1.0f, 1.0f, 0.0f);
		vertices[0].uv = glm::vec2(0.0f, 1.0f);

		// ���� �Ʒ�
		vertices[1].position = glm::vec3(-1.0f, -1.0f, 0.0f);
		vertices[1].uv = glm::vec2(0.0f, 0.0f);

		// ������ ��
		vertices[2].position = glm::vec3(1.0f, 1.0f, 0.0f);
		vertices[2].uv = glm::vec2(1.0f, 1.0f);

		// ������ �Ʒ�
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
	// ������ ���ڸ� 0���� �����ν� �ܼ��� ���� bind�� vao�� bind�� index buffer���
	glBindVertexArray(vao);
	glDrawElements(GL_TRIANGLES, indexNum, GL_UNSIGNED_INT, 0);
}

void Mesh::Terminate()
{
	delete vertices;
	delete indices;
}