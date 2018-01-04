#include "Model.h"

void Model::LoadModel(const string& fileName)
{
	// aiprocess_triangulate�� triangle ���°� �ƴ� model load �� �� triangle�� �ҷ����̴� ��
	// flipuvs�� y���� flip�ϴ� ��
	// scene�� mMeshes���� ��� mesh���� ����Ǿ� �ִ�
	// scene�� mRootNode�� ������ �ְ� �� ��忡�� mesh�� �ִ�
	Assimp::Importer importer;

	scene = importer.ReadFile(fileName, aiProcess_Triangulate | aiProcess_FlipUVs);
	if (!scene || scene->mFlags & AI_SCENE_FLAGS_INCOMPLETE || !scene->mRootNode)
	{
		printf("�� ������ �ҷ��� �� �����ϴ�. \n");
		getchar();
	}
	else
	{
		meshTextureIndex = new unsigned int[scene->mNumMeshes];
		for (int i = 0; i < scene->mNumMeshes; i++)
		{
			/*aiString a;
			aiColor4D diffuse;
			aiGetMaterialColor(scene->mMaterials[meshTextureIndex[i]], AI_MATKEY_COLOR_DIFFUSE, &diffuse);
			scene->mMaterials[scene->mMeshes[i]->mMaterialIndex]->GetTexture(aiTextureType_DIFFUSE, 0, &a);*/

			Mesh mesh;
			meshTextureIndex[i] = scene->mMeshes[i]->mMaterialIndex;
			mesh.SetMesh(scene->mMeshes[i]);
			mesh.GenerateAndSetVAO();
			meshes.push_back(mesh);
		}

		/*for (int i = 0; i < scene->mNumMaterials; i++)
		{
			aiString textureStr;
			scene->mMaterials[i]->GetTexture(aiTextureType_DIFFUSE, 0, &textureStr);
		}*/
	}
}

void Model::DrawModel()
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