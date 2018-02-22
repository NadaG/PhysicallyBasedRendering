#include "Exporter.h"

#include "Debug.h"

// new를 해서 보내고 함수 내에서 delete가 됨
void PNGExporter::WritePngFile(const string fileName, png_bytep* rowPointers, const int width, const int height, const png_byte bitDepth, const png_byte colorType)
{
	png_structp png_ptr;
	png_infop info_ptr;

	/* create file */
	FILE *fp = fopen((exportDir + fileName).c_str(), "wb");
	
	/* initialize stuff */
	png_ptr = png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);

	info_ptr = png_create_info_struct(png_ptr);
	
	setjmp(png_jmpbuf(png_ptr));
	
	png_init_io(png_ptr, fp);

	/* write header */
	setjmp(png_jmpbuf(png_ptr));
	
	png_set_IHDR(png_ptr, info_ptr, width, height,
		bitDepth, colorType, PNG_INTERLACE_NONE,
		PNG_COMPRESSION_TYPE_BASE, PNG_FILTER_TYPE_BASE);

	png_write_info(png_ptr, info_ptr);

	/* write bytes */
	setjmp(png_jmpbuf(png_ptr));

	int colorChannel;
	switch (colorType)
	{
	case PNG_COLOR_TYPE_RGB:
		colorChannel = 3;
		break;
	case PNG_COLOR_TYPE_RGBA:
		colorChannel = 4;
		break;
	default:
		colorChannel = 4;
		break;
	}

	const int byteDepth = bitDepth / 8;

	png_write_image(png_ptr, rowPointers);

	png_write_end(png_ptr, NULL);

	fclose(fp);
}

void PNGExporter::WritePngFile(const string fileName, Texture2D texture)
{
	// pointer는 reture으로 써야하는 구나
	float* texData = texture.TexImage();
	WritePngFile(fileName, texData, texture.GetWidth(), texture.GetHeight());
}

void PNGExporter::WritePngFile(const string fileName, float* data, const int width, const int height)
{
	png_bytep* rawData = new png_bytep[height];

	for (int i = 0; i < height; i++)
		rawData[i] = new png_byte[width * 4];

	for (int i = 0; i < height; ++i)
	{
		for (int j = 0; j < width; ++j)
		{
			rawData[height - i - 1][j * 4 + 0] = (png_byte)floor(data[(i * width + j) * 4 + 0] * 255.0f);
			rawData[height - i - 1][j * 4 + 1] = (png_byte)floor(data[(i * width + j) * 4 + 1] * 255.0f);
			rawData[height - i - 1][j * 4 + 2] = (png_byte)floor(data[(i * width + j) * 4 + 2] * 255.0f);
			rawData[height - i - 1][j * 4 + 3] = 255;
		}
	}

	WritePngFile(fileName, rawData, width, height, 8, PNG_COLOR_TYPE_RGBA);
}