#include "RayTracingSceneManager.h"

void RayTracingSceneManager::InitializeObjects()
{
	quadObj.LoadModel(QUAD);

	sceneObjs.push_back(quadObj);
	sceneObjs[0].Scale(glm::vec3(15.0));
	sceneObjs[0].Rotate(glm::vec3(1.0f, 0.0f, 0.0f), glm::radians(90.0f));
	sceneObjs[0].Translate(glm::vec3(0.0f, 0.0f, 0.0f));

	movingCamera->Translate(glm::vec3(0.0f, 0.1f, 10.0f));
}

void RayTracingSceneManager::Update()
{
	movingCamera->Update();
}

// quaternion은 

// quaternion에 대해서 값은 다음과 같다.
// x = RotationAxis.x * sin(RotationAngle / 2)
// y = RotationAxis.y * sin(RotationAngle / 2)
// z = RotationAxis.z * sin(RotationAngle / 2)
// w = cos(RotationAngle / 2)

// [0.7, 0, 0, 0.7]이라는 quaternion이 있을 경우
// 2 * acos(w) = RotationAngle이라는 것을 알고
// 2 * acos(w)의 값은 1.57정도이므로
// 이 quaternion이 표현한 회전은 90도 회전이다.
// 또한 y, z 값이 0이므로 단순히 x축에 대한 회전이라는 것을 알 수 있다.

// LookAt 함수에 대해서 공부함
// Result[0][0] = s.x;
// Result[1][0] = s.y;
// Result[2][0] = s.z;
// Result[0][1] = u.x;
// Result[1][1] = u.y;
// Result[2][1] = u.z;
// Result[0][2] = -f.x;
// Result[1][2] = -f.y;
// Result[2][2] = -f.z;
// Result[3][0] = -dot(s, eye);
// Result[3][1] = -dot(u, eye);
// Result[3][2] = dot(f, eye);