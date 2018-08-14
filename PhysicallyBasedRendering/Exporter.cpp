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
	case PNG_COLOR_TYPE_GRAY:
		colorChannel = 1;
		break;
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

void PNGExporter::WritePngFile(const string fileName, Texture2D texture, GLenum format)
{
	// pointer는 reture으로 써야하는 구나
	float* texData = texture.GetTexImage(format);

	png_byte colorType;
	
	switch (format)
	{
	case GL_R:
		colorType = PNG_COLOR_TYPE_GRAY;
		break;
	case GL_RGB:
		colorType = PNG_COLOR_TYPE_RGB;
		break;
	case GL_RGBA:
		colorType = PNG_COLOR_TYPE_RGBA;
		break;
	default:
		colorType = PNG_COLOR_TYPE_RGB;
		break;
	}

	WritePngFile(fileName, texData, texture.GetWidth(), texture.GetHeight(), colorType);
}

void PNGExporter::WritePngFile(const string fileName, float* data, const int width, const int height, const png_byte colorType)
{
	png_bytep* rawData = new png_bytep[height];

	int channel = 0;
	switch (colorType)
	{
	case PNG_COLOR_TYPE_GRAY:
		channel = 1;
		break;
	case PNG_COLOR_TYPE_RGB:
		channel = 3;
		break;
	case PNG_COLOR_TYPE_RGBA:
		channel = 4;
		break;
	default:
		break;
	}

	for (int i = 0; i < height; i++)
		rawData[i] = new png_byte[width * channel];

	for (int i = 0; i < height; ++i)
	{
		for (int j = 0; j < width; ++j)
		{
			for (int k = 0; k < channel; k++)
			{
				data[(i * width + j) * channel + k] = glm::clamp(data[(i * width + j) * channel + k], 0.0f, 1.0f);
				rawData[height - i - 1][j * channel + k] = (png_byte)floor(data[(i * width + j) * channel + k] * 255.0f);
				//rawData[height - i - 1][j * channel + 3] = 255;
			}
		}
	}

	delete[] data;
	WritePngFile(fileName, rawData, width, height, 8, colorType);
}

png_bytep* PNGExporter::ReadPngFile(const string fileName, int& width, int& height)
{
	// 8 is the maximum size that can be checked
	/* open file and test for it being a png */
	//png_const_bytep header;
	
	char header[8];
	FILE *fp = fopen(fileName.c_str(), "rb");

	fread(header, 1, 8, fp);
	png_sig_cmp((png_const_bytep)header, 0, 8);

	/* initialize stuff */
	png_structp png_ptr;
	png_ptr = png_create_read_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);

	png_infop info_ptr;
	info_ptr = png_create_info_struct(png_ptr);

	setjmp(png_jmpbuf(png_ptr));

	png_init_io(png_ptr, fp);
	png_set_sig_bytes(png_ptr, 8);

	png_read_info(png_ptr, info_ptr);

	png_byte color_type, bit_depth;
	width = png_get_image_width(png_ptr, info_ptr);
	height = png_get_image_height(png_ptr, info_ptr);
	color_type = png_get_color_type(png_ptr, info_ptr);
	bit_depth = png_get_bit_depth(png_ptr, info_ptr);

	int number_of_passes;
	number_of_passes = png_set_interlace_handling(png_ptr);
	png_read_update_info(png_ptr, info_ptr);

	/* read file */
	setjmp(png_jmpbuf(png_ptr));

	png_bytep* row_pointers;
	row_pointers = new png_bytep[height];
	for (int i = 0; i < height; i++)
		row_pointers[i] = new png_byte[png_get_rowbytes(png_ptr, info_ptr)];

	png_read_image(png_ptr, row_pointers);

	/*for (int i = 0; i < height; i++)
	{
		for (int j = 0; j < width; j++)
			cout << row_pointers[i][j] << endl;
	}*/

	fclose(fp);

	return row_pointers;
}

png_bytep* PNGExporter::SumPng(png_bytep* a, const string fileName)
{
	int width, height;
	png_bytep* b = ReadPngFile(fileName, width, height);

	png_bytep* c = new png_bytep[1024];
	for (int i = 0; i < 1024; i++)
		c[i] = new png_byte[4096];

	for (int i = 0; i < 1024; i++)
	{
		for (int j = 0; j < 4096; j++)
		{
			int aCol = a[i][j];
			int bCol = b[i][j];
			if (aCol + bCol > 255)
				c[i][j] = 255;
			else
				c[i][j] = a[i][j] + b[i][j];
		}
	}

	return c;
}

png_bytep* PNGExporter::SumPng(const string fileNameA, const string fileNameB)
{
	int width, height;
	png_bytep* a = ReadPngFile(fileNameA, width, height);
	png_bytep* b = ReadPngFile(fileNameB, width, height);

	png_bytep* c = new png_bytep[1024];
	for (int i = 0; i < 1024; i++)
		c[i] = new png_byte[4096];

	for (int i = 0; i < 1024; i++)
	{
		for (int j = 0; j < 4096; j++)
		{
			int aCol = a[i][j];
			int bCol = b[i][j];
			if (aCol + bCol > 255)
				c[i][j] = 255;
			else
				c[i][j] = a[i][j] + b[i][j];
		}
	}

	delete[] a;
	delete[] b;

	return c;
}
