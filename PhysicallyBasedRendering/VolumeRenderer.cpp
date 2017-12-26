#include "VolumeRenderer.h"

void VolumeRenderer::InitializeRender()
{
	backgroundColor = glm::vec4(1.0f, 0.0f, 1.0f, 0.0f);

	pointShader = new ShaderProgram("ParticleBasic.vs", "PointToCube.gs", "Phong.fs");
	pointShader->Use();

	// tc는 draw할 때 vertex 갯수 만큼 호출된다.
	// te를 할 때는 tc와 te 사이에서 vertex가 증가했기 때문에 (다른 셰이더로 인해) 더 많이 호출된다.

	tessShader = new ShaderProgram("vertex.vs", "tessellationControl.tcs", "tessellationEvaluation.tes", "geometry.gs", "fragment.fs");
	tessShader->Use();
	
	vertices = new GLfloat[pointNum * 6];

	for (int i = 0; i < pointNum; i++)
	{
		// pos
		vertices[i * 6 + 0] = i * 3.0f;
		vertices[i * 6 + 1] = 0.0f;
		vertices[i * 6 + 2] = 0.0f;
		// color
		vertices[i * 6 + 3] = 1.0f;
		vertices[i * 6 + 4] = 0.0f;
		vertices[i * 6 + 5] = 0.0f;
	}

	smokeVAO.GenVAOVBOIBO();
	smokeVAO.VertexBufferData(sizeof(GLfloat) * pointNum * 6, vertices);

	// position 
	smokeVAO.VertexAttribPointer(3, 6);
	smokeVAO.VertexAttribPointer(3, 6);

	const GLint faces[] = {
		2, 1, 0,
		3, 2, 0,
		4, 3, 0,
		5, 4, 0,
		1, 5, 0,
		11, 6,  7,
		11, 7,  8,
		11, 8,  9,
		11, 9,  10,
		11, 10, 6,
		1, 2, 6,
		2, 3, 7,
		3, 4, 8,
		4, 5, 9,
		5, 1, 10,
		2,  7, 6,
		3,  8, 7,
		4,  9, 8,
		5, 10, 9,
		1, 6, 10
	};

	const GLfloat icosahedronVertices[] = {
		0.000f,  0.000f,  1.000f,
		0.894f,  0.000f,  0.447f,
		0.276f,  0.851f,  0.447f,
		- 0.724f,  0.526f,  0.447f,
		- 0.724f, -0.526f,  0.447f,
		0.276f, -0.851f,  0.447f,
		0.724f,  0.526f, -0.447f,
		- 0.276f,  0.851f, -0.447f,
		- 0.894f,  0.000f, -0.447f,
		- 0.276f, -0.851f, -0.447f,
		0.724f, -0.526f, -0.447f,
		0.000f,  0.000f, -1.000f 
	};

	tessVAO.GenVAOVBOIBO();
	tessVAO.VertexBufferData(sizeof(GLfloat) * 36, icosahedronVertices);
	tessVAO.VertexAttribPointer(3, 3);

	tessVAO.IndexBufferData(sizeof(GLint) * 60, faces);
}

const float cubeLength = 1.0f;

void VolumeRenderer::Render()
{
	UseDefaultFrameBufferObject();
	glViewport(0, 0, WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);

	glEnable(GL_DEPTH_TEST);
	glClearColor(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	SceneObject& camera = sceneManager->cameraObj;
	SceneObject& quad = sceneManager->quadObj;
	vector<SceneObject>& objs = sceneManager->sceneObjs;

	glm::mat4 projection = glm::perspective(
		glm::radians(45.0f),
		WindowManager::GetInstance()->width / WindowManager::GetInstance()->height,
		0.1f,
		100.0f);

	glm::mat4 view = glm::lookAt(
		camera.GetWorldPosition(),
		glm::vec3(0.0f, camera.GetPosition().y, 0.0f),
		glm::vec3(0.0f, 1.0f, 0.0f)
	);

	pointShader->Use();

	pointShader->SetUniformMatrix4f("view", view);
	pointShader->SetUniformMatrix4f("projection", projection);

	pointShader->SetUniformMatrix4f("model[0]", 
		glm::translate(glm::vec3(0.0f, 0.0f, cubeLength)));
	pointShader->SetUniformMatrix4f("model[1]", 
		glm::rotate(glm::radians(180.0f), glm::vec3(0.0f, 1.0f, 0.0f)) * glm::translate(glm::vec3(0.0f, 0.0f, cubeLength)));
	pointShader->SetUniformMatrix4f("model[2]", 
		glm::rotate(glm::radians(90.0f), glm::vec3(0.0f, 1.0f, 0.0f)) * glm::translate(glm::vec3(0.0f, 0.0f, cubeLength)));
	pointShader->SetUniformMatrix4f("model[3]", 
		glm::rotate(glm::radians(-90.0f), glm::vec3(0.0f, 1.0f, 0.0f)) * glm::translate(glm::vec3(0.0f, 0.0f, cubeLength)));
	pointShader->SetUniformMatrix4f("model[4]", 
		glm::rotate(glm::radians(90.0f), glm::vec3(1.0f, 0.0f, 0.0f)) * glm::translate(glm::vec3(0.0f, 0.0f, cubeLength)));
	pointShader->SetUniformMatrix4f("model[5]", 
		glm::rotate(glm::radians(-90.0f), glm::vec3(1.0f, 0.0f, 0.0f)) * glm::translate(glm::vec3(0.0f, 0.0f, cubeLength)));
	
	pointShader->SetUniformVector3f("eyePos", camera.GetWorldPosition());
	pointShader->SetUniformVector3f("lightDir", glm::vec3(1.0f, 0.0f, 0.0f));

	DrawSmoke();
}

void VolumeRenderer::TerminateRender()
{
	pointShader->Delete();
	delete pointShader;
}

void VolumeRenderer::DrawSmoke()
{
	smokeVAO.Bind();
	glPointSize(10);
	glDrawArrays(GL_POINTS, 0, pointNum);
}

void VolumeRenderer::DrawIco()
{
	SceneObject& camera = sceneManager->cameraObj;

	glm::mat4 projection = glm::perspective(
		glm::radians(45.0f),
		WindowManager::GetInstance()->width / WindowManager::GetInstance()->height,
		0.1f,
		100.0f);

	glm::mat4 view = glm::lookAt(
		camera.GetWorldPosition(),
		glm::vec3(0.0f, camera.GetPosition().y, 0.0f),
		glm::vec3(0.0f, 1.0f, 0.0f)
	);

	tessShader->Use();

	tessShader->SetUniformMatrix4f("model", glm::mat4());
	tessShader->SetUniformMatrix4f("view", view);
	tessShader->SetUniformMatrix4f("projection", projection);
	// 중첩된 primitive의 개수를 말하고
	tessShader->SetUniform1f("tessLevelInner", 0);
	// 엣지를 subdivide한 횟수를 말한다.
	tessShader->SetUniform1f("tessLevelOuter", 1);
	tessShader->SetUniformVector3f("lightDir", glm::vec3(1.0, 0.0, 0.0));
	tessShader->SetUniformMatrix3f("normalMatrix", glm::mat3(glm::mat4()*view));

	tessVAO.Bind();
	glPatchParameteri(GL_PATCH_VERTICES, 3);
	glDrawElements(GL_PATCHES, 60, GL_UNSIGNED_INT, 0);
}
