#include "NormalEstimateModel.h"

NormalEstimateModel::NormalEstimateModel()
{
	InitializePython();
}

NormalEstimateModel::~NormalEstimateModel()
{
	sess.attr("close");
}

void NormalEstimateModel::InitializePython()
{
	Py_SetPythonHome(L"C:\\Users\\RENDER4\\AppData\\Local\\Programs\\python-3.6.3-h9e2ca53_1");

	Py_Initialize();
	np::initialize();

	py::object main_module = py::import("__main__");
	py::object main_namespace = main_module.attr("__dict__");

	sys_ = py::import("sys");
	PyRun_SimpleString("import sys\n""sys.argv=['']\n");

	string version = py::extract<string>(sys_.attr("version"));

	print = py::import("__main__").attr("__builtins__").attr("print");

	tf_ = py::import("tensorflow");
	
	sess = tf_.attr("Session")();

	

	/*const np::ndarray d1 = np::array(py::make_tuple(1.0f, 2.0f, 3.0f, 4.0f));
	const np::ndarray d2 = np::array(py::make_tuple(5.0f, 6.0f, 7.0f, 9.0f));

	const py::object x1 = tf_.attr("constant")(d1);
	const py::object x2 = tf_.attr("constant")(d2);

	const py::object result = tf_.attr("multiply")(x1, x2);
	
	print(sess.attr("run")(result));
	sess.attr("close");*/
}

void NormalEstimateModel::glutDisplayFunc(void(*fun)(int b))
{
	
}

void NormalEstimateModel::LoadModel()
{
	PyRun_SimpleString(
		"import tensorflow as tf\n"
		"import numpy as np\n"
		"import cv2\n"
	);

	string s = "noisy_image = np.array(";

	for (int n = 0; n < 1; n++)
	{
		s += "[";
		for (int i = 0; i < 1024; i++)
		{
			s += "[";
			for (int j = 0; j < 1024; j++)
			{
				s += "[";
				for (int k = 0; k < 2; k++)
				{
					s += "0,";
				}
				s += "0],";
			}
			s += "],";
		}
		s += "]";
	}

	s += ")\n";

	PyRun_SimpleString(
		s.c_str()
	);

	PyRun_SimpleString(
		"reso = 1024\n"
		"with tf.Session() as sess:\n"
		"	save = 'Model/20180730_215620/last_model'\n"
		"	saver = tf.train.import_meta_graph(save+'.meta')\n"
		"	saver.restore(sess, save)\n"
		"	noisy_tensor = tf.get_default_graph().get_tensor_by_name('noisy_data:0')\n"
		"	denoised_tensor = tf.get_default_graph().get_tensor_by_name('denoised_data:0')\n"
		"	noisy_image = np.reshape(noisy_image, (1, reso, reso, 3))\n"
		"	feed_dict = { noisy_tensor: noisy_image }\n"
		"	denoised_image = denoised_tensor.eval(feed_dict=feed_dict, session=sess)\n"
		"	denoised_image = np.reshape(denoised_image, (reso, reso, 3))\n"
		"	cv2.imwrite('t.png', denoised_image)\n"
		"\n"
		"\n"
		"\n"
		"\n"
		"\n"
		"\n"
		"\n"
		"\n"
		"\n"
		"\n"
		"\n"
		"\n"
		"\n"
		"\n"
		"\n"
		"\n"
		"\n"
		"\n"
		"\n"
		"\n"
		"\n"
		"\n"
		"\n"
		);


	//const py::object saver = tf_.attr("train").attr("import_meta_graph")()
	
}

void NormalEstimateModel::UseModel()
{
}
