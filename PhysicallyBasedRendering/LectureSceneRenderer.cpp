#include "LectureSceneRenderer.h"


void LectureSceneRenderer::InitializeRender()
{
}

// glm�� cross(a, b)�� ���������� a���⿡�� b�������� ������ ���� ���������̴�.
void LectureSceneRenderer::Render()
{
	Object* camera = sceneManager->movingCamera;

	glViewport(0, 0, WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);
	UseDefaultFBO();
	ClearDefaultFBO();

	glBegin(GL_QUADS);

	VECTOR3D points;

	float x[4] = { -10.0f, -10.0f, 10.0f, 10.0f };
	float y[4] = { -10.0f, 10.0f, -10.0f, 10.0f };

	for (int i = 0; i < 4; i++)
	{
		float z = 2 * x[i] + 2 * y[i] + 5;

		glVertex3f(x[i], y[i], z);
	}
	glEnd();
}

void LectureSceneRenderer::TerminateRender()
{
}