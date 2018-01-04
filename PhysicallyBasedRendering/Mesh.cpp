#include "Mesh.h"

Mesh::Mesh()
{
}

Mesh::~Mesh()
{
}

void Mesh::SetMesh(aiMesh* mesh)
{
	vertexNum = mesh->mNumVertices;
	indexNum = mesh->mNumFaces * 3;

	vertices = new Vertex[mesh->mNumVertices];
	indices = new GLuint[indexNum];

	// vertices�� positions�� �ƴ϶�� ���� ������ ��
	for (int i = 0; i < mesh->mNumVertices; i++)
	{
		vertices[i].position.x = mesh->mVertices[i].x;
		vertices[i].position.y = mesh->mVertices[i].y;
		vertices[i].position.z = mesh->mVertices[i].z;

		if (mesh->HasNormals())
		{
			vertices[i].normal.x = mesh->mNormals[i].x;
			vertices[i].normal.y = mesh->mNormals[i].y;
			vertices[i].normal.z = mesh->mNormals[i].z;
		}

		if (mesh->HasTextureCoords(0))
		{
			vertices[i].uv.x = mesh->mTextureCoords[0][i].x;
			vertices[i].uv.y = mesh->mTextureCoords[0][i].y;
		}
	}

	for (int i = 0; i < mesh->mNumFaces; i++)
	{
		indices[i * 3 + 0] = mesh->mFaces[i].mIndices[0];
		indices[i * 3 + 1] = mesh->mFaces[i].mIndices[1];
		indices[i * 3 + 2] = mesh->mFaces[i].mIndices[2];
	}
}

