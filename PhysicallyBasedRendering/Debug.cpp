#include "Debug.h"

Debug* Debug::instance = nullptr;

void Debug::Log(const std::size_t& num)
{
	cout << num << endl;
}

void Debug::Log(const unsigned int& inum)
{
	cout << inum << endl;
}

void Debug::Log(const int& inum)
{
	cout << inum << endl;
}

void Debug::Log(const float& fnum)
{
	cout << std::fixed << std::setprecision(3) << fnum << endl;
}

void Debug::Log(const unsigned char & c)
{
	cout << c << endl;
}

void Debug::Log(const string& str)
{
	cout << str << endl;
}

void Debug::Log(const glm::mat4& mat)
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