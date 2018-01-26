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

// quaternion�� 

// quaternion�� ���ؼ� ���� ������ ����.
// x = RotationAxis.x * sin(RotationAngle / 2)
// y = RotationAxis.y * sin(RotationAngle / 2)
// z = RotationAxis.z * sin(RotationAngle / 2)
// w = cos(RotationAngle / 2)

// [0.7, 0, 0, 0.7]�̶�� quaternion�� ���� ���
// 2 * acos(w) = RotationAngle�̶�� ���� �˰�
// 2 * acos(w)�� ���� 1.57�����̹Ƿ�
// �� quaternion�� ǥ���� ȸ���� 90�� ȸ���̴�.
// ���� y, z ���� 0�̹Ƿ� �ܼ��� x�࿡ ���� ȸ���̶�� ���� �� �� �ִ�.

// LookAt �Լ��� ���ؼ� ������
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