#include "SceneManager.h"

#include "DefaultMovement.h"
#include "LightMovement.h"
#include "CameraMovement.h"

SceneManager::SceneManager()
{
	cameraMovement = new CameraMovement();
	movingCamera = new Object(cameraMovement);
	cameraMovement->BindObject(movingCamera);
}

void SceneManager::TerminateObjects()
{
	for (int i = 0; i < sceneObjs.size(); i++)
		sceneObjs[i].Delete();
	movingCamera->Delete();

	delete movingCamera;
	delete cameraMovement;
}