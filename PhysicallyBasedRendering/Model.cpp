#include "Model.h"

void Model::LoadModel(const string& fileName)
{
	// aiprocess_triangulate는 triangle 형태가 아닌 model load 할 때 triangle로 불러들이는 것
	// flipuvs는 y값은 flip하는 것
	// scene의 mMeshes에는 모든 mesh들이 저장되어 있다
	// scene은 mRootNode를 가지고 있고 각 노드에는 mesh가 있다
	Assimp::Importer importer;

	scene = importer.ReadFile(fileName, aiProcess_Triangulate | aiProcess_FlipUVs);
	if (!scene || scene->mFlags & AI_SCENE_FLAGS_INCOMPLETE || !scene->mRootNode)
	{
		printf("모델 파일을 불러올 수 없습니다. \n");
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