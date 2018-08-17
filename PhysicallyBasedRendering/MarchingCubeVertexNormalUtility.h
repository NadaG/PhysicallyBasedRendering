/*
*  utility.h
*  flip3D
*
*/

#ifndef _UTILITY_H
#define _UTILITY_H

template <class T> T *** alloc3D(int w, int h, int d) {
	T *** field = new T **[w+1];
	for (int i = 0; i<w; i++) {
		field[i] = new T*[h+1];
		for (int j = 0; j<h; j++) {
			field[i][j] = new T[d+1];
		}
		field[i][h] = NULL;
	}
	field[w] = NULL;
	return field;
}

template <class T> void free3D(T ***ptr) {
	for (int i = 0; ptr[i] != NULL; i++) {
		for (int j = 0; ptr[i][j] != NULL; j++) delete[] ptr[i][j];
		delete[] ptr[i];
	}
	delete[] ptr;
}

#endif
