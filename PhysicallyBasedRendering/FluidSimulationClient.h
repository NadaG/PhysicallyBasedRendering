#define WIN32_LEAN_AND_MEAN

#include <windows.h>
#include <winsock2.h>
#include <ws2tcpip.h>
#include <stdlib.h>
#include <stdio.h>
#include <iostream>

#include <vector>

#include <thread>

#include <GL\glew.h>
#include <GL\freeglut.h>

#include <glm\common.hpp>

// Need to link with Ws2_32.lib, Mswsock.lib, and Advapi32.lib
#pragma comment (lib, "Ws2_32.lib")
#pragma comment (lib, "Mswsock.lib")
#pragma comment (lib, "AdvApi32.lib")

#define DEFAULT_BUFLEN 512
#define DEFAULT_PORT "27015"

using namespace std;

struct SimulationParam;
struct ObstacleSphere;
struct FluidCube;

class FluidSimulationClient
{
public:
	FluidSimulationClient() { ConnectSocket = INVALID_SOCKET; }
	~FluidSimulationClient() {}

	void Initialize(const glm::vec3 boundarySize, FluidCube* cubes, int cubeNum);
	void Update(GLfloat* v);
	void Quit();

	int particleNum;

	float* pos;
	float* vel;
	int* issur;

	SOCKET ConnectSocket;

private:

	void InitializeSocket();

	void Send(int val);
	int iResult;
};

