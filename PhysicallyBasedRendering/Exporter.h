#ifndef _EXPORTER_
#define _EXPORTER_

#include<png.h>

#include "Texture2D.h"

class PNGExporter
{
public:
	PNGExporter(){}
	virtual ~PNGExporter(){}

	void WritePngFile(const string fileName, png_bytep* rowPointers,
		const int width, const int height, const png_byte bitDepth, const png_byte colorType);
	
	void WritePngFile(const string fileName, Texture2D texture);
	void WritePngFile(const string fileName, float* data, const int width, const int height);

private:

	const string exportDir = "./ExportData/";
};

#endif
