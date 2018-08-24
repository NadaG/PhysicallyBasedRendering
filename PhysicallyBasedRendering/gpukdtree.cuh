#include <thrust/functional.h>
#include <thrust/sort.h>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include "RayTracer.cuh"
#include <glm\common.hpp>

#pragma once
//#define GPUKDTREETHRESHOLD 7000
//#define GPUKDTREEMAXSTACK 7000

// optimize memory access
