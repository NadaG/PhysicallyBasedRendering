#include "Test.cuh"
#include <cuda.h>
#include <cuda_runtime.h>
#include <stdio.h>

__global__ void makernel(float* data)
{
	unsigned int i = blockIdx.x * blockDim.x + threadIdx.x;
	data[i] = 7.0f;
}

int hello(float* data)
{
	float* ddata;
	cudaMalloc((void**)&ddata, 3 * sizeof(float));

	makernel << <1, 3 >> > (ddata);

	cudaMemcpy(data, ddata, 3 * sizeof(float), cudaMemcpyDeviceToHost);

	cudaFree(ddata);
	cudaDeviceSynchronize();
	return 0;
}