//
//float* pos_vec;
//SOCKET ConnectSocket;
//int particleNum;
//
//void synchronize_server()
//{
//	int iResult;
//	int32_t val = 1;
//	iResult = send(ConnectSocket, (char *)&val, 4, 0);
//	if (iResult == SOCKET_ERROR)
//	{
//		printf("send failed with error: %d\n", WSAGetLastError());
//		closesocket(ConnectSocket);
//		WSACleanup();
//	}
//
//	const size_t per_bytes = 1024 * 128;
//	const size_t total_bytes = 4 * 3 * particleNum;
//	size_t now_total_bytes = 0;
//	int whileNum = 0;
//
//	while (now_total_bytes < total_bytes)
//	{
//		whileNum++;
//		if (now_total_bytes + per_bytes <= total_bytes)
//		{
//			iResult = recv(ConnectSocket, (char*)pos_vec + now_total_bytes, per_bytes, 0);
//			now_total_bytes += per_bytes;
//
//			cout << iResult << endl;
//		}
//		else
//		{
//			iResult = recv(ConnectSocket, (char*)pos_vec + now_total_bytes, total_bytes - now_total_bytes, 0);
//			cout << iResult << endl;
//			break;
//		}
//	}
//
//	//printf("%f %f %f\n\n", pos_vec[0], pos_vec[1], pos_vec[2]);
//}
//
//int test = 0;
//
//void render()
//{
//	glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
//	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
//
//	glPointSize(3.0f);
//	glBegin(GL_POINTS);
//	glColor3f(1.0f, 0.0f, 0.0f);
//
//	if (test < 1000)
//		synchronize_server();
//
//	for (int i = 0; i < particleNum; i++)
//	{
//		glVertex3f(pos_vec[i * 3 + 0], pos_vec[i * 3 + 1], pos_vec[i * 3 + 2]);
//	}
//
//	glEnd();
//
//	glutSwapBuffers();
//
//	test++;
//}
//
//void reshape(int w, int h)
//{
//	glViewport(0, 0, w, h);
//	glutPostRedisplay();
//
//	glMatrixMode(GL_PROJECTION);
//	glLoadIdentity();
//	gluPerspective(45.0f, w / h, 0.01f, 100.0f);
//
//	glMatrixMode(GL_MODELVIEW);
//	glLoadIdentity();
//	gluLookAt(1.0f, 0.0f, 50.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f);
//}
//
//void idle()
//{
//	glutPostRedisplay();
//}
//
//void InitializeOpenGL(int argc, char** argv)
//{
//	glutInit(&argc, argv);
//	glutInitDisplayMode(GLUT_RGBA | GLUT_DOUBLE);
//
//	glutInitWindowSize(500, 500);
//	glutCreateWindow("title");
//
//	glEnable(GL_POINT_SIZE);
//
//	glutDisplayFunc(render);
//	glutIdleFunc(idle);
//	glutReshapeFunc(reshape);
//
//	glutMainLoop();
//}
//
//// thread를 열어서 server와 통신한다
//// thread는 일정 시간마다 서버에 패킷을 보내 position 데이터를 불러온다
//// 불러온 데이터를 이용해 client에서 rendering 한다.
//
//SOCKET InitializeSimulation(int* particleNum)
//{
//	WSADATA wsaData;
//	SOCKET ConnectSocket = INVALID_SOCKET;
//	struct addrinfo *result = NULL,
//		*ptr = NULL,
//		hints;
//	char recvbuf[DEFAULT_BUFLEN];
//	int iResult;
//	int recvbuflen = DEFAULT_BUFLEN;
//
//	// Initialize Winsock
//	iResult = WSAStartup(MAKEWORD(2, 2), &wsaData);
//	if (iResult != 0)
//	{
//		printf("WSAStartup failed with error: %d\n", iResult);
//		return 1;
//	}
//
//	ZeroMemory(&hints, sizeof(hints));
//	hints.ai_family = AF_UNSPEC;
//	hints.ai_socktype = SOCK_STREAM;
//	hints.ai_protocol = IPPROTO_TCP;
//
//	// Resolve the server address and port
//	iResult = getaddrinfo("163.152.20.223", DEFAULT_PORT, &hints, &result);
//	if (iResult != 0)
//	{
//		printf("getaddrinfo failed with error: %d\n", iResult);
//		WSACleanup();
//		return 1;
//	}
//
//	// Attempt to connect to an address until one succeeds
//	for (ptr = result; ptr != NULL; ptr = ptr->ai_next)
//	{
//		// Create a SOCKET for connecting to server
//		ConnectSocket = socket(ptr->ai_family, ptr->ai_socktype, ptr->ai_protocol);
//
//		if (ConnectSocket == INVALID_SOCKET)
//		{
//			printf("socket failed with error: %ld\n", WSAGetLastError());
//			WSACleanup();
//			return 1;
//		}
//
//		// Connect to server.
//		iResult = connect(ConnectSocket, ptr->ai_addr, (int)ptr->ai_addrlen);
//		if (iResult == SOCKET_ERROR)
//		{
//			closesocket(ConnectSocket);
//			ConnectSocket = INVALID_SOCKET;
//			continue;
//		}
//
//		break;
//	}
//
//	freeaddrinfo(result);
//
//	if (ConnectSocket == INVALID_SOCKET)
//	{
//		printf("Unable to connect to server!\n");
//		WSACleanup();
//		return 1;
//	}
//
//	// Send an initial buffer
//	int val = 0;
//	iResult = send(ConnectSocket, (char *)&val, 4, 0);
//	if (iResult == SOCKET_ERROR)
//	{
//		printf("send failed with error: %d\n", WSAGetLastError());
//		closesocket(ConnectSocket);
//		WSACleanup();
//		return 1;
//	}
//
//	iResult = recv(ConnectSocket, (char *)particleNum, 4, 0);
//
//	cout << *particleNum << endl;
//
//	return ConnectSocket;
//}
//
//// c declaration
//int __cdecl maint(int argc, char **argv)
//{
//	ConnectSocket = InitializeSimulation(&particleNum);
//	pos_vec = new float[particleNum * 3];
//
//	InitializeOpenGL(argc, argv);
//
//	int iResult;
//	int32_t val = 2;
//	iResult = send(ConnectSocket, (char *)&val, 4, 0);
//
//	closesocket(ConnectSocket);
//	WSACleanup();
//
//	delete[] pos_vec;
//
//	return 0;
//}