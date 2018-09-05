#include "Debug.h"

Debug* Debug::instance = nullptr;

void Debug::Log(const std::size_t num)
{
	cout << num << endl;
}

void Debug::Log(const unsigned int inum)
{
	cout << inum << endl;
}

void Debug::Log(const int inum)
{
	cout << inum << endl;
}

void Debug::Log(const float fnum)
{
	cout << std::fixed << std::setprecision(3) << fnum << endl;
}

void Debug::Log(const double dnum)
{
	cout << dnum << endl;
}

void Debug::Log(const unsigned char & c)
{
	cout << c << endl;
}

void Debug::Log(const string& str)
{
	cout << str << endl;
}

void Debug::Log(const glm::mat3 mat)
{
	cout << mat[0][0] << " " << mat[1][0] << " " << mat[2][0] << endl;
	cout << mat[0][1] << " " << mat[1][1] << " " << mat[2][1] << endl;
	cout << mat[0][2] << " " << mat[1][2] << " " << mat[2][2] << endl;
}

// glm 및 glsl은 column major이다.
// 이 말은 메모리 배열이 column 순서대로 저장된다는 것이다.
// 이차원 배열로 표현한 경우 [0][0]은 1행1열, [0][1]은 2행 1열이라는 말이다.
// 일차원 배열로 표현한 경우 [0]은 1행 1열, [1]은 2행 1열이라는 말이다.
void Debug::Log(const glm::mat4 mat)
{
	cout << mat[0][0] << " " << mat[1][0] << " " << mat[2][0] << " " << mat[3][0] << endl;
	cout << mat[0][1] << " " << mat[1][1] << " " << mat[2][1] << " " << mat[3][1] << endl;
	cout << mat[0][2] << " " << mat[1][2] << " " << mat[2][2] << " " << mat[3][2] << endl;
	cout << mat[0][3] << " " << mat[1][3] << " " << mat[2][3] << " " << mat[3][3] << endl;
}

void Debug::Log(const glm::vec3 vec)
{
	cout << "x: " << vec.x << " y: " << vec.y << " z: " << vec.z << endl;
}

void Debug::Log(const glm::vec2 vec)
{
	cout << "x: " << vec.x << " y: " << vec.y << endl;
}

// TODO
//void Debug::Log(const char * format, ...)
//{
//	/*va_list* arg;
//	__va_start(arg, format);
//	vfprintf(stdout, format, *arg);
//	__crt_va_end(*arg);*/
//}
