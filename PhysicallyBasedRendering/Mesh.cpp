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
	// triangulate �Ǿ� ����
	indexNum = mesh->mNumFaces * 3;

	vertices = new Vertex[mesh->mNumVertices];
	indices = new GLuint[indexNum];

	// vertices�� positions�� �ƴ϶�� ���� ������ ��
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

		// face normal�� vertex normal�� ����
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
		// vertex�� normal ������ ���ٸ� vertex position ������ �̿��� face normal�� ����
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

	// vertex�� normal ������ ���ٸ� vertex position ������ �̿��� vertex normal�� ����
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

		// ���� ��
		vertices[0].position = glm::vec3(-1.0f, 1.0f, 0.0f);
		vertices[0].uv = glm::vec2(0.0f, 1.0f);
		vertices[0].normal = glm::vec3(0.0f, 0.0f, 1.0f);

		// ���� �Ʒ�
		vertices[1].position = glm::vec3(-1.0f, -1.0f, 0.0f);
		vertices[1].uv = glm::vec2(0.0f, 0.0f);
		vertices[1].normal = glm::vec3(0.0f, 0.0f, 1.0f);

		// ������ ��
		vertices[2].position = glm::vec3(1.0f, 1.0f, 0.0f);
		vertices[2].uv = glm::vec2(1.0f, 1.0f);
		vertices[2].normal = glm::vec3(0.0f, 0.0f, 1.0f);

		// ������ �Ʒ�
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

