#pragma once

#define BOOST_PYTHON_STATIC_LIB
#define BOOST_LIB_NAME "boost_numpy3"

#include <boost/config/auto_link.hpp>
#include <boost/python.hpp>
#include <boost/python/numpy.hpp>

#include "Debug.h"

namespace py = boost::python;
namespace np = boost::python::numpy;

class NormalEstimateModel
{
public:

	NormalEstimateModel();
	~NormalEstimateModel();

	// model�� load
	void LoadModel();

	// model�� input�� �־ output�� �̾� ��
	void UseModel(float* data);

private:

	py::object print;
	py::object tf_;
	py::object sys_;
	py::object sess;

	void InitializePython();
};