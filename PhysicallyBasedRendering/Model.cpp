#include "Model.h"

void Model::Load(const string& fileName)
{
	// aiprocess_triangulate는 triangle 형태가 아닌 model load 할 때 triangle로 불러들이는 것
	// flipuvs는 y값은 flip하는 것
	// scene의 mMeshes에는 모든 mesh들이 저장되어 있다
	// scene은 mRootNode를 가지고 있고 각 노드에는 mesh가 있다
	Assimp::Importer importer;

	scene = importer.ReadFile(fileName, aiProcess_Triangulate | aiProcess_FlipUVs | aiProcess_JoinIdenticalVertices);
	if (!scene || scene->mFlags & AI_SCENE_FLAGS_INCOMPLETE || !scene->mRootNode)
	{
		printf("모델 파일을 불러올 수 없습니다. \n");
		getchar();
	}
	else
	{
		meshMaterialIndex = new unsigned int[scene->mNumMeshes];
		for (int i = 0; i < scene->mNumMeshes; i++)
		{
			/*aiString a;
			aiColor4D diffuse;
			aiGetMaterialColor(scene->mMaterials[meshTextureIndex[i]], AI_MATKEY_COLOR_DIFFUSE, &diffuse);
			scene->mMaterials[scene->mMeshes[i]->mMaterialIndex]->GetTexture(aiTextureType_DIFFUSE, 0, &a);*/

			Mesh mesh;
			meshMaterialIndex[i] = scene->mMeshes[i]->mMaterialIndex;
			mesh.SetMesh(scene->mMeshes[i]);
			mesh.GenerateAndSetVAO();
			meshes.push_back(mesh);
		}

		for (int i = 0; i < scene->mNumMaterials; i++)
		{
			aiString textureStr;
			scene->mMaterials[i]->GetTexture(aiTextureType_DIFFUSE, 0, &textureStr);
		}
	}
}

// TODO model을 draw 하기 위해서는 meshes들을 draw해야 한다.
// 단 각 mesh는 연결된 material이 있다.
// material은 하나의 ShaderProgram과 연관되어 있다.
// 하나의 ShaderProgram은 여러 개의 texture를 가지고 있다.
// 사실 하나의 ShaderProgram은 한 개의 vertex shader와 fragment shader로 이루어져 있고
// 각각의 vertex shader와 fragment shader는 여러 개의 texture를 가지고 있다.
// 뿐만 아니라 각각의 shader는 uniform 변수 또한 가지고 있다.
// 여러 개의 shader가 같은 uniform 변수를 새로 정의한다고 하더라고 걱정할 필요 없다.
// glsl은 그 상황을 용인하기 때문이다.
void Model::Draw()
{
	for (int i = 0; i < meshes.size(); i++)
	{
		meshes[i].Draw();
	}
}

void Model::AddMesh(const MeshType & meshType)
{
	Mesh mesh;
	mesh.LoadMesh(meshType);
	mesh.GenerateAndSetVAO();
	meshes.push_back(mesh);
}

void Model::Delete()
{
	for (int i = 0; i < meshes.size(); i++)
		meshes[i].Delete();
}

std::vector<Triangle> Model::GetTriangles() const
{
	vector<Triangle> triangles;
	for (int i = 0; i < meshes.size(); i++)
	{
		vector<Triangle> meshTriangles = meshes[i].GetTriangles();
		for (int j = 0; j < meshTriangles.size(); j++)
		{
			triangles.push_back(meshTriangles[j]);
		}
	}
	return triangles;
}
