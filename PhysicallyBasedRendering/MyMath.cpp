#include "MyMath.h"

//const double PI = 3.141592653589793238460;
//
//void FastFourierTransform(ComplexArray& x)
//{
//	const size_t N = x.size();
//	if (N <= 1) return;
//
//	// slice(offset, size, stride)
//	ComplexArray even = x[std::slice(0, N / 2, 2)];
//	ComplexArray odd = x[std::slice(1, N / 2, 2)];
//	
//	FastFourierTransform(even);
//	FastFourierTransform(odd);
//
//	for (int i = 0; i < N / 2; i++)
//	{
//		// polar(radius, theta)
//		// real + imag
//		Complex t = std::polar(1.0, -2 * PI*i / N) * odd[i];
//		x[i] = even[i] + t;
//		x[i + N / 2] = even[i] - t;
//	}
//}
//
//void InverseFastFourierTransform(ComplexArray& x)
//{
//	x = x.apply(std::conj);
//
//	FastFourierTransform(x);
//
//	x = x.apply(std::conj);
//
//	x /= x.size();
//}
