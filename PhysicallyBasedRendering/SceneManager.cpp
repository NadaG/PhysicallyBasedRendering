#include "SceneManager.h"

#include "DefaultMovement.h"
#include "LightMovement.h"
#include "CameraMovement.h"

SceneManager::SceneManager()
{
	CameraMovement* cameraMovement;
	cameraMovement = new CameraMovement();
	movingCamera = new Object(cameraMovement);
	cameraMovement->BindObject(movingCamera);
}

void SceneManager::TerminateObjects()
{
	for (int i = 0; i < sceneObjs.size(); i++)
		sceneObjs[i].Delete();
	movingCamera->Delete();

	for (int i = 0; i < lightObjs.size(); ++i)
	{
		lightObjs[i]->Delete();
		delete lightObjs[i];
	}

	delete movingCamera;
}

void SceneManager::GenerateLight(glm::vec3 color, glm::vec3 size)
{
	int lightsNum = lightObjs.size();
	lightObjs.resize(lightsNum + 1);

	LightMovement* lightMovement = new LightMovement(movingCamera);
	lightObjs[lightsNum] = new SceneObject(lightMovement);
	lightMovement->BindObject(lightObjs[lightsNum]);

	lightObjs[lightsNum]->LoadModel("Obj/Sphere.obj");
	lightObjs[lightsNum]->Scale(size);
	lightObjs[lightsNum]->SetColor(glm::vec3(color));
}