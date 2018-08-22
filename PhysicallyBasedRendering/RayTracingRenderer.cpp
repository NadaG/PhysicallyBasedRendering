#include "RayTracingRenderer.h"
#include "gpukdtree.cuh"
#include <chrono>
#include <cuda_runtime.h>
#include <cuda_gl_interop.h>
#include <ctime>
#include <random>

using namespace std::chrono;

void RayTracingRenderer::InitializeRender()
{
	debugQuadShader->Use();
	debugQuadShader->BindTexture(&rayTracingTex, "map");

	LoadCudaTextures();

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
	
	const int rayNum =
		(WindowManager::GetInstance()->width / gridX) *
		(WindowManager::GetInstance()->height / gridY);

	vec.resize(rayNum * sampleNum * 2);

	vector<Triangle> triangles = dynamic_cast<RayTracingSceneManager*>(sceneManager)->triangles;
	vector<Sphere> spheres = dynamic_cast<RayTracingSceneManager*>(sceneManager)->spheres;

	/*for (int i = 0; i < triangles.size(); i++)
	{
		aabb.bounds[0].x = 
			min(min(min(triangles[i].v0.x, triangles[i].v1.x), triangles[i].v2.x), aabb.bounds[0].x);
		aabb.bounds[0].y = 
			min(min(min(triangles[i].v0.y, triangles[i].v1.y), triangles[i].v2.y), aabb.bounds[0].y);
		aabb.bounds[0].z = 
			min(min(min(triangles[i].v0.z, triangles[i].v1.z), triangles[i].v2.z), aabb.bounds[0].z);

		aabb.bounds[1].x =
			max(max(max(triangles[i].v0.x, triangles[i].v1.x), triangles[i].v2.x), aabb.bounds[1].x);
		aabb.bounds[1].y =
			max(max(max(triangles[i].v0.y, triangles[i].v1.y), triangles[i].v2.y), aabb.bounds[1].y);
		aabb.bounds[1].z =
			max(max(max(triangles[i].v0.z, triangles[i].v1.z), triangles[i].v2.z), aabb.bounds[1].z);
	}
	
	for (int i = 0; i < spheres.size(); i++)
	{
		aabb.bounds[0].x = min(spheres[i].origin.x - spheres[i].radius, aabb.bounds[0].x);
		aabb.bounds[0].y = min(spheres[i].origin.y - spheres[i].radius, aabb.bounds[0].y);
		aabb.bounds[0].z = min(spheres[i].origin.z - spheres[i].radius, aabb.bounds[0].z);

		aabb.bounds[1].x = max(spheres[i].origin.x + spheres[i].radius, aabb.bounds[1].x);
		aabb.bounds[1].y = max(spheres[i].origin.y + spheres[i].radius, aabb.bounds[1].y);
		aabb.bounds[1].z = max(spheres[i].origin.z + spheres[i].radius, aabb.bounds[1].z);
	}
	time_t rawtime;
	struct tm* timeinfo;
	char buffer[80];

	time(&rawtime);
	timeinfo = localtime(&rawtime);

	strftime(buffer, sizeof(buffer), "%d-%m-%Y %I:%M:%S", timeinfo);
	std::string str(buffer);
	
	*/

	//char tmp[1024];
	//for (int i = 0; i < 500; i++)
	//{
	//	sprintf(tmp, "%04d", i);
	//	string infile = "";
	//	string outfile = "";
	//	infile += "Obj/PouringFluid/";
	//	infile += tmp;
	//	//infile += "0220";
	//	infile += ".obj";
	//	dynamic_cast<RayTracingSceneManager*>(sceneManager)->LoadFluidScene(infile);

	//	outfile += "fluid_raytracing3/";
	//	outfile += tmp;
	//	outfile += ".png";
	//	OfflineRender(outfile);
	//	cout << i << "번째 프레임 그리는 중" << endl;
	//	Sleep(5000.0f);
	//}

	//OfflineRender("0002.png");

	dynamic_cast<RayTracingSceneManager*>(sceneManager)->LoadFluidScene("Obj/PouringFluid/0250.obj");
	OfflineRender("0003.png");
}

