#include "Test.cuh"
#include <cuda.h>
#include <cuda_runtime.h>
#include <stdio.h>

__global__ void makernel()
{
	unsigned int i = blockIdx.x * blockDim.x + threadIdx.x;
	printf("%d", i);
	printf("Hello from mykernel\n");
}

int hello()
{
	makernel << <1, 10 >> > ();
	cudaDeviceSynchronize();
	return 0;
}