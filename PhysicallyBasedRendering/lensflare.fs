#version 400 core

// noperspective를 사용하면 window-space에서 선형적으로 interpolated된다.
// noperspective in vec2 outUV;

// flat, 값이 interpolated되지 않는다.

// smooth, 값이 perpective-correct fashion으로 interpolated된다. default값이다.

// fract함수 fract(x) == x - floor(x)

