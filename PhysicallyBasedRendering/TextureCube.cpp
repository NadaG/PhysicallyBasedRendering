#include "TextureCube.h"

void TextureCube::Bind(GLenum texture)
{
	glActiveTexture(texture);
	glBindTexture(GL_TEXTURE_CUBE_MAP, this->texture);
}

void TextureCube::LoadTexture(const string & s)
{
	/*equirectangularToCubemapShader->Use();
	equirectangularToCubemapShader->SetUniform1i("equirectangularMap", 0);
	equirectangularToCubemapShader->SetUniformMatrix4f("projection", captureProjection);

	glViewport(0, 0, 2048, 2048);
	captureFBO.Use();
	for (int i = 0; i < 6; i++)
	{
		equirectangularToCubemapShader->SetUniformMatrix4f("view", captureViews[i]);
		Bind(GL_TEXTURE0);
		captureFBO.BindTexture(GL_COLOR_ATTACHMENT0, GL_TEXTURE_CUBE_MAP_POSITIVE_X + i, &hdrSkyboxTex);
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

		sceneManager->skyboxObj.Draw();
	}

	hdrSkyboxTex.GenerateMipmap();*/
}

void TextureCube::LoadTextureCubeMap(const GLint& internalformat, const GLsizei& width, const GLsizei& height, const GLenum& format, const GLenum& type)
{
	glGenTextures(1, &texture);
	glBindTexture(GL_TEXTURE_CUBE_MAP, texture);

	for (int i = 0; i < 6; i++)
	{
		glTexImage2D(
			GL_TEXTURE_CUBE_MAP_POSITIVE_X + i,
			0,
			internalformat,
			width,
			height,
			0,
			format,
			type,
			nullptr);
	}
}

void TextureCube::LoadTextureCubeMap(vector<string> faces, const GLint& internalformat, const GLenum& format, const GLenum& type)
{
	glGenTextures(1, &texture);
	glBindTexture(GL_TEXTURE_CUBE_MAP, texture);

	int width, height, nrChannels;
	for (int i = 0; i < faces.size(); i++)
	{
		unsigned char* data = stbi_load(faces[i].c_str(), &width, &height, &nrChannels, 0);

		if (data)
		{
			glTexImage2D(
				GL_TEXTURE_CUBE_MAP_POSITIVE_X + i,
				0,
				internalformat,
				width,
				height,
				0,
				format,
				type,
				data);

			this->width = width;
			this->height = height;
		}
		else
		{
			cout << "Cubemap texture failed to load at path: " << faces[i] << endl;
			stbi_image_free(data);
		}
	}
}