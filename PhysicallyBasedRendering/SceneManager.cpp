#include "SceneManager.h"

SceneManager::SceneManager()
{
	Object* tmpObj = new SceneObject();
	movingCamera = new CameraMovingScript(tmpObj);

	// TODO Light moving code ≥÷¿ª ∞Õ
}

void SceneManager::TerminateObjects()
{
	for (int i = 0; i < sceneObjs.size(); i++)
		sceneObjs[i].Delete();
	movingCamera->Delete();
}