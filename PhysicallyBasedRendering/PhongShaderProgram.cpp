#include "PhongShaderProgram.h"

void PhongShaderProgram::LoadPhongModel()
{
	scene = importer.ReadFile("Obj/street_lamp.obj", aiProcess_Triangulate | aiProcess_FlipUVs);
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

void PhongShaderProgram::DrawPhongModel()
{
	aiColor3D ambient, diffuse, specular, shiness, transmission;

	for (int i = 0; i < meshes.size(); i++)
	{
		aiMaterial* mat = scene->mMaterials[scene->mMeshes[i]->mMaterialIndex];
		Use();

		mat->Get(AI_MATKEY_COLOR_AMBIENT, ambient);
		mat->Get(AI_MATKEY_COLOR_DIFFUSE, diffuse);
		mat->Get(AI_MATKEY_COLOR_SPECULAR, specular);
		mat->Get(AI_MATKEY_SHININESS, shiness);
		// TODO 제대로 mtl 파일을 가져오지 못하는거 같음
		mat->Get(AI_MATKEY_OPACITY, transmission);

		SetUniformVector3f("ambientColor", glm::vec3(ambient.r, ambient.g, ambient.b));
		SetUniformVector3f("diffuseColor", glm::vec3(diffuse.r, diffuse.g, diffuse.b));
		SetUniformVector3f("specularColor", glm::vec3(specular.r, specular.g, specular.b));
		SetUniform1f("specularExpo", shiness.r);
		SetUniformVector3f("transmission", glm::vec3(transmission.r, transmission.g, transmission.b));

		meshes[i].Draw();
	}
}
