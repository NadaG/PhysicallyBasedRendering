#include "Material.h"

Material::Material()
{
}

Material::~Material()
{
}

// pointer �ڿ� const�� ���� ���� 
void Material::BindShader(ShaderProgram* const shader)
{
	this->shader = shader;
}