#include "Renderer.h"

void Renderer::Initialize(GLFWwindow* window)
{
	this->window = window;

	glewExperimental = true;

	if (glewInit() != GLEW_OK)
	{
		fprintf(stderr, "Failed to initialize GLEW\n");
		return;
	}
}

void Renderer::UseDefaultFrameBufferObject()
{
	glBindFramebuffer(GL_FRAMEBUFFER, 0);
	glClearColor(0.8, 0.8, 0.8, 0.0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

void Renderer::RenderObjects(ShaderProgram * shader, vector<SceneObject> objs)
{
	shader->Use();
	for (int i = 0; i < objs.size(); i++)
	{
		glm::mat4 model = objs[i].GetModelMatrix();
		shader->SetUniformMatrix4f("model", model);
		objs[i].Draw();
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