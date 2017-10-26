#include "FluidRenderer.h"

#include <iostream>


struct float3
{
	float x;
	float y;
	float z;
};

struct int3
{
	int x;
	int y;
	int z;
};

struct SimulationParam
{
	float3 boundaryPos;
	float3 boundarySize;

	int objNum;
	int obsobjNum;

	float viscosity;
	float restDensity;
	float pressure;
	float surfacetension;
	float threshold;
	float surfaceThreshold;

	int box2d;
	float vAtten;
};

SimulationParam sparam;

struct FluidCube
{
	float3 pos;
	int3 size;
};

struct ObstacleCube
{
	float3 pos;
	int3 size;
};

struct ObstacleObj
{
	float3* vertices;
	int vertexNum;
};

struct ObstacleSphere
{
	float3 pos;
	float radius;
};

int particleNum;
float* pos;
float* vel;
int* issur;
std::vector<ObstacleSphere> spheres;

int(*initialize)(SimulationParam param, FluidCube* cubes, ObstacleCube* obsobjs);
void(*update)(float* pos, float* vel, int* issur, ObstacleSphere *spheres, int n_spheres);

void FluidRenderer::InitializeRender(GLenum cap, glm::vec4 color)
{
	glEnable(cap);
	glClearColor(color.r, color.g, color.b, color.a);

	quadShader = new ShaderProgram("DebugQuad.vs", "DebugQuad.fs");
	
	quadShader->Use();
	quadShader->SetUniform1i("depthMap", 0);

	particleSphereShader = new ShaderProgram("ParticleSphere.vs", "ParticleSphere.fs");
	particleSphereShader->Use();

	depthTex.LoadDepthTexture(depthWidth, depthHeight);
	depthTex.SetParameters(GL_NEAREST, GL_NEAREST, GL_REPEAT, GL_REPEAT);

	depthFBO.GenFrameBufferObject();
	depthFBO.BindTexture(GL_DEPTH_ATTACHMENT, GL_TEXTURE_2D, depthTex);
	depthFBO.DrawBuffers();

	////////////////////////////////////////////////////////////////////////////////////////////////////////////

	HMODULE handle;
	handle = LoadLibrary(SOLUTION_DIR L"\\x64\\Release\\FLing.dll");

	initialize = (int(*)(SimulationParam, FluidCube*, ObstacleCube*))GetProcAddress(handle, "initialize");
	update = (void(*)(float*, float*, int*, ObstacleSphere *, int))GetProcAddress(handle, "update");
	
	sparam.boundaryPos.x = 0.0f;
	sparam.boundaryPos.y = 0.0f;
	sparam.boundaryPos.z = 0.0f;
	sparam.boundarySize.x = 10.0f;
	sparam.boundarySize.y = 10.0f;
	sparam.boundarySize.z = 10.0f;
	sparam.objNum = 1;
	sparam.obsobjNum = 0;

	sparam.viscosity = 0.03f;
	sparam.restDensity = 1000.0f;
	sparam.pressure = 0.1f;
	sparam.surfacetension = 0.0002f;
	sparam.threshold = 1.0f;
	sparam.surfaceThreshold = 0.005f;
	sparam.vAtten = 0.2f;

	sparam.box2d = 0;

	FluidCube* cubes = new FluidCube[sparam.objNum];
	cubes[0].size.x = 10;
	cubes[0].size.y = 10;
	cubes[0].size.z = 10;
	cubes[0].pos.x = 0.0f;
	cubes[0].pos.y = 0.0f;
	cubes[0].pos.z = 0.0f;

	ObstacleCube* obsobjs = nullptr;

	particleNum = initialize(sparam, cubes, obsobjs);
	pos = new float[particleNum * 3];
	vel = new float[particleNum * 3];
	issur = new int[particleNum];

	/////////////////////////////////////////////////////////////////////////////////////////

	v = new GLfloat[particleNum * 6];

	glGenVertexArrays(1, &vao);
	glGenBuffers(1, &vbo);

	glBindVertexArray(vao);
	glBindBuffer(GL_ARRAY_BUFFER, vbo);
	glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * particleNum * 6, v, GL_STATIC_DRAW);

	// position
	glEnableVertexAttribArray(0);
	glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 6, (void*)0);

	// color
	glEnableVertexAttribArray(1);
	glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 6, (void*)(3 * sizeof(GLfloat)));
}

void FluidRenderer::Render()
{
	update(pos, vel, issur, spheres.data(), 0);

	for (int i = 0; i < particleNum; i++)
	{
		v[i * 6 + 0] = pos[i * 3 + 0];
		v[i * 6 + 1] = pos[i * 3 + 1];
		v[i * 6 + 2] = pos[i * 3 + 2];
		v[i * 6 + 4] = vel[i * 3 + 0];
		v[i * 6 + 5] = vel[i * 3 + 1];
		v[i * 6 + 6] = vel[i * 3 + 2];
	}

	glBindBuffer(GL_ARRAY_BUFFER, vbo);
	glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * particleNum * 6, v, GL_STATIC_DRAW);

	SceneObject& camera = SceneManager::GetInstance()->cameraObj;
	SceneObject& quad = SceneManager::GetInstance()->quadObj;

	float depthNear = 0.01f;
	float depthFar = 30.0f;

	glViewport(0, 0, depthWidth, depthHeight);

	depthFBO.Use();
	particleSphereShader->Use();

	glm::mat4 projection = glm::perspective(
		glm::radians(45.0f),
		WindowManager::GetInstance()->width / WindowManager::GetInstance()->height,
		depthNear,
		depthFar);

	glm::mat4 view = glm::lookAt(
		camera.GetWorldPosition(),
		glm::vec3(0.0f, camera.GetPosition().y, 0.0f),
		glm::vec3(0.0f, 1.0f, 0.0f)
	);

	particleSphereShader->SetUniformMatrix4f("view", view);
	particleSphereShader->SetUniformMatrix4f("projection", projection);
	particleSphereShader->SetUniformVector3f("lightPos", glm::vec3(0.0f, 0.0f, 3.0f));

	glBindVertexArray(vao);
	glPointSize(50);
	glDrawArrays(GL_POINTS, 0, particleNum);

	glViewport(0, 0, WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);
	UseDefaultFrameBufferObject();
	quadShader->Use();

	depthTex.Bind(GL_TEXTURE0);
	quadShader->SetUniform1f("near", depthNear);
	quadShader->SetUniform1f("far", depthFar);

	quad.Draw();

	glfwSwapBuffers(window);
}

void FluidRenderer::TerminateRender()
{
	quadShader->Delete();
	delete quadShader;

	particleSphereShader->Delete();
	delete particleSphereShader;

	SceneManager::GetInstance()->TerminateObjects();
}