#include "LectureSceneRenderer.h"


void LectureSceneRenderer::InitializeRender()
{
}

// glm의 cross(a, b)는 오른손으로 a방향에서 b방향으로 감싸쥘 때의 엄지방향이다.
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