// glm의 cross(a, b)는 오른손으로 a방향에서 b방향으로 감싸쥘 때의 엄지방향이다.
void RayTracingRenderer::Render()
{
	return;

	milliseconds bms = duration_cast<milliseconds>(system_clock::now().time_since_epoch());

	Object* camera = sceneManager->movingCamera;

	vector<Triangle> triangles = dynamic_cast<RayTracingSceneManager*>(sceneManager)->triangles;
	vector<Sphere> spheres = dynamic_cast<RayTracingSceneManager*>(sceneManager)->spheres;
	vector<Light> lights = dynamic_cast<RayTracingSceneManager*>(sceneManager)->lights;
	vector<Material> materials = dynamic_cast<RayTracingSceneManager*>(sceneManager)->materials;

	glViewport(0, 0, WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);
	UseDefaultFBO();
	ClearDefaultFBO();

	// render start //
	cudaGraphicsMapResources(1, &cuda_pbo_resource, 0);

	glm::vec4* output;
	size_t num_bytes;

	cudaGraphicsResourceGetMappedPointer((void**)&output, &num_bytes, cuda_pbo_resource);
	glm::mat4 view = camera->GetModelMatrix();

	///////////////////////////
	// build octree
	vec3 min = vec3(-100, -100, -100);
	vec3 max = vec3(100, 100, 100);

	cout << "triangles : " << triangles.size() << endl;
	cout << "build octree start" << endl;

	OctreeNode* root2 = BuildOctree((Triangle *)triangles.data(), triangles.size(), 1000, min, max);

	OctreeNode* octree = OTHostToDevice(root2);
	cout << "build octree end" << endl;

	///////////////////////////

	for (int i = 0; i < gridY; i++)
	{
		for (int j = 0; j < gridX; j++)
		{
			// Path Tracing
			std::random_device rd;
			std::mt19937 mersenne_engine(rd());
			std::uniform_real_distribution<> dis(0.0, 1.0);

			auto gen = [&dis, &mersenne_engine]() {return dis(mersenne_engine); };
			generate(begin(vec), end(vec), gen);

			//RayTrace(output, i, j, view, triangles, spheres, lights, materials, vec, octree);
		}
	}

	cudaGraphicsUnmapResources(1, &cuda_pbo_resource, 0);

	glBindBuffer(GL_PIXEL_UNPACK_BUFFER, rayTracePBO);
	glBindTexture(GL_TEXTURE_2D, rayTracingTex.GetTexture());
	// pixels를 0으로 함으로써 연결된 PBO로 부터 픽셀 정보를 가져옴
	glTexSubImage2D(
		GL_TEXTURE_2D, 0, 0, 0,
		WindowManager::GetInstance()->width,
		WindowManager::GetInstance()->height,
		GL_RGBA, GL_FLOAT, 0);
	glBindBuffer(GL_PIXEL_UNPACK_BUFFER, 0);
	// render end // 

	SceneObject& quad = sceneManager->quadObj;
	quad.DrawModel();

	milliseconds ams = duration_cast<milliseconds>(system_clock::now().time_since_epoch());
	cout << ams.count() - bms.count() << " milliseconds" << endl;
}

void RayTracingRenderer::TerminateRender()
{
}

