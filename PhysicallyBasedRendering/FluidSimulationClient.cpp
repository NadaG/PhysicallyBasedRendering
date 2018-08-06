#include "FluidSimulationClient.h"

void FluidSimulationClient::Initialize(const glm::vec3 boundarySize, FluidCube * cubes, int cubeNum)
{
	InitializeSocket();

	// send an initial buffer
	Send(0);

	// receive particle num
	iResult = recv(ConnectSocket, (char *)&particleNum, 4, 0);

	pos = new float[particleNum * 3];
}

void FluidSimulationClient::Update(GLfloat* v)
{
	Send(1);

	const size_t total_bytes = 4 * 3 * particleNum;

	size_t now_total_bytes = 0;
	int whileNum = 0;

	//char* posBytes = new char[total_bytes];

	/*const size_t total_bytes = 120;
	float* test = new float[30];*/
	const size_t per_bytes = 400;
	
	while (now_total_bytes < total_bytes)
	{
		whileNum++;
		if (now_total_bytes + per_bytes <= total_bytes)
		{
			/*iResult = recv(ConnectSocket, (char*)test + now_total_bytes, per_bytes, 0);
			now_total_bytes += per_bytes;*/

			iResult = recv(ConnectSocket, (char*)pos + now_total_bytes, per_bytes, 0);
			now_total_bytes += per_bytes;

			/*float f;
			memcpy(&f, (char*)pos + now_total_bytes, 4);
			cout << f << endl;
			cout << "while °³¼ö: " << whileNum << endl;*/
		}
		else
		{
			//iResult = recv(ConnectSocket, (char*)test + now_total_bytes, total_bytes - now_total_bytes, 0);

			iResult = recv(ConnectSocket, (char*)pos + now_total_bytes, total_bytes - now_total_bytes, 0);

			//cout << iResult << endl;
			break;
		}

		//cout << "now total bytes" << now_total_bytes << endl;
		//Sleep(100);
		//Sleep(10);
	}

	cout << "after recv: " << pos[0] << " " << pos[1] << " " << pos[2] << endl;
	//cout << iResult << endl;

	for (int i = 0; i < particleNum; i++)
	{
		v[i * 6 + 0] = pos[i * 3 + 0];
		v[i * 6 + 1] = pos[i * 3 + 1];
		v[i * 6 + 2] = pos[i * 3 + 2];

		/*	
		v[i * 6 + 0] = ntohl(pos[i * 3 + 0]);
		v[i * 6 + 1] = ntohl(pos[i * 3 + 1]);
		v[i * 6 + 2] = ntohl(pos[i * 3 + 2]);*/
		//v[i * 6 + 4] = vel[i * 3 + 0];
		//v[i * 6 + 5] = vel[i * 3 + 1];
		//v[i * 6 + 6] = vel[i * 3 + 2];
	}
}

void FluidSimulationClient::Quit()
{
	Send(2);

	delete[] pos;
}

void FluidSimulationClient::InitializeSocket()
{
	WSADATA wsaData;
	struct addrinfo *result = NULL, *ptr = NULL, hints;

	// Initialize Winsock
	iResult = WSAStartup(MAKEWORD(2, 2), &wsaData);
	if (iResult != 0)
	{
		printf("WSAStartup failed with error: %d\n", iResult);
		return;
	}

	ZeroMemory(&hints, sizeof(hints));
	hints.ai_family = AF_UNSPEC;
	hints.ai_socktype = SOCK_STREAM;
	hints.ai_protocol = IPPROTO_TCP;

	// Resolve the server address and port
	iResult = getaddrinfo("163.152.20.223", DEFAULT_PORT, &hints, &result);
	if (iResult != 0)
	{
		printf("getaddrinfo failed with error: %d\n", iResult);
		WSACleanup();
		return;
	}

	// Attempt to connect to an address until one succeeds
	for (ptr = result; ptr != NULL; ptr = ptr->ai_next)
	{
		// Create a SOCKET for connecting to server
		ConnectSocket = socket(ptr->ai_family, ptr->ai_socktype, ptr->ai_protocol);

		if (ConnectSocket == INVALID_SOCKET)
		{
			printf("socket failed with error: %ld\n", WSAGetLastError());
			WSACleanup();
			return;
		}

		// Connect to server.
		iResult = connect(ConnectSocket, ptr->ai_addr, (int)ptr->ai_addrlen);
		if (iResult == SOCKET_ERROR)
		{
			closesocket(ConnectSocket);
			ConnectSocket = INVALID_SOCKET;
			continue;
		}

		break;
	}

	freeaddrinfo(result);

	if (ConnectSocket == INVALID_SOCKET)
	{
		printf("Unable to connect to server!\n");
		WSACleanup();
		return;
	}
}

void FluidSimulationClient::Send(int val)
{
	iResult = send(ConnectSocket, (char *)&val, 4, 0);
	if (iResult == SOCKET_ERROR)
	{
		printf("send failed with error: %d\n", WSAGetLastError());
		closesocket(ConnectSocket);
		WSACleanup();
		return;
	}
}
