/*
 * Mesh.cpp
 *
 *  Created on: 2018. 6. 8.
 *      Author: DIGITALIDEA\d10513
 */

#include "Mesh.h"

Mesh::Mesh() {
	// TODO Auto-generated constructor stub

}

Mesh::~Mesh() {
	// TODO Auto-generated destructor stub
}

bool Mesh::LoadMesh(const char *fileName)
{

	int	minIdx = 1000000;

	//File Open
	std::ifstream fs;
	fs.open(fileName);

	if(fs.fail())
	{
		printf("-------Can not found File------ \n");
		printf("Please Check your FILE PATH \n");
		printf("-------------------------------\n");
		return false;
	}
	else
	{
		while(!fs.eof())
		{
			char n;
			fs >> n;

			std::string line;
			if( n == '#' )
			{
				getline(fs, line);
			}
			else if( n == 'v' )
			{
				float x, y, z;
				fs >> x;
				fs >> y;
				fs >> z;

				Vertex v;
				v.pos = glm::vec3(x, y, z);
				mVList.push_back(v);
			}
			else if ( n == 'f' )
			{
				int x, y, z;
				fs >> x;
				fs >> y;
				fs >> z;

				mFList.push_back(x);
				mFList.push_back(y);
				mFList.push_back(z);

				//Serch min face index
				minIdx = minValue(minIdx, x);
				minIdx = minValue(minIdx, y);
				minIdx = minValue(minIdx, z);
			}
		}
	}

	fs.close();

	//If minimum vertex idx is 1, then all vertex idx have to -1
	if( minIdx > 0 )
	{
#pragma omp parallel for		//omp acceleration
		for(int i = 0; i < mFList.size(); i ++)
		{
			mFList[i] -= 1;
		}
	}

	//Compute Vertex Normal
	ComputeVertexNormal();

	return true;
}


void Mesh::ComputeVertexNormal()
{
#pragma omp parallel for		//omp acceleration
	for(int i = 0; i < mFList.size(); i += 3)
	{
		int idx[3];
		idx[0] = mFList[i];
		idx[1] = mFList[i+1];
		idx[2] = mFList[i+2];

		glm::vec3 v1 = mVList[idx[1]].pos - mVList[idx[0]].pos;
		glm::vec3 v2 = mVList[idx[2]].pos - mVList[idx[0]].pos;

		glm::vec3 c_v1_v2 = cross(v1, v2);

		for(int j = 0; j < 3; j ++)
		{
			mVList[idx[j]].normal += c_v1_v2;
		}
	}

#pragma omp parallel for		//omp acceleration
	for(int i = 0; i < mVList.size(); i ++)
	{
		mVList[i].normal = normalize(mVList[i].normal);
	}
}

