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

// VAO(vertex array object), VBO(vertex buffer object), IBO(index buffer object) 정리
// 생성
// glGenVertexArrays(1, &vao);
// glGenBuffers(1, &vbo);
// glGenBuffers(1, &ibo);

// 바인딩
// glBindVertexArray(vao);
// glBindBuffer(GL_ARRAY_BUFFER, vbo); // 단 현재 bind 된 vao에서 GL_ARRAY_BUFFER에 바인드 하는 것이다
// glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ibo); // 위와 같다

// 데이터 넘기기
// glBufferData(GL_ARRAY_BUFFER, len, pointer, GL_STATIC_DRAW);
// glBufferData(GL_ELEMENT_ARRAY_BUFFER, len, pointer, GL_STATIC_DRAW);

// shader 데이터 정의, 단 vbo가 bind 된 후에 해야 한다
// glEnableVertexAttribArray(0);
// glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, stride, (void*)0);

// 나중에는 단순히 밑 3줄로 그릴 수 있다.
// glBindVertexArray(vao);
// glDrawElements(GL_TRIANGLE_STRIP, indexNum, GL_UNSIGNED_INT, 0);
// glBindVertexArray(0);