void RayTracingRenderer::OfflineRender(const string outfile)
{
	milliseconds bms = duration_cast<milliseconds>(system_clock::now().time_since_epoch());

	Object* camera = sceneManager->movingCamera;

	vector<Triangle> triangles = dynamic_cast<RayTracingSceneManager*>(sceneManager)->triangles;
	vector<Sphere> spheres = dynamic_cast<RayTracingSceneManager*>(sceneManager)->spheres;
	vector<Light> lights = dynamic_cast<RayTracingSceneManager*>(sceneManager)->lights;
	vector<Material> materials = dynamic_cast<RayTracingSceneManager*>(sceneManager)->materials;

	glViewport(0, 0, WindowManager::GetInstance()->width, WindowManager::GetInstance()->height);
	UseDefaultFBO();
	ClearDefaultFBO();

	// render start //
	cudaGraphicsMapResources(1, &cuda_pbo_resource, 0);

	glm::vec4* output;
	size_t num_bytes;
	// cuda memory로부터 cpu memory로 포인터 위치를 가져오는 건가?
	cudaGraphicsResourceGetMappedPointer((void**)&output, &num_bytes, cuda_pbo_resource);
	glm::mat4 view = camera->GetModelMatrix();


	///////////////////////////////////////////////////////////
	// build octree
	vec3 min = vec3(-51, -51, -51);
	vec3 max = vec3(51, 51, 51);

	AABB rootAABB;
	rootAABB.bounds[0] = min;
	rootAABB.bounds[1] = max;

	OctreeNode* root1 = BuildOctree((Triangle *)triangles.data(), triangles.size(), 64, min, max);
	OctreeNode* octree = OTHostToDevice(root1);

	cout << "build octree end" << endl;

	//KDTreeNode* kdroot = BuildKDTree(triangles);

	cout << "triangles : "<<triangles.size() << endl;
	cout << "build octree" << endl;
	///////////////////////////////////////////////////////////



	///////////////////////////////////////////////////////////
	//perform gpu kd-tree algorithm
	time_t kdstart = clock();
	gpukdtree* gpuroot = new gpukdtree((Triangle *)triangles.data(), triangles.size(), rootAABB);
	gpuroot->create();
	time_t kdend = clock();
	cout << "gpu KD-Tree created in " << kdend - kdstart << endl;

	
	gpukdtreeNode* tmpnode0 = new gpukdtreeNode();
	cudaMemcpy(tmpnode0, &gpuroot->nodes.data[0], sizeof(gpukdtreeNode), cudaMemcpyDeviceToHost);

	gpukdtreeNode* tmpnode1 = new gpukdtreeNode();
	cudaMemcpy(tmpnode1, &gpuroot->nodes.data[1], sizeof(gpukdtreeNode), cudaMemcpyDeviceToHost);

	gpukdtreeNode* tmpnode2 = new gpukdtreeNode();
	cudaMemcpy(tmpnode2, &gpuroot->nodes.data[3], sizeof(gpukdtreeNode), cudaMemcpyDeviceToHost);
	
	cout << tmpnode0->triangleNumber << endl;

	cout << tmpnode0->nodeAABB.bounds[0].x << endl;
	cout << tmpnode0->nodeAABB.bounds[0].y << endl;
	cout << tmpnode0->nodeAABB.bounds[0].z << endl;

	cout << tmpnode0->nodeAABB.bounds[1].x << endl;
	cout << tmpnode0->nodeAABB.bounds[1].y << endl;
	cout << tmpnode0->nodeAABB.bounds[1].z << endl;

	cout << "=======================================" << endl;
	cout << tmpnode1->leftChild << endl;

	cout << tmpnode1->nodeAABB.bounds[0].x << endl;
	cout << tmpnode1->nodeAABB.bounds[0].y << endl;
	cout << tmpnode1->nodeAABB.bounds[0].z << endl;

	cout << tmpnode1->nodeAABB.bounds[1].x << endl;
	cout << tmpnode1->nodeAABB.bounds[1].y << endl;
	cout << tmpnode1->nodeAABB.bounds[1].z << endl;
	cout << "=======================================" << endl;
	cout << tmpnode2->leftChild << endl;

	cout << tmpnode2->nodeAABB.bounds[0].x << endl;
	cout << tmpnode2->nodeAABB.bounds[0].y << endl;
	cout << tmpnode2->nodeAABB.bounds[0].z << endl;

	cout << tmpnode2->nodeAABB.bounds[1].x << endl;
	cout << tmpnode2->nodeAABB.bounds[1].y << endl;
	cout << tmpnode2->nodeAABB.bounds[1].z << endl;
	///////////////////////////////////////////////////////////



	for (int i = 0; i < gridY; i++)
	{
		for (int j = 0; j < gridX; j++)
		{
			// Path Tracing
			std::random_device rd;
			std::mt19937 mersenne_engine(rd());
			std::uniform_real_distribution<> dis(0.0, 1.0);

			auto gen = [&dis, &mersenne_engine]() {return dis(mersenne_engine); };
			generate(begin(vec), end(vec), gen);

			RayTrace(output, i, j, view, triangles, spheres, lights, materials, vec, octree, gpuroot);
		}
	}

	cudaGraphicsUnmapResources(1, &cuda_pbo_resource, 0);

	glBindBuffer(GL_PIXEL_UNPACK_BUFFER, rayTracePBO);
	glBindTexture(GL_TEXTURE_2D, rayTracingTex.GetTexture());
	// pixels를 0으로 함으로써 연결된 PBO로 부터 픽셀 정보를 가져옴
	glTexSubImage2D(
		GL_TEXTURE_2D, 0, 0, 0,
		WindowManager::GetInstance()->width,
		WindowManager::GetInstance()->height,
		GL_RGBA, GL_FLOAT, 0);
	glBindBuffer(GL_PIXEL_UNPACK_BUFFER, 0);
	// render end // 

	// draw on fbo
	/*SceneObject& quad = sceneManager->quadObj;
	quad.DrawModel();*/

	// draw on png
	pngExporter.WritePngFile(outfile, rayTracingTex, GL_RGB);

	milliseconds ams = duration_cast<milliseconds>(system_clock::now().time_since_epoch());
	cout << ams.count() - bms.count() << " milliseconds" << endl;
}
