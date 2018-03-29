#include "RayTracingRenderer.h"

#include<cuda_runtime.h>
#include<cuda_gl_interop.h>

void RayTracingRenderer::InitializeRender()
{
	debugQuadShader->Use();
	// ���̴��� �� �ؽ��ĸ� �׸��ڴٰ� ��������
	debugQuadShader->BindTexture(&rayTracingTex, "map");

	frontTex.LoadTexture("Texture/SkyBox/front.jpg");
	frontTex.SetParameters(GL_LINEAR, GL_LINEAR, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);

	unsigned char* frontArray = frontTex.GetTexImage(GL_RGB, GL_UNSIGNED_BYTE);

	rayTracingTex.LoadTexture(
		GL_RGBA16F,
		WindowManager::GetInstance()->width,
		WindowManager::GetInstance()->height,
		GL_RGBA,
		GL_FLOAT);
	rayTracingTex.SetParameters(GL_LINEAR, GL_LINEAR, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);

	glGenBuffers(1, &rayTracePBO);
	glBindBuffer(GL_PIXEL_UNPACK_BUFFER, rayTracePBO);
	glBufferData(
		GL_PIXEL_UNPACK_BUFFER, 
		WindowManager::GetInstance()->width * WindowManager::GetInstance()->height * sizeof(GLfloat) * 4, 
		0, 
		GL_STREAM_DRAW);

	cudaGraphicsGLRegisterBuffer(&cuda_pbo_resource, rayTracePBO, cudaGraphicsMapFlagsWriteDiscard);
}

// glm�� cross(a, b)�� ���������� a���⿡�� b�������� ������ ���� ���������̴�.
void RayTracingRenderer::Render()
{
	Object* camera = sceneManager->movingCamera;

	vector<Triangle> triangles = dynamic_cast<RayTracingSceneManager*>(sceneManager)->triangles;
	vector<Light> lights = dynamic_cast<RayTracingSceneManager*>(sceneManager)->lights;
	vector<Material> materials = dynamic_cast<RayTracingSceneManager*>(sceneManager)->materials;

	glViewport(0, 0, WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);
	UseDefaultFBO();
	ClearDefaultFBO();
	
	// render start //
	cudaGraphicsMapResources(1, &cuda_pbo_resource, 0);

	//float4* output;
	glm::vec4* output;
	size_t num_bytes;
	// cuda memory�κ��� cpu memory�� ������ ��ġ�� �������� �ǰ�?
	cudaGraphicsResourceGetMappedPointer((void**)&output, &num_bytes, cuda_pbo_resource);

	// �� �ȼ����� rgba
	// count��ŭ�� ũ���� device �޸� ����(devPtr���� ����)�� value�� ���� ���� 
	cudaMemset(output, 0, WindowManager::GetInstance()->width * WindowManager::GetInstance()->height * 16);

	glm::mat4 view;
	// camera�� model matrix�� inverse�� �ٷ� view matrix
	// y�� �ڹٲ�� ����
	view = glm::inverse(camera->GetModelMatrix());

	// ���⼭ render�� �� �Ͼ
	RayTrace(output, view, triangles, lights, materials);

	cudaGraphicsUnmapResources(1, &cuda_pbo_resource, 0);

	glBindBuffer(GL_PIXEL_UNPACK_BUFFER, rayTracePBO);
	glBindTexture(GL_TEXTURE_2D, rayTracingTex.GetTexture());
	// pixels�� 0���� �����ν� ����� PBO�� ���� �ȼ� ������ ������
	glTexSubImage2D(
		GL_TEXTURE_2D, 0, 0, 0,
		WindowManager::GetInstance()->width,
		WindowManager::GetInstance()->height,
		GL_RGBA, GL_FLOAT, 0);
	glBindBuffer(GL_PIXEL_UNPACK_BUFFER, 0);
	// render end // 

	// draw on fbo
	SceneObject& quad = sceneManager->quadObj;
	quad.DrawModel();

	// draw on png
	if (writeFileNum < 5)
	{
		if(writeFileNum == 0)
			pngExporter.WritePngFile("bab.png", rayTracingTex);
		writeFileNum++;
	}
}

void RayTracingRenderer::TerminateRender()
{
}