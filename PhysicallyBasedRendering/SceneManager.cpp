#include "SceneManager.h"

void SceneManager::TerminateObjects()
{
	for (int i = 0; i < sceneObjs.size(); i++)
		sceneObjs[i].TerminateModel();
	cameraObj.TerminateModel();
}