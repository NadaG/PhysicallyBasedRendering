#include "Model.h"

void Model::LoadModel(const string& fileName)
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
		for (int i = 0; i < scene->mNumMeshes; i++)
		{
			Mesh tmpMesh;
			tmpMesh.SetMesh(scene->mMeshes[i]);
			tmpMesh.GenerateAndSetVAO();
			meshes.push_back(tmpMesh);
		}
	}
}

void Model::DrawModel()
{
	for (int i = 0; i < meshes.size(); i++)
		meshes[i].Draw();
}