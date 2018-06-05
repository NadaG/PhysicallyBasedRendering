//#include "MarchingMesh.h"
//
//
//MarchingMesh::MarchingMesh(void)
//{
//}
//
//
//MarchingMesh::~MarchingMesh(void)
//{
//}
//
//void MarchingMesh::ComputeFaceNormal()
//{
//	for (int i = 0; i < fList.size(); i += 3)
//	{
//		int idx1, idx2, idx3;
//		idx1 = fList[i];
//		idx2 = fList[i + 1];
//		idx3 = fList[i + 2];
//
//		glm::vec3 vecA;
//		vecA.x = vList[idx2].Position.x - vList[idx1].Position.x;
//		vecA.y = vList[idx2].Position.y - vList[idx1].Position.y;
//		vecA.z = vList[idx2].Position.z - vList[idx1].Position.z;
//
//		glm::vec3 vecB;
//		vecB.x = vList[idx3].Position.x - vList[idx1].Position.x;
//		vecB.y = vList[idx3].Position.y - vList[idx1].Position.y;
//		vecB.z = vList[idx3].Position.z - vList[idx1].Position.z;
//
//		glm::vec3 crossValue = glm::cross(vecA, vecB);
//		glm::vec3 normal = glm::normalize(crossValue);
//
//		nList.push_back(normal);
//	}
//
//}
//
//void MarchingMesh::DrawMesh(Vector3 color)
//{
//	GLfloat global_ambient[] = { 0.5, 0.5, 0.5,1.0 };
//
//	GLfloat light0_ambient[] = { 0.7, 0.7, 0.7,1.0 };
//	GLfloat light0_diffuse[] = { 0.6,0.6,0.6,1.0 };
//
//	GLfloat material_ambient[] = { 0.5, 0.5, 0.5, 1.0 };
//	GLfloat material_diffuse[] = { color.x, color.y, color.z,1.0 };
//
//	glShadeModel(GL_SMOOTH);
//	glEnable(GL_LIGHTING);
//
//	glEnable(GL_LIGHT0);
//	glLightfv(GL_LIGHT0, GL_AMBIENT, light0_ambient);
//	glLightfv(GL_LIGHT0, GL_DIFFUSE, light0_diffuse);
//
//	glMaterialfv(GL_FRONT, GL_DIFFUSE, material_diffuse);
//	glMaterialfv(GL_FRONT, GL_AMBIENT, material_ambient);
//
//	glLightModelfv(GL_LIGHT_MODEL_AMBIENT, global_ambient);
//	glLightModeli(GL_LIGHT_MODEL_LOCAL_VIEWER, GL_TRUE);
//
//	glEnable(GL_LIGHT0);
//	GLfloat LightPosition[] = { 64.0f, 128.0f, 64.0f, 1.0f };
//	glLightfv(GL_LIGHT0, GL_POSITION, LightPosition);
//	glFrontFace(GL_CCW);
//
//	glEnable(GL_LIGHTING);
//	glBegin(GL_TRIANGLES);
//
//	int nIndex = 0;
//	for (int index = 0; index < (int)fList.size(); index += 3)
//	{
//
//		int idx1, idx2, idx3;
//		idx1 = fList[index];
//		idx2 = fList[index + 1];
//		idx3 = fList[index + 2];
//
//		glNormal3f(nList[nIndex].x, nList[nIndex].y, nList[nIndex].z);
//
//		glVertex3f(vList[idx1].Position.x,
//			vList[idx1].Position.y,
//			vList[idx1].Position.z);
//
//		glVertex3f(vList[idx2].Position.x,
//			vList[idx2].Position.y,
//			vList[idx2].Position.z);
//
//		glVertex3f(vList[idx3].Position.x,
//			vList[idx3].Position.y,
//			vList[idx3].Position.z);
//
//		nIndex++;
//	}
//	glEnd();
//
//	glDisable(GL_LIGHTING);		//Lighting mode off
//}
//
//void MarchingMesh::DrawMesh()
//{
//	GLfloat global_ambient[] = { 0.5, 0.5, 0.5,1.0 };
//
//	GLfloat light0_ambient[] = { 0.7, 0.7, 0.7,1.0 };
//	GLfloat light0_diffuse[] = { 0.6,0.6,0.6,1.0 };
//
//	GLfloat material_ambient[] = { 0.5, 0.5, 0.5, 1.0 };
//	GLfloat material_diffuse[] = { 1.0,0.0,0.0,1.0 };
//
//	glShadeModel(GL_SMOOTH);
//	glEnable(GL_LIGHTING);
//
//	glEnable(GL_LIGHT0);
//	glLightfv(GL_LIGHT0, GL_AMBIENT, light0_ambient);
//	glLightfv(GL_LIGHT0, GL_DIFFUSE, light0_diffuse);
//
//	glMaterialfv(GL_FRONT, GL_DIFFUSE, material_diffuse);
//	glMaterialfv(GL_FRONT, GL_AMBIENT, material_ambient);
//
//	glLightModelfv(GL_LIGHT_MODEL_AMBIENT, global_ambient);
//	glLightModeli(GL_LIGHT_MODEL_LOCAL_VIEWER, GL_TRUE);
//
//	glEnable(GL_LIGHT0);
//	GLfloat LightPosition[] = { 64.0f, 128.0f, 64.0f, 1.0f };
//	glLightfv(GL_LIGHT0, GL_POSITION, LightPosition);
//	glFrontFace(GL_CCW);
//
//	glEnable(GL_LIGHTING);
//	glBegin(GL_TRIANGLES);
//
//	int nIndex = 0;
//	for (int index = 0; index < (int)fList.size(); index += 3)
//	{
//
//		int idx1, idx2, idx3;
//		idx1 = fList[index];
//		idx2 = fList[index + 1];
//		idx3 = fList[index + 2];
//
//		glNormal3f(nList[nIndex].x, nList[nIndex].y, nList[nIndex].z);
//
//		glVertex3f(vList[idx1].Position.x,
//			vList[idx1].Position.y,
//			vList[idx1].Position.z);
//
//		glVertex3f(vList[idx2].Position.x,
//			vList[idx2].Position.y,
//			vList[idx2].Position.z);
//
//		glVertex3f(vList[idx3].Position.x,
//			vList[idx3].Position.y,
//			vList[idx3].Position.z);
//
//		nIndex++;
//	}
//	glEnd();
//
//	glDisable(GL_LIGHTING);		//Lighting mode off
//}
//
//void MarchingMesh::ExportMesh()
//{
//	FILE *pFile;
//	char fileName[255];
//
//	sprintf_s(fileName, size_t(fileName), "ice_.obj");
//
//
//	fopen_s(&pFile, fileName, "w+t");
//	for (int i = 0; i < (int)vList.size(); i++)
//	{
//		Vector3 p = vList[i].Position;
//		fprintf(pFile, "v %f %f %f\n", p.x, p.y, p.z);
//	}
//
//	for (int i = 0; i < (int)fList.size(); i += 3)
//	{
//		fprintf(pFile, "f %d %d %d\n", fList[i] + 1, fList[i + 1] + 1, fList[i + 2] + 1);
//	}
//
//	for (int i = 0; i < (int)vList.size(); i++)
//	{
//		Vector3 n = vList[i].Normal;
//		fprintf(pFile, "vn %f %f %f\n", n.x, n.y, n.z);
//	}
//
//	fclose(pFile);
//
//}