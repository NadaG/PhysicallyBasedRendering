#include "Renderer.h"

void Renderer::Initialize(GLFWwindow* window)
{
	this->window = window;
}

void Renderer::UseDefaultFrameBufferObject()
{
	glBindFramebuffer(GL_FRAMEBUFFER, 0);
	glClearColor(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

void Renderer::RenderObjects(ShaderProgram * shader, vector<SceneObject> objs)
{
	shader->Use();
	for (int i = 0; i < objs.size(); i++)
	{
		glm::mat4 model = objs[i].GetModelMatrix();
		shader->SetUniformMatrix4f("model", model);
		// decorator pattern ����??
		shader->SetUniformVector3f("uniColor", objs[i].GetColor());
		objs[i].DrawModel();
	}
}

void Renderer::RenderObjects(ShaderProgram * shader, vector<SceneObject*> objs)
{
	shader->Use();
	for (int i = 0; i < objs.size(); i++)
	{
		glm::mat4 model = objs[i]->GetModelMatrix();
		shader->SetUniformMatrix4f("model", model);
		// decorator pattern ����??
		shader->SetUniformVector3f("uniColor", objs[i]->GetColor());
		objs[i]->DrawModel();
	}
}

void Renderer::RenderObject(ShaderProgram * shader, SceneObject obj)
{
	shader->Use();
	glm::mat4 model = obj.GetModelMatrix();
	shader->SetUniformMatrix4f("model", model);
	obj.DrawModel();
}

void Renderer::RenderObject(ShaderProgram * shader, SceneObject* obj)
{
	shader->Use();
	glm::mat4 model = obj->GetModelMatrix();
	shader->SetUniformMatrix4f("model", model);
	shader->SetUniformVector3f("uniColor", obj->GetColor());
	obj->DrawModel();
}

void Renderer::DrawWithVAO(VertexArrayObject vao, const int vertexNum) const
{
	vao.Bind();
	glDrawArrays(vao.GetDrawMode(), 0, vertexNum);
}

void Renderer::GenCubemapFromEquirectangular(TextureCube* texCube, Texture2D tex)
{
	equirectangularToCubemapShader->Use();
	equirectangularToCubemapShader->SetUniform1i("equirectangularMap", 0);
	equirectangularToCubemapShader->SetUniformMatrix4f("projection", captureProjection);
	tex.Bind(GL_TEXTURE0);

	glViewport(0, 0, 2048, 2048);
	captureFBO.Use();
	for (int i = 0; i < 6; i++)
	{
		equirectangularToCubemapShader->SetUniformMatrix4f("view", captureViews[i]);
		captureFBO.BindTexture(GL_COLOR_ATTACHMENT0, GL_TEXTURE_CUBE_MAP_POSITIVE_X + i, texCube);
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

		sceneManager->skyboxObj.DrawModel();
	}
}

// VAO(vertex array object), VBO(vertex buffer object), IBO(index buffer object) ����
// ����
// glGenVertexArrays(1, &vao);
// glGenBuffers(1, &vbo);
// glGenBuffers(1, &ibo);

// ���ε�
// glBindVertexArray(vao);
// glBindBuffer(GL_ARRAY_BUFFER, vbo); // �� ���� bind �� vao���� GL_ARRAY_BUFFER�� ���ε� �ϴ� ���̴�
// glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ibo); // ���� ����

// ������ �ѱ��
// glBufferData(GL_ARRAY_BUFFER, len, pointer, GL_STATIC_DRAW);
// glBufferData(GL_ELEMENT_ARRAY_BUFFER, len, pointer, GL_STATIC_DRAW);

// shader ������ ����, �� vbo�� bind �� �Ŀ� �ؾ� �Ѵ�
// glEnableVertexAttribArray(0);
// glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, stride, (void*)0);

// ���߿��� �ܼ��� �� 3�ٷ� �׸� �� �ִ�.
// glBindVertexArray(vao);
// glDrawElements(GL_TRIANGLE_STRIP, indexNum, GL_UNSIGNED_INT, 0);
// glBindVertexArray(0);