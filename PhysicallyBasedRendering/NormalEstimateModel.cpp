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
}

void NormalEstimateModel::LoadModel()
{
	PyRun_SimpleString(
		"import tensorflow as tf\n"
		"import numpy as np\n"
		"import cv2\n"
	);

	PyRun_SimpleString(
		"noisy_images = []"
	);
}

void NormalEstimateModel::UseModel(
	const string model_dir,
	const string output_tensor,
	const string original_image, 
	const string model_out_image,
	const int length)
{
	string use_model_code =
		"reso = 1024\n"
		"with tf.Session() as sess:\n"
		"	save = '" + model_dir + "'\n"
		"	saver = tf.train.import_meta_graph(save+'.meta')\n"
		"	saver.restore(sess, save)\n"
		"	noisy_tensor = tf.get_default_graph().get_tensor_by_name('noisy_data:0')\n"
		"	denoised_tensor = tf.get_default_graph().get_tensor_by_name('" + output_tensor + "')\n"
		"	for i in range(" + std::to_string(length) + "):\n"
		"		noisy_image = np.reshape(noisy_images[i], (1, reso, reso, 3), order='C')\n"
		"		noisy_image = noisy_image[:,::-1,:,::-1]\n"
		"		feed_dict = { noisy_tensor: noisy_image }\n"
		"		denoised_image = denoised_tensor.eval(feed_dict=feed_dict, session=sess)\n"
		"		denoised_image = np.reshape(denoised_image, (reso, reso, 3))\n"
		"		cv2.imwrite('" + model_out_image + "'+str(i)+'.png', denoised_image)\n"
		"		noisy_image = np.reshape(noisy_image, (reso, reso, 3), order='C')\n"
		"		cv2.imwrite('" + original_image + "'+str(i)+'.png', noisy_image)\n";

	PyRun_SimpleString(use_model_code.c_str());
}

void NormalEstimateModel::AppendNoisyImage(float* data)
{
	string noisy_image_alloc_code = "noisy_images.append(np.array(";
	noisy_image_alloc_code += "[";

	for (int n = 0; n < 1024 * 1024 * 3 - 1; n++)
	{
		noisy_image_alloc_code += boost::lexical_cast<std::string>(data[n] * 255.0f);
		noisy_image_alloc_code += ",";
	}
	noisy_image_alloc_code += boost::lexical_cast<std::string>(data[1024 * 1024 * 3 - 1] * 255.0f);
	noisy_image_alloc_code += "]))\n";

	PyRun_SimpleString(
		noisy_image_alloc_code.c_str()
	);
}