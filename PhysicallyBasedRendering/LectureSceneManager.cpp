#include "LectureSceneManager.h"

void LectureSceneManager::InitializeObjects()
{
	cout << endl;
	quadObj.LoadModel(QUAD);

	MATRIX a;
	a.ele[0][0] = 1.0f; a.ele[0][1] = 0.0f; a.ele[0][2] = 1.0f;
	a.ele[1][0] = 0.0f; a.ele[1][1] = 3.0f; a.ele[1][2] = 2.0f;
	a.ele[2][0] = 0.0f; a.ele[2][1] = 4.0f; a.ele[2][2] = 1.0f;

	float det = a.Determinant();
	cout << "determinant 값: " << det << endl;


	cout << a.ele[0][0] << " " << a.ele[0][1] << " " << a.ele[0][2] << endl;
	cout << a.ele[1][0] << " " << a.ele[1][1] << " " << a.ele[1][2] << endl;
	cout << a.ele[2][0] << " " << a.ele[2][1] << " " << a.ele[2][2] << endl;

	/*MATRIX b;
	b.ele[0][0] = 1.0f; b.ele[0][1] = 0.0f; b.ele[0][2] = 0.0f;
	b.ele[1][0] = 0.0f; b.ele[1][1] = 1.0f; b.ele[1][2] = 0.0f;
	b.ele[2][0] = 0.0f; b.ele[2][1] = 0.0f; b.ele[2][2] = 1.0f;

	MATRIX c = a + b;*/

	//cout << "m11: " << a.ele[0][0] << " m12: " << a.ele[0][1] << " m13: " << a.ele[0][2] << endl;
	//cout << "m21: " << a.ele[1][0] << " m22: " << a.ele[1][1] << " m23: " << a.ele[1][2] << endl;
	//cout << "m31: " << a.ele[2][0] << " m32: " << a.ele[2][1] << " m33: " << a.ele[2][2] << endl << endl;


	/*VECTOR3D a = VECTOR3D(0.5f, 1.0f, 0.0f);
	VECTOR3D b = VECTOR3D(5.0f, 0.0f, -3.0f);

	VECTOR3D c = a + b;

	cout << "x: " << c.x << " y: " << c.y << " z: " << c.z << endl;

	cout << endl;
	
	float t = 3.0f;
	VECTOR3D d = t * a;

	cout << "x: " << d.x << " y: " << d.y << " z: " << d.z << endl;*/

	
	//float c = a.InnerProduct(b);

	//cout << "inner product 값: " << c << endl;

	//float magnitude = a.Magnitude();

	//cout << "magnitude 값: " << magnitude << endl;

	/*VECTOR3D b = VECTOR3D(3.0f, 2.0f, 1.0f);
	
	VECTOR3D c = a.CrossProduct(b);

	cout << "x: " << c.x << " y: " << c.y << " z: " << c.z << endl;*/

	//VECTOR3D a = VECTOR3D(3.0f, 4.0f, 2.0f);
	//a.Normalize();

	//cout << "x: " << a.x << " y: " << a.y << " z: " << a.z << endl;


	//// xy 평면의 법선벡터는 (0.0, 0.0, 1.0)
	//VECTOR3D xyPlane = VECTOR3D(0.0f, 0.0f, 1.0f);
	//// 2x + 2y - z + 5 = 0 평면의 법선벡터는 (2.0, 2.0, -1.0)
	//VECTOR3D plane = VECTOR3D(2.0f, 2.0f, -1.0f);

	//// 내적을 통해 cosTheta 구하는 공식을 이용 
	//float cosTheta = abs(xyPlane.InnerProduct(plane)) / (xyPlane.Magnitude() * plane.Magnitude());

	//// 정답 출력
	//cout << "cosTheta 값:" << cosTheta << endl;
	//cout << endl << endl;
	//
	//// P점
	//// Q점

	//VECTOR3D V = VECTOR3D(1.5f, 0.2f, 3.0f);

	//// 행렬

	//VECTOR2D P = VECTOR2D(2.0f, -1.0f);
	//
	//MATRIX matrix;
	//matrix.ele[0][0] = 1.0f;
	//matrix.ele[0][1] = 2.0f;
	//matrix.ele[1][0] = -2.0f;
	//matrix.ele[1][1] = 1.0f;

	//VECTOR2D Q = matrix * P;

	//cout << "x: " << Q.x << " y: " << Q.y << endl;


	//// PQ 직선의 기울기 계산
	//float inclination = (Q.y - P.y) / (Q.x - P.x);
	//cout << "기울기 값:" << inclination << endl;

	//MATRIX iden;

	//iden.ele[0][0] = 1.0f;
	//iden.ele[1][1] = 1.0f;
	//iden.ele[2][2] = 1.0f;

	//MATRIX inv = iden.Inverse();

	//for (int i = 0; i < 3; i++)
	//	for (int j = 0; j < 3; j++)
	//		cout << iden.ele[i][j] << endl;

	//cout << endl << endl;
}

void LectureSceneManager::Update()
{
}