// ka ambient
// kd diffuse
// ks specular
// Ns specular exponent specular�� ���������� ��
// tf transmission ���� 0, 1, 0�� ��� G�� ���� ��� �����ϰ� �������� �ݻ�ȴ�.
// d dissolve 1.0�� ��� �������� ��, 0.0�� ��� ������ ��
// Ni index of refraction, optical density��� �Ҹ� ���� Ŭ ���� �������� ���� ��
// illum 4, color on, ambient on, highlight on, reflection on, transparency on ����� ����
// map_Kd(�̹��� ����) ���� ���� Kd�� ���� �������� �ϴ���

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
	case CUBE:
	{
		vertexNum = 36;
		indexNum = 36;

		vertices = new Vertex[vertexNum];
		indices = new GLuint[indexNum];

		float tmpVertices[] = {
			// position          // normal            // uv
			// back face
			-1.0f, -1.0f, -1.0f,  0.0f,  0.0f, -1.0f, 0.0f, 0.0f, // bottom-left
			1.0f,  1.0f, -1.0f,  0.0f,  0.0f, -1.0f, 1.0f, 1.0f, // top-right
			1.0f, -1.0f, -1.0f,  0.0f,  0.0f, -1.0f, 1.0f, 0.0f, // bottom-right         
			1.0f,  1.0f, -1.0f,  0.0f,  0.0f, -1.0f, 1.0f, 1.0f, // top-right
			-1.0f, -1.0f, -1.0f,  0.0f,  0.0f, -1.0f, 0.0f, 0.0f, // bottom-left
			-1.0f,  1.0f, -1.0f,  0.0f,  0.0f, -1.0f, 0.0f, 1.0f, // top-left
			// front face
			-1.0f, -1.0f,  1.0f,  0.0f,  0.0f,  1.0f, 0.0f, 0.0f, // bottom-left
			1.0f, -1.0f,  1.0f,  0.0f,  0.0f,  1.0f, 1.0f, 0.0f, // bottom-right
			1.0f,  1.0f,  1.0f,  0.0f,  0.0f,  1.0f, 1.0f, 1.0f, // top-right
			1.0f,  1.0f,  1.0f,  0.0f,  0.0f,  1.0f, 1.0f, 1.0f, // top-right
			-1.0f,  1.0f,  1.0f,  0.0f,  0.0f,  1.0f, 0.0f, 1.0f, // top-left
			-1.0f, -1.0f,  1.0f,  0.0f,  0.0f,  1.0f, 0.0f, 0.0f, // bottom-left
			// left face
			-1.0f,  1.0f,  1.0f, -1.0f,  0.0f,  0.0f, 1.0f, 0.0f, // top-right
			-1.0f,  1.0f, -1.0f, -1.0f,  0.0f,  0.0f, 1.0f, 1.0f, // top-left
			-1.0f, -1.0f, -1.0f, -1.0f,  0.0f,  0.0f, 0.0f, 1.0f, // bottom-left
			-1.0f, -1.0f, -1.0f, -1.0f,  0.0f,  0.0f, 0.0f, 1.0f, // bottom-left
			-1.0f, -1.0f,  1.0f, -1.0f,  0.0f,  0.0f, 0.0f, 0.0f, // bottom-right
			-1.0f,  1.0f,  1.0f, -1.0f,  0.0f,  0.0f, 1.0f, 0.0f, // top-right
			// right face
			1.0f,  1.0f,  1.0f,  1.0f,  0.0f,  0.0f, 1.0f, 0.0f, // top-left
			1.0f, -1.0f, -1.0f,  1.0f,  0.0f,  0.0f, 0.0f, 1.0f, // bottom-right
			1.0f,  1.0f, -1.0f,  1.0f,  0.0f,  0.0f, 1.0f, 1.0f, // top-right         
			1.0f, -1.0f, -1.0f,  1.0f,  0.0f,  0.0f, 0.0f, 1.0f, // bottom-right
			1.0f,  1.0f,  1.0f,  1.0f,  0.0f,  0.0f, 1.0f, 0.0f, // top-left
			1.0f, -1.0f,  1.0f,  1.0f,  0.0f,  0.0f, 0.0f, 0.0f, // bottom-left     
			// bottom face
			-1.0f, -1.0f, -1.0f,  0.0f, -1.0f,  0.0f, 0.0f, 1.0f, // top-right
			1.0f, -1.0f, -1.0f,  0.0f, -1.0f,  0.0f, 1.0f, 1.0f, // top-left
			1.0f, -1.0f,  1.0f,  0.0f, -1.0f,  0.0f, 1.0f, 0.0f, // bottom-left
			1.0f, -1.0f,  1.0f,  0.0f, -1.0f,  0.0f, 1.0f, 0.0f, // bottom-left
			-1.0f, -1.0f,  1.0f,  0.0f, -1.0f,  0.0f, 0.0f, 0.0f, // bottom-right
			-1.0f, -1.0f, -1.0f,  0.0f, -1.0f,  0.0f, 0.0f, 1.0f, // top-right
			// top face
			-1.0f,  1.0f, -1.0f,  0.0f,  1.0f,  0.0f, 0.0f, 1.0f, // top-left
			1.0f,  1.0f , 1.0f,  0.0f,  1.0f,  0.0f, 1.0f, 0.0f, // bottom-right
			1.0f,  1.0f, -1.0f,  0.0f,  1.0f,  0.0f, 1.0f, 1.0f, // top-right     
			1.0f,  1.0f,  1.0f,  0.0f,  1.0f,  0.0f, 1.0f, 0.0f, // bottom-right
			-1.0f,  1.0f, -1.0f,  0.0f,  1.0f,  0.0f, 0.0f, 1.0f, // top-left
			-1.0f,  1.0f,  1.0f,  0.0f,  1.0f,  0.0f, 0.0f, 0.0f  // bottom-left        
		};

		const int floatNum = 8;

		for (int i = 0; i < vertexNum; i++)
		{
			vertices[i].position = glm::vec3(
				tmpVertices[i * floatNum + 0],
				tmpVertices[i * floatNum + 1],
				tmpVertices[i * floatNum + 2]);
			vertices[i].normal = glm::vec3(
				tmpVertices[i * floatNum + 3],
				tmpVertices[i * floatNum + 4],
				tmpVertices[i * floatNum + 5]);
			vertices[i].uv = glm::vec2(
				tmpVertices[i * floatNum + 6],
				tmpVertices[i * floatNum + 7]);
			indices[i] = i;
		}
		break;
	}
	default:
		break;
	}
}

void Mesh::GenerateAndSetVAO()
{
	vao.GenVAOVBOIBO();

	vao.VertexBufferData(sizeof(Vertex) * vertexNum, vertices);
	vao.IndexBufferData(sizeof(GLuint) * indexNum, indices);

	// position
	vao.VertexAttribPointer(3, 14);
	// normal
	vao.VertexAttribPointer(3, 14);
	// coordinate
	vao.VertexAttribPointer(2, 14);
	// color
	vao.VertexAttribPointer(3, 14);
	// tangent
	vao.VertexAttribPointer(3, 14);
}

// �� �ڵ带 �̿��ؼ� �������� ���� ��������
void Mesh::SetAllColor(const glm::vec3& color)
{
	for (int i = 0; i < vertexNum; i++)
		vertices[i].color = color;
}

void Mesh::Draw()
{
	// ������ ���ڸ� 0���� �����ν� �ܼ��� ���� bind�� vao�� bind�� index buffer���
	vao.Bind();
	glDrawElements(GL_TRIANGLES, indexNum, GL_UNSIGNED_INT, 0);
}

void Mesh::Delete()
{
	delete[] vertices;
	delete[] indices;
}