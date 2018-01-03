#include "Material.h"

Material::Material()
{
}

Material::~Material()
{
}

// pointer 뒤에 const가 붙은 것은 
void Material::BindShader(ShaderProgram* const shader)
{
	this->shader = shader;
}