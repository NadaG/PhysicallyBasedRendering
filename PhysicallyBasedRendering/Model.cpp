#include "Model.h"

void Model::LoadModel(const string& fileName)
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