#include "Test.cuh"
#include <cuda.h>
#include <cuda_runtime.h>
#include <stdio.h>

__global__ void TestFunctionD(float* data)
{
	unsigned int i = blockIdx.x * blockDim.x + threadIdx.x;
	data[i] = 7.0f;
}

int TestFunction(float* data)
{
	float* ddata;
	cudaMalloc((void**)&ddata, 3 * sizeof(float));

	TestFunctionD << <1, 3 >> > (ddata);

	cudaMemcpy(data, ddata, 3 * sizeof(float), cudaMemcpyDeviceToHost);

	cudaFree(ddata);
	cudaDeviceSynchronize();
	return 0;
}

__global__ void pboTestD(float* data)
{
	unsigned int x = blockIdx.x * blockDim.x + threadIdx.x;

	switch (x % 4)
	{
	case 0:
		data[x] = 1.0f;
		break;
	case 1:
		data[x] = 0.0f;
		break;
	case 2:
		data[x] = 1.0f;
		break;
	default:
		data[x] = 1.0f;
		break;
	}
}

void pboTest(float* data)
{
	pboTestD << <1024 * 4, 1024 >> > (data);
}