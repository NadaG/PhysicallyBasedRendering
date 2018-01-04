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

	// vertices지 positions가 아니라는 것을 주의할 것
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
// Ns specular exponent specular에 제곱해지는 값
// tf transmission 값이 0, 1, 0일 경우 G의 값은 모두 투과하고 나머지는 반사된다.
// d dissolve 1.0일 경우 불투명한 것, 0.0일 경우 투명한 것
// Ni index of refraction, optical density라고 불림 값이 클 수록 굴절률이 높은 것
// illum 4, color on, ambient on, highlight on, reflection on, transparency on 등등을 뜻함
// map_Kd(이미지 파일) 등의 값은 Kd의 값과 곱해진다 하더라

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

// 이 코드를 이용해서 광원들의 색을 정해주자
void Mesh::SetAllColor(const glm::vec3& color)
{
	for (int i = 0; i < vertexNum; i++)
		vertices[i].color = color;
}

void Mesh::Draw()
{
	// 마지막 인자를 0으로 함으로써 단순히 현재 bind된 vao에 bind된 index buffer대로
	vao.Bind();
	glDrawElements(GL_TRIANGLES, indexNum, GL_UNSIGNED_INT, 0);
}

void Mesh::Delete()
{
	delete[] vertices;
	delete[] indices;
}