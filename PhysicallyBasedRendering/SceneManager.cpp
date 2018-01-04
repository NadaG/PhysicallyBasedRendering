#include "SceneManager.h"


SceneManager::SceneManager()
{
	Object* camera = new SceneObject();
	Object* movingCamera = new CameraMovingScript(camera);
}

void SceneManager::TerminateObjects()
{
	for (int i = 0; i < sceneObjs.size(); i++)
		sceneObjs[i].TerminateModel();
	cameraObj.TerminateModel();
}