#include "BillBoardMovement.h"
#include "Object.h"

void BillBoardMovement::Update()
{
	glm::mat4 view = glm::lookAt(
		camera->GetWorldPosition(),
		glm::vec3(0.0f, camera->GetPosition().y, 0.0f),
		glm::vec3(0.0f, 1.0f, 0.0f)
	);

	glm::mat4 inverseView = glm::inverse(view);
	glm::mat3 inverseRotView = glm::mat3(inverseView);
	glm::mat4 inverseRotView2 = inverseRotView;
	object->SetRotation(inverseRotView2);
}