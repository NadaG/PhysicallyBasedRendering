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
	// triangulate 되어 있음
	indexNum = mesh->mNumFaces * 3;

	vertices = new Vertex[mesh->mNumVertices];
	indices = new GLuint[indexNum];

	// vertices지 positions가 아니라는 것을 주의할 것
	for (int i = 0; i < mesh->mNumVertices; ++i)
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

	for (int i = 0; i < mesh->mNumFaces; ++i)
	{
		indices[i * 3 + 0] = mesh->mFaces[i].mIndices[0];
		indices[i * 3 + 1] = mesh->mFaces[i].mIndices[1];
		indices[i * 3 + 2] = mesh->mFaces[i].mIndices[2];

		Triangle triangle;
		triangle.v0 = vertices[indices[i * 3 + 0]].position;
		triangle.v1 = vertices[indices[i * 3 + 1]].position;
		triangle.v2 = vertices[indices[i * 3 + 2]].position;

		// face normal과 vertex normal을 대입
		if(mesh->HasNormals())
		{
			triangle.normal =
				normalize((
					vertices[indices[i * 3 + 0]].normal +
					vertices[indices[i * 3 + 1]].normal +
					vertices[indices[i * 3 + 2]].normal)
					/ 3.0f);

			triangle.v0normal = vertices[indices[i * 3 + 0]].normal;
			triangle.v1normal = vertices[indices[i * 3 + 1]].normal;
			triangle.v2normal = vertices[indices[i * 3 + 2]].normal;
		}
		// vertex에 normal 정보가 없다면 vertex position 정보를 이용해 face normal을 구함
		else
		{
			triangle.normal = cross(triangle.v1 - triangle.v0, triangle.v2 - triangle.v0);
		}

		if (mesh->HasTextureCoords(0))
		{
			triangle.v0uv = vertices[indices[i * 3 + 0]].uv;
			triangle.v1uv = vertices[indices[i * 3 + 1]].uv;
			triangle.v2uv = vertices[indices[i * 3 + 2]].uv;
		}

		triangles.push_back(triangle);
	}

	// vertex에 normal 정보가 없다면 vertex position 정보를 이용해 vertex normal을 구함
	if (!mesh->HasNormals())
	{
		// TODO Fluid Scene
		/*CaculateFaceNormal();
		CaculateVertexNormal();*/

		// TODO RayTracing Scene
		vector<vector<int> > neighborFaceMap;
		for (int i = 0; i < mesh->mNumVertices; ++i)
		{
			vector<int> neighborFaces;
			for (int j = 0; j < mesh->mNumFaces; ++j)
			{
				if (i == mesh->mFaces[j].mIndices[0] ||
					i == mesh->mFaces[j].mIndices[1] ||
					i == mesh->mFaces[j].mIndices[2])
					neighborFaces.push_back(j);
			}
			neighborFaceMap.push_back(neighborFaces);
		}

		for (int i = 0; i < mesh->mNumFaces; ++i)
		{
			triangles[i].v0normal = glm::vec3();
			for (int k = 0; k < neighborFaceMap[indices[i * 3 + 0]].size(); k++)
			{
				triangles[i].v0normal += triangles[neighborFaceMap[indices[i * 3 + 0]][k]].normal;
			}
			triangles[i].v0normal /= neighborFaceMap[indices[i * 3 + 0]].size();

			triangles[i].v1normal = glm::vec3();
			for (int k = 0; k < neighborFaceMap[indices[i * 3 + 1]].size(); k++)
			{
				triangles[i].v1normal += triangles[neighborFaceMap[indices[i * 3 + 1]][k]].normal;
			}
			triangles[i].v1normal /= neighborFaceMap[indices[i * 3 + 1]].size();

			triangles[i].v2normal = glm::vec3();
			for (int k = 0; k < neighborFaceMap[indices[i * 3 + 2]].size(); k++)
			{
				triangles[i].v2normal += triangles[neighborFaceMap[indices[i * 3 + 2]][k]].normal;
			}
			triangles[i].v2normal /= neighborFaceMap[indices[i * 3 + 2]].size();
		}
	}
}

void Mesh::CaculateFaceNormal()
{
	for (int i = 0; i < vertexNum; i += 3)
	{
		vertices[i].normal = glm::normalize(glm::cross(
			vertices[i + 1].position - vertices[i].position,
			vertices[i + 2].position - vertices[i].position));
		vertices[i + 1].normal = vertices[i].normal;
		vertices[i + 2].normal = vertices[i].normal;
	}
}

void Mesh::CaculateVertexNormal()
{
	for (int i = 0; i < vertexNum; i++)
	{
		for (int j = 0; j < i; j++)
		{
			if (vertices[i].position == vertices[j].position)
			{
				indices[j] = i;
			}
		}
	}
}

std::vector<Triangle> Mesh::GetTriangles() const
{
	return triangles;
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
		vertices[0].normal = glm::vec3(0.0f, 0.0f, 1.0f);

		// 왼쪽 아래
		vertices[1].position = glm::vec3(-1.0f, -1.0f, 0.0f);
		vertices[1].uv = glm::vec2(0.0f, 0.0f);
		vertices[1].normal = glm::vec3(0.0f, 0.0f, 1.0f);

		// 오른쪽 위
		vertices[2].position = glm::vec3(1.0f, 1.0f, 0.0f);
		vertices[2].uv = glm::vec2(1.0f, 1.0f);
		vertices[2].normal = glm::vec3(0.0f, 0.0f, 1.0f);

		// 오른쪽 아래
		vertices[3].position = glm::vec3(1.0f, -1.0f, 0.0f);
		vertices[3].uv = glm::vec2(1.0f, 0.0f);
		vertices[3].normal = glm::vec3(0.0f, 0.0f, 1.0f);

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

