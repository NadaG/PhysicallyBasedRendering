node {
  name: "noisy_data"
  op: "Placeholder"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: -1
        }
        dim {
          size: 1024
        }
        dim {
          size: 1024
        }
        dim {
          size: 3
        }
      }
    }
  }
}
node {
  name: "target_data"
  op: "Placeholder"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: -1
        }
        dim {
          size: 1024
        }
        dim {
          size: 1024
        }
        dim {
          size: 3
        }
      }
    }
  }
}
node {
  name: "truediv/y"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 255.0
      }
    }
  }
}
node {
  name: "truediv"
  op: "RealDiv"
  input: "noisy_data"
  input: "truediv/y"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "Reshape/shape"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\377\377\377\377\000\004\000\000\000\004\000\000\003\000\000\000"
      }
    }
  }
}
node {
  name: "Reshape"
  op: "Reshape"
  input: "truediv"
  input: "Reshape/shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d/kernel/Initializer/random_uniform/shape"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\010\000\000\000\010\000\000\000\003\000\000\000 \000\000\000"
      }
    }
  }
}
node {
  name: "conv2d/kernel/Initializer/random_uniform/min"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: -0.051754917949438095
      }
    }
  }
}
node {
  name: "conv2d/kernel/Initializer/random_uniform/max"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.051754917949438095
      }
    }
  }
}
node {
  name: "conv2d/kernel/Initializer/random_uniform/RandomUniform"
  op: "RandomUniform"
  input: "conv2d/kernel/Initializer/random_uniform/shape"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "seed"
    value {
      i: 0
    }
  }
  attr {
    key: "seed2"
    value {
      i: 0
    }
  }
}
node {
  name: "conv2d/kernel/Initializer/random_uniform/sub"
  op: "Sub"
  input: "conv2d/kernel/Initializer/random_uniform/max"
  input: "conv2d/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/kernel"
      }
    }
  }
}
node {
  name: "conv2d/kernel/Initializer/random_uniform/mul"
  op: "Mul"
  input: "conv2d/kernel/Initializer/random_uniform/RandomUniform"
  input: "conv2d/kernel/Initializer/random_uniform/sub"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/kernel"
      }
    }
  }
}
node {
  name: "conv2d/kernel/Initializer/random_uniform"
  op: "Add"
  input: "conv2d/kernel/Initializer/random_uniform/mul"
  input: "conv2d/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/kernel"
      }
    }
  }
}
node {
  name: "conv2d/kernel"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
        dim {
          size: 8
        }
        dim {
          size: 3
        }
        dim {
          size: 32
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d/kernel/Assign"
  op: "Assign"
  input: "conv2d/kernel"
  input: "conv2d/kernel/Initializer/random_uniform"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d/kernel/read"
  op: "Identity"
  input: "conv2d/kernel"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/kernel"
      }
    }
  }
}
node {
  name: "conv2d/bias/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 32
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d/bias"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 32
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d/bias/Assign"
  op: "Assign"
  input: "conv2d/bias"
  input: "conv2d/bias/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d/bias/read"
  op: "Identity"
  input: "conv2d/bias"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/bias"
      }
    }
  }
}
node {
  name: "conv2d/dilation_rate"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 2
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d/Conv2D"
  op: "Conv2D"
  input: "Reshape"
  input: "conv2d/kernel/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d/BiasAdd"
  op: "BiasAdd"
  input: "conv2d/Conv2D"
  input: "conv2d/bias/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "LeakyRelu/alpha"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.20000000298023224
      }
    }
  }
}
node {
  name: "LeakyRelu/mul"
  op: "Mul"
  input: "LeakyRelu/alpha"
  input: "conv2d/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "LeakyRelu/Maximum"
  op: "Maximum"
  input: "LeakyRelu/mul"
  input: "conv2d/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "conv2d_1/kernel/Initializer/random_uniform/shape"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_1/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\006\000\000\000\006\000\000\000 \000\000\000\030\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_1/kernel/Initializer/random_uniform/min"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_1/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: -0.054554473608732224
      }
    }
  }
}
node {
  name: "conv2d_1/kernel/Initializer/random_uniform/max"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_1/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.054554473608732224
      }
    }
  }
}
node {
  name: "conv2d_1/kernel/Initializer/random_uniform/RandomUniform"
  op: "RandomUniform"
  input: "conv2d_1/kernel/Initializer/random_uniform/shape"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_1/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "seed"
    value {
      i: 0
    }
  }
  attr {
    key: "seed2"
    value {
      i: 0
    }
  }
}
node {
  name: "conv2d_1/kernel/Initializer/random_uniform/sub"
  op: "Sub"
  input: "conv2d_1/kernel/Initializer/random_uniform/max"
  input: "conv2d_1/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_1/kernel"
      }
    }
  }
}
node {
  name: "conv2d_1/kernel/Initializer/random_uniform/mul"
  op: "Mul"
  input: "conv2d_1/kernel/Initializer/random_uniform/RandomUniform"
  input: "conv2d_1/kernel/Initializer/random_uniform/sub"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_1/kernel"
      }
    }
  }
}
node {
  name: "conv2d_1/kernel/Initializer/random_uniform"
  op: "Add"
  input: "conv2d_1/kernel/Initializer/random_uniform/mul"
  input: "conv2d_1/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_1/kernel"
      }
    }
  }
}
node {
  name: "conv2d_1/kernel"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_1/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 6
        }
        dim {
          size: 6
        }
        dim {
          size: 32
        }
        dim {
          size: 24
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_1/kernel/Assign"
  op: "Assign"
  input: "conv2d_1/kernel"
  input: "conv2d_1/kernel/Initializer/random_uniform"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_1/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_1/kernel/read"
  op: "Identity"
  input: "conv2d_1/kernel"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_1/kernel"
      }
    }
  }
}
node {
  name: "conv2d_1/bias/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_1/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 24
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_1/bias"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_1/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 24
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_1/bias/Assign"
  op: "Assign"
  input: "conv2d_1/bias"
  input: "conv2d_1/bias/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_1/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_1/bias/read"
  op: "Identity"
  input: "conv2d_1/bias"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_1/bias"
      }
    }
  }
}
node {
  name: "conv2d_1/dilation_rate"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 2
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_1/Conv2D"
  op: "Conv2D"
  input: "LeakyRelu/Maximum"
  input: "conv2d_1/kernel/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_1/BiasAdd"
  op: "BiasAdd"
  input: "conv2d_1/Conv2D"
  input: "conv2d_1/bias/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "LeakyRelu_1/alpha"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.20000000298023224
      }
    }
  }
}
node {
  name: "LeakyRelu_1/mul"
  op: "Mul"
  input: "LeakyRelu_1/alpha"
  input: "conv2d_1/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "LeakyRelu_1/Maximum"
  op: "Maximum"
  input: "LeakyRelu_1/mul"
  input: "conv2d_1/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "conv2d_2/kernel/Initializer/random_uniform/shape"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_2/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\005\000\000\000\005\000\000\000\030\000\000\000\020\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_2/kernel/Initializer/random_uniform/min"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_2/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: -0.0774596706032753
      }
    }
  }
}
node {
  name: "conv2d_2/kernel/Initializer/random_uniform/max"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_2/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0774596706032753
      }
    }
  }
}
node {
  name: "conv2d_2/kernel/Initializer/random_uniform/RandomUniform"
  op: "RandomUniform"
  input: "conv2d_2/kernel/Initializer/random_uniform/shape"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_2/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "seed"
    value {
      i: 0
    }
  }
  attr {
    key: "seed2"
    value {
      i: 0
    }
  }
}
node {
  name: "conv2d_2/kernel/Initializer/random_uniform/sub"
  op: "Sub"
  input: "conv2d_2/kernel/Initializer/random_uniform/max"
  input: "conv2d_2/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_2/kernel"
      }
    }
  }
}
node {
  name: "conv2d_2/kernel/Initializer/random_uniform/mul"
  op: "Mul"
  input: "conv2d_2/kernel/Initializer/random_uniform/RandomUniform"
  input: "conv2d_2/kernel/Initializer/random_uniform/sub"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_2/kernel"
      }
    }
  }
}
node {
  name: "conv2d_2/kernel/Initializer/random_uniform"
  op: "Add"
  input: "conv2d_2/kernel/Initializer/random_uniform/mul"
  input: "conv2d_2/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_2/kernel"
      }
    }
  }
}
node {
  name: "conv2d_2/kernel"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_2/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 5
        }
        dim {
          size: 5
        }
        dim {
          size: 24
        }
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_2/kernel/Assign"
  op: "Assign"
  input: "conv2d_2/kernel"
  input: "conv2d_2/kernel/Initializer/random_uniform"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_2/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_2/kernel/read"
  op: "Identity"
  input: "conv2d_2/kernel"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_2/kernel"
      }
    }
  }
}
node {
  name: "conv2d_2/bias/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_2/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 16
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_2/bias"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_2/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_2/bias/Assign"
  op: "Assign"
  input: "conv2d_2/bias"
  input: "conv2d_2/bias/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_2/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_2/bias/read"
  op: "Identity"
  input: "conv2d_2/bias"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_2/bias"
      }
    }
  }
}
node {
  name: "conv2d_2/dilation_rate"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 2
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_2/Conv2D"
  op: "Conv2D"
  input: "LeakyRelu_1/Maximum"
  input: "conv2d_2/kernel/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_2/BiasAdd"
  op: "BiasAdd"
  input: "conv2d_2/Conv2D"
  input: "conv2d_2/bias/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "LeakyRelu_2/alpha"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.20000000298023224
      }
    }
  }
}
node {
  name: "LeakyRelu_2/mul"
  op: "Mul"
  input: "LeakyRelu_2/alpha"
  input: "conv2d_2/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "LeakyRelu_2/Maximum"
  op: "Maximum"
  input: "LeakyRelu_2/mul"
  input: "conv2d_2/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "conv2d_3/kernel/Initializer/random_uniform/shape"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_3/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\004\000\000\000\004\000\000\000\020\000\000\000\030\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_3/kernel/Initializer/random_uniform/min"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_3/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: -0.09682458639144897
      }
    }
  }
}
node {
  name: "conv2d_3/kernel/Initializer/random_uniform/max"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_3/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.09682458639144897
      }
    }
  }
}
node {
  name: "conv2d_3/kernel/Initializer/random_uniform/RandomUniform"
  op: "RandomUniform"
  input: "conv2d_3/kernel/Initializer/random_uniform/shape"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_3/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "seed"
    value {
      i: 0
    }
  }
  attr {
    key: "seed2"
    value {
      i: 0
    }
  }
}
node {
  name: "conv2d_3/kernel/Initializer/random_uniform/sub"
  op: "Sub"
  input: "conv2d_3/kernel/Initializer/random_uniform/max"
  input: "conv2d_3/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_3/kernel"
      }
    }
  }
}
node {
  name: "conv2d_3/kernel/Initializer/random_uniform/mul"
  op: "Mul"
  input: "conv2d_3/kernel/Initializer/random_uniform/RandomUniform"
  input: "conv2d_3/kernel/Initializer/random_uniform/sub"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_3/kernel"
      }
    }
  }
}
node {
  name: "conv2d_3/kernel/Initializer/random_uniform"
  op: "Add"
  input: "conv2d_3/kernel/Initializer/random_uniform/mul"
  input: "conv2d_3/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_3/kernel"
      }
    }
  }
}
node {
  name: "conv2d_3/kernel"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_3/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 4
        }
        dim {
          size: 4
        }
        dim {
          size: 16
        }
        dim {
          size: 24
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_3/kernel/Assign"
  op: "Assign"
  input: "conv2d_3/kernel"
  input: "conv2d_3/kernel/Initializer/random_uniform"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_3/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_3/kernel/read"
  op: "Identity"
  input: "conv2d_3/kernel"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_3/kernel"
      }
    }
  }
}
node {
  name: "conv2d_3/bias/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_3/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 24
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_3/bias"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_3/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 24
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_3/bias/Assign"
  op: "Assign"
  input: "conv2d_3/bias"
  input: "conv2d_3/bias/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_3/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_3/bias/read"
  op: "Identity"
  input: "conv2d_3/bias"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_3/bias"
      }
    }
  }
}
node {
  name: "conv2d_3/dilation_rate"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 2
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_3/Conv2D"
  op: "Conv2D"
  input: "LeakyRelu_2/Maximum"
  input: "conv2d_3/kernel/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 2
        i: 2
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_3/BiasAdd"
  op: "BiasAdd"
  input: "conv2d_3/Conv2D"
  input: "conv2d_3/bias/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "LeakyRelu_3/alpha"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.20000000298023224
      }
    }
  }
}
node {
  name: "LeakyRelu_3/mul"
  op: "Mul"
  input: "LeakyRelu_3/alpha"
  input: "conv2d_3/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "LeakyRelu_3/Maximum"
  op: "Maximum"
  input: "LeakyRelu_3/mul"
  input: "conv2d_3/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "conv2d_4/kernel/Initializer/random_uniform/shape"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_4/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\004\000\000\000\004\000\000\000\030\000\000\000\030\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_4/kernel/Initializer/random_uniform/min"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_4/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: -0.0883883461356163
      }
    }
  }
}
node {
  name: "conv2d_4/kernel/Initializer/random_uniform/max"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_4/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0883883461356163
      }
    }
  }
}
node {
  name: "conv2d_4/kernel/Initializer/random_uniform/RandomUniform"
  op: "RandomUniform"
  input: "conv2d_4/kernel/Initializer/random_uniform/shape"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_4/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "seed"
    value {
      i: 0
    }
  }
  attr {
    key: "seed2"
    value {
      i: 0
    }
  }
}
node {
  name: "conv2d_4/kernel/Initializer/random_uniform/sub"
  op: "Sub"
  input: "conv2d_4/kernel/Initializer/random_uniform/max"
  input: "conv2d_4/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_4/kernel"
      }
    }
  }
}
node {
  name: "conv2d_4/kernel/Initializer/random_uniform/mul"
  op: "Mul"
  input: "conv2d_4/kernel/Initializer/random_uniform/RandomUniform"
  input: "conv2d_4/kernel/Initializer/random_uniform/sub"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_4/kernel"
      }
    }
  }
}
node {
  name: "conv2d_4/kernel/Initializer/random_uniform"
  op: "Add"
  input: "conv2d_4/kernel/Initializer/random_uniform/mul"
  input: "conv2d_4/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_4/kernel"
      }
    }
  }
}
node {
  name: "conv2d_4/kernel"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_4/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 4
        }
        dim {
          size: 4
        }
        dim {
          size: 24
        }
        dim {
          size: 24
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_4/kernel/Assign"
  op: "Assign"
  input: "conv2d_4/kernel"
  input: "conv2d_4/kernel/Initializer/random_uniform"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_4/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_4/kernel/read"
  op: "Identity"
  input: "conv2d_4/kernel"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_4/kernel"
      }
    }
  }
}
node {
  name: "conv2d_4/bias/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_4/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 24
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_4/bias"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_4/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 24
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_4/bias/Assign"
  op: "Assign"
  input: "conv2d_4/bias"
  input: "conv2d_4/bias/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_4/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_4/bias/read"
  op: "Identity"
  input: "conv2d_4/bias"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_4/bias"
      }
    }
  }
}
node {
  name: "conv2d_4/dilation_rate"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 2
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_4/Conv2D"
  op: "Conv2D"
  input: "LeakyRelu_3/Maximum"
  input: "conv2d_4/kernel/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_4/BiasAdd"
  op: "BiasAdd"
  input: "conv2d_4/Conv2D"
  input: "conv2d_4/bias/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "LeakyRelu_4/alpha"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.20000000298023224
      }
    }
  }
}
node {
  name: "LeakyRelu_4/mul"
  op: "Mul"
  input: "LeakyRelu_4/alpha"
  input: "conv2d_4/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "LeakyRelu_4/Maximum"
  op: "Maximum"
  input: "LeakyRelu_4/mul"
  input: "conv2d_4/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "conv2d_5/kernel/Initializer/random_uniform/shape"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_5/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000\030\000\000\000\020\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_5/kernel/Initializer/random_uniform/min"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_5/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: -0.3872983455657959
      }
    }
  }
}
node {
  name: "conv2d_5/kernel/Initializer/random_uniform/max"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_5/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.3872983455657959
      }
    }
  }
}
node {
  name: "conv2d_5/kernel/Initializer/random_uniform/RandomUniform"
  op: "RandomUniform"
  input: "conv2d_5/kernel/Initializer/random_uniform/shape"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_5/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "seed"
    value {
      i: 0
    }
  }
  attr {
    key: "seed2"
    value {
      i: 0
    }
  }
}
node {
  name: "conv2d_5/kernel/Initializer/random_uniform/sub"
  op: "Sub"
  input: "conv2d_5/kernel/Initializer/random_uniform/max"
  input: "conv2d_5/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_5/kernel"
      }
    }
  }
}
node {
  name: "conv2d_5/kernel/Initializer/random_uniform/mul"
  op: "Mul"
  input: "conv2d_5/kernel/Initializer/random_uniform/RandomUniform"
  input: "conv2d_5/kernel/Initializer/random_uniform/sub"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_5/kernel"
      }
    }
  }
}
node {
  name: "conv2d_5/kernel/Initializer/random_uniform"
  op: "Add"
  input: "conv2d_5/kernel/Initializer/random_uniform/mul"
  input: "conv2d_5/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_5/kernel"
      }
    }
  }
}
node {
  name: "conv2d_5/kernel"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_5/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 1
        }
        dim {
          size: 1
        }
        dim {
          size: 24
        }
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_5/kernel/Assign"
  op: "Assign"
  input: "conv2d_5/kernel"
  input: "conv2d_5/kernel/Initializer/random_uniform"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_5/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_5/kernel/read"
  op: "Identity"
  input: "conv2d_5/kernel"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_5/kernel"
      }
    }
  }
}
node {
  name: "conv2d_5/bias/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_5/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 16
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_5/bias"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_5/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_5/bias/Assign"
  op: "Assign"
  input: "conv2d_5/bias"
  input: "conv2d_5/bias/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_5/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_5/bias/read"
  op: "Identity"
  input: "conv2d_5/bias"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_5/bias"
      }
    }
  }
}
node {
  name: "conv2d_5/dilation_rate"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 2
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_5/Conv2D"
  op: "Conv2D"
  input: "LeakyRelu_4/Maximum"
  input: "conv2d_5/kernel/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_5/BiasAdd"
  op: "BiasAdd"
  input: "conv2d_5/Conv2D"
  input: "conv2d_5/bias/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "LeakyRelu_5/alpha"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.20000000298023224
      }
    }
  }
}
node {
  name: "LeakyRelu_5/mul"
  op: "Mul"
  input: "LeakyRelu_5/alpha"
  input: "conv2d_5/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "LeakyRelu_5/Maximum"
  op: "Maximum"
  input: "LeakyRelu_5/mul"
  input: "conv2d_5/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "conv2d_6/kernel/Initializer/random_uniform/shape"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_6/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\003\000\000\000\003\000\000\000\020\000\000\000\020\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_6/kernel/Initializer/random_uniform/min"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_6/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: -0.14433756470680237
      }
    }
  }
}
node {
  name: "conv2d_6/kernel/Initializer/random_uniform/max"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_6/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.14433756470680237
      }
    }
  }
}
node {
  name: "conv2d_6/kernel/Initializer/random_uniform/RandomUniform"
  op: "RandomUniform"
  input: "conv2d_6/kernel/Initializer/random_uniform/shape"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_6/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "seed"
    value {
      i: 0
    }
  }
  attr {
    key: "seed2"
    value {
      i: 0
    }
  }
}
node {
  name: "conv2d_6/kernel/Initializer/random_uniform/sub"
  op: "Sub"
  input: "conv2d_6/kernel/Initializer/random_uniform/max"
  input: "conv2d_6/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_6/kernel"
      }
    }
  }
}
node {
  name: "conv2d_6/kernel/Initializer/random_uniform/mul"
  op: "Mul"
  input: "conv2d_6/kernel/Initializer/random_uniform/RandomUniform"
  input: "conv2d_6/kernel/Initializer/random_uniform/sub"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_6/kernel"
      }
    }
  }
}
node {
  name: "conv2d_6/kernel/Initializer/random_uniform"
  op: "Add"
  input: "conv2d_6/kernel/Initializer/random_uniform/mul"
  input: "conv2d_6/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_6/kernel"
      }
    }
  }
}
node {
  name: "conv2d_6/kernel"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_6/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 3
        }
        dim {
          size: 3
        }
        dim {
          size: 16
        }
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_6/kernel/Assign"
  op: "Assign"
  input: "conv2d_6/kernel"
  input: "conv2d_6/kernel/Initializer/random_uniform"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_6/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_6/kernel/read"
  op: "Identity"
  input: "conv2d_6/kernel"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_6/kernel"
      }
    }
  }
}
node {
  name: "conv2d_6/bias/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_6/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 16
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_6/bias"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_6/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_6/bias/Assign"
  op: "Assign"
  input: "conv2d_6/bias"
  input: "conv2d_6/bias/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_6/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_6/bias/read"
  op: "Identity"
  input: "conv2d_6/bias"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_6/bias"
      }
    }
  }
}
node {
  name: "conv2d_6/dilation_rate"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 2
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_6/Conv2D"
  op: "Conv2D"
  input: "LeakyRelu_5/Maximum"
  input: "conv2d_6/kernel/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 2
        i: 2
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_6/BiasAdd"
  op: "BiasAdd"
  input: "conv2d_6/Conv2D"
  input: "conv2d_6/bias/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "LeakyRelu_6/alpha"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.20000000298023224
      }
    }
  }
}
node {
  name: "LeakyRelu_6/mul"
  op: "Mul"
  input: "LeakyRelu_6/alpha"
  input: "conv2d_6/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "LeakyRelu_6/Maximum"
  op: "Maximum"
  input: "LeakyRelu_6/mul"
  input: "conv2d_6/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "conv2d_7/kernel/Initializer/random_uniform/shape"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_7/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\003\000\000\000\003\000\000\000\020\000\000\000\020\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_7/kernel/Initializer/random_uniform/min"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_7/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: -0.14433756470680237
      }
    }
  }
}
node {
  name: "conv2d_7/kernel/Initializer/random_uniform/max"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_7/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.14433756470680237
      }
    }
  }
}
node {
  name: "conv2d_7/kernel/Initializer/random_uniform/RandomUniform"
  op: "RandomUniform"
  input: "conv2d_7/kernel/Initializer/random_uniform/shape"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_7/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "seed"
    value {
      i: 0
    }
  }
  attr {
    key: "seed2"
    value {
      i: 0
    }
  }
}
node {
  name: "conv2d_7/kernel/Initializer/random_uniform/sub"
  op: "Sub"
  input: "conv2d_7/kernel/Initializer/random_uniform/max"
  input: "conv2d_7/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_7/kernel"
      }
    }
  }
}
node {
  name: "conv2d_7/kernel/Initializer/random_uniform/mul"
  op: "Mul"
  input: "conv2d_7/kernel/Initializer/random_uniform/RandomUniform"
  input: "conv2d_7/kernel/Initializer/random_uniform/sub"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_7/kernel"
      }
    }
  }
}
node {
  name: "conv2d_7/kernel/Initializer/random_uniform"
  op: "Add"
  input: "conv2d_7/kernel/Initializer/random_uniform/mul"
  input: "conv2d_7/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_7/kernel"
      }
    }
  }
}
node {
  name: "conv2d_7/kernel"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_7/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 3
        }
        dim {
          size: 3
        }
        dim {
          size: 16
        }
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_7/kernel/Assign"
  op: "Assign"
  input: "conv2d_7/kernel"
  input: "conv2d_7/kernel/Initializer/random_uniform"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_7/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_7/kernel/read"
  op: "Identity"
  input: "conv2d_7/kernel"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_7/kernel"
      }
    }
  }
}
node {
  name: "conv2d_7/bias/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_7/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 16
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_7/bias"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_7/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_7/bias/Assign"
  op: "Assign"
  input: "conv2d_7/bias"
  input: "conv2d_7/bias/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_7/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_7/bias/read"
  op: "Identity"
  input: "conv2d_7/bias"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_7/bias"
      }
    }
  }
}
node {
  name: "conv2d_7/dilation_rate"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 2
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_7/Conv2D"
  op: "Conv2D"
  input: "LeakyRelu_6/Maximum"
  input: "conv2d_7/kernel/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_7/BiasAdd"
  op: "BiasAdd"
  input: "conv2d_7/Conv2D"
  input: "conv2d_7/bias/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "LeakyRelu_7/alpha"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.20000000298023224
      }
    }
  }
}
node {
  name: "LeakyRelu_7/mul"
  op: "Mul"
  input: "LeakyRelu_7/alpha"
  input: "conv2d_7/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "LeakyRelu_7/Maximum"
  op: "Maximum"
  input: "LeakyRelu_7/mul"
  input: "conv2d_7/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "conv2d_8/kernel/Initializer/random_uniform/shape"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_8/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000\020\000\000\000\020\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_8/kernel/Initializer/random_uniform/min"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_8/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: -0.4330126941204071
      }
    }
  }
}
node {
  name: "conv2d_8/kernel/Initializer/random_uniform/max"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_8/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.4330126941204071
      }
    }
  }
}
node {
  name: "conv2d_8/kernel/Initializer/random_uniform/RandomUniform"
  op: "RandomUniform"
  input: "conv2d_8/kernel/Initializer/random_uniform/shape"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_8/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "seed"
    value {
      i: 0
    }
  }
  attr {
    key: "seed2"
    value {
      i: 0
    }
  }
}
node {
  name: "conv2d_8/kernel/Initializer/random_uniform/sub"
  op: "Sub"
  input: "conv2d_8/kernel/Initializer/random_uniform/max"
  input: "conv2d_8/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_8/kernel"
      }
    }
  }
}
node {
  name: "conv2d_8/kernel/Initializer/random_uniform/mul"
  op: "Mul"
  input: "conv2d_8/kernel/Initializer/random_uniform/RandomUniform"
  input: "conv2d_8/kernel/Initializer/random_uniform/sub"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_8/kernel"
      }
    }
  }
}
node {
  name: "conv2d_8/kernel/Initializer/random_uniform"
  op: "Add"
  input: "conv2d_8/kernel/Initializer/random_uniform/mul"
  input: "conv2d_8/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_8/kernel"
      }
    }
  }
}
node {
  name: "conv2d_8/kernel"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_8/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 1
        }
        dim {
          size: 1
        }
        dim {
          size: 16
        }
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_8/kernel/Assign"
  op: "Assign"
  input: "conv2d_8/kernel"
  input: "conv2d_8/kernel/Initializer/random_uniform"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_8/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_8/kernel/read"
  op: "Identity"
  input: "conv2d_8/kernel"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_8/kernel"
      }
    }
  }
}
node {
  name: "conv2d_8/bias/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_8/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 16
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_8/bias"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_8/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_8/bias/Assign"
  op: "Assign"
  input: "conv2d_8/bias"
  input: "conv2d_8/bias/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_8/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_8/bias/read"
  op: "Identity"
  input: "conv2d_8/bias"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_8/bias"
      }
    }
  }
}
node {
  name: "conv2d_8/dilation_rate"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 2
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_8/Conv2D"
  op: "Conv2D"
  input: "LeakyRelu_7/Maximum"
  input: "conv2d_8/kernel/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_8/BiasAdd"
  op: "BiasAdd"
  input: "conv2d_8/Conv2D"
  input: "conv2d_8/bias/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "LeakyRelu_8/alpha"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.20000000298023224
      }
    }
  }
}
node {
  name: "LeakyRelu_8/mul"
  op: "Mul"
  input: "LeakyRelu_8/alpha"
  input: "conv2d_8/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "LeakyRelu_8/Maximum"
  op: "Maximum"
  input: "LeakyRelu_8/mul"
  input: "conv2d_8/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "conv2d_9/kernel/Initializer/random_uniform/shape"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_9/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\003\000\000\000\003\000\000\000\020\000\000\000\010\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_9/kernel/Initializer/random_uniform/min"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_9/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: -0.1666666716337204
      }
    }
  }
}
node {
  name: "conv2d_9/kernel/Initializer/random_uniform/max"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_9/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.1666666716337204
      }
    }
  }
}
node {
  name: "conv2d_9/kernel/Initializer/random_uniform/RandomUniform"
  op: "RandomUniform"
  input: "conv2d_9/kernel/Initializer/random_uniform/shape"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_9/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "seed"
    value {
      i: 0
    }
  }
  attr {
    key: "seed2"
    value {
      i: 0
    }
  }
}
node {
  name: "conv2d_9/kernel/Initializer/random_uniform/sub"
  op: "Sub"
  input: "conv2d_9/kernel/Initializer/random_uniform/max"
  input: "conv2d_9/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_9/kernel"
      }
    }
  }
}
node {
  name: "conv2d_9/kernel/Initializer/random_uniform/mul"
  op: "Mul"
  input: "conv2d_9/kernel/Initializer/random_uniform/RandomUniform"
  input: "conv2d_9/kernel/Initializer/random_uniform/sub"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_9/kernel"
      }
    }
  }
}
node {
  name: "conv2d_9/kernel/Initializer/random_uniform"
  op: "Add"
  input: "conv2d_9/kernel/Initializer/random_uniform/mul"
  input: "conv2d_9/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_9/kernel"
      }
    }
  }
}
node {
  name: "conv2d_9/kernel"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_9/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 3
        }
        dim {
          size: 3
        }
        dim {
          size: 16
        }
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_9/kernel/Assign"
  op: "Assign"
  input: "conv2d_9/kernel"
  input: "conv2d_9/kernel/Initializer/random_uniform"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_9/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_9/kernel/read"
  op: "Identity"
  input: "conv2d_9/kernel"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_9/kernel"
      }
    }
  }
}
node {
  name: "conv2d_9/bias/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_9/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_9/bias"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_9/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_9/bias/Assign"
  op: "Assign"
  input: "conv2d_9/bias"
  input: "conv2d_9/bias/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_9/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_9/bias/read"
  op: "Identity"
  input: "conv2d_9/bias"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_9/bias"
      }
    }
  }
}
node {
  name: "conv2d_9/dilation_rate"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 2
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_9/Conv2D"
  op: "Conv2D"
  input: "LeakyRelu_8/Maximum"
  input: "conv2d_9/kernel/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 2
        i: 2
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_9/BiasAdd"
  op: "BiasAdd"
  input: "conv2d_9/Conv2D"
  input: "conv2d_9/bias/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "LeakyRelu_9/alpha"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.20000000298023224
      }
    }
  }
}
node {
  name: "LeakyRelu_9/mul"
  op: "Mul"
  input: "LeakyRelu_9/alpha"
  input: "conv2d_9/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "LeakyRelu_9/Maximum"
  op: "Maximum"
  input: "LeakyRelu_9/mul"
  input: "conv2d_9/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "conv2d_10/kernel/Initializer/random_uniform/shape"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_10/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000\010\000\000\000\010\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_10/kernel/Initializer/random_uniform/min"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_10/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: -0.6123724579811096
      }
    }
  }
}
node {
  name: "conv2d_10/kernel/Initializer/random_uniform/max"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_10/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.6123724579811096
      }
    }
  }
}
node {
  name: "conv2d_10/kernel/Initializer/random_uniform/RandomUniform"
  op: "RandomUniform"
  input: "conv2d_10/kernel/Initializer/random_uniform/shape"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_10/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "seed"
    value {
      i: 0
    }
  }
  attr {
    key: "seed2"
    value {
      i: 0
    }
  }
}
node {
  name: "conv2d_10/kernel/Initializer/random_uniform/sub"
  op: "Sub"
  input: "conv2d_10/kernel/Initializer/random_uniform/max"
  input: "conv2d_10/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_10/kernel"
      }
    }
  }
}
node {
  name: "conv2d_10/kernel/Initializer/random_uniform/mul"
  op: "Mul"
  input: "conv2d_10/kernel/Initializer/random_uniform/RandomUniform"
  input: "conv2d_10/kernel/Initializer/random_uniform/sub"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_10/kernel"
      }
    }
  }
}
node {
  name: "conv2d_10/kernel/Initializer/random_uniform"
  op: "Add"
  input: "conv2d_10/kernel/Initializer/random_uniform/mul"
  input: "conv2d_10/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_10/kernel"
      }
    }
  }
}
node {
  name: "conv2d_10/kernel"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_10/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 1
        }
        dim {
          size: 1
        }
        dim {
          size: 8
        }
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_10/kernel/Assign"
  op: "Assign"
  input: "conv2d_10/kernel"
  input: "conv2d_10/kernel/Initializer/random_uniform"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_10/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_10/kernel/read"
  op: "Identity"
  input: "conv2d_10/kernel"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_10/kernel"
      }
    }
  }
}
node {
  name: "conv2d_10/bias/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_10/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_10/bias"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_10/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_10/bias/Assign"
  op: "Assign"
  input: "conv2d_10/bias"
  input: "conv2d_10/bias/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_10/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_10/bias/read"
  op: "Identity"
  input: "conv2d_10/bias"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_10/bias"
      }
    }
  }
}
node {
  name: "conv2d_10/dilation_rate"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 2
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_10/Conv2D"
  op: "Conv2D"
  input: "LeakyRelu_9/Maximum"
  input: "conv2d_10/kernel/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_10/BiasAdd"
  op: "BiasAdd"
  input: "conv2d_10/Conv2D"
  input: "conv2d_10/bias/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "LeakyRelu_10/alpha"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.20000000298023224
      }
    }
  }
}
node {
  name: "LeakyRelu_10/mul"
  op: "Mul"
  input: "LeakyRelu_10/alpha"
  input: "conv2d_10/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "LeakyRelu_10/Maximum"
  op: "Maximum"
  input: "LeakyRelu_10/mul"
  input: "conv2d_10/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "conv2d_11/kernel/Initializer/random_uniform/shape"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_11/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\003\000\000\000\003\000\000\000\010\000\000\000\010\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_11/kernel/Initializer/random_uniform/min"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_11/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: -0.20412415266036987
      }
    }
  }
}
node {
  name: "conv2d_11/kernel/Initializer/random_uniform/max"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_11/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.20412415266036987
      }
    }
  }
}
node {
  name: "conv2d_11/kernel/Initializer/random_uniform/RandomUniform"
  op: "RandomUniform"
  input: "conv2d_11/kernel/Initializer/random_uniform/shape"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_11/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "seed"
    value {
      i: 0
    }
  }
  attr {
    key: "seed2"
    value {
      i: 0
    }
  }
}
node {
  name: "conv2d_11/kernel/Initializer/random_uniform/sub"
  op: "Sub"
  input: "conv2d_11/kernel/Initializer/random_uniform/max"
  input: "conv2d_11/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_11/kernel"
      }
    }
  }
}
node {
  name: "conv2d_11/kernel/Initializer/random_uniform/mul"
  op: "Mul"
  input: "conv2d_11/kernel/Initializer/random_uniform/RandomUniform"
  input: "conv2d_11/kernel/Initializer/random_uniform/sub"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_11/kernel"
      }
    }
  }
}
node {
  name: "conv2d_11/kernel/Initializer/random_uniform"
  op: "Add"
  input: "conv2d_11/kernel/Initializer/random_uniform/mul"
  input: "conv2d_11/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_11/kernel"
      }
    }
  }
}
node {
  name: "conv2d_11/kernel"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_11/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 3
        }
        dim {
          size: 3
        }
        dim {
          size: 8
        }
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_11/kernel/Assign"
  op: "Assign"
  input: "conv2d_11/kernel"
  input: "conv2d_11/kernel/Initializer/random_uniform"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_11/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_11/kernel/read"
  op: "Identity"
  input: "conv2d_11/kernel"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_11/kernel"
      }
    }
  }
}
node {
  name: "conv2d_11/bias/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_11/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_11/bias"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_11/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_11/bias/Assign"
  op: "Assign"
  input: "conv2d_11/bias"
  input: "conv2d_11/bias/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_11/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_11/bias/read"
  op: "Identity"
  input: "conv2d_11/bias"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_11/bias"
      }
    }
  }
}
node {
  name: "conv2d_11/dilation_rate"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 2
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_11/Conv2D"
  op: "Conv2D"
  input: "LeakyRelu_10/Maximum"
  input: "conv2d_11/kernel/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 2
        i: 2
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_11/BiasAdd"
  op: "BiasAdd"
  input: "conv2d_11/Conv2D"
  input: "conv2d_11/bias/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "LeakyRelu_11/alpha"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.20000000298023224
      }
    }
  }
}
node {
  name: "LeakyRelu_11/mul"
  op: "Mul"
  input: "LeakyRelu_11/alpha"
  input: "conv2d_11/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "LeakyRelu_11/Maximum"
  op: "Maximum"
  input: "LeakyRelu_11/mul"
  input: "conv2d_11/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "conv2d_12/kernel/Initializer/random_uniform/shape"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_12/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000\010\000\000\000\010\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_12/kernel/Initializer/random_uniform/min"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_12/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: -0.6123724579811096
      }
    }
  }
}
node {
  name: "conv2d_12/kernel/Initializer/random_uniform/max"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_12/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.6123724579811096
      }
    }
  }
}
node {
  name: "conv2d_12/kernel/Initializer/random_uniform/RandomUniform"
  op: "RandomUniform"
  input: "conv2d_12/kernel/Initializer/random_uniform/shape"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_12/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "seed"
    value {
      i: 0
    }
  }
  attr {
    key: "seed2"
    value {
      i: 0
    }
  }
}
node {
  name: "conv2d_12/kernel/Initializer/random_uniform/sub"
  op: "Sub"
  input: "conv2d_12/kernel/Initializer/random_uniform/max"
  input: "conv2d_12/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_12/kernel"
      }
    }
  }
}
node {
  name: "conv2d_12/kernel/Initializer/random_uniform/mul"
  op: "Mul"
  input: "conv2d_12/kernel/Initializer/random_uniform/RandomUniform"
  input: "conv2d_12/kernel/Initializer/random_uniform/sub"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_12/kernel"
      }
    }
  }
}
node {
  name: "conv2d_12/kernel/Initializer/random_uniform"
  op: "Add"
  input: "conv2d_12/kernel/Initializer/random_uniform/mul"
  input: "conv2d_12/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_12/kernel"
      }
    }
  }
}
node {
  name: "conv2d_12/kernel"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_12/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 1
        }
        dim {
          size: 1
        }
        dim {
          size: 8
        }
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_12/kernel/Assign"
  op: "Assign"
  input: "conv2d_12/kernel"
  input: "conv2d_12/kernel/Initializer/random_uniform"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_12/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_12/kernel/read"
  op: "Identity"
  input: "conv2d_12/kernel"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_12/kernel"
      }
    }
  }
}
node {
  name: "conv2d_12/bias/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_12/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_12/bias"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_12/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_12/bias/Assign"
  op: "Assign"
  input: "conv2d_12/bias"
  input: "conv2d_12/bias/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_12/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_12/bias/read"
  op: "Identity"
  input: "conv2d_12/bias"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_12/bias"
      }
    }
  }
}
node {
  name: "conv2d_12/dilation_rate"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 2
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_12/Conv2D"
  op: "Conv2D"
  input: "LeakyRelu_11/Maximum"
  input: "conv2d_12/kernel/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_12/BiasAdd"
  op: "BiasAdd"
  input: "conv2d_12/Conv2D"
  input: "conv2d_12/bias/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "LeakyRelu_12/alpha"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.20000000298023224
      }
    }
  }
}
node {
  name: "LeakyRelu_12/mul"
  op: "Mul"
  input: "LeakyRelu_12/alpha"
  input: "conv2d_12/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "LeakyRelu_12/Maximum"
  op: "Maximum"
  input: "LeakyRelu_12/mul"
  input: "conv2d_12/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "conv2d_13/kernel/Initializer/random_uniform/shape"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_13/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\003\000\000\000\003\000\000\000\010\000\000\000\010\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_13/kernel/Initializer/random_uniform/min"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_13/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: -0.20412415266036987
      }
    }
  }
}
node {
  name: "conv2d_13/kernel/Initializer/random_uniform/max"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_13/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.20412415266036987
      }
    }
  }
}
node {
  name: "conv2d_13/kernel/Initializer/random_uniform/RandomUniform"
  op: "RandomUniform"
  input: "conv2d_13/kernel/Initializer/random_uniform/shape"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_13/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "seed"
    value {
      i: 0
    }
  }
  attr {
    key: "seed2"
    value {
      i: 0
    }
  }
}
node {
  name: "conv2d_13/kernel/Initializer/random_uniform/sub"
  op: "Sub"
  input: "conv2d_13/kernel/Initializer/random_uniform/max"
  input: "conv2d_13/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_13/kernel"
      }
    }
  }
}
node {
  name: "conv2d_13/kernel/Initializer/random_uniform/mul"
  op: "Mul"
  input: "conv2d_13/kernel/Initializer/random_uniform/RandomUniform"
  input: "conv2d_13/kernel/Initializer/random_uniform/sub"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_13/kernel"
      }
    }
  }
}
node {
  name: "conv2d_13/kernel/Initializer/random_uniform"
  op: "Add"
  input: "conv2d_13/kernel/Initializer/random_uniform/mul"
  input: "conv2d_13/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_13/kernel"
      }
    }
  }
}
node {
  name: "conv2d_13/kernel"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_13/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 3
        }
        dim {
          size: 3
        }
        dim {
          size: 8
        }
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_13/kernel/Assign"
  op: "Assign"
  input: "conv2d_13/kernel"
  input: "conv2d_13/kernel/Initializer/random_uniform"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_13/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_13/kernel/read"
  op: "Identity"
  input: "conv2d_13/kernel"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_13/kernel"
      }
    }
  }
}
node {
  name: "conv2d_13/bias/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_13/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_13/bias"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_13/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_13/bias/Assign"
  op: "Assign"
  input: "conv2d_13/bias"
  input: "conv2d_13/bias/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_13/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_13/bias/read"
  op: "Identity"
  input: "conv2d_13/bias"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_13/bias"
      }
    }
  }
}
node {
  name: "conv2d_13/dilation_rate"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 2
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_13/Conv2D"
  op: "Conv2D"
  input: "LeakyRelu_12/Maximum"
  input: "conv2d_13/kernel/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 2
        i: 2
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_13/BiasAdd"
  op: "BiasAdd"
  input: "conv2d_13/Conv2D"
  input: "conv2d_13/bias/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "LeakyRelu_13/alpha"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.20000000298023224
      }
    }
  }
}
node {
  name: "LeakyRelu_13/mul"
  op: "Mul"
  input: "LeakyRelu_13/alpha"
  input: "conv2d_13/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "LeakyRelu_13/Maximum"
  op: "Maximum"
  input: "LeakyRelu_13/mul"
  input: "conv2d_13/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "conv2d_14/kernel/Initializer/random_uniform/shape"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_14/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000\010\000\000\000\010\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_14/kernel/Initializer/random_uniform/min"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_14/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: -0.6123724579811096
      }
    }
  }
}
node {
  name: "conv2d_14/kernel/Initializer/random_uniform/max"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_14/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.6123724579811096
      }
    }
  }
}
node {
  name: "conv2d_14/kernel/Initializer/random_uniform/RandomUniform"
  op: "RandomUniform"
  input: "conv2d_14/kernel/Initializer/random_uniform/shape"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_14/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "seed"
    value {
      i: 0
    }
  }
  attr {
    key: "seed2"
    value {
      i: 0
    }
  }
}
node {
  name: "conv2d_14/kernel/Initializer/random_uniform/sub"
  op: "Sub"
  input: "conv2d_14/kernel/Initializer/random_uniform/max"
  input: "conv2d_14/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_14/kernel"
      }
    }
  }
}
node {
  name: "conv2d_14/kernel/Initializer/random_uniform/mul"
  op: "Mul"
  input: "conv2d_14/kernel/Initializer/random_uniform/RandomUniform"
  input: "conv2d_14/kernel/Initializer/random_uniform/sub"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_14/kernel"
      }
    }
  }
}
node {
  name: "conv2d_14/kernel/Initializer/random_uniform"
  op: "Add"
  input: "conv2d_14/kernel/Initializer/random_uniform/mul"
  input: "conv2d_14/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_14/kernel"
      }
    }
  }
}
node {
  name: "conv2d_14/kernel"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_14/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 1
        }
        dim {
          size: 1
        }
        dim {
          size: 8
        }
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_14/kernel/Assign"
  op: "Assign"
  input: "conv2d_14/kernel"
  input: "conv2d_14/kernel/Initializer/random_uniform"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_14/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_14/kernel/read"
  op: "Identity"
  input: "conv2d_14/kernel"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_14/kernel"
      }
    }
  }
}
node {
  name: "conv2d_14/bias/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_14/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_14/bias"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_14/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_14/bias/Assign"
  op: "Assign"
  input: "conv2d_14/bias"
  input: "conv2d_14/bias/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_14/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_14/bias/read"
  op: "Identity"
  input: "conv2d_14/bias"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_14/bias"
      }
    }
  }
}
node {
  name: "conv2d_14/dilation_rate"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 2
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_14/Conv2D"
  op: "Conv2D"
  input: "LeakyRelu_13/Maximum"
  input: "conv2d_14/kernel/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_14/BiasAdd"
  op: "BiasAdd"
  input: "conv2d_14/Conv2D"
  input: "conv2d_14/bias/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "LeakyRelu_14/alpha"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.20000000298023224
      }
    }
  }
}
node {
  name: "LeakyRelu_14/mul"
  op: "Mul"
  input: "LeakyRelu_14/alpha"
  input: "conv2d_14/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "LeakyRelu_14/Maximum"
  op: "Maximum"
  input: "LeakyRelu_14/mul"
  input: "conv2d_14/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "conv2d_15/kernel/Initializer/random_uniform/shape"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_15/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000\010\000\000\000\010\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_15/kernel/Initializer/random_uniform/min"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_15/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: -0.6123724579811096
      }
    }
  }
}
node {
  name: "conv2d_15/kernel/Initializer/random_uniform/max"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_15/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.6123724579811096
      }
    }
  }
}
node {
  name: "conv2d_15/kernel/Initializer/random_uniform/RandomUniform"
  op: "RandomUniform"
  input: "conv2d_15/kernel/Initializer/random_uniform/shape"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_15/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "seed"
    value {
      i: 0
    }
  }
  attr {
    key: "seed2"
    value {
      i: 0
    }
  }
}
node {
  name: "conv2d_15/kernel/Initializer/random_uniform/sub"
  op: "Sub"
  input: "conv2d_15/kernel/Initializer/random_uniform/max"
  input: "conv2d_15/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_15/kernel"
      }
    }
  }
}
node {
  name: "conv2d_15/kernel/Initializer/random_uniform/mul"
  op: "Mul"
  input: "conv2d_15/kernel/Initializer/random_uniform/RandomUniform"
  input: "conv2d_15/kernel/Initializer/random_uniform/sub"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_15/kernel"
      }
    }
  }
}
node {
  name: "conv2d_15/kernel/Initializer/random_uniform"
  op: "Add"
  input: "conv2d_15/kernel/Initializer/random_uniform/mul"
  input: "conv2d_15/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_15/kernel"
      }
    }
  }
}
node {
  name: "conv2d_15/kernel"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_15/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 1
        }
        dim {
          size: 1
        }
        dim {
          size: 8
        }
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_15/kernel/Assign"
  op: "Assign"
  input: "conv2d_15/kernel"
  input: "conv2d_15/kernel/Initializer/random_uniform"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_15/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_15/kernel/read"
  op: "Identity"
  input: "conv2d_15/kernel"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_15/kernel"
      }
    }
  }
}
node {
  name: "conv2d_15/bias/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_15/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_15/bias"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_15/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_15/bias/Assign"
  op: "Assign"
  input: "conv2d_15/bias"
  input: "conv2d_15/bias/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_15/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_15/bias/read"
  op: "Identity"
  input: "conv2d_15/bias"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_15/bias"
      }
    }
  }
}
node {
  name: "conv2d_15/dilation_rate"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 2
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_15/Conv2D"
  op: "Conv2D"
  input: "LeakyRelu_14/Maximum"
  input: "conv2d_15/kernel/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_15/BiasAdd"
  op: "BiasAdd"
  input: "conv2d_15/Conv2D"
  input: "conv2d_15/bias/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "LeakyRelu_15/alpha"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.20000000298023224
      }
    }
  }
}
node {
  name: "LeakyRelu_15/mul"
  op: "Mul"
  input: "LeakyRelu_15/alpha"
  input: "conv2d_15/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "LeakyRelu_15/Maximum"
  op: "Maximum"
  input: "LeakyRelu_15/mul"
  input: "conv2d_15/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "conv2d_transpose/kernel/Initializer/random_uniform/shape"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\003\000\000\000\003\000\000\000\010\000\000\000\010\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_transpose/kernel/Initializer/random_uniform/min"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: -0.20412415266036987
      }
    }
  }
}
node {
  name: "conv2d_transpose/kernel/Initializer/random_uniform/max"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.20412415266036987
      }
    }
  }
}
node {
  name: "conv2d_transpose/kernel/Initializer/random_uniform/RandomUniform"
  op: "RandomUniform"
  input: "conv2d_transpose/kernel/Initializer/random_uniform/shape"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "seed"
    value {
      i: 0
    }
  }
  attr {
    key: "seed2"
    value {
      i: 0
    }
  }
}
node {
  name: "conv2d_transpose/kernel/Initializer/random_uniform/sub"
  op: "Sub"
  input: "conv2d_transpose/kernel/Initializer/random_uniform/max"
  input: "conv2d_transpose/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose/kernel"
      }
    }
  }
}
node {
  name: "conv2d_transpose/kernel/Initializer/random_uniform/mul"
  op: "Mul"
  input: "conv2d_transpose/kernel/Initializer/random_uniform/RandomUniform"
  input: "conv2d_transpose/kernel/Initializer/random_uniform/sub"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose/kernel"
      }
    }
  }
}
node {
  name: "conv2d_transpose/kernel/Initializer/random_uniform"
  op: "Add"
  input: "conv2d_transpose/kernel/Initializer/random_uniform/mul"
  input: "conv2d_transpose/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose/kernel"
      }
    }
  }
}
node {
  name: "conv2d_transpose/kernel"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 3
        }
        dim {
          size: 3
        }
        dim {
          size: 8
        }
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_transpose/kernel/Assign"
  op: "Assign"
  input: "conv2d_transpose/kernel"
  input: "conv2d_transpose/kernel/Initializer/random_uniform"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_transpose/kernel/read"
  op: "Identity"
  input: "conv2d_transpose/kernel"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose/kernel"
      }
    }
  }
}
node {
  name: "conv2d_transpose/bias/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_transpose/bias"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_transpose/bias/Assign"
  op: "Assign"
  input: "conv2d_transpose/bias"
  input: "conv2d_transpose/bias/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_transpose/bias/read"
  op: "Identity"
  input: "conv2d_transpose/bias"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose/bias"
      }
    }
  }
}
node {
  name: "conv2d_transpose/Shape"
  op: "Shape"
  input: "LeakyRelu_15/Maximum"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_transpose/strided_slice/stack"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 0
      }
    }
  }
}
node {
  name: "conv2d_transpose/strided_slice/stack_1"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 1
      }
    }
  }
}
node {
  name: "conv2d_transpose/strided_slice/stack_2"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 1
      }
    }
  }
}
node {
  name: "conv2d_transpose/strided_slice"
  op: "StridedSlice"
  input: "conv2d_transpose/Shape"
  input: "conv2d_transpose/strided_slice/stack"
  input: "conv2d_transpose/strided_slice/stack_1"
  input: "conv2d_transpose/strided_slice/stack_2"
  attr {
    key: "Index"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "begin_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "ellipsis_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "end_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "new_axis_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "shrink_axis_mask"
    value {
      i: 1
    }
  }
}
node {
  name: "conv2d_transpose/strided_slice_1/stack"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 1
      }
    }
  }
}
node {
  name: "conv2d_transpose/strided_slice_1/stack_1"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 2
      }
    }
  }
}
node {
  name: "conv2d_transpose/strided_slice_1/stack_2"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 1
      }
    }
  }
}
node {
  name: "conv2d_transpose/strided_slice_1"
  op: "StridedSlice"
  input: "conv2d_transpose/Shape"
  input: "conv2d_transpose/strided_slice_1/stack"
  input: "conv2d_transpose/strided_slice_1/stack_1"
  input: "conv2d_transpose/strided_slice_1/stack_2"
  attr {
    key: "Index"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "begin_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "ellipsis_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "end_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "new_axis_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "shrink_axis_mask"
    value {
      i: 1
    }
  }
}
node {
  name: "conv2d_transpose/strided_slice_2/stack"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 2
      }
    }
  }
}
node {
  name: "conv2d_transpose/strided_slice_2/stack_1"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 3
      }
    }
  }
}
node {
  name: "conv2d_transpose/strided_slice_2/stack_2"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 1
      }
    }
  }
}
node {
  name: "conv2d_transpose/strided_slice_2"
  op: "StridedSlice"
  input: "conv2d_transpose/Shape"
  input: "conv2d_transpose/strided_slice_2/stack"
  input: "conv2d_transpose/strided_slice_2/stack_1"
  input: "conv2d_transpose/strided_slice_2/stack_2"
  attr {
    key: "Index"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "begin_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "ellipsis_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "end_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "new_axis_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "shrink_axis_mask"
    value {
      i: 1
    }
  }
}
node {
  name: "conv2d_transpose/mul/y"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
        }
        int_val: 2
      }
    }
  }
}
node {
  name: "conv2d_transpose/mul"
  op: "Mul"
  input: "conv2d_transpose/strided_slice_1"
  input: "conv2d_transpose/mul/y"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_transpose/mul_1/y"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
        }
        int_val: 2
      }
    }
  }
}
node {
  name: "conv2d_transpose/mul_1"
  op: "Mul"
  input: "conv2d_transpose/strided_slice_2"
  input: "conv2d_transpose/mul_1/y"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_transpose/stack/3"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
        }
        int_val: 8
      }
    }
  }
}
node {
  name: "conv2d_transpose/stack"
  op: "Pack"
  input: "conv2d_transpose/strided_slice"
  input: "conv2d_transpose/mul"
  input: "conv2d_transpose/mul_1"
  input: "conv2d_transpose/stack/3"
  attr {
    key: "N"
    value {
      i: 4
    }
  }
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "axis"
    value {
      i: 0
    }
  }
}
node {
  name: "conv2d_transpose/conv2d_transpose"
  op: "Conv2DBackpropInput"
  input: "conv2d_transpose/stack"
  input: "conv2d_transpose/kernel/read"
  input: "LeakyRelu_15/Maximum"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 2
        i: 2
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_transpose/BiasAdd"
  op: "BiasAdd"
  input: "conv2d_transpose/conv2d_transpose"
  input: "conv2d_transpose/bias/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "LeakyRelu_16/alpha"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.20000000298023224
      }
    }
  }
}
node {
  name: "LeakyRelu_16/mul"
  op: "Mul"
  input: "LeakyRelu_16/alpha"
  input: "conv2d_transpose/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "LeakyRelu_16/Maximum"
  op: "Maximum"
  input: "LeakyRelu_16/mul"
  input: "conv2d_transpose/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "concat/axis"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
        }
        int_val: 3
      }
    }
  }
}
node {
  name: "concat"
  op: "ConcatV2"
  input: "LeakyRelu_16/Maximum"
  input: "LeakyRelu_12/Maximum"
  input: "concat/axis"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_16/kernel/Initializer/random_uniform/shape"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_16/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000\020\000\000\000\010\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_16/kernel/Initializer/random_uniform/min"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_16/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: -0.5
      }
    }
  }
}
node {
  name: "conv2d_16/kernel/Initializer/random_uniform/max"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_16/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.5
      }
    }
  }
}
node {
  name: "conv2d_16/kernel/Initializer/random_uniform/RandomUniform"
  op: "RandomUniform"
  input: "conv2d_16/kernel/Initializer/random_uniform/shape"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_16/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "seed"
    value {
      i: 0
    }
  }
  attr {
    key: "seed2"
    value {
      i: 0
    }
  }
}
node {
  name: "conv2d_16/kernel/Initializer/random_uniform/sub"
  op: "Sub"
  input: "conv2d_16/kernel/Initializer/random_uniform/max"
  input: "conv2d_16/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_16/kernel"
      }
    }
  }
}
node {
  name: "conv2d_16/kernel/Initializer/random_uniform/mul"
  op: "Mul"
  input: "conv2d_16/kernel/Initializer/random_uniform/RandomUniform"
  input: "conv2d_16/kernel/Initializer/random_uniform/sub"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_16/kernel"
      }
    }
  }
}
node {
  name: "conv2d_16/kernel/Initializer/random_uniform"
  op: "Add"
  input: "conv2d_16/kernel/Initializer/random_uniform/mul"
  input: "conv2d_16/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_16/kernel"
      }
    }
  }
}
node {
  name: "conv2d_16/kernel"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_16/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 1
        }
        dim {
          size: 1
        }
        dim {
          size: 16
        }
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_16/kernel/Assign"
  op: "Assign"
  input: "conv2d_16/kernel"
  input: "conv2d_16/kernel/Initializer/random_uniform"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_16/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_16/kernel/read"
  op: "Identity"
  input: "conv2d_16/kernel"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_16/kernel"
      }
    }
  }
}
node {
  name: "conv2d_16/bias/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_16/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_16/bias"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_16/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_16/bias/Assign"
  op: "Assign"
  input: "conv2d_16/bias"
  input: "conv2d_16/bias/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_16/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_16/bias/read"
  op: "Identity"
  input: "conv2d_16/bias"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_16/bias"
      }
    }
  }
}
node {
  name: "conv2d_16/dilation_rate"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 2
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_16/Conv2D"
  op: "Conv2D"
  input: "concat"
  input: "conv2d_16/kernel/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_16/BiasAdd"
  op: "BiasAdd"
  input: "conv2d_16/Conv2D"
  input: "conv2d_16/bias/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "LeakyRelu_17/alpha"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.20000000298023224
      }
    }
  }
}
node {
  name: "LeakyRelu_17/mul"
  op: "Mul"
  input: "LeakyRelu_17/alpha"
  input: "conv2d_16/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "LeakyRelu_17/Maximum"
  op: "Maximum"
  input: "LeakyRelu_17/mul"
  input: "conv2d_16/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "conv2d_transpose_1/kernel/Initializer/random_uniform/shape"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_1/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\003\000\000\000\003\000\000\000\010\000\000\000\010\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_transpose_1/kernel/Initializer/random_uniform/min"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_1/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: -0.20412415266036987
      }
    }
  }
}
node {
  name: "conv2d_transpose_1/kernel/Initializer/random_uniform/max"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_1/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.20412415266036987
      }
    }
  }
}
node {
  name: "conv2d_transpose_1/kernel/Initializer/random_uniform/RandomUniform"
  op: "RandomUniform"
  input: "conv2d_transpose_1/kernel/Initializer/random_uniform/shape"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_1/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "seed"
    value {
      i: 0
    }
  }
  attr {
    key: "seed2"
    value {
      i: 0
    }
  }
}
node {
  name: "conv2d_transpose_1/kernel/Initializer/random_uniform/sub"
  op: "Sub"
  input: "conv2d_transpose_1/kernel/Initializer/random_uniform/max"
  input: "conv2d_transpose_1/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_1/kernel"
      }
    }
  }
}
node {
  name: "conv2d_transpose_1/kernel/Initializer/random_uniform/mul"
  op: "Mul"
  input: "conv2d_transpose_1/kernel/Initializer/random_uniform/RandomUniform"
  input: "conv2d_transpose_1/kernel/Initializer/random_uniform/sub"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_1/kernel"
      }
    }
  }
}
node {
  name: "conv2d_transpose_1/kernel/Initializer/random_uniform"
  op: "Add"
  input: "conv2d_transpose_1/kernel/Initializer/random_uniform/mul"
  input: "conv2d_transpose_1/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_1/kernel"
      }
    }
  }
}
node {
  name: "conv2d_transpose_1/kernel"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_1/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 3
        }
        dim {
          size: 3
        }
        dim {
          size: 8
        }
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_transpose_1/kernel/Assign"
  op: "Assign"
  input: "conv2d_transpose_1/kernel"
  input: "conv2d_transpose_1/kernel/Initializer/random_uniform"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_1/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_transpose_1/kernel/read"
  op: "Identity"
  input: "conv2d_transpose_1/kernel"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_1/kernel"
      }
    }
  }
}
node {
  name: "conv2d_transpose_1/bias/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_1/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_transpose_1/bias"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_1/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_transpose_1/bias/Assign"
  op: "Assign"
  input: "conv2d_transpose_1/bias"
  input: "conv2d_transpose_1/bias/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_1/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_transpose_1/bias/read"
  op: "Identity"
  input: "conv2d_transpose_1/bias"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_1/bias"
      }
    }
  }
}
node {
  name: "conv2d_transpose_1/Shape"
  op: "Shape"
  input: "LeakyRelu_17/Maximum"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_transpose_1/strided_slice/stack"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 0
      }
    }
  }
}
node {
  name: "conv2d_transpose_1/strided_slice/stack_1"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 1
      }
    }
  }
}
node {
  name: "conv2d_transpose_1/strided_slice/stack_2"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 1
      }
    }
  }
}
node {
  name: "conv2d_transpose_1/strided_slice"
  op: "StridedSlice"
  input: "conv2d_transpose_1/Shape"
  input: "conv2d_transpose_1/strided_slice/stack"
  input: "conv2d_transpose_1/strided_slice/stack_1"
  input: "conv2d_transpose_1/strided_slice/stack_2"
  attr {
    key: "Index"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "begin_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "ellipsis_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "end_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "new_axis_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "shrink_axis_mask"
    value {
      i: 1
    }
  }
}
node {
  name: "conv2d_transpose_1/strided_slice_1/stack"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 1
      }
    }
  }
}
node {
  name: "conv2d_transpose_1/strided_slice_1/stack_1"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 2
      }
    }
  }
}
node {
  name: "conv2d_transpose_1/strided_slice_1/stack_2"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 1
      }
    }
  }
}
node {
  name: "conv2d_transpose_1/strided_slice_1"
  op: "StridedSlice"
  input: "conv2d_transpose_1/Shape"
  input: "conv2d_transpose_1/strided_slice_1/stack"
  input: "conv2d_transpose_1/strided_slice_1/stack_1"
  input: "conv2d_transpose_1/strided_slice_1/stack_2"
  attr {
    key: "Index"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "begin_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "ellipsis_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "end_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "new_axis_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "shrink_axis_mask"
    value {
      i: 1
    }
  }
}
node {
  name: "conv2d_transpose_1/strided_slice_2/stack"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 2
      }
    }
  }
}
node {
  name: "conv2d_transpose_1/strided_slice_2/stack_1"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 3
      }
    }
  }
}
node {
  name: "conv2d_transpose_1/strided_slice_2/stack_2"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 1
      }
    }
  }
}
node {
  name: "conv2d_transpose_1/strided_slice_2"
  op: "StridedSlice"
  input: "conv2d_transpose_1/Shape"
  input: "conv2d_transpose_1/strided_slice_2/stack"
  input: "conv2d_transpose_1/strided_slice_2/stack_1"
  input: "conv2d_transpose_1/strided_slice_2/stack_2"
  attr {
    key: "Index"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "begin_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "ellipsis_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "end_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "new_axis_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "shrink_axis_mask"
    value {
      i: 1
    }
  }
}
node {
  name: "conv2d_transpose_1/mul/y"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
        }
        int_val: 2
      }
    }
  }
}
node {
  name: "conv2d_transpose_1/mul"
  op: "Mul"
  input: "conv2d_transpose_1/strided_slice_1"
  input: "conv2d_transpose_1/mul/y"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_transpose_1/mul_1/y"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
        }
        int_val: 2
      }
    }
  }
}
node {
  name: "conv2d_transpose_1/mul_1"
  op: "Mul"
  input: "conv2d_transpose_1/strided_slice_2"
  input: "conv2d_transpose_1/mul_1/y"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_transpose_1/stack/3"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
        }
        int_val: 8
      }
    }
  }
}
node {
  name: "conv2d_transpose_1/stack"
  op: "Pack"
  input: "conv2d_transpose_1/strided_slice"
  input: "conv2d_transpose_1/mul"
  input: "conv2d_transpose_1/mul_1"
  input: "conv2d_transpose_1/stack/3"
  attr {
    key: "N"
    value {
      i: 4
    }
  }
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "axis"
    value {
      i: 0
    }
  }
}
node {
  name: "conv2d_transpose_1/conv2d_transpose"
  op: "Conv2DBackpropInput"
  input: "conv2d_transpose_1/stack"
  input: "conv2d_transpose_1/kernel/read"
  input: "LeakyRelu_17/Maximum"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 2
        i: 2
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_transpose_1/BiasAdd"
  op: "BiasAdd"
  input: "conv2d_transpose_1/conv2d_transpose"
  input: "conv2d_transpose_1/bias/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "LeakyRelu_18/alpha"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.20000000298023224
      }
    }
  }
}
node {
  name: "LeakyRelu_18/mul"
  op: "Mul"
  input: "LeakyRelu_18/alpha"
  input: "conv2d_transpose_1/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "LeakyRelu_18/Maximum"
  op: "Maximum"
  input: "LeakyRelu_18/mul"
  input: "conv2d_transpose_1/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "concat_1/axis"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
        }
        int_val: 3
      }
    }
  }
}
node {
  name: "concat_1"
  op: "ConcatV2"
  input: "LeakyRelu_18/Maximum"
  input: "LeakyRelu_10/Maximum"
  input: "concat_1/axis"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_17/kernel/Initializer/random_uniform/shape"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_17/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000\020\000\000\000\010\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_17/kernel/Initializer/random_uniform/min"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_17/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: -0.5
      }
    }
  }
}
node {
  name: "conv2d_17/kernel/Initializer/random_uniform/max"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_17/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.5
      }
    }
  }
}
node {
  name: "conv2d_17/kernel/Initializer/random_uniform/RandomUniform"
  op: "RandomUniform"
  input: "conv2d_17/kernel/Initializer/random_uniform/shape"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_17/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "seed"
    value {
      i: 0
    }
  }
  attr {
    key: "seed2"
    value {
      i: 0
    }
  }
}
node {
  name: "conv2d_17/kernel/Initializer/random_uniform/sub"
  op: "Sub"
  input: "conv2d_17/kernel/Initializer/random_uniform/max"
  input: "conv2d_17/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_17/kernel"
      }
    }
  }
}
node {
  name: "conv2d_17/kernel/Initializer/random_uniform/mul"
  op: "Mul"
  input: "conv2d_17/kernel/Initializer/random_uniform/RandomUniform"
  input: "conv2d_17/kernel/Initializer/random_uniform/sub"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_17/kernel"
      }
    }
  }
}
node {
  name: "conv2d_17/kernel/Initializer/random_uniform"
  op: "Add"
  input: "conv2d_17/kernel/Initializer/random_uniform/mul"
  input: "conv2d_17/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_17/kernel"
      }
    }
  }
}
node {
  name: "conv2d_17/kernel"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_17/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 1
        }
        dim {
          size: 1
        }
        dim {
          size: 16
        }
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_17/kernel/Assign"
  op: "Assign"
  input: "conv2d_17/kernel"
  input: "conv2d_17/kernel/Initializer/random_uniform"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_17/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_17/kernel/read"
  op: "Identity"
  input: "conv2d_17/kernel"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_17/kernel"
      }
    }
  }
}
node {
  name: "conv2d_17/bias/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_17/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_17/bias"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_17/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_17/bias/Assign"
  op: "Assign"
  input: "conv2d_17/bias"
  input: "conv2d_17/bias/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_17/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_17/bias/read"
  op: "Identity"
  input: "conv2d_17/bias"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_17/bias"
      }
    }
  }
}
node {
  name: "conv2d_17/dilation_rate"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 2
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_17/Conv2D"
  op: "Conv2D"
  input: "concat_1"
  input: "conv2d_17/kernel/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_17/BiasAdd"
  op: "BiasAdd"
  input: "conv2d_17/Conv2D"
  input: "conv2d_17/bias/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "LeakyRelu_19/alpha"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.20000000298023224
      }
    }
  }
}
node {
  name: "LeakyRelu_19/mul"
  op: "Mul"
  input: "LeakyRelu_19/alpha"
  input: "conv2d_17/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "LeakyRelu_19/Maximum"
  op: "Maximum"
  input: "LeakyRelu_19/mul"
  input: "conv2d_17/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "conv2d_transpose_2/kernel/Initializer/random_uniform/shape"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_2/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\003\000\000\000\003\000\000\000\010\000\000\000\010\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_transpose_2/kernel/Initializer/random_uniform/min"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_2/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: -0.20412415266036987
      }
    }
  }
}
node {
  name: "conv2d_transpose_2/kernel/Initializer/random_uniform/max"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_2/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.20412415266036987
      }
    }
  }
}
node {
  name: "conv2d_transpose_2/kernel/Initializer/random_uniform/RandomUniform"
  op: "RandomUniform"
  input: "conv2d_transpose_2/kernel/Initializer/random_uniform/shape"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_2/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "seed"
    value {
      i: 0
    }
  }
  attr {
    key: "seed2"
    value {
      i: 0
    }
  }
}
node {
  name: "conv2d_transpose_2/kernel/Initializer/random_uniform/sub"
  op: "Sub"
  input: "conv2d_transpose_2/kernel/Initializer/random_uniform/max"
  input: "conv2d_transpose_2/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_2/kernel"
      }
    }
  }
}
node {
  name: "conv2d_transpose_2/kernel/Initializer/random_uniform/mul"
  op: "Mul"
  input: "conv2d_transpose_2/kernel/Initializer/random_uniform/RandomUniform"
  input: "conv2d_transpose_2/kernel/Initializer/random_uniform/sub"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_2/kernel"
      }
    }
  }
}
node {
  name: "conv2d_transpose_2/kernel/Initializer/random_uniform"
  op: "Add"
  input: "conv2d_transpose_2/kernel/Initializer/random_uniform/mul"
  input: "conv2d_transpose_2/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_2/kernel"
      }
    }
  }
}
node {
  name: "conv2d_transpose_2/kernel"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_2/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 3
        }
        dim {
          size: 3
        }
        dim {
          size: 8
        }
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_transpose_2/kernel/Assign"
  op: "Assign"
  input: "conv2d_transpose_2/kernel"
  input: "conv2d_transpose_2/kernel/Initializer/random_uniform"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_2/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_transpose_2/kernel/read"
  op: "Identity"
  input: "conv2d_transpose_2/kernel"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_2/kernel"
      }
    }
  }
}
node {
  name: "conv2d_transpose_2/bias/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_2/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_transpose_2/bias"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_2/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_transpose_2/bias/Assign"
  op: "Assign"
  input: "conv2d_transpose_2/bias"
  input: "conv2d_transpose_2/bias/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_2/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_transpose_2/bias/read"
  op: "Identity"
  input: "conv2d_transpose_2/bias"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_2/bias"
      }
    }
  }
}
node {
  name: "conv2d_transpose_2/Shape"
  op: "Shape"
  input: "LeakyRelu_19/Maximum"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_transpose_2/strided_slice/stack"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 0
      }
    }
  }
}
node {
  name: "conv2d_transpose_2/strided_slice/stack_1"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 1
      }
    }
  }
}
node {
  name: "conv2d_transpose_2/strided_slice/stack_2"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 1
      }
    }
  }
}
node {
  name: "conv2d_transpose_2/strided_slice"
  op: "StridedSlice"
  input: "conv2d_transpose_2/Shape"
  input: "conv2d_transpose_2/strided_slice/stack"
  input: "conv2d_transpose_2/strided_slice/stack_1"
  input: "conv2d_transpose_2/strided_slice/stack_2"
  attr {
    key: "Index"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "begin_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "ellipsis_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "end_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "new_axis_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "shrink_axis_mask"
    value {
      i: 1
    }
  }
}
node {
  name: "conv2d_transpose_2/strided_slice_1/stack"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 1
      }
    }
  }
}
node {
  name: "conv2d_transpose_2/strided_slice_1/stack_1"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 2
      }
    }
  }
}
node {
  name: "conv2d_transpose_2/strided_slice_1/stack_2"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 1
      }
    }
  }
}
node {
  name: "conv2d_transpose_2/strided_slice_1"
  op: "StridedSlice"
  input: "conv2d_transpose_2/Shape"
  input: "conv2d_transpose_2/strided_slice_1/stack"
  input: "conv2d_transpose_2/strided_slice_1/stack_1"
  input: "conv2d_transpose_2/strided_slice_1/stack_2"
  attr {
    key: "Index"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "begin_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "ellipsis_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "end_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "new_axis_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "shrink_axis_mask"
    value {
      i: 1
    }
  }
}
node {
  name: "conv2d_transpose_2/strided_slice_2/stack"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 2
      }
    }
  }
}
node {
  name: "conv2d_transpose_2/strided_slice_2/stack_1"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 3
      }
    }
  }
}
node {
  name: "conv2d_transpose_2/strided_slice_2/stack_2"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 1
      }
    }
  }
}
node {
  name: "conv2d_transpose_2/strided_slice_2"
  op: "StridedSlice"
  input: "conv2d_transpose_2/Shape"
  input: "conv2d_transpose_2/strided_slice_2/stack"
  input: "conv2d_transpose_2/strided_slice_2/stack_1"
  input: "conv2d_transpose_2/strided_slice_2/stack_2"
  attr {
    key: "Index"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "begin_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "ellipsis_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "end_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "new_axis_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "shrink_axis_mask"
    value {
      i: 1
    }
  }
}
node {
  name: "conv2d_transpose_2/mul/y"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
        }
        int_val: 2
      }
    }
  }
}
node {
  name: "conv2d_transpose_2/mul"
  op: "Mul"
  input: "conv2d_transpose_2/strided_slice_1"
  input: "conv2d_transpose_2/mul/y"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_transpose_2/mul_1/y"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
        }
        int_val: 2
      }
    }
  }
}
node {
  name: "conv2d_transpose_2/mul_1"
  op: "Mul"
  input: "conv2d_transpose_2/strided_slice_2"
  input: "conv2d_transpose_2/mul_1/y"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_transpose_2/stack/3"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
        }
        int_val: 8
      }
    }
  }
}
node {
  name: "conv2d_transpose_2/stack"
  op: "Pack"
  input: "conv2d_transpose_2/strided_slice"
  input: "conv2d_transpose_2/mul"
  input: "conv2d_transpose_2/mul_1"
  input: "conv2d_transpose_2/stack/3"
  attr {
    key: "N"
    value {
      i: 4
    }
  }
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "axis"
    value {
      i: 0
    }
  }
}
node {
  name: "conv2d_transpose_2/conv2d_transpose"
  op: "Conv2DBackpropInput"
  input: "conv2d_transpose_2/stack"
  input: "conv2d_transpose_2/kernel/read"
  input: "LeakyRelu_19/Maximum"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 2
        i: 2
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_transpose_2/BiasAdd"
  op: "BiasAdd"
  input: "conv2d_transpose_2/conv2d_transpose"
  input: "conv2d_transpose_2/bias/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "LeakyRelu_20/alpha"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.20000000298023224
      }
    }
  }
}
node {
  name: "LeakyRelu_20/mul"
  op: "Mul"
  input: "LeakyRelu_20/alpha"
  input: "conv2d_transpose_2/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "LeakyRelu_20/Maximum"
  op: "Maximum"
  input: "LeakyRelu_20/mul"
  input: "conv2d_transpose_2/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "concat_2/axis"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
        }
        int_val: 3
      }
    }
  }
}
node {
  name: "concat_2"
  op: "ConcatV2"
  input: "LeakyRelu_20/Maximum"
  input: "LeakyRelu_8/Maximum"
  input: "concat_2/axis"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_18/kernel/Initializer/random_uniform/shape"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_18/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000\030\000\000\000\020\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_18/kernel/Initializer/random_uniform/min"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_18/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: -0.3872983455657959
      }
    }
  }
}
node {
  name: "conv2d_18/kernel/Initializer/random_uniform/max"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_18/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.3872983455657959
      }
    }
  }
}
node {
  name: "conv2d_18/kernel/Initializer/random_uniform/RandomUniform"
  op: "RandomUniform"
  input: "conv2d_18/kernel/Initializer/random_uniform/shape"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_18/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "seed"
    value {
      i: 0
    }
  }
  attr {
    key: "seed2"
    value {
      i: 0
    }
  }
}
node {
  name: "conv2d_18/kernel/Initializer/random_uniform/sub"
  op: "Sub"
  input: "conv2d_18/kernel/Initializer/random_uniform/max"
  input: "conv2d_18/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_18/kernel"
      }
    }
  }
}
node {
  name: "conv2d_18/kernel/Initializer/random_uniform/mul"
  op: "Mul"
  input: "conv2d_18/kernel/Initializer/random_uniform/RandomUniform"
  input: "conv2d_18/kernel/Initializer/random_uniform/sub"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_18/kernel"
      }
    }
  }
}
node {
  name: "conv2d_18/kernel/Initializer/random_uniform"
  op: "Add"
  input: "conv2d_18/kernel/Initializer/random_uniform/mul"
  input: "conv2d_18/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_18/kernel"
      }
    }
  }
}
node {
  name: "conv2d_18/kernel"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_18/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 1
        }
        dim {
          size: 1
        }
        dim {
          size: 24
        }
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_18/kernel/Assign"
  op: "Assign"
  input: "conv2d_18/kernel"
  input: "conv2d_18/kernel/Initializer/random_uniform"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_18/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_18/kernel/read"
  op: "Identity"
  input: "conv2d_18/kernel"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_18/kernel"
      }
    }
  }
}
node {
  name: "conv2d_18/bias/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_18/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 16
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_18/bias"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_18/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_18/bias/Assign"
  op: "Assign"
  input: "conv2d_18/bias"
  input: "conv2d_18/bias/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_18/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_18/bias/read"
  op: "Identity"
  input: "conv2d_18/bias"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_18/bias"
      }
    }
  }
}
node {
  name: "conv2d_18/dilation_rate"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 2
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_18/Conv2D"
  op: "Conv2D"
  input: "concat_2"
  input: "conv2d_18/kernel/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_18/BiasAdd"
  op: "BiasAdd"
  input: "conv2d_18/Conv2D"
  input: "conv2d_18/bias/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "LeakyRelu_21/alpha"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.20000000298023224
      }
    }
  }
}
node {
  name: "LeakyRelu_21/mul"
  op: "Mul"
  input: "LeakyRelu_21/alpha"
  input: "conv2d_18/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "LeakyRelu_21/Maximum"
  op: "Maximum"
  input: "LeakyRelu_21/mul"
  input: "conv2d_18/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "conv2d_19/kernel/Initializer/random_uniform/shape"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_19/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\003\000\000\000\003\000\000\000\020\000\000\000\020\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_19/kernel/Initializer/random_uniform/min"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_19/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: -0.14433756470680237
      }
    }
  }
}
node {
  name: "conv2d_19/kernel/Initializer/random_uniform/max"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_19/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.14433756470680237
      }
    }
  }
}
node {
  name: "conv2d_19/kernel/Initializer/random_uniform/RandomUniform"
  op: "RandomUniform"
  input: "conv2d_19/kernel/Initializer/random_uniform/shape"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_19/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "seed"
    value {
      i: 0
    }
  }
  attr {
    key: "seed2"
    value {
      i: 0
    }
  }
}
node {
  name: "conv2d_19/kernel/Initializer/random_uniform/sub"
  op: "Sub"
  input: "conv2d_19/kernel/Initializer/random_uniform/max"
  input: "conv2d_19/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_19/kernel"
      }
    }
  }
}
node {
  name: "conv2d_19/kernel/Initializer/random_uniform/mul"
  op: "Mul"
  input: "conv2d_19/kernel/Initializer/random_uniform/RandomUniform"
  input: "conv2d_19/kernel/Initializer/random_uniform/sub"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_19/kernel"
      }
    }
  }
}
node {
  name: "conv2d_19/kernel/Initializer/random_uniform"
  op: "Add"
  input: "conv2d_19/kernel/Initializer/random_uniform/mul"
  input: "conv2d_19/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_19/kernel"
      }
    }
  }
}
node {
  name: "conv2d_19/kernel"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_19/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 3
        }
        dim {
          size: 3
        }
        dim {
          size: 16
        }
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_19/kernel/Assign"
  op: "Assign"
  input: "conv2d_19/kernel"
  input: "conv2d_19/kernel/Initializer/random_uniform"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_19/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_19/kernel/read"
  op: "Identity"
  input: "conv2d_19/kernel"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_19/kernel"
      }
    }
  }
}
node {
  name: "conv2d_19/bias/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_19/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 16
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_19/bias"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_19/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_19/bias/Assign"
  op: "Assign"
  input: "conv2d_19/bias"
  input: "conv2d_19/bias/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_19/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_19/bias/read"
  op: "Identity"
  input: "conv2d_19/bias"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_19/bias"
      }
    }
  }
}
node {
  name: "conv2d_19/dilation_rate"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 2
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_19/Conv2D"
  op: "Conv2D"
  input: "LeakyRelu_21/Maximum"
  input: "conv2d_19/kernel/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_19/BiasAdd"
  op: "BiasAdd"
  input: "conv2d_19/Conv2D"
  input: "conv2d_19/bias/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "LeakyRelu_22/alpha"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.20000000298023224
      }
    }
  }
}
node {
  name: "LeakyRelu_22/mul"
  op: "Mul"
  input: "LeakyRelu_22/alpha"
  input: "conv2d_19/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "LeakyRelu_22/Maximum"
  op: "Maximum"
  input: "LeakyRelu_22/mul"
  input: "conv2d_19/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "conv2d_transpose_3/kernel/Initializer/random_uniform/shape"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_3/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\003\000\000\000\003\000\000\000\020\000\000\000\020\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_transpose_3/kernel/Initializer/random_uniform/min"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_3/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: -0.14433756470680237
      }
    }
  }
}
node {
  name: "conv2d_transpose_3/kernel/Initializer/random_uniform/max"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_3/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.14433756470680237
      }
    }
  }
}
node {
  name: "conv2d_transpose_3/kernel/Initializer/random_uniform/RandomUniform"
  op: "RandomUniform"
  input: "conv2d_transpose_3/kernel/Initializer/random_uniform/shape"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_3/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "seed"
    value {
      i: 0
    }
  }
  attr {
    key: "seed2"
    value {
      i: 0
    }
  }
}
node {
  name: "conv2d_transpose_3/kernel/Initializer/random_uniform/sub"
  op: "Sub"
  input: "conv2d_transpose_3/kernel/Initializer/random_uniform/max"
  input: "conv2d_transpose_3/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_3/kernel"
      }
    }
  }
}
node {
  name: "conv2d_transpose_3/kernel/Initializer/random_uniform/mul"
  op: "Mul"
  input: "conv2d_transpose_3/kernel/Initializer/random_uniform/RandomUniform"
  input: "conv2d_transpose_3/kernel/Initializer/random_uniform/sub"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_3/kernel"
      }
    }
  }
}
node {
  name: "conv2d_transpose_3/kernel/Initializer/random_uniform"
  op: "Add"
  input: "conv2d_transpose_3/kernel/Initializer/random_uniform/mul"
  input: "conv2d_transpose_3/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_3/kernel"
      }
    }
  }
}
node {
  name: "conv2d_transpose_3/kernel"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_3/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 3
        }
        dim {
          size: 3
        }
        dim {
          size: 16
        }
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_transpose_3/kernel/Assign"
  op: "Assign"
  input: "conv2d_transpose_3/kernel"
  input: "conv2d_transpose_3/kernel/Initializer/random_uniform"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_3/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_transpose_3/kernel/read"
  op: "Identity"
  input: "conv2d_transpose_3/kernel"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_3/kernel"
      }
    }
  }
}
node {
  name: "conv2d_transpose_3/bias/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_3/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 16
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_transpose_3/bias"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_3/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_transpose_3/bias/Assign"
  op: "Assign"
  input: "conv2d_transpose_3/bias"
  input: "conv2d_transpose_3/bias/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_3/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_transpose_3/bias/read"
  op: "Identity"
  input: "conv2d_transpose_3/bias"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_3/bias"
      }
    }
  }
}
node {
  name: "conv2d_transpose_3/Shape"
  op: "Shape"
  input: "LeakyRelu_22/Maximum"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_transpose_3/strided_slice/stack"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 0
      }
    }
  }
}
node {
  name: "conv2d_transpose_3/strided_slice/stack_1"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 1
      }
    }
  }
}
node {
  name: "conv2d_transpose_3/strided_slice/stack_2"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 1
      }
    }
  }
}
node {
  name: "conv2d_transpose_3/strided_slice"
  op: "StridedSlice"
  input: "conv2d_transpose_3/Shape"
  input: "conv2d_transpose_3/strided_slice/stack"
  input: "conv2d_transpose_3/strided_slice/stack_1"
  input: "conv2d_transpose_3/strided_slice/stack_2"
  attr {
    key: "Index"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "begin_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "ellipsis_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "end_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "new_axis_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "shrink_axis_mask"
    value {
      i: 1
    }
  }
}
node {
  name: "conv2d_transpose_3/strided_slice_1/stack"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 1
      }
    }
  }
}
node {
  name: "conv2d_transpose_3/strided_slice_1/stack_1"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 2
      }
    }
  }
}
node {
  name: "conv2d_transpose_3/strided_slice_1/stack_2"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 1
      }
    }
  }
}
node {
  name: "conv2d_transpose_3/strided_slice_1"
  op: "StridedSlice"
  input: "conv2d_transpose_3/Shape"
  input: "conv2d_transpose_3/strided_slice_1/stack"
  input: "conv2d_transpose_3/strided_slice_1/stack_1"
  input: "conv2d_transpose_3/strided_slice_1/stack_2"
  attr {
    key: "Index"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "begin_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "ellipsis_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "end_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "new_axis_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "shrink_axis_mask"
    value {
      i: 1
    }
  }
}
node {
  name: "conv2d_transpose_3/strided_slice_2/stack"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 2
      }
    }
  }
}
node {
  name: "conv2d_transpose_3/strided_slice_2/stack_1"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 3
      }
    }
  }
}
node {
  name: "conv2d_transpose_3/strided_slice_2/stack_2"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 1
      }
    }
  }
}
node {
  name: "conv2d_transpose_3/strided_slice_2"
  op: "StridedSlice"
  input: "conv2d_transpose_3/Shape"
  input: "conv2d_transpose_3/strided_slice_2/stack"
  input: "conv2d_transpose_3/strided_slice_2/stack_1"
  input: "conv2d_transpose_3/strided_slice_2/stack_2"
  attr {
    key: "Index"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "begin_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "ellipsis_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "end_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "new_axis_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "shrink_axis_mask"
    value {
      i: 1
    }
  }
}
node {
  name: "conv2d_transpose_3/mul/y"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
        }
        int_val: 2
      }
    }
  }
}
node {
  name: "conv2d_transpose_3/mul"
  op: "Mul"
  input: "conv2d_transpose_3/strided_slice_1"
  input: "conv2d_transpose_3/mul/y"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_transpose_3/mul_1/y"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
        }
        int_val: 2
      }
    }
  }
}
node {
  name: "conv2d_transpose_3/mul_1"
  op: "Mul"
  input: "conv2d_transpose_3/strided_slice_2"
  input: "conv2d_transpose_3/mul_1/y"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_transpose_3/stack/3"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
        }
        int_val: 16
      }
    }
  }
}
node {
  name: "conv2d_transpose_3/stack"
  op: "Pack"
  input: "conv2d_transpose_3/strided_slice"
  input: "conv2d_transpose_3/mul"
  input: "conv2d_transpose_3/mul_1"
  input: "conv2d_transpose_3/stack/3"
  attr {
    key: "N"
    value {
      i: 4
    }
  }
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "axis"
    value {
      i: 0
    }
  }
}
node {
  name: "conv2d_transpose_3/conv2d_transpose"
  op: "Conv2DBackpropInput"
  input: "conv2d_transpose_3/stack"
  input: "conv2d_transpose_3/kernel/read"
  input: "LeakyRelu_22/Maximum"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 2
        i: 2
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_transpose_3/BiasAdd"
  op: "BiasAdd"
  input: "conv2d_transpose_3/conv2d_transpose"
  input: "conv2d_transpose_3/bias/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "LeakyRelu_23/alpha"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.20000000298023224
      }
    }
  }
}
node {
  name: "LeakyRelu_23/mul"
  op: "Mul"
  input: "LeakyRelu_23/alpha"
  input: "conv2d_transpose_3/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "LeakyRelu_23/Maximum"
  op: "Maximum"
  input: "LeakyRelu_23/mul"
  input: "conv2d_transpose_3/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "concat_3/axis"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
        }
        int_val: 3
      }
    }
  }
}
node {
  name: "concat_3"
  op: "ConcatV2"
  input: "LeakyRelu_23/Maximum"
  input: "LeakyRelu_5/Maximum"
  input: "concat_3/axis"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_20/kernel/Initializer/random_uniform/shape"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_20/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000 \000\000\000\020\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_20/kernel/Initializer/random_uniform/min"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_20/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: -0.3535533845424652
      }
    }
  }
}
node {
  name: "conv2d_20/kernel/Initializer/random_uniform/max"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_20/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.3535533845424652
      }
    }
  }
}
node {
  name: "conv2d_20/kernel/Initializer/random_uniform/RandomUniform"
  op: "RandomUniform"
  input: "conv2d_20/kernel/Initializer/random_uniform/shape"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_20/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "seed"
    value {
      i: 0
    }
  }
  attr {
    key: "seed2"
    value {
      i: 0
    }
  }
}
node {
  name: "conv2d_20/kernel/Initializer/random_uniform/sub"
  op: "Sub"
  input: "conv2d_20/kernel/Initializer/random_uniform/max"
  input: "conv2d_20/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_20/kernel"
      }
    }
  }
}
node {
  name: "conv2d_20/kernel/Initializer/random_uniform/mul"
  op: "Mul"
  input: "conv2d_20/kernel/Initializer/random_uniform/RandomUniform"
  input: "conv2d_20/kernel/Initializer/random_uniform/sub"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_20/kernel"
      }
    }
  }
}
node {
  name: "conv2d_20/kernel/Initializer/random_uniform"
  op: "Add"
  input: "conv2d_20/kernel/Initializer/random_uniform/mul"
  input: "conv2d_20/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_20/kernel"
      }
    }
  }
}
node {
  name: "conv2d_20/kernel"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_20/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 1
        }
        dim {
          size: 1
        }
        dim {
          size: 32
        }
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_20/kernel/Assign"
  op: "Assign"
  input: "conv2d_20/kernel"
  input: "conv2d_20/kernel/Initializer/random_uniform"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_20/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_20/kernel/read"
  op: "Identity"
  input: "conv2d_20/kernel"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_20/kernel"
      }
    }
  }
}
node {
  name: "conv2d_20/bias/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_20/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 16
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_20/bias"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_20/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_20/bias/Assign"
  op: "Assign"
  input: "conv2d_20/bias"
  input: "conv2d_20/bias/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_20/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_20/bias/read"
  op: "Identity"
  input: "conv2d_20/bias"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_20/bias"
      }
    }
  }
}
node {
  name: "conv2d_20/dilation_rate"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 2
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_20/Conv2D"
  op: "Conv2D"
  input: "concat_3"
  input: "conv2d_20/kernel/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_20/BiasAdd"
  op: "BiasAdd"
  input: "conv2d_20/Conv2D"
  input: "conv2d_20/bias/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "LeakyRelu_24/alpha"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.20000000298023224
      }
    }
  }
}
node {
  name: "LeakyRelu_24/mul"
  op: "Mul"
  input: "LeakyRelu_24/alpha"
  input: "conv2d_20/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "LeakyRelu_24/Maximum"
  op: "Maximum"
  input: "LeakyRelu_24/mul"
  input: "conv2d_20/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "conv2d_21/kernel/Initializer/random_uniform/shape"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_21/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\004\000\000\000\004\000\000\000\020\000\000\000\030\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_21/kernel/Initializer/random_uniform/min"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_21/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: -0.09682458639144897
      }
    }
  }
}
node {
  name: "conv2d_21/kernel/Initializer/random_uniform/max"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_21/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.09682458639144897
      }
    }
  }
}
node {
  name: "conv2d_21/kernel/Initializer/random_uniform/RandomUniform"
  op: "RandomUniform"
  input: "conv2d_21/kernel/Initializer/random_uniform/shape"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_21/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "seed"
    value {
      i: 0
    }
  }
  attr {
    key: "seed2"
    value {
      i: 0
    }
  }
}
node {
  name: "conv2d_21/kernel/Initializer/random_uniform/sub"
  op: "Sub"
  input: "conv2d_21/kernel/Initializer/random_uniform/max"
  input: "conv2d_21/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_21/kernel"
      }
    }
  }
}
node {
  name: "conv2d_21/kernel/Initializer/random_uniform/mul"
  op: "Mul"
  input: "conv2d_21/kernel/Initializer/random_uniform/RandomUniform"
  input: "conv2d_21/kernel/Initializer/random_uniform/sub"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_21/kernel"
      }
    }
  }
}
node {
  name: "conv2d_21/kernel/Initializer/random_uniform"
  op: "Add"
  input: "conv2d_21/kernel/Initializer/random_uniform/mul"
  input: "conv2d_21/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_21/kernel"
      }
    }
  }
}
node {
  name: "conv2d_21/kernel"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_21/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 4
        }
        dim {
          size: 4
        }
        dim {
          size: 16
        }
        dim {
          size: 24
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_21/kernel/Assign"
  op: "Assign"
  input: "conv2d_21/kernel"
  input: "conv2d_21/kernel/Initializer/random_uniform"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_21/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_21/kernel/read"
  op: "Identity"
  input: "conv2d_21/kernel"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_21/kernel"
      }
    }
  }
}
node {
  name: "conv2d_21/bias/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_21/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 24
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_21/bias"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_21/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 24
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_21/bias/Assign"
  op: "Assign"
  input: "conv2d_21/bias"
  input: "conv2d_21/bias/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_21/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_21/bias/read"
  op: "Identity"
  input: "conv2d_21/bias"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_21/bias"
      }
    }
  }
}
node {
  name: "conv2d_21/dilation_rate"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 2
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_21/Conv2D"
  op: "Conv2D"
  input: "LeakyRelu_24/Maximum"
  input: "conv2d_21/kernel/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_21/BiasAdd"
  op: "BiasAdd"
  input: "conv2d_21/Conv2D"
  input: "conv2d_21/bias/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "LeakyRelu_25/alpha"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.20000000298023224
      }
    }
  }
}
node {
  name: "LeakyRelu_25/mul"
  op: "Mul"
  input: "LeakyRelu_25/alpha"
  input: "conv2d_21/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "LeakyRelu_25/Maximum"
  op: "Maximum"
  input: "LeakyRelu_25/mul"
  input: "conv2d_21/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "conv2d_transpose_4/kernel/Initializer/random_uniform/shape"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_4/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\004\000\000\000\004\000\000\000\030\000\000\000\030\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_transpose_4/kernel/Initializer/random_uniform/min"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_4/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: -0.0883883461356163
      }
    }
  }
}
node {
  name: "conv2d_transpose_4/kernel/Initializer/random_uniform/max"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_4/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0883883461356163
      }
    }
  }
}
node {
  name: "conv2d_transpose_4/kernel/Initializer/random_uniform/RandomUniform"
  op: "RandomUniform"
  input: "conv2d_transpose_4/kernel/Initializer/random_uniform/shape"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_4/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "seed"
    value {
      i: 0
    }
  }
  attr {
    key: "seed2"
    value {
      i: 0
    }
  }
}
node {
  name: "conv2d_transpose_4/kernel/Initializer/random_uniform/sub"
  op: "Sub"
  input: "conv2d_transpose_4/kernel/Initializer/random_uniform/max"
  input: "conv2d_transpose_4/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_4/kernel"
      }
    }
  }
}
node {
  name: "conv2d_transpose_4/kernel/Initializer/random_uniform/mul"
  op: "Mul"
  input: "conv2d_transpose_4/kernel/Initializer/random_uniform/RandomUniform"
  input: "conv2d_transpose_4/kernel/Initializer/random_uniform/sub"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_4/kernel"
      }
    }
  }
}
node {
  name: "conv2d_transpose_4/kernel/Initializer/random_uniform"
  op: "Add"
  input: "conv2d_transpose_4/kernel/Initializer/random_uniform/mul"
  input: "conv2d_transpose_4/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_4/kernel"
      }
    }
  }
}
node {
  name: "conv2d_transpose_4/kernel"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_4/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 4
        }
        dim {
          size: 4
        }
        dim {
          size: 24
        }
        dim {
          size: 24
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_transpose_4/kernel/Assign"
  op: "Assign"
  input: "conv2d_transpose_4/kernel"
  input: "conv2d_transpose_4/kernel/Initializer/random_uniform"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_4/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_transpose_4/kernel/read"
  op: "Identity"
  input: "conv2d_transpose_4/kernel"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_4/kernel"
      }
    }
  }
}
node {
  name: "conv2d_transpose_4/bias/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_4/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 24
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_transpose_4/bias"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_4/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 24
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_transpose_4/bias/Assign"
  op: "Assign"
  input: "conv2d_transpose_4/bias"
  input: "conv2d_transpose_4/bias/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_4/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_transpose_4/bias/read"
  op: "Identity"
  input: "conv2d_transpose_4/bias"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_4/bias"
      }
    }
  }
}
node {
  name: "conv2d_transpose_4/Shape"
  op: "Shape"
  input: "LeakyRelu_25/Maximum"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_transpose_4/strided_slice/stack"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 0
      }
    }
  }
}
node {
  name: "conv2d_transpose_4/strided_slice/stack_1"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 1
      }
    }
  }
}
node {
  name: "conv2d_transpose_4/strided_slice/stack_2"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 1
      }
    }
  }
}
node {
  name: "conv2d_transpose_4/strided_slice"
  op: "StridedSlice"
  input: "conv2d_transpose_4/Shape"
  input: "conv2d_transpose_4/strided_slice/stack"
  input: "conv2d_transpose_4/strided_slice/stack_1"
  input: "conv2d_transpose_4/strided_slice/stack_2"
  attr {
    key: "Index"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "begin_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "ellipsis_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "end_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "new_axis_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "shrink_axis_mask"
    value {
      i: 1
    }
  }
}
node {
  name: "conv2d_transpose_4/strided_slice_1/stack"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 1
      }
    }
  }
}
node {
  name: "conv2d_transpose_4/strided_slice_1/stack_1"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 2
      }
    }
  }
}
node {
  name: "conv2d_transpose_4/strided_slice_1/stack_2"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 1
      }
    }
  }
}
node {
  name: "conv2d_transpose_4/strided_slice_1"
  op: "StridedSlice"
  input: "conv2d_transpose_4/Shape"
  input: "conv2d_transpose_4/strided_slice_1/stack"
  input: "conv2d_transpose_4/strided_slice_1/stack_1"
  input: "conv2d_transpose_4/strided_slice_1/stack_2"
  attr {
    key: "Index"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "begin_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "ellipsis_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "end_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "new_axis_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "shrink_axis_mask"
    value {
      i: 1
    }
  }
}
node {
  name: "conv2d_transpose_4/strided_slice_2/stack"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 2
      }
    }
  }
}
node {
  name: "conv2d_transpose_4/strided_slice_2/stack_1"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 3
      }
    }
  }
}
node {
  name: "conv2d_transpose_4/strided_slice_2/stack_2"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 1
      }
    }
  }
}
node {
  name: "conv2d_transpose_4/strided_slice_2"
  op: "StridedSlice"
  input: "conv2d_transpose_4/Shape"
  input: "conv2d_transpose_4/strided_slice_2/stack"
  input: "conv2d_transpose_4/strided_slice_2/stack_1"
  input: "conv2d_transpose_4/strided_slice_2/stack_2"
  attr {
    key: "Index"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "begin_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "ellipsis_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "end_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "new_axis_mask"
    value {
      i: 0
    }
  }
  attr {
    key: "shrink_axis_mask"
    value {
      i: 1
    }
  }
}
node {
  name: "conv2d_transpose_4/mul/y"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
        }
        int_val: 2
      }
    }
  }
}
node {
  name: "conv2d_transpose_4/mul"
  op: "Mul"
  input: "conv2d_transpose_4/strided_slice_1"
  input: "conv2d_transpose_4/mul/y"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_transpose_4/mul_1/y"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
        }
        int_val: 2
      }
    }
  }
}
node {
  name: "conv2d_transpose_4/mul_1"
  op: "Mul"
  input: "conv2d_transpose_4/strided_slice_2"
  input: "conv2d_transpose_4/mul_1/y"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_transpose_4/stack/3"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
        }
        int_val: 24
      }
    }
  }
}
node {
  name: "conv2d_transpose_4/stack"
  op: "Pack"
  input: "conv2d_transpose_4/strided_slice"
  input: "conv2d_transpose_4/mul"
  input: "conv2d_transpose_4/mul_1"
  input: "conv2d_transpose_4/stack/3"
  attr {
    key: "N"
    value {
      i: 4
    }
  }
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "axis"
    value {
      i: 0
    }
  }
}
node {
  name: "conv2d_transpose_4/conv2d_transpose"
  op: "Conv2DBackpropInput"
  input: "conv2d_transpose_4/stack"
  input: "conv2d_transpose_4/kernel/read"
  input: "LeakyRelu_25/Maximum"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 2
        i: 2
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_transpose_4/BiasAdd"
  op: "BiasAdd"
  input: "conv2d_transpose_4/conv2d_transpose"
  input: "conv2d_transpose_4/bias/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "LeakyRelu_26/alpha"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.20000000298023224
      }
    }
  }
}
node {
  name: "LeakyRelu_26/mul"
  op: "Mul"
  input: "LeakyRelu_26/alpha"
  input: "conv2d_transpose_4/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "LeakyRelu_26/Maximum"
  op: "Maximum"
  input: "LeakyRelu_26/mul"
  input: "conv2d_transpose_4/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "concat_4/axis"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
        }
        int_val: 3
      }
    }
  }
}
node {
  name: "concat_4"
  op: "ConcatV2"
  input: "LeakyRelu_26/Maximum"
  input: "Reshape"
  input: "concat_4/axis"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_22/kernel/Initializer/random_uniform/shape"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_22/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\005\000\000\000\005\000\000\000\033\000\000\000\020\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_22/kernel/Initializer/random_uniform/min"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_22/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: -0.0747087374329567
      }
    }
  }
}
node {
  name: "conv2d_22/kernel/Initializer/random_uniform/max"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_22/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0747087374329567
      }
    }
  }
}
node {
  name: "conv2d_22/kernel/Initializer/random_uniform/RandomUniform"
  op: "RandomUniform"
  input: "conv2d_22/kernel/Initializer/random_uniform/shape"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_22/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "seed"
    value {
      i: 0
    }
  }
  attr {
    key: "seed2"
    value {
      i: 0
    }
  }
}
node {
  name: "conv2d_22/kernel/Initializer/random_uniform/sub"
  op: "Sub"
  input: "conv2d_22/kernel/Initializer/random_uniform/max"
  input: "conv2d_22/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_22/kernel"
      }
    }
  }
}
node {
  name: "conv2d_22/kernel/Initializer/random_uniform/mul"
  op: "Mul"
  input: "conv2d_22/kernel/Initializer/random_uniform/RandomUniform"
  input: "conv2d_22/kernel/Initializer/random_uniform/sub"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_22/kernel"
      }
    }
  }
}
node {
  name: "conv2d_22/kernel/Initializer/random_uniform"
  op: "Add"
  input: "conv2d_22/kernel/Initializer/random_uniform/mul"
  input: "conv2d_22/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_22/kernel"
      }
    }
  }
}
node {
  name: "conv2d_22/kernel"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_22/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 5
        }
        dim {
          size: 5
        }
        dim {
          size: 27
        }
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_22/kernel/Assign"
  op: "Assign"
  input: "conv2d_22/kernel"
  input: "conv2d_22/kernel/Initializer/random_uniform"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_22/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_22/kernel/read"
  op: "Identity"
  input: "conv2d_22/kernel"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_22/kernel"
      }
    }
  }
}
node {
  name: "conv2d_22/bias/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_22/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 16
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_22/bias"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_22/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_22/bias/Assign"
  op: "Assign"
  input: "conv2d_22/bias"
  input: "conv2d_22/bias/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_22/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_22/bias/read"
  op: "Identity"
  input: "conv2d_22/bias"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_22/bias"
      }
    }
  }
}
node {
  name: "conv2d_22/dilation_rate"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 2
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_22/Conv2D"
  op: "Conv2D"
  input: "concat_4"
  input: "conv2d_22/kernel/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_22/BiasAdd"
  op: "BiasAdd"
  input: "conv2d_22/Conv2D"
  input: "conv2d_22/bias/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "LeakyRelu_27/alpha"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.20000000298023224
      }
    }
  }
}
node {
  name: "LeakyRelu_27/mul"
  op: "Mul"
  input: "LeakyRelu_27/alpha"
  input: "conv2d_22/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "LeakyRelu_27/Maximum"
  op: "Maximum"
  input: "LeakyRelu_27/mul"
  input: "conv2d_22/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "conv2d_23/kernel/Initializer/random_uniform/shape"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_23/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\006\000\000\000\006\000\000\000\020\000\000\000\030\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_23/kernel/Initializer/random_uniform/min"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_23/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: -0.06454972177743912
      }
    }
  }
}
node {
  name: "conv2d_23/kernel/Initializer/random_uniform/max"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_23/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.06454972177743912
      }
    }
  }
}
node {
  name: "conv2d_23/kernel/Initializer/random_uniform/RandomUniform"
  op: "RandomUniform"
  input: "conv2d_23/kernel/Initializer/random_uniform/shape"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_23/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "seed"
    value {
      i: 0
    }
  }
  attr {
    key: "seed2"
    value {
      i: 0
    }
  }
}
node {
  name: "conv2d_23/kernel/Initializer/random_uniform/sub"
  op: "Sub"
  input: "conv2d_23/kernel/Initializer/random_uniform/max"
  input: "conv2d_23/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_23/kernel"
      }
    }
  }
}
node {
  name: "conv2d_23/kernel/Initializer/random_uniform/mul"
  op: "Mul"
  input: "conv2d_23/kernel/Initializer/random_uniform/RandomUniform"
  input: "conv2d_23/kernel/Initializer/random_uniform/sub"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_23/kernel"
      }
    }
  }
}
node {
  name: "conv2d_23/kernel/Initializer/random_uniform"
  op: "Add"
  input: "conv2d_23/kernel/Initializer/random_uniform/mul"
  input: "conv2d_23/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_23/kernel"
      }
    }
  }
}
node {
  name: "conv2d_23/kernel"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_23/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 6
        }
        dim {
          size: 6
        }
        dim {
          size: 16
        }
        dim {
          size: 24
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_23/kernel/Assign"
  op: "Assign"
  input: "conv2d_23/kernel"
  input: "conv2d_23/kernel/Initializer/random_uniform"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_23/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_23/kernel/read"
  op: "Identity"
  input: "conv2d_23/kernel"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_23/kernel"
      }
    }
  }
}
node {
  name: "conv2d_23/bias/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_23/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 24
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_23/bias"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_23/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 24
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_23/bias/Assign"
  op: "Assign"
  input: "conv2d_23/bias"
  input: "conv2d_23/bias/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_23/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_23/bias/read"
  op: "Identity"
  input: "conv2d_23/bias"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_23/bias"
      }
    }
  }
}
node {
  name: "conv2d_23/dilation_rate"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 2
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_23/Conv2D"
  op: "Conv2D"
  input: "LeakyRelu_27/Maximum"
  input: "conv2d_23/kernel/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_23/BiasAdd"
  op: "BiasAdd"
  input: "conv2d_23/Conv2D"
  input: "conv2d_23/bias/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "LeakyRelu_28/alpha"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.20000000298023224
      }
    }
  }
}
node {
  name: "LeakyRelu_28/mul"
  op: "Mul"
  input: "LeakyRelu_28/alpha"
  input: "conv2d_23/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "LeakyRelu_28/Maximum"
  op: "Maximum"
  input: "LeakyRelu_28/mul"
  input: "conv2d_23/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "conv2d_24/kernel/Initializer/random_uniform/shape"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_24/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\010\000\000\000\010\000\000\000\030\000\000\000 \000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_24/kernel/Initializer/random_uniform/min"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_24/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: -0.04091585427522659
      }
    }
  }
}
node {
  name: "conv2d_24/kernel/Initializer/random_uniform/max"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_24/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.04091585427522659
      }
    }
  }
}
node {
  name: "conv2d_24/kernel/Initializer/random_uniform/RandomUniform"
  op: "RandomUniform"
  input: "conv2d_24/kernel/Initializer/random_uniform/shape"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_24/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "seed"
    value {
      i: 0
    }
  }
  attr {
    key: "seed2"
    value {
      i: 0
    }
  }
}
node {
  name: "conv2d_24/kernel/Initializer/random_uniform/sub"
  op: "Sub"
  input: "conv2d_24/kernel/Initializer/random_uniform/max"
  input: "conv2d_24/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_24/kernel"
      }
    }
  }
}
node {
  name: "conv2d_24/kernel/Initializer/random_uniform/mul"
  op: "Mul"
  input: "conv2d_24/kernel/Initializer/random_uniform/RandomUniform"
  input: "conv2d_24/kernel/Initializer/random_uniform/sub"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_24/kernel"
      }
    }
  }
}
node {
  name: "conv2d_24/kernel/Initializer/random_uniform"
  op: "Add"
  input: "conv2d_24/kernel/Initializer/random_uniform/mul"
  input: "conv2d_24/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_24/kernel"
      }
    }
  }
}
node {
  name: "conv2d_24/kernel"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_24/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
        dim {
          size: 8
        }
        dim {
          size: 24
        }
        dim {
          size: 32
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_24/kernel/Assign"
  op: "Assign"
  input: "conv2d_24/kernel"
  input: "conv2d_24/kernel/Initializer/random_uniform"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_24/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_24/kernel/read"
  op: "Identity"
  input: "conv2d_24/kernel"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_24/kernel"
      }
    }
  }
}
node {
  name: "conv2d_24/bias/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_24/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 32
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_24/bias"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_24/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 32
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_24/bias/Assign"
  op: "Assign"
  input: "conv2d_24/bias"
  input: "conv2d_24/bias/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_24/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_24/bias/read"
  op: "Identity"
  input: "conv2d_24/bias"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_24/bias"
      }
    }
  }
}
node {
  name: "conv2d_24/dilation_rate"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 2
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_24/Conv2D"
  op: "Conv2D"
  input: "LeakyRelu_28/Maximum"
  input: "conv2d_24/kernel/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_24/BiasAdd"
  op: "BiasAdd"
  input: "conv2d_24/Conv2D"
  input: "conv2d_24/bias/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "LeakyRelu_29/alpha"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.20000000298023224
      }
    }
  }
}
node {
  name: "LeakyRelu_29/mul"
  op: "Mul"
  input: "LeakyRelu_29/alpha"
  input: "conv2d_24/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "LeakyRelu_29/Maximum"
  op: "Maximum"
  input: "LeakyRelu_29/mul"
  input: "conv2d_24/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "conv2d_25/kernel/Initializer/random_uniform/shape"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_25/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\002\000\000\000\002\000\000\000 \000\000\000\003\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_25/kernel/Initializer/random_uniform/min"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_25/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: -0.20701967179775238
      }
    }
  }
}
node {
  name: "conv2d_25/kernel/Initializer/random_uniform/max"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_25/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.20701967179775238
      }
    }
  }
}
node {
  name: "conv2d_25/kernel/Initializer/random_uniform/RandomUniform"
  op: "RandomUniform"
  input: "conv2d_25/kernel/Initializer/random_uniform/shape"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_25/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "seed"
    value {
      i: 0
    }
  }
  attr {
    key: "seed2"
    value {
      i: 0
    }
  }
}
node {
  name: "conv2d_25/kernel/Initializer/random_uniform/sub"
  op: "Sub"
  input: "conv2d_25/kernel/Initializer/random_uniform/max"
  input: "conv2d_25/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_25/kernel"
      }
    }
  }
}
node {
  name: "conv2d_25/kernel/Initializer/random_uniform/mul"
  op: "Mul"
  input: "conv2d_25/kernel/Initializer/random_uniform/RandomUniform"
  input: "conv2d_25/kernel/Initializer/random_uniform/sub"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_25/kernel"
      }
    }
  }
}
node {
  name: "conv2d_25/kernel/Initializer/random_uniform"
  op: "Add"
  input: "conv2d_25/kernel/Initializer/random_uniform/mul"
  input: "conv2d_25/kernel/Initializer/random_uniform/min"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_25/kernel"
      }
    }
  }
}
node {
  name: "conv2d_25/kernel"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_25/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 2
        }
        dim {
          size: 2
        }
        dim {
          size: 32
        }
        dim {
          size: 3
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_25/kernel/Assign"
  op: "Assign"
  input: "conv2d_25/kernel"
  input: "conv2d_25/kernel/Initializer/random_uniform"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_25/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_25/kernel/read"
  op: "Identity"
  input: "conv2d_25/kernel"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_25/kernel"
      }
    }
  }
}
node {
  name: "conv2d_25/bias/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_25/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 3
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_25/bias"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_25/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 3
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_25/bias/Assign"
  op: "Assign"
  input: "conv2d_25/bias"
  input: "conv2d_25/bias/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_25/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_25/bias/read"
  op: "Identity"
  input: "conv2d_25/bias"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_25/bias"
      }
    }
  }
}
node {
  name: "conv2d_25/dilation_rate"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 2
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_25/Conv2D"
  op: "Conv2D"
  input: "LeakyRelu_29/Maximum"
  input: "conv2d_25/kernel/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_25/BiasAdd"
  op: "BiasAdd"
  input: "conv2d_25/Conv2D"
  input: "conv2d_25/bias/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "LeakyRelu_30/alpha"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.20000000298023224
      }
    }
  }
}
node {
  name: "LeakyRelu_30/mul"
  op: "Mul"
  input: "LeakyRelu_30/alpha"
  input: "conv2d_25/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "LeakyRelu_30/Maximum"
  op: "Maximum"
  input: "LeakyRelu_30/mul"
  input: "conv2d_25/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "denoised_data/y"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 255.0
      }
    }
  }
}
node {
  name: "denoised_data"
  op: "Mul"
  input: "LeakyRelu_30/Maximum"
  input: "denoised_data/y"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "sub"
  op: "Sub"
  input: "target_data"
  input: "denoised_data"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "Square"
  op: "Square"
  input: "sub"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\000\000\000\000\001\000\000\000\002\000\000\000\003\000\000\000"
      }
    }
  }
}
node {
  name: "Mean"
  op: "Mean"
  input: "Square"
  input: "Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "Sqrt"
  op: "Sqrt"
  input: "Mean"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "cost/tags"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_STRING
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_STRING
        tensor_shape {
        }
        string_val: "cost"
      }
    }
  }
}
node {
  name: "cost"
  op: "ScalarSummary"
  input: "cost/tags"
  input: "Sqrt"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "Merge/MergeSummary"
  op: "MergeSummary"
  input: "cost"
  attr {
    key: "N"
    value {
      i: 1
    }
  }
}
node {
  name: "gradients/Shape"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
          }
        }
      }
    }
  }
}
node {
  name: "gradients/grad_ys_0"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 1.0
      }
    }
  }
}
node {
  name: "gradients/Fill"
  op: "Fill"
  input: "gradients/Shape"
  input: "gradients/grad_ys_0"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/Sqrt_grad/SqrtGrad"
  op: "SqrtGrad"
  input: "Sqrt"
  input: "gradients/Fill"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/Mean_grad/Reshape/shape"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000\001\000\000\000\001\000\000\000"
      }
    }
  }
}
node {
  name: "gradients/Mean_grad/Reshape"
  op: "Reshape"
  input: "gradients/Sqrt_grad/SqrtGrad"
  input: "gradients/Mean_grad/Reshape/shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/Mean_grad/Shape"
  op: "Shape"
  input: "Square"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/Mean_grad/Tile"
  op: "Tile"
  input: "gradients/Mean_grad/Reshape"
  input: "gradients/Mean_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tmultiples"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/Mean_grad/Shape_1"
  op: "Shape"
  input: "Square"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/Mean_grad/Shape_2"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
          }
        }
      }
    }
  }
}
node {
  name: "gradients/Mean_grad/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 0
      }
    }
  }
}
node {
  name: "gradients/Mean_grad/Prod"
  op: "Prod"
  input: "gradients/Mean_grad/Shape_1"
  input: "gradients/Mean_grad/Const"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/Mean_grad/Const_1"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 1
          }
        }
        int_val: 0
      }
    }
  }
}
node {
  name: "gradients/Mean_grad/Prod_1"
  op: "Prod"
  input: "gradients/Mean_grad/Shape_2"
  input: "gradients/Mean_grad/Const_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/Mean_grad/Maximum/y"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
        }
        int_val: 1
      }
    }
  }
}
node {
  name: "gradients/Mean_grad/Maximum"
  op: "Maximum"
  input: "gradients/Mean_grad/Prod_1"
  input: "gradients/Mean_grad/Maximum/y"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/Mean_grad/floordiv"
  op: "FloorDiv"
  input: "gradients/Mean_grad/Prod"
  input: "gradients/Mean_grad/Maximum"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/Mean_grad/Cast"
  op: "Cast"
  input: "gradients/Mean_grad/floordiv"
  attr {
    key: "DstT"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "SrcT"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/Mean_grad/truediv"
  op: "RealDiv"
  input: "gradients/Mean_grad/Tile"
  input: "gradients/Mean_grad/Cast"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/Square_grad/Const"
  op: "Const"
  input: "^gradients/Mean_grad/truediv"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 2.0
      }
    }
  }
}
node {
  name: "gradients/Square_grad/Mul"
  op: "Mul"
  input: "sub"
  input: "gradients/Square_grad/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/Square_grad/Mul_1"
  op: "Mul"
  input: "gradients/Mean_grad/truediv"
  input: "gradients/Square_grad/Mul"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/sub_grad/Shape"
  op: "Shape"
  input: "target_data"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/sub_grad/Shape_1"
  op: "Shape"
  input: "denoised_data"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/sub_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/sub_grad/Shape"
  input: "gradients/sub_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/sub_grad/Sum"
  op: "Sum"
  input: "gradients/Square_grad/Mul_1"
  input: "gradients/sub_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/sub_grad/Reshape"
  op: "Reshape"
  input: "gradients/sub_grad/Sum"
  input: "gradients/sub_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/sub_grad/Sum_1"
  op: "Sum"
  input: "gradients/Square_grad/Mul_1"
  input: "gradients/sub_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/sub_grad/Neg"
  op: "Neg"
  input: "gradients/sub_grad/Sum_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/sub_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/sub_grad/Neg"
  input: "gradients/sub_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/sub_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/sub_grad/Reshape"
  input: "^gradients/sub_grad/Reshape_1"
}
node {
  name: "gradients/sub_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/sub_grad/Reshape"
  input: "^gradients/sub_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/sub_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/sub_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/sub_grad/Reshape_1"
  input: "^gradients/sub_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/sub_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/denoised_data_grad/Shape"
  op: "Shape"
  input: "LeakyRelu_30/Maximum"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/denoised_data_grad/Shape_1"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
          }
        }
      }
    }
  }
}
node {
  name: "gradients/denoised_data_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/denoised_data_grad/Shape"
  input: "gradients/denoised_data_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/denoised_data_grad/Mul"
  op: "Mul"
  input: "gradients/sub_grad/tuple/control_dependency_1"
  input: "denoised_data/y"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/denoised_data_grad/Sum"
  op: "Sum"
  input: "gradients/denoised_data_grad/Mul"
  input: "gradients/denoised_data_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/denoised_data_grad/Reshape"
  op: "Reshape"
  input: "gradients/denoised_data_grad/Sum"
  input: "gradients/denoised_data_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/denoised_data_grad/Mul_1"
  op: "Mul"
  input: "LeakyRelu_30/Maximum"
  input: "gradients/sub_grad/tuple/control_dependency_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/denoised_data_grad/Sum_1"
  op: "Sum"
  input: "gradients/denoised_data_grad/Mul_1"
  input: "gradients/denoised_data_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/denoised_data_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/denoised_data_grad/Sum_1"
  input: "gradients/denoised_data_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/denoised_data_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/denoised_data_grad/Reshape"
  input: "^gradients/denoised_data_grad/Reshape_1"
}
node {
  name: "gradients/denoised_data_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/denoised_data_grad/Reshape"
  input: "^gradients/denoised_data_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/denoised_data_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/denoised_data_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/denoised_data_grad/Reshape_1"
  input: "^gradients/denoised_data_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/denoised_data_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_30/Maximum_grad/Shape"
  op: "Shape"
  input: "LeakyRelu_30/mul"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_30/Maximum_grad/Shape_1"
  op: "Shape"
  input: "conv2d_25/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_30/Maximum_grad/Shape_2"
  op: "Shape"
  input: "gradients/denoised_data_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_30/Maximum_grad/zeros/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_30/Maximum_grad/zeros"
  op: "Fill"
  input: "gradients/LeakyRelu_30/Maximum_grad/Shape_2"
  input: "gradients/LeakyRelu_30/Maximum_grad/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_30/Maximum_grad/GreaterEqual"
  op: "GreaterEqual"
  input: "LeakyRelu_30/mul"
  input: "conv2d_25/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_30/Maximum_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_30/Maximum_grad/Shape"
  input: "gradients/LeakyRelu_30/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_30/Maximum_grad/Select"
  op: "Select"
  input: "gradients/LeakyRelu_30/Maximum_grad/GreaterEqual"
  input: "gradients/denoised_data_grad/tuple/control_dependency"
  input: "gradients/LeakyRelu_30/Maximum_grad/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_30/Maximum_grad/Select_1"
  op: "Select"
  input: "gradients/LeakyRelu_30/Maximum_grad/GreaterEqual"
  input: "gradients/LeakyRelu_30/Maximum_grad/zeros"
  input: "gradients/denoised_data_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_30/Maximum_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_30/Maximum_grad/Select"
  input: "gradients/LeakyRelu_30/Maximum_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_30/Maximum_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_30/Maximum_grad/Sum"
  input: "gradients/LeakyRelu_30/Maximum_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_30/Maximum_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_30/Maximum_grad/Select_1"
  input: "gradients/LeakyRelu_30/Maximum_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_30/Maximum_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_30/Maximum_grad/Sum_1"
  input: "gradients/LeakyRelu_30/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_30/Maximum_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_30/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_30/Maximum_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_30/Maximum_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_30/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_30/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_30/Maximum_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_30/Maximum_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_30/Maximum_grad/Reshape_1"
  input: "^gradients/LeakyRelu_30/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_30/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_30/mul_grad/Shape"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
          }
        }
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_30/mul_grad/Shape_1"
  op: "Shape"
  input: "conv2d_25/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_30/mul_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_30/mul_grad/Shape"
  input: "gradients/LeakyRelu_30/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_30/mul_grad/Mul"
  op: "Mul"
  input: "gradients/LeakyRelu_30/Maximum_grad/tuple/control_dependency"
  input: "conv2d_25/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_30/mul_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_30/mul_grad/Mul"
  input: "gradients/LeakyRelu_30/mul_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_30/mul_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_30/mul_grad/Sum"
  input: "gradients/LeakyRelu_30/mul_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_30/mul_grad/Mul_1"
  op: "Mul"
  input: "LeakyRelu_30/alpha"
  input: "gradients/LeakyRelu_30/Maximum_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_30/mul_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_30/mul_grad/Mul_1"
  input: "gradients/LeakyRelu_30/mul_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_30/mul_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_30/mul_grad/Sum_1"
  input: "gradients/LeakyRelu_30/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_30/mul_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_30/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_30/mul_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_30/mul_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_30/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_30/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_30/mul_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_30/mul_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_30/mul_grad/Reshape_1"
  input: "^gradients/LeakyRelu_30/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_30/mul_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/AddN"
  op: "AddN"
  input: "gradients/LeakyRelu_30/Maximum_grad/tuple/control_dependency_1"
  input: "gradients/LeakyRelu_30/mul_grad/tuple/control_dependency_1"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_30/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_25/BiasAdd_grad/BiasAddGrad"
  op: "BiasAddGrad"
  input: "gradients/AddN"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "gradients/conv2d_25/BiasAdd_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/AddN"
  input: "^gradients/conv2d_25/BiasAdd_grad/BiasAddGrad"
}
node {
  name: "gradients/conv2d_25/BiasAdd_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/AddN"
  input: "^gradients/conv2d_25/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_30/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_25/BiasAdd_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_25/BiasAdd_grad/BiasAddGrad"
  input: "^gradients/conv2d_25/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_25/BiasAdd_grad/BiasAddGrad"
      }
    }
  }
}
node {
  name: "gradients/conv2d_25/Conv2D_grad/ShapeN"
  op: "ShapeN"
  input: "LeakyRelu_29/Maximum"
  input: "conv2d_25/kernel/read"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/conv2d_25/Conv2D_grad/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\002\000\000\000\002\000\000\000 \000\000\000\003\000\000\000"
      }
    }
  }
}
node {
  name: "gradients/conv2d_25/Conv2D_grad/Conv2DBackpropInput"
  op: "Conv2DBackpropInput"
  input: "gradients/conv2d_25/Conv2D_grad/ShapeN"
  input: "conv2d_25/kernel/read"
  input: "gradients/conv2d_25/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_25/Conv2D_grad/Conv2DBackpropFilter"
  op: "Conv2DBackpropFilter"
  input: "LeakyRelu_29/Maximum"
  input: "gradients/conv2d_25/Conv2D_grad/Const"
  input: "gradients/conv2d_25/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_25/Conv2D_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/conv2d_25/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_25/Conv2D_grad/Conv2DBackpropInput"
}
node {
  name: "gradients/conv2d_25/Conv2D_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/conv2d_25/Conv2D_grad/Conv2DBackpropInput"
  input: "^gradients/conv2d_25/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_25/Conv2D_grad/Conv2DBackpropInput"
      }
    }
  }
}
node {
  name: "gradients/conv2d_25/Conv2D_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_25/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_25/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_25/Conv2D_grad/Conv2DBackpropFilter"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_29/Maximum_grad/Shape"
  op: "Shape"
  input: "LeakyRelu_29/mul"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_29/Maximum_grad/Shape_1"
  op: "Shape"
  input: "conv2d_24/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_29/Maximum_grad/Shape_2"
  op: "Shape"
  input: "gradients/conv2d_25/Conv2D_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_29/Maximum_grad/zeros/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_29/Maximum_grad/zeros"
  op: "Fill"
  input: "gradients/LeakyRelu_29/Maximum_grad/Shape_2"
  input: "gradients/LeakyRelu_29/Maximum_grad/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_29/Maximum_grad/GreaterEqual"
  op: "GreaterEqual"
  input: "LeakyRelu_29/mul"
  input: "conv2d_24/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_29/Maximum_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_29/Maximum_grad/Shape"
  input: "gradients/LeakyRelu_29/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_29/Maximum_grad/Select"
  op: "Select"
  input: "gradients/LeakyRelu_29/Maximum_grad/GreaterEqual"
  input: "gradients/conv2d_25/Conv2D_grad/tuple/control_dependency"
  input: "gradients/LeakyRelu_29/Maximum_grad/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_29/Maximum_grad/Select_1"
  op: "Select"
  input: "gradients/LeakyRelu_29/Maximum_grad/GreaterEqual"
  input: "gradients/LeakyRelu_29/Maximum_grad/zeros"
  input: "gradients/conv2d_25/Conv2D_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_29/Maximum_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_29/Maximum_grad/Select"
  input: "gradients/LeakyRelu_29/Maximum_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_29/Maximum_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_29/Maximum_grad/Sum"
  input: "gradients/LeakyRelu_29/Maximum_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_29/Maximum_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_29/Maximum_grad/Select_1"
  input: "gradients/LeakyRelu_29/Maximum_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_29/Maximum_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_29/Maximum_grad/Sum_1"
  input: "gradients/LeakyRelu_29/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_29/Maximum_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_29/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_29/Maximum_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_29/Maximum_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_29/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_29/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_29/Maximum_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_29/Maximum_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_29/Maximum_grad/Reshape_1"
  input: "^gradients/LeakyRelu_29/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_29/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_29/mul_grad/Shape"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
          }
        }
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_29/mul_grad/Shape_1"
  op: "Shape"
  input: "conv2d_24/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_29/mul_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_29/mul_grad/Shape"
  input: "gradients/LeakyRelu_29/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_29/mul_grad/Mul"
  op: "Mul"
  input: "gradients/LeakyRelu_29/Maximum_grad/tuple/control_dependency"
  input: "conv2d_24/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_29/mul_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_29/mul_grad/Mul"
  input: "gradients/LeakyRelu_29/mul_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_29/mul_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_29/mul_grad/Sum"
  input: "gradients/LeakyRelu_29/mul_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_29/mul_grad/Mul_1"
  op: "Mul"
  input: "LeakyRelu_29/alpha"
  input: "gradients/LeakyRelu_29/Maximum_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_29/mul_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_29/mul_grad/Mul_1"
  input: "gradients/LeakyRelu_29/mul_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_29/mul_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_29/mul_grad/Sum_1"
  input: "gradients/LeakyRelu_29/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_29/mul_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_29/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_29/mul_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_29/mul_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_29/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_29/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_29/mul_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_29/mul_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_29/mul_grad/Reshape_1"
  input: "^gradients/LeakyRelu_29/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_29/mul_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/AddN_1"
  op: "AddN"
  input: "gradients/LeakyRelu_29/Maximum_grad/tuple/control_dependency_1"
  input: "gradients/LeakyRelu_29/mul_grad/tuple/control_dependency_1"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_29/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_24/BiasAdd_grad/BiasAddGrad"
  op: "BiasAddGrad"
  input: "gradients/AddN_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "gradients/conv2d_24/BiasAdd_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/AddN_1"
  input: "^gradients/conv2d_24/BiasAdd_grad/BiasAddGrad"
}
node {
  name: "gradients/conv2d_24/BiasAdd_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/AddN_1"
  input: "^gradients/conv2d_24/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_29/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_24/BiasAdd_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_24/BiasAdd_grad/BiasAddGrad"
  input: "^gradients/conv2d_24/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_24/BiasAdd_grad/BiasAddGrad"
      }
    }
  }
}
node {
  name: "gradients/conv2d_24/Conv2D_grad/ShapeN"
  op: "ShapeN"
  input: "LeakyRelu_28/Maximum"
  input: "conv2d_24/kernel/read"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/conv2d_24/Conv2D_grad/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\010\000\000\000\010\000\000\000\030\000\000\000 \000\000\000"
      }
    }
  }
}
node {
  name: "gradients/conv2d_24/Conv2D_grad/Conv2DBackpropInput"
  op: "Conv2DBackpropInput"
  input: "gradients/conv2d_24/Conv2D_grad/ShapeN"
  input: "conv2d_24/kernel/read"
  input: "gradients/conv2d_24/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_24/Conv2D_grad/Conv2DBackpropFilter"
  op: "Conv2DBackpropFilter"
  input: "LeakyRelu_28/Maximum"
  input: "gradients/conv2d_24/Conv2D_grad/Const"
  input: "gradients/conv2d_24/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_24/Conv2D_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/conv2d_24/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_24/Conv2D_grad/Conv2DBackpropInput"
}
node {
  name: "gradients/conv2d_24/Conv2D_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/conv2d_24/Conv2D_grad/Conv2DBackpropInput"
  input: "^gradients/conv2d_24/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_24/Conv2D_grad/Conv2DBackpropInput"
      }
    }
  }
}
node {
  name: "gradients/conv2d_24/Conv2D_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_24/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_24/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_24/Conv2D_grad/Conv2DBackpropFilter"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_28/Maximum_grad/Shape"
  op: "Shape"
  input: "LeakyRelu_28/mul"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_28/Maximum_grad/Shape_1"
  op: "Shape"
  input: "conv2d_23/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_28/Maximum_grad/Shape_2"
  op: "Shape"
  input: "gradients/conv2d_24/Conv2D_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_28/Maximum_grad/zeros/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_28/Maximum_grad/zeros"
  op: "Fill"
  input: "gradients/LeakyRelu_28/Maximum_grad/Shape_2"
  input: "gradients/LeakyRelu_28/Maximum_grad/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_28/Maximum_grad/GreaterEqual"
  op: "GreaterEqual"
  input: "LeakyRelu_28/mul"
  input: "conv2d_23/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_28/Maximum_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_28/Maximum_grad/Shape"
  input: "gradients/LeakyRelu_28/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_28/Maximum_grad/Select"
  op: "Select"
  input: "gradients/LeakyRelu_28/Maximum_grad/GreaterEqual"
  input: "gradients/conv2d_24/Conv2D_grad/tuple/control_dependency"
  input: "gradients/LeakyRelu_28/Maximum_grad/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_28/Maximum_grad/Select_1"
  op: "Select"
  input: "gradients/LeakyRelu_28/Maximum_grad/GreaterEqual"
  input: "gradients/LeakyRelu_28/Maximum_grad/zeros"
  input: "gradients/conv2d_24/Conv2D_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_28/Maximum_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_28/Maximum_grad/Select"
  input: "gradients/LeakyRelu_28/Maximum_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_28/Maximum_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_28/Maximum_grad/Sum"
  input: "gradients/LeakyRelu_28/Maximum_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_28/Maximum_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_28/Maximum_grad/Select_1"
  input: "gradients/LeakyRelu_28/Maximum_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_28/Maximum_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_28/Maximum_grad/Sum_1"
  input: "gradients/LeakyRelu_28/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_28/Maximum_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_28/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_28/Maximum_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_28/Maximum_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_28/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_28/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_28/Maximum_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_28/Maximum_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_28/Maximum_grad/Reshape_1"
  input: "^gradients/LeakyRelu_28/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_28/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_28/mul_grad/Shape"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
          }
        }
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_28/mul_grad/Shape_1"
  op: "Shape"
  input: "conv2d_23/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_28/mul_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_28/mul_grad/Shape"
  input: "gradients/LeakyRelu_28/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_28/mul_grad/Mul"
  op: "Mul"
  input: "gradients/LeakyRelu_28/Maximum_grad/tuple/control_dependency"
  input: "conv2d_23/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_28/mul_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_28/mul_grad/Mul"
  input: "gradients/LeakyRelu_28/mul_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_28/mul_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_28/mul_grad/Sum"
  input: "gradients/LeakyRelu_28/mul_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_28/mul_grad/Mul_1"
  op: "Mul"
  input: "LeakyRelu_28/alpha"
  input: "gradients/LeakyRelu_28/Maximum_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_28/mul_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_28/mul_grad/Mul_1"
  input: "gradients/LeakyRelu_28/mul_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_28/mul_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_28/mul_grad/Sum_1"
  input: "gradients/LeakyRelu_28/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_28/mul_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_28/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_28/mul_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_28/mul_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_28/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_28/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_28/mul_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_28/mul_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_28/mul_grad/Reshape_1"
  input: "^gradients/LeakyRelu_28/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_28/mul_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/AddN_2"
  op: "AddN"
  input: "gradients/LeakyRelu_28/Maximum_grad/tuple/control_dependency_1"
  input: "gradients/LeakyRelu_28/mul_grad/tuple/control_dependency_1"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_28/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_23/BiasAdd_grad/BiasAddGrad"
  op: "BiasAddGrad"
  input: "gradients/AddN_2"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "gradients/conv2d_23/BiasAdd_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/AddN_2"
  input: "^gradients/conv2d_23/BiasAdd_grad/BiasAddGrad"
}
node {
  name: "gradients/conv2d_23/BiasAdd_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/AddN_2"
  input: "^gradients/conv2d_23/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_28/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_23/BiasAdd_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_23/BiasAdd_grad/BiasAddGrad"
  input: "^gradients/conv2d_23/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_23/BiasAdd_grad/BiasAddGrad"
      }
    }
  }
}
node {
  name: "gradients/conv2d_23/Conv2D_grad/ShapeN"
  op: "ShapeN"
  input: "LeakyRelu_27/Maximum"
  input: "conv2d_23/kernel/read"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/conv2d_23/Conv2D_grad/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\006\000\000\000\006\000\000\000\020\000\000\000\030\000\000\000"
      }
    }
  }
}
node {
  name: "gradients/conv2d_23/Conv2D_grad/Conv2DBackpropInput"
  op: "Conv2DBackpropInput"
  input: "gradients/conv2d_23/Conv2D_grad/ShapeN"
  input: "conv2d_23/kernel/read"
  input: "gradients/conv2d_23/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_23/Conv2D_grad/Conv2DBackpropFilter"
  op: "Conv2DBackpropFilter"
  input: "LeakyRelu_27/Maximum"
  input: "gradients/conv2d_23/Conv2D_grad/Const"
  input: "gradients/conv2d_23/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_23/Conv2D_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/conv2d_23/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_23/Conv2D_grad/Conv2DBackpropInput"
}
node {
  name: "gradients/conv2d_23/Conv2D_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/conv2d_23/Conv2D_grad/Conv2DBackpropInput"
  input: "^gradients/conv2d_23/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_23/Conv2D_grad/Conv2DBackpropInput"
      }
    }
  }
}
node {
  name: "gradients/conv2d_23/Conv2D_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_23/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_23/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_23/Conv2D_grad/Conv2DBackpropFilter"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_27/Maximum_grad/Shape"
  op: "Shape"
  input: "LeakyRelu_27/mul"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_27/Maximum_grad/Shape_1"
  op: "Shape"
  input: "conv2d_22/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_27/Maximum_grad/Shape_2"
  op: "Shape"
  input: "gradients/conv2d_23/Conv2D_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_27/Maximum_grad/zeros/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_27/Maximum_grad/zeros"
  op: "Fill"
  input: "gradients/LeakyRelu_27/Maximum_grad/Shape_2"
  input: "gradients/LeakyRelu_27/Maximum_grad/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_27/Maximum_grad/GreaterEqual"
  op: "GreaterEqual"
  input: "LeakyRelu_27/mul"
  input: "conv2d_22/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_27/Maximum_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_27/Maximum_grad/Shape"
  input: "gradients/LeakyRelu_27/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_27/Maximum_grad/Select"
  op: "Select"
  input: "gradients/LeakyRelu_27/Maximum_grad/GreaterEqual"
  input: "gradients/conv2d_23/Conv2D_grad/tuple/control_dependency"
  input: "gradients/LeakyRelu_27/Maximum_grad/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_27/Maximum_grad/Select_1"
  op: "Select"
  input: "gradients/LeakyRelu_27/Maximum_grad/GreaterEqual"
  input: "gradients/LeakyRelu_27/Maximum_grad/zeros"
  input: "gradients/conv2d_23/Conv2D_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_27/Maximum_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_27/Maximum_grad/Select"
  input: "gradients/LeakyRelu_27/Maximum_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_27/Maximum_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_27/Maximum_grad/Sum"
  input: "gradients/LeakyRelu_27/Maximum_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_27/Maximum_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_27/Maximum_grad/Select_1"
  input: "gradients/LeakyRelu_27/Maximum_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_27/Maximum_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_27/Maximum_grad/Sum_1"
  input: "gradients/LeakyRelu_27/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_27/Maximum_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_27/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_27/Maximum_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_27/Maximum_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_27/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_27/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_27/Maximum_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_27/Maximum_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_27/Maximum_grad/Reshape_1"
  input: "^gradients/LeakyRelu_27/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_27/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_27/mul_grad/Shape"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
          }
        }
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_27/mul_grad/Shape_1"
  op: "Shape"
  input: "conv2d_22/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_27/mul_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_27/mul_grad/Shape"
  input: "gradients/LeakyRelu_27/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_27/mul_grad/Mul"
  op: "Mul"
  input: "gradients/LeakyRelu_27/Maximum_grad/tuple/control_dependency"
  input: "conv2d_22/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_27/mul_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_27/mul_grad/Mul"
  input: "gradients/LeakyRelu_27/mul_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_27/mul_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_27/mul_grad/Sum"
  input: "gradients/LeakyRelu_27/mul_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_27/mul_grad/Mul_1"
  op: "Mul"
  input: "LeakyRelu_27/alpha"
  input: "gradients/LeakyRelu_27/Maximum_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_27/mul_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_27/mul_grad/Mul_1"
  input: "gradients/LeakyRelu_27/mul_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_27/mul_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_27/mul_grad/Sum_1"
  input: "gradients/LeakyRelu_27/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_27/mul_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_27/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_27/mul_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_27/mul_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_27/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_27/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_27/mul_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_27/mul_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_27/mul_grad/Reshape_1"
  input: "^gradients/LeakyRelu_27/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_27/mul_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/AddN_3"
  op: "AddN"
  input: "gradients/LeakyRelu_27/Maximum_grad/tuple/control_dependency_1"
  input: "gradients/LeakyRelu_27/mul_grad/tuple/control_dependency_1"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_27/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_22/BiasAdd_grad/BiasAddGrad"
  op: "BiasAddGrad"
  input: "gradients/AddN_3"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "gradients/conv2d_22/BiasAdd_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/AddN_3"
  input: "^gradients/conv2d_22/BiasAdd_grad/BiasAddGrad"
}
node {
  name: "gradients/conv2d_22/BiasAdd_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/AddN_3"
  input: "^gradients/conv2d_22/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_27/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_22/BiasAdd_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_22/BiasAdd_grad/BiasAddGrad"
  input: "^gradients/conv2d_22/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_22/BiasAdd_grad/BiasAddGrad"
      }
    }
  }
}
node {
  name: "gradients/conv2d_22/Conv2D_grad/ShapeN"
  op: "ShapeN"
  input: "concat_4"
  input: "conv2d_22/kernel/read"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/conv2d_22/Conv2D_grad/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\005\000\000\000\005\000\000\000\033\000\000\000\020\000\000\000"
      }
    }
  }
}
node {
  name: "gradients/conv2d_22/Conv2D_grad/Conv2DBackpropInput"
  op: "Conv2DBackpropInput"
  input: "gradients/conv2d_22/Conv2D_grad/ShapeN"
  input: "conv2d_22/kernel/read"
  input: "gradients/conv2d_22/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_22/Conv2D_grad/Conv2DBackpropFilter"
  op: "Conv2DBackpropFilter"
  input: "concat_4"
  input: "gradients/conv2d_22/Conv2D_grad/Const"
  input: "gradients/conv2d_22/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_22/Conv2D_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/conv2d_22/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_22/Conv2D_grad/Conv2DBackpropInput"
}
node {
  name: "gradients/conv2d_22/Conv2D_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/conv2d_22/Conv2D_grad/Conv2DBackpropInput"
  input: "^gradients/conv2d_22/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_22/Conv2D_grad/Conv2DBackpropInput"
      }
    }
  }
}
node {
  name: "gradients/conv2d_22/Conv2D_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_22/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_22/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_22/Conv2D_grad/Conv2DBackpropFilter"
      }
    }
  }
}
node {
  name: "gradients/concat_4_grad/Rank"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
        }
        int_val: 4
      }
    }
  }
}
node {
  name: "gradients/concat_4_grad/mod"
  op: "FloorMod"
  input: "concat_4/axis"
  input: "gradients/concat_4_grad/Rank"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/concat_4_grad/Shape"
  op: "Shape"
  input: "LeakyRelu_26/Maximum"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/concat_4_grad/ShapeN"
  op: "ShapeN"
  input: "LeakyRelu_26/Maximum"
  input: "Reshape"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/concat_4_grad/ConcatOffset"
  op: "ConcatOffset"
  input: "gradients/concat_4_grad/mod"
  input: "gradients/concat_4_grad/ShapeN"
  input: "gradients/concat_4_grad/ShapeN:1"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
}
node {
  name: "gradients/concat_4_grad/Slice"
  op: "Slice"
  input: "gradients/conv2d_22/Conv2D_grad/tuple/control_dependency"
  input: "gradients/concat_4_grad/ConcatOffset"
  input: "gradients/concat_4_grad/ShapeN"
  attr {
    key: "Index"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/concat_4_grad/Slice_1"
  op: "Slice"
  input: "gradients/conv2d_22/Conv2D_grad/tuple/control_dependency"
  input: "gradients/concat_4_grad/ConcatOffset:1"
  input: "gradients/concat_4_grad/ShapeN:1"
  attr {
    key: "Index"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/concat_4_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/concat_4_grad/Slice"
  input: "^gradients/concat_4_grad/Slice_1"
}
node {
  name: "gradients/concat_4_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/concat_4_grad/Slice"
  input: "^gradients/concat_4_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/concat_4_grad/Slice"
      }
    }
  }
}
node {
  name: "gradients/concat_4_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/concat_4_grad/Slice_1"
  input: "^gradients/concat_4_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/concat_4_grad/Slice_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_26/Maximum_grad/Shape"
  op: "Shape"
  input: "LeakyRelu_26/mul"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_26/Maximum_grad/Shape_1"
  op: "Shape"
  input: "conv2d_transpose_4/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_26/Maximum_grad/Shape_2"
  op: "Shape"
  input: "gradients/concat_4_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_26/Maximum_grad/zeros/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_26/Maximum_grad/zeros"
  op: "Fill"
  input: "gradients/LeakyRelu_26/Maximum_grad/Shape_2"
  input: "gradients/LeakyRelu_26/Maximum_grad/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_26/Maximum_grad/GreaterEqual"
  op: "GreaterEqual"
  input: "LeakyRelu_26/mul"
  input: "conv2d_transpose_4/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_26/Maximum_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_26/Maximum_grad/Shape"
  input: "gradients/LeakyRelu_26/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_26/Maximum_grad/Select"
  op: "Select"
  input: "gradients/LeakyRelu_26/Maximum_grad/GreaterEqual"
  input: "gradients/concat_4_grad/tuple/control_dependency"
  input: "gradients/LeakyRelu_26/Maximum_grad/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_26/Maximum_grad/Select_1"
  op: "Select"
  input: "gradients/LeakyRelu_26/Maximum_grad/GreaterEqual"
  input: "gradients/LeakyRelu_26/Maximum_grad/zeros"
  input: "gradients/concat_4_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_26/Maximum_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_26/Maximum_grad/Select"
  input: "gradients/LeakyRelu_26/Maximum_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_26/Maximum_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_26/Maximum_grad/Sum"
  input: "gradients/LeakyRelu_26/Maximum_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_26/Maximum_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_26/Maximum_grad/Select_1"
  input: "gradients/LeakyRelu_26/Maximum_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_26/Maximum_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_26/Maximum_grad/Sum_1"
  input: "gradients/LeakyRelu_26/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_26/Maximum_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_26/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_26/Maximum_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_26/Maximum_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_26/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_26/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_26/Maximum_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_26/Maximum_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_26/Maximum_grad/Reshape_1"
  input: "^gradients/LeakyRelu_26/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_26/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_26/mul_grad/Shape"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
          }
        }
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_26/mul_grad/Shape_1"
  op: "Shape"
  input: "conv2d_transpose_4/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_26/mul_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_26/mul_grad/Shape"
  input: "gradients/LeakyRelu_26/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_26/mul_grad/Mul"
  op: "Mul"
  input: "gradients/LeakyRelu_26/Maximum_grad/tuple/control_dependency"
  input: "conv2d_transpose_4/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_26/mul_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_26/mul_grad/Mul"
  input: "gradients/LeakyRelu_26/mul_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_26/mul_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_26/mul_grad/Sum"
  input: "gradients/LeakyRelu_26/mul_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_26/mul_grad/Mul_1"
  op: "Mul"
  input: "LeakyRelu_26/alpha"
  input: "gradients/LeakyRelu_26/Maximum_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_26/mul_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_26/mul_grad/Mul_1"
  input: "gradients/LeakyRelu_26/mul_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_26/mul_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_26/mul_grad/Sum_1"
  input: "gradients/LeakyRelu_26/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_26/mul_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_26/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_26/mul_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_26/mul_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_26/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_26/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_26/mul_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_26/mul_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_26/mul_grad/Reshape_1"
  input: "^gradients/LeakyRelu_26/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_26/mul_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/AddN_4"
  op: "AddN"
  input: "gradients/LeakyRelu_26/Maximum_grad/tuple/control_dependency_1"
  input: "gradients/LeakyRelu_26/mul_grad/tuple/control_dependency_1"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_26/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_transpose_4/BiasAdd_grad/BiasAddGrad"
  op: "BiasAddGrad"
  input: "gradients/AddN_4"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "gradients/conv2d_transpose_4/BiasAdd_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/AddN_4"
  input: "^gradients/conv2d_transpose_4/BiasAdd_grad/BiasAddGrad"
}
node {
  name: "gradients/conv2d_transpose_4/BiasAdd_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/AddN_4"
  input: "^gradients/conv2d_transpose_4/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_26/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_transpose_4/BiasAdd_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_transpose_4/BiasAdd_grad/BiasAddGrad"
  input: "^gradients/conv2d_transpose_4/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_transpose_4/BiasAdd_grad/BiasAddGrad"
      }
    }
  }
}
node {
  name: "gradients/conv2d_transpose_4/conv2d_transpose_grad/Shape"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\004\000\000\000\004\000\000\000\030\000\000\000\030\000\000\000"
      }
    }
  }
}
node {
  name: "gradients/conv2d_transpose_4/conv2d_transpose_grad/Conv2DBackpropFilter"
  op: "Conv2DBackpropFilter"
  input: "gradients/conv2d_transpose_4/BiasAdd_grad/tuple/control_dependency"
  input: "gradients/conv2d_transpose_4/conv2d_transpose_grad/Shape"
  input: "LeakyRelu_25/Maximum"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 2
        i: 2
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_transpose_4/conv2d_transpose_grad/Conv2D"
  op: "Conv2D"
  input: "gradients/conv2d_transpose_4/BiasAdd_grad/tuple/control_dependency"
  input: "conv2d_transpose_4/kernel/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 2
        i: 2
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_transpose_4/conv2d_transpose_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/conv2d_transpose_4/conv2d_transpose_grad/Conv2D"
  input: "^gradients/conv2d_transpose_4/conv2d_transpose_grad/Conv2DBackpropFilter"
}
node {
  name: "gradients/conv2d_transpose_4/conv2d_transpose_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/conv2d_transpose_4/conv2d_transpose_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_transpose_4/conv2d_transpose_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_transpose_4/conv2d_transpose_grad/Conv2DBackpropFilter"
      }
    }
  }
}
node {
  name: "gradients/conv2d_transpose_4/conv2d_transpose_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_transpose_4/conv2d_transpose_grad/Conv2D"
  input: "^gradients/conv2d_transpose_4/conv2d_transpose_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_transpose_4/conv2d_transpose_grad/Conv2D"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_25/Maximum_grad/Shape"
  op: "Shape"
  input: "LeakyRelu_25/mul"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_25/Maximum_grad/Shape_1"
  op: "Shape"
  input: "conv2d_21/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_25/Maximum_grad/Shape_2"
  op: "Shape"
  input: "gradients/conv2d_transpose_4/conv2d_transpose_grad/tuple/control_dependency_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_25/Maximum_grad/zeros/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_25/Maximum_grad/zeros"
  op: "Fill"
  input: "gradients/LeakyRelu_25/Maximum_grad/Shape_2"
  input: "gradients/LeakyRelu_25/Maximum_grad/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_25/Maximum_grad/GreaterEqual"
  op: "GreaterEqual"
  input: "LeakyRelu_25/mul"
  input: "conv2d_21/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_25/Maximum_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_25/Maximum_grad/Shape"
  input: "gradients/LeakyRelu_25/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_25/Maximum_grad/Select"
  op: "Select"
  input: "gradients/LeakyRelu_25/Maximum_grad/GreaterEqual"
  input: "gradients/conv2d_transpose_4/conv2d_transpose_grad/tuple/control_dependency_1"
  input: "gradients/LeakyRelu_25/Maximum_grad/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_25/Maximum_grad/Select_1"
  op: "Select"
  input: "gradients/LeakyRelu_25/Maximum_grad/GreaterEqual"
  input: "gradients/LeakyRelu_25/Maximum_grad/zeros"
  input: "gradients/conv2d_transpose_4/conv2d_transpose_grad/tuple/control_dependency_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_25/Maximum_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_25/Maximum_grad/Select"
  input: "gradients/LeakyRelu_25/Maximum_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_25/Maximum_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_25/Maximum_grad/Sum"
  input: "gradients/LeakyRelu_25/Maximum_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_25/Maximum_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_25/Maximum_grad/Select_1"
  input: "gradients/LeakyRelu_25/Maximum_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_25/Maximum_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_25/Maximum_grad/Sum_1"
  input: "gradients/LeakyRelu_25/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_25/Maximum_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_25/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_25/Maximum_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_25/Maximum_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_25/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_25/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_25/Maximum_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_25/Maximum_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_25/Maximum_grad/Reshape_1"
  input: "^gradients/LeakyRelu_25/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_25/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_25/mul_grad/Shape"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
          }
        }
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_25/mul_grad/Shape_1"
  op: "Shape"
  input: "conv2d_21/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_25/mul_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_25/mul_grad/Shape"
  input: "gradients/LeakyRelu_25/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_25/mul_grad/Mul"
  op: "Mul"
  input: "gradients/LeakyRelu_25/Maximum_grad/tuple/control_dependency"
  input: "conv2d_21/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_25/mul_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_25/mul_grad/Mul"
  input: "gradients/LeakyRelu_25/mul_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_25/mul_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_25/mul_grad/Sum"
  input: "gradients/LeakyRelu_25/mul_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_25/mul_grad/Mul_1"
  op: "Mul"
  input: "LeakyRelu_25/alpha"
  input: "gradients/LeakyRelu_25/Maximum_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_25/mul_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_25/mul_grad/Mul_1"
  input: "gradients/LeakyRelu_25/mul_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_25/mul_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_25/mul_grad/Sum_1"
  input: "gradients/LeakyRelu_25/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_25/mul_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_25/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_25/mul_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_25/mul_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_25/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_25/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_25/mul_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_25/mul_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_25/mul_grad/Reshape_1"
  input: "^gradients/LeakyRelu_25/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_25/mul_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/AddN_5"
  op: "AddN"
  input: "gradients/LeakyRelu_25/Maximum_grad/tuple/control_dependency_1"
  input: "gradients/LeakyRelu_25/mul_grad/tuple/control_dependency_1"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_25/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_21/BiasAdd_grad/BiasAddGrad"
  op: "BiasAddGrad"
  input: "gradients/AddN_5"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "gradients/conv2d_21/BiasAdd_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/AddN_5"
  input: "^gradients/conv2d_21/BiasAdd_grad/BiasAddGrad"
}
node {
  name: "gradients/conv2d_21/BiasAdd_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/AddN_5"
  input: "^gradients/conv2d_21/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_25/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_21/BiasAdd_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_21/BiasAdd_grad/BiasAddGrad"
  input: "^gradients/conv2d_21/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_21/BiasAdd_grad/BiasAddGrad"
      }
    }
  }
}
node {
  name: "gradients/conv2d_21/Conv2D_grad/ShapeN"
  op: "ShapeN"
  input: "LeakyRelu_24/Maximum"
  input: "conv2d_21/kernel/read"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/conv2d_21/Conv2D_grad/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\004\000\000\000\004\000\000\000\020\000\000\000\030\000\000\000"
      }
    }
  }
}
node {
  name: "gradients/conv2d_21/Conv2D_grad/Conv2DBackpropInput"
  op: "Conv2DBackpropInput"
  input: "gradients/conv2d_21/Conv2D_grad/ShapeN"
  input: "conv2d_21/kernel/read"
  input: "gradients/conv2d_21/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_21/Conv2D_grad/Conv2DBackpropFilter"
  op: "Conv2DBackpropFilter"
  input: "LeakyRelu_24/Maximum"
  input: "gradients/conv2d_21/Conv2D_grad/Const"
  input: "gradients/conv2d_21/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_21/Conv2D_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/conv2d_21/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_21/Conv2D_grad/Conv2DBackpropInput"
}
node {
  name: "gradients/conv2d_21/Conv2D_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/conv2d_21/Conv2D_grad/Conv2DBackpropInput"
  input: "^gradients/conv2d_21/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_21/Conv2D_grad/Conv2DBackpropInput"
      }
    }
  }
}
node {
  name: "gradients/conv2d_21/Conv2D_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_21/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_21/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_21/Conv2D_grad/Conv2DBackpropFilter"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_24/Maximum_grad/Shape"
  op: "Shape"
  input: "LeakyRelu_24/mul"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_24/Maximum_grad/Shape_1"
  op: "Shape"
  input: "conv2d_20/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_24/Maximum_grad/Shape_2"
  op: "Shape"
  input: "gradients/conv2d_21/Conv2D_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_24/Maximum_grad/zeros/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_24/Maximum_grad/zeros"
  op: "Fill"
  input: "gradients/LeakyRelu_24/Maximum_grad/Shape_2"
  input: "gradients/LeakyRelu_24/Maximum_grad/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_24/Maximum_grad/GreaterEqual"
  op: "GreaterEqual"
  input: "LeakyRelu_24/mul"
  input: "conv2d_20/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_24/Maximum_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_24/Maximum_grad/Shape"
  input: "gradients/LeakyRelu_24/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_24/Maximum_grad/Select"
  op: "Select"
  input: "gradients/LeakyRelu_24/Maximum_grad/GreaterEqual"
  input: "gradients/conv2d_21/Conv2D_grad/tuple/control_dependency"
  input: "gradients/LeakyRelu_24/Maximum_grad/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_24/Maximum_grad/Select_1"
  op: "Select"
  input: "gradients/LeakyRelu_24/Maximum_grad/GreaterEqual"
  input: "gradients/LeakyRelu_24/Maximum_grad/zeros"
  input: "gradients/conv2d_21/Conv2D_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_24/Maximum_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_24/Maximum_grad/Select"
  input: "gradients/LeakyRelu_24/Maximum_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_24/Maximum_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_24/Maximum_grad/Sum"
  input: "gradients/LeakyRelu_24/Maximum_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_24/Maximum_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_24/Maximum_grad/Select_1"
  input: "gradients/LeakyRelu_24/Maximum_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_24/Maximum_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_24/Maximum_grad/Sum_1"
  input: "gradients/LeakyRelu_24/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_24/Maximum_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_24/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_24/Maximum_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_24/Maximum_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_24/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_24/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_24/Maximum_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_24/Maximum_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_24/Maximum_grad/Reshape_1"
  input: "^gradients/LeakyRelu_24/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_24/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_24/mul_grad/Shape"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
          }
        }
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_24/mul_grad/Shape_1"
  op: "Shape"
  input: "conv2d_20/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_24/mul_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_24/mul_grad/Shape"
  input: "gradients/LeakyRelu_24/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_24/mul_grad/Mul"
  op: "Mul"
  input: "gradients/LeakyRelu_24/Maximum_grad/tuple/control_dependency"
  input: "conv2d_20/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_24/mul_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_24/mul_grad/Mul"
  input: "gradients/LeakyRelu_24/mul_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_24/mul_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_24/mul_grad/Sum"
  input: "gradients/LeakyRelu_24/mul_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_24/mul_grad/Mul_1"
  op: "Mul"
  input: "LeakyRelu_24/alpha"
  input: "gradients/LeakyRelu_24/Maximum_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_24/mul_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_24/mul_grad/Mul_1"
  input: "gradients/LeakyRelu_24/mul_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_24/mul_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_24/mul_grad/Sum_1"
  input: "gradients/LeakyRelu_24/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_24/mul_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_24/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_24/mul_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_24/mul_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_24/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_24/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_24/mul_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_24/mul_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_24/mul_grad/Reshape_1"
  input: "^gradients/LeakyRelu_24/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_24/mul_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/AddN_6"
  op: "AddN"
  input: "gradients/LeakyRelu_24/Maximum_grad/tuple/control_dependency_1"
  input: "gradients/LeakyRelu_24/mul_grad/tuple/control_dependency_1"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_24/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_20/BiasAdd_grad/BiasAddGrad"
  op: "BiasAddGrad"
  input: "gradients/AddN_6"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "gradients/conv2d_20/BiasAdd_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/AddN_6"
  input: "^gradients/conv2d_20/BiasAdd_grad/BiasAddGrad"
}
node {
  name: "gradients/conv2d_20/BiasAdd_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/AddN_6"
  input: "^gradients/conv2d_20/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_24/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_20/BiasAdd_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_20/BiasAdd_grad/BiasAddGrad"
  input: "^gradients/conv2d_20/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_20/BiasAdd_grad/BiasAddGrad"
      }
    }
  }
}
node {
  name: "gradients/conv2d_20/Conv2D_grad/ShapeN"
  op: "ShapeN"
  input: "concat_3"
  input: "conv2d_20/kernel/read"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/conv2d_20/Conv2D_grad/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000 \000\000\000\020\000\000\000"
      }
    }
  }
}
node {
  name: "gradients/conv2d_20/Conv2D_grad/Conv2DBackpropInput"
  op: "Conv2DBackpropInput"
  input: "gradients/conv2d_20/Conv2D_grad/ShapeN"
  input: "conv2d_20/kernel/read"
  input: "gradients/conv2d_20/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_20/Conv2D_grad/Conv2DBackpropFilter"
  op: "Conv2DBackpropFilter"
  input: "concat_3"
  input: "gradients/conv2d_20/Conv2D_grad/Const"
  input: "gradients/conv2d_20/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_20/Conv2D_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/conv2d_20/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_20/Conv2D_grad/Conv2DBackpropInput"
}
node {
  name: "gradients/conv2d_20/Conv2D_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/conv2d_20/Conv2D_grad/Conv2DBackpropInput"
  input: "^gradients/conv2d_20/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_20/Conv2D_grad/Conv2DBackpropInput"
      }
    }
  }
}
node {
  name: "gradients/conv2d_20/Conv2D_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_20/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_20/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_20/Conv2D_grad/Conv2DBackpropFilter"
      }
    }
  }
}
node {
  name: "gradients/concat_3_grad/Rank"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
        }
        int_val: 4
      }
    }
  }
}
node {
  name: "gradients/concat_3_grad/mod"
  op: "FloorMod"
  input: "concat_3/axis"
  input: "gradients/concat_3_grad/Rank"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/concat_3_grad/Shape"
  op: "Shape"
  input: "LeakyRelu_23/Maximum"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/concat_3_grad/ShapeN"
  op: "ShapeN"
  input: "LeakyRelu_23/Maximum"
  input: "LeakyRelu_5/Maximum"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/concat_3_grad/ConcatOffset"
  op: "ConcatOffset"
  input: "gradients/concat_3_grad/mod"
  input: "gradients/concat_3_grad/ShapeN"
  input: "gradients/concat_3_grad/ShapeN:1"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
}
node {
  name: "gradients/concat_3_grad/Slice"
  op: "Slice"
  input: "gradients/conv2d_20/Conv2D_grad/tuple/control_dependency"
  input: "gradients/concat_3_grad/ConcatOffset"
  input: "gradients/concat_3_grad/ShapeN"
  attr {
    key: "Index"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/concat_3_grad/Slice_1"
  op: "Slice"
  input: "gradients/conv2d_20/Conv2D_grad/tuple/control_dependency"
  input: "gradients/concat_3_grad/ConcatOffset:1"
  input: "gradients/concat_3_grad/ShapeN:1"
  attr {
    key: "Index"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/concat_3_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/concat_3_grad/Slice"
  input: "^gradients/concat_3_grad/Slice_1"
}
node {
  name: "gradients/concat_3_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/concat_3_grad/Slice"
  input: "^gradients/concat_3_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/concat_3_grad/Slice"
      }
    }
  }
}
node {
  name: "gradients/concat_3_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/concat_3_grad/Slice_1"
  input: "^gradients/concat_3_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/concat_3_grad/Slice_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_23/Maximum_grad/Shape"
  op: "Shape"
  input: "LeakyRelu_23/mul"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_23/Maximum_grad/Shape_1"
  op: "Shape"
  input: "conv2d_transpose_3/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_23/Maximum_grad/Shape_2"
  op: "Shape"
  input: "gradients/concat_3_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_23/Maximum_grad/zeros/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_23/Maximum_grad/zeros"
  op: "Fill"
  input: "gradients/LeakyRelu_23/Maximum_grad/Shape_2"
  input: "gradients/LeakyRelu_23/Maximum_grad/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_23/Maximum_grad/GreaterEqual"
  op: "GreaterEqual"
  input: "LeakyRelu_23/mul"
  input: "conv2d_transpose_3/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_23/Maximum_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_23/Maximum_grad/Shape"
  input: "gradients/LeakyRelu_23/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_23/Maximum_grad/Select"
  op: "Select"
  input: "gradients/LeakyRelu_23/Maximum_grad/GreaterEqual"
  input: "gradients/concat_3_grad/tuple/control_dependency"
  input: "gradients/LeakyRelu_23/Maximum_grad/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_23/Maximum_grad/Select_1"
  op: "Select"
  input: "gradients/LeakyRelu_23/Maximum_grad/GreaterEqual"
  input: "gradients/LeakyRelu_23/Maximum_grad/zeros"
  input: "gradients/concat_3_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_23/Maximum_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_23/Maximum_grad/Select"
  input: "gradients/LeakyRelu_23/Maximum_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_23/Maximum_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_23/Maximum_grad/Sum"
  input: "gradients/LeakyRelu_23/Maximum_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_23/Maximum_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_23/Maximum_grad/Select_1"
  input: "gradients/LeakyRelu_23/Maximum_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_23/Maximum_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_23/Maximum_grad/Sum_1"
  input: "gradients/LeakyRelu_23/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_23/Maximum_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_23/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_23/Maximum_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_23/Maximum_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_23/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_23/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_23/Maximum_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_23/Maximum_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_23/Maximum_grad/Reshape_1"
  input: "^gradients/LeakyRelu_23/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_23/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_23/mul_grad/Shape"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
          }
        }
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_23/mul_grad/Shape_1"
  op: "Shape"
  input: "conv2d_transpose_3/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_23/mul_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_23/mul_grad/Shape"
  input: "gradients/LeakyRelu_23/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_23/mul_grad/Mul"
  op: "Mul"
  input: "gradients/LeakyRelu_23/Maximum_grad/tuple/control_dependency"
  input: "conv2d_transpose_3/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_23/mul_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_23/mul_grad/Mul"
  input: "gradients/LeakyRelu_23/mul_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_23/mul_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_23/mul_grad/Sum"
  input: "gradients/LeakyRelu_23/mul_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_23/mul_grad/Mul_1"
  op: "Mul"
  input: "LeakyRelu_23/alpha"
  input: "gradients/LeakyRelu_23/Maximum_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_23/mul_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_23/mul_grad/Mul_1"
  input: "gradients/LeakyRelu_23/mul_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_23/mul_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_23/mul_grad/Sum_1"
  input: "gradients/LeakyRelu_23/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_23/mul_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_23/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_23/mul_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_23/mul_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_23/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_23/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_23/mul_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_23/mul_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_23/mul_grad/Reshape_1"
  input: "^gradients/LeakyRelu_23/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_23/mul_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/AddN_7"
  op: "AddN"
  input: "gradients/LeakyRelu_23/Maximum_grad/tuple/control_dependency_1"
  input: "gradients/LeakyRelu_23/mul_grad/tuple/control_dependency_1"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_23/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_transpose_3/BiasAdd_grad/BiasAddGrad"
  op: "BiasAddGrad"
  input: "gradients/AddN_7"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "gradients/conv2d_transpose_3/BiasAdd_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/AddN_7"
  input: "^gradients/conv2d_transpose_3/BiasAdd_grad/BiasAddGrad"
}
node {
  name: "gradients/conv2d_transpose_3/BiasAdd_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/AddN_7"
  input: "^gradients/conv2d_transpose_3/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_23/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_transpose_3/BiasAdd_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_transpose_3/BiasAdd_grad/BiasAddGrad"
  input: "^gradients/conv2d_transpose_3/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_transpose_3/BiasAdd_grad/BiasAddGrad"
      }
    }
  }
}
node {
  name: "gradients/conv2d_transpose_3/conv2d_transpose_grad/Shape"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\003\000\000\000\003\000\000\000\020\000\000\000\020\000\000\000"
      }
    }
  }
}
node {
  name: "gradients/conv2d_transpose_3/conv2d_transpose_grad/Conv2DBackpropFilter"
  op: "Conv2DBackpropFilter"
  input: "gradients/conv2d_transpose_3/BiasAdd_grad/tuple/control_dependency"
  input: "gradients/conv2d_transpose_3/conv2d_transpose_grad/Shape"
  input: "LeakyRelu_22/Maximum"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 2
        i: 2
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_transpose_3/conv2d_transpose_grad/Conv2D"
  op: "Conv2D"
  input: "gradients/conv2d_transpose_3/BiasAdd_grad/tuple/control_dependency"
  input: "conv2d_transpose_3/kernel/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 2
        i: 2
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_transpose_3/conv2d_transpose_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/conv2d_transpose_3/conv2d_transpose_grad/Conv2D"
  input: "^gradients/conv2d_transpose_3/conv2d_transpose_grad/Conv2DBackpropFilter"
}
node {
  name: "gradients/conv2d_transpose_3/conv2d_transpose_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/conv2d_transpose_3/conv2d_transpose_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_transpose_3/conv2d_transpose_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_transpose_3/conv2d_transpose_grad/Conv2DBackpropFilter"
      }
    }
  }
}
node {
  name: "gradients/conv2d_transpose_3/conv2d_transpose_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_transpose_3/conv2d_transpose_grad/Conv2D"
  input: "^gradients/conv2d_transpose_3/conv2d_transpose_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_transpose_3/conv2d_transpose_grad/Conv2D"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_22/Maximum_grad/Shape"
  op: "Shape"
  input: "LeakyRelu_22/mul"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_22/Maximum_grad/Shape_1"
  op: "Shape"
  input: "conv2d_19/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_22/Maximum_grad/Shape_2"
  op: "Shape"
  input: "gradients/conv2d_transpose_3/conv2d_transpose_grad/tuple/control_dependency_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_22/Maximum_grad/zeros/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_22/Maximum_grad/zeros"
  op: "Fill"
  input: "gradients/LeakyRelu_22/Maximum_grad/Shape_2"
  input: "gradients/LeakyRelu_22/Maximum_grad/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_22/Maximum_grad/GreaterEqual"
  op: "GreaterEqual"
  input: "LeakyRelu_22/mul"
  input: "conv2d_19/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_22/Maximum_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_22/Maximum_grad/Shape"
  input: "gradients/LeakyRelu_22/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_22/Maximum_grad/Select"
  op: "Select"
  input: "gradients/LeakyRelu_22/Maximum_grad/GreaterEqual"
  input: "gradients/conv2d_transpose_3/conv2d_transpose_grad/tuple/control_dependency_1"
  input: "gradients/LeakyRelu_22/Maximum_grad/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_22/Maximum_grad/Select_1"
  op: "Select"
  input: "gradients/LeakyRelu_22/Maximum_grad/GreaterEqual"
  input: "gradients/LeakyRelu_22/Maximum_grad/zeros"
  input: "gradients/conv2d_transpose_3/conv2d_transpose_grad/tuple/control_dependency_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_22/Maximum_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_22/Maximum_grad/Select"
  input: "gradients/LeakyRelu_22/Maximum_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_22/Maximum_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_22/Maximum_grad/Sum"
  input: "gradients/LeakyRelu_22/Maximum_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_22/Maximum_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_22/Maximum_grad/Select_1"
  input: "gradients/LeakyRelu_22/Maximum_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_22/Maximum_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_22/Maximum_grad/Sum_1"
  input: "gradients/LeakyRelu_22/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_22/Maximum_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_22/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_22/Maximum_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_22/Maximum_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_22/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_22/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_22/Maximum_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_22/Maximum_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_22/Maximum_grad/Reshape_1"
  input: "^gradients/LeakyRelu_22/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_22/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_22/mul_grad/Shape"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
          }
        }
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_22/mul_grad/Shape_1"
  op: "Shape"
  input: "conv2d_19/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_22/mul_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_22/mul_grad/Shape"
  input: "gradients/LeakyRelu_22/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_22/mul_grad/Mul"
  op: "Mul"
  input: "gradients/LeakyRelu_22/Maximum_grad/tuple/control_dependency"
  input: "conv2d_19/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_22/mul_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_22/mul_grad/Mul"
  input: "gradients/LeakyRelu_22/mul_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_22/mul_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_22/mul_grad/Sum"
  input: "gradients/LeakyRelu_22/mul_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_22/mul_grad/Mul_1"
  op: "Mul"
  input: "LeakyRelu_22/alpha"
  input: "gradients/LeakyRelu_22/Maximum_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_22/mul_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_22/mul_grad/Mul_1"
  input: "gradients/LeakyRelu_22/mul_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_22/mul_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_22/mul_grad/Sum_1"
  input: "gradients/LeakyRelu_22/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_22/mul_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_22/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_22/mul_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_22/mul_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_22/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_22/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_22/mul_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_22/mul_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_22/mul_grad/Reshape_1"
  input: "^gradients/LeakyRelu_22/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_22/mul_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/AddN_8"
  op: "AddN"
  input: "gradients/LeakyRelu_22/Maximum_grad/tuple/control_dependency_1"
  input: "gradients/LeakyRelu_22/mul_grad/tuple/control_dependency_1"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_22/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_19/BiasAdd_grad/BiasAddGrad"
  op: "BiasAddGrad"
  input: "gradients/AddN_8"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "gradients/conv2d_19/BiasAdd_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/AddN_8"
  input: "^gradients/conv2d_19/BiasAdd_grad/BiasAddGrad"
}
node {
  name: "gradients/conv2d_19/BiasAdd_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/AddN_8"
  input: "^gradients/conv2d_19/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_22/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_19/BiasAdd_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_19/BiasAdd_grad/BiasAddGrad"
  input: "^gradients/conv2d_19/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_19/BiasAdd_grad/BiasAddGrad"
      }
    }
  }
}
node {
  name: "gradients/conv2d_19/Conv2D_grad/ShapeN"
  op: "ShapeN"
  input: "LeakyRelu_21/Maximum"
  input: "conv2d_19/kernel/read"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/conv2d_19/Conv2D_grad/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\003\000\000\000\003\000\000\000\020\000\000\000\020\000\000\000"
      }
    }
  }
}
node {
  name: "gradients/conv2d_19/Conv2D_grad/Conv2DBackpropInput"
  op: "Conv2DBackpropInput"
  input: "gradients/conv2d_19/Conv2D_grad/ShapeN"
  input: "conv2d_19/kernel/read"
  input: "gradients/conv2d_19/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_19/Conv2D_grad/Conv2DBackpropFilter"
  op: "Conv2DBackpropFilter"
  input: "LeakyRelu_21/Maximum"
  input: "gradients/conv2d_19/Conv2D_grad/Const"
  input: "gradients/conv2d_19/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_19/Conv2D_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/conv2d_19/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_19/Conv2D_grad/Conv2DBackpropInput"
}
node {
  name: "gradients/conv2d_19/Conv2D_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/conv2d_19/Conv2D_grad/Conv2DBackpropInput"
  input: "^gradients/conv2d_19/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_19/Conv2D_grad/Conv2DBackpropInput"
      }
    }
  }
}
node {
  name: "gradients/conv2d_19/Conv2D_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_19/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_19/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_19/Conv2D_grad/Conv2DBackpropFilter"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_21/Maximum_grad/Shape"
  op: "Shape"
  input: "LeakyRelu_21/mul"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_21/Maximum_grad/Shape_1"
  op: "Shape"
  input: "conv2d_18/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_21/Maximum_grad/Shape_2"
  op: "Shape"
  input: "gradients/conv2d_19/Conv2D_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_21/Maximum_grad/zeros/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_21/Maximum_grad/zeros"
  op: "Fill"
  input: "gradients/LeakyRelu_21/Maximum_grad/Shape_2"
  input: "gradients/LeakyRelu_21/Maximum_grad/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_21/Maximum_grad/GreaterEqual"
  op: "GreaterEqual"
  input: "LeakyRelu_21/mul"
  input: "conv2d_18/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_21/Maximum_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_21/Maximum_grad/Shape"
  input: "gradients/LeakyRelu_21/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_21/Maximum_grad/Select"
  op: "Select"
  input: "gradients/LeakyRelu_21/Maximum_grad/GreaterEqual"
  input: "gradients/conv2d_19/Conv2D_grad/tuple/control_dependency"
  input: "gradients/LeakyRelu_21/Maximum_grad/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_21/Maximum_grad/Select_1"
  op: "Select"
  input: "gradients/LeakyRelu_21/Maximum_grad/GreaterEqual"
  input: "gradients/LeakyRelu_21/Maximum_grad/zeros"
  input: "gradients/conv2d_19/Conv2D_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_21/Maximum_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_21/Maximum_grad/Select"
  input: "gradients/LeakyRelu_21/Maximum_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_21/Maximum_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_21/Maximum_grad/Sum"
  input: "gradients/LeakyRelu_21/Maximum_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_21/Maximum_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_21/Maximum_grad/Select_1"
  input: "gradients/LeakyRelu_21/Maximum_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_21/Maximum_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_21/Maximum_grad/Sum_1"
  input: "gradients/LeakyRelu_21/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_21/Maximum_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_21/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_21/Maximum_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_21/Maximum_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_21/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_21/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_21/Maximum_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_21/Maximum_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_21/Maximum_grad/Reshape_1"
  input: "^gradients/LeakyRelu_21/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_21/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_21/mul_grad/Shape"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
          }
        }
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_21/mul_grad/Shape_1"
  op: "Shape"
  input: "conv2d_18/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_21/mul_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_21/mul_grad/Shape"
  input: "gradients/LeakyRelu_21/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_21/mul_grad/Mul"
  op: "Mul"
  input: "gradients/LeakyRelu_21/Maximum_grad/tuple/control_dependency"
  input: "conv2d_18/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_21/mul_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_21/mul_grad/Mul"
  input: "gradients/LeakyRelu_21/mul_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_21/mul_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_21/mul_grad/Sum"
  input: "gradients/LeakyRelu_21/mul_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_21/mul_grad/Mul_1"
  op: "Mul"
  input: "LeakyRelu_21/alpha"
  input: "gradients/LeakyRelu_21/Maximum_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_21/mul_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_21/mul_grad/Mul_1"
  input: "gradients/LeakyRelu_21/mul_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_21/mul_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_21/mul_grad/Sum_1"
  input: "gradients/LeakyRelu_21/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_21/mul_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_21/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_21/mul_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_21/mul_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_21/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_21/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_21/mul_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_21/mul_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_21/mul_grad/Reshape_1"
  input: "^gradients/LeakyRelu_21/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_21/mul_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/AddN_9"
  op: "AddN"
  input: "gradients/LeakyRelu_21/Maximum_grad/tuple/control_dependency_1"
  input: "gradients/LeakyRelu_21/mul_grad/tuple/control_dependency_1"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_21/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_18/BiasAdd_grad/BiasAddGrad"
  op: "BiasAddGrad"
  input: "gradients/AddN_9"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "gradients/conv2d_18/BiasAdd_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/AddN_9"
  input: "^gradients/conv2d_18/BiasAdd_grad/BiasAddGrad"
}
node {
  name: "gradients/conv2d_18/BiasAdd_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/AddN_9"
  input: "^gradients/conv2d_18/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_21/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_18/BiasAdd_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_18/BiasAdd_grad/BiasAddGrad"
  input: "^gradients/conv2d_18/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_18/BiasAdd_grad/BiasAddGrad"
      }
    }
  }
}
node {
  name: "gradients/conv2d_18/Conv2D_grad/ShapeN"
  op: "ShapeN"
  input: "concat_2"
  input: "conv2d_18/kernel/read"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/conv2d_18/Conv2D_grad/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000\030\000\000\000\020\000\000\000"
      }
    }
  }
}
node {
  name: "gradients/conv2d_18/Conv2D_grad/Conv2DBackpropInput"
  op: "Conv2DBackpropInput"
  input: "gradients/conv2d_18/Conv2D_grad/ShapeN"
  input: "conv2d_18/kernel/read"
  input: "gradients/conv2d_18/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_18/Conv2D_grad/Conv2DBackpropFilter"
  op: "Conv2DBackpropFilter"
  input: "concat_2"
  input: "gradients/conv2d_18/Conv2D_grad/Const"
  input: "gradients/conv2d_18/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_18/Conv2D_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/conv2d_18/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_18/Conv2D_grad/Conv2DBackpropInput"
}
node {
  name: "gradients/conv2d_18/Conv2D_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/conv2d_18/Conv2D_grad/Conv2DBackpropInput"
  input: "^gradients/conv2d_18/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_18/Conv2D_grad/Conv2DBackpropInput"
      }
    }
  }
}
node {
  name: "gradients/conv2d_18/Conv2D_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_18/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_18/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_18/Conv2D_grad/Conv2DBackpropFilter"
      }
    }
  }
}
node {
  name: "gradients/concat_2_grad/Rank"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
        }
        int_val: 4
      }
    }
  }
}
node {
  name: "gradients/concat_2_grad/mod"
  op: "FloorMod"
  input: "concat_2/axis"
  input: "gradients/concat_2_grad/Rank"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/concat_2_grad/Shape"
  op: "Shape"
  input: "LeakyRelu_20/Maximum"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/concat_2_grad/ShapeN"
  op: "ShapeN"
  input: "LeakyRelu_20/Maximum"
  input: "LeakyRelu_8/Maximum"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/concat_2_grad/ConcatOffset"
  op: "ConcatOffset"
  input: "gradients/concat_2_grad/mod"
  input: "gradients/concat_2_grad/ShapeN"
  input: "gradients/concat_2_grad/ShapeN:1"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
}
node {
  name: "gradients/concat_2_grad/Slice"
  op: "Slice"
  input: "gradients/conv2d_18/Conv2D_grad/tuple/control_dependency"
  input: "gradients/concat_2_grad/ConcatOffset"
  input: "gradients/concat_2_grad/ShapeN"
  attr {
    key: "Index"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/concat_2_grad/Slice_1"
  op: "Slice"
  input: "gradients/conv2d_18/Conv2D_grad/tuple/control_dependency"
  input: "gradients/concat_2_grad/ConcatOffset:1"
  input: "gradients/concat_2_grad/ShapeN:1"
  attr {
    key: "Index"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/concat_2_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/concat_2_grad/Slice"
  input: "^gradients/concat_2_grad/Slice_1"
}
node {
  name: "gradients/concat_2_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/concat_2_grad/Slice"
  input: "^gradients/concat_2_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/concat_2_grad/Slice"
      }
    }
  }
}
node {
  name: "gradients/concat_2_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/concat_2_grad/Slice_1"
  input: "^gradients/concat_2_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/concat_2_grad/Slice_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_20/Maximum_grad/Shape"
  op: "Shape"
  input: "LeakyRelu_20/mul"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_20/Maximum_grad/Shape_1"
  op: "Shape"
  input: "conv2d_transpose_2/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_20/Maximum_grad/Shape_2"
  op: "Shape"
  input: "gradients/concat_2_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_20/Maximum_grad/zeros/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_20/Maximum_grad/zeros"
  op: "Fill"
  input: "gradients/LeakyRelu_20/Maximum_grad/Shape_2"
  input: "gradients/LeakyRelu_20/Maximum_grad/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_20/Maximum_grad/GreaterEqual"
  op: "GreaterEqual"
  input: "LeakyRelu_20/mul"
  input: "conv2d_transpose_2/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_20/Maximum_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_20/Maximum_grad/Shape"
  input: "gradients/LeakyRelu_20/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_20/Maximum_grad/Select"
  op: "Select"
  input: "gradients/LeakyRelu_20/Maximum_grad/GreaterEqual"
  input: "gradients/concat_2_grad/tuple/control_dependency"
  input: "gradients/LeakyRelu_20/Maximum_grad/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_20/Maximum_grad/Select_1"
  op: "Select"
  input: "gradients/LeakyRelu_20/Maximum_grad/GreaterEqual"
  input: "gradients/LeakyRelu_20/Maximum_grad/zeros"
  input: "gradients/concat_2_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_20/Maximum_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_20/Maximum_grad/Select"
  input: "gradients/LeakyRelu_20/Maximum_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_20/Maximum_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_20/Maximum_grad/Sum"
  input: "gradients/LeakyRelu_20/Maximum_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_20/Maximum_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_20/Maximum_grad/Select_1"
  input: "gradients/LeakyRelu_20/Maximum_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_20/Maximum_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_20/Maximum_grad/Sum_1"
  input: "gradients/LeakyRelu_20/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_20/Maximum_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_20/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_20/Maximum_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_20/Maximum_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_20/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_20/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_20/Maximum_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_20/Maximum_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_20/Maximum_grad/Reshape_1"
  input: "^gradients/LeakyRelu_20/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_20/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_20/mul_grad/Shape"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
          }
        }
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_20/mul_grad/Shape_1"
  op: "Shape"
  input: "conv2d_transpose_2/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_20/mul_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_20/mul_grad/Shape"
  input: "gradients/LeakyRelu_20/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_20/mul_grad/Mul"
  op: "Mul"
  input: "gradients/LeakyRelu_20/Maximum_grad/tuple/control_dependency"
  input: "conv2d_transpose_2/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_20/mul_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_20/mul_grad/Mul"
  input: "gradients/LeakyRelu_20/mul_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_20/mul_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_20/mul_grad/Sum"
  input: "gradients/LeakyRelu_20/mul_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_20/mul_grad/Mul_1"
  op: "Mul"
  input: "LeakyRelu_20/alpha"
  input: "gradients/LeakyRelu_20/Maximum_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_20/mul_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_20/mul_grad/Mul_1"
  input: "gradients/LeakyRelu_20/mul_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_20/mul_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_20/mul_grad/Sum_1"
  input: "gradients/LeakyRelu_20/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_20/mul_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_20/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_20/mul_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_20/mul_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_20/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_20/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_20/mul_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_20/mul_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_20/mul_grad/Reshape_1"
  input: "^gradients/LeakyRelu_20/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_20/mul_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/AddN_10"
  op: "AddN"
  input: "gradients/LeakyRelu_20/Maximum_grad/tuple/control_dependency_1"
  input: "gradients/LeakyRelu_20/mul_grad/tuple/control_dependency_1"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_20/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_transpose_2/BiasAdd_grad/BiasAddGrad"
  op: "BiasAddGrad"
  input: "gradients/AddN_10"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "gradients/conv2d_transpose_2/BiasAdd_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/AddN_10"
  input: "^gradients/conv2d_transpose_2/BiasAdd_grad/BiasAddGrad"
}
node {
  name: "gradients/conv2d_transpose_2/BiasAdd_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/AddN_10"
  input: "^gradients/conv2d_transpose_2/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_20/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_transpose_2/BiasAdd_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_transpose_2/BiasAdd_grad/BiasAddGrad"
  input: "^gradients/conv2d_transpose_2/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_transpose_2/BiasAdd_grad/BiasAddGrad"
      }
    }
  }
}
node {
  name: "gradients/conv2d_transpose_2/conv2d_transpose_grad/Shape"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\003\000\000\000\003\000\000\000\010\000\000\000\010\000\000\000"
      }
    }
  }
}
node {
  name: "gradients/conv2d_transpose_2/conv2d_transpose_grad/Conv2DBackpropFilter"
  op: "Conv2DBackpropFilter"
  input: "gradients/conv2d_transpose_2/BiasAdd_grad/tuple/control_dependency"
  input: "gradients/conv2d_transpose_2/conv2d_transpose_grad/Shape"
  input: "LeakyRelu_19/Maximum"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 2
        i: 2
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_transpose_2/conv2d_transpose_grad/Conv2D"
  op: "Conv2D"
  input: "gradients/conv2d_transpose_2/BiasAdd_grad/tuple/control_dependency"
  input: "conv2d_transpose_2/kernel/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 2
        i: 2
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_transpose_2/conv2d_transpose_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/conv2d_transpose_2/conv2d_transpose_grad/Conv2D"
  input: "^gradients/conv2d_transpose_2/conv2d_transpose_grad/Conv2DBackpropFilter"
}
node {
  name: "gradients/conv2d_transpose_2/conv2d_transpose_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/conv2d_transpose_2/conv2d_transpose_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_transpose_2/conv2d_transpose_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_transpose_2/conv2d_transpose_grad/Conv2DBackpropFilter"
      }
    }
  }
}
node {
  name: "gradients/conv2d_transpose_2/conv2d_transpose_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_transpose_2/conv2d_transpose_grad/Conv2D"
  input: "^gradients/conv2d_transpose_2/conv2d_transpose_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_transpose_2/conv2d_transpose_grad/Conv2D"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_19/Maximum_grad/Shape"
  op: "Shape"
  input: "LeakyRelu_19/mul"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_19/Maximum_grad/Shape_1"
  op: "Shape"
  input: "conv2d_17/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_19/Maximum_grad/Shape_2"
  op: "Shape"
  input: "gradients/conv2d_transpose_2/conv2d_transpose_grad/tuple/control_dependency_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_19/Maximum_grad/zeros/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_19/Maximum_grad/zeros"
  op: "Fill"
  input: "gradients/LeakyRelu_19/Maximum_grad/Shape_2"
  input: "gradients/LeakyRelu_19/Maximum_grad/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_19/Maximum_grad/GreaterEqual"
  op: "GreaterEqual"
  input: "LeakyRelu_19/mul"
  input: "conv2d_17/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_19/Maximum_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_19/Maximum_grad/Shape"
  input: "gradients/LeakyRelu_19/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_19/Maximum_grad/Select"
  op: "Select"
  input: "gradients/LeakyRelu_19/Maximum_grad/GreaterEqual"
  input: "gradients/conv2d_transpose_2/conv2d_transpose_grad/tuple/control_dependency_1"
  input: "gradients/LeakyRelu_19/Maximum_grad/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_19/Maximum_grad/Select_1"
  op: "Select"
  input: "gradients/LeakyRelu_19/Maximum_grad/GreaterEqual"
  input: "gradients/LeakyRelu_19/Maximum_grad/zeros"
  input: "gradients/conv2d_transpose_2/conv2d_transpose_grad/tuple/control_dependency_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_19/Maximum_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_19/Maximum_grad/Select"
  input: "gradients/LeakyRelu_19/Maximum_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_19/Maximum_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_19/Maximum_grad/Sum"
  input: "gradients/LeakyRelu_19/Maximum_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_19/Maximum_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_19/Maximum_grad/Select_1"
  input: "gradients/LeakyRelu_19/Maximum_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_19/Maximum_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_19/Maximum_grad/Sum_1"
  input: "gradients/LeakyRelu_19/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_19/Maximum_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_19/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_19/Maximum_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_19/Maximum_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_19/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_19/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_19/Maximum_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_19/Maximum_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_19/Maximum_grad/Reshape_1"
  input: "^gradients/LeakyRelu_19/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_19/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_19/mul_grad/Shape"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
          }
        }
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_19/mul_grad/Shape_1"
  op: "Shape"
  input: "conv2d_17/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_19/mul_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_19/mul_grad/Shape"
  input: "gradients/LeakyRelu_19/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_19/mul_grad/Mul"
  op: "Mul"
  input: "gradients/LeakyRelu_19/Maximum_grad/tuple/control_dependency"
  input: "conv2d_17/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_19/mul_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_19/mul_grad/Mul"
  input: "gradients/LeakyRelu_19/mul_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_19/mul_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_19/mul_grad/Sum"
  input: "gradients/LeakyRelu_19/mul_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_19/mul_grad/Mul_1"
  op: "Mul"
  input: "LeakyRelu_19/alpha"
  input: "gradients/LeakyRelu_19/Maximum_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_19/mul_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_19/mul_grad/Mul_1"
  input: "gradients/LeakyRelu_19/mul_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_19/mul_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_19/mul_grad/Sum_1"
  input: "gradients/LeakyRelu_19/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_19/mul_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_19/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_19/mul_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_19/mul_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_19/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_19/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_19/mul_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_19/mul_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_19/mul_grad/Reshape_1"
  input: "^gradients/LeakyRelu_19/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_19/mul_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/AddN_11"
  op: "AddN"
  input: "gradients/LeakyRelu_19/Maximum_grad/tuple/control_dependency_1"
  input: "gradients/LeakyRelu_19/mul_grad/tuple/control_dependency_1"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_19/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_17/BiasAdd_grad/BiasAddGrad"
  op: "BiasAddGrad"
  input: "gradients/AddN_11"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "gradients/conv2d_17/BiasAdd_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/AddN_11"
  input: "^gradients/conv2d_17/BiasAdd_grad/BiasAddGrad"
}
node {
  name: "gradients/conv2d_17/BiasAdd_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/AddN_11"
  input: "^gradients/conv2d_17/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_19/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_17/BiasAdd_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_17/BiasAdd_grad/BiasAddGrad"
  input: "^gradients/conv2d_17/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_17/BiasAdd_grad/BiasAddGrad"
      }
    }
  }
}
node {
  name: "gradients/conv2d_17/Conv2D_grad/ShapeN"
  op: "ShapeN"
  input: "concat_1"
  input: "conv2d_17/kernel/read"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/conv2d_17/Conv2D_grad/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000\020\000\000\000\010\000\000\000"
      }
    }
  }
}
node {
  name: "gradients/conv2d_17/Conv2D_grad/Conv2DBackpropInput"
  op: "Conv2DBackpropInput"
  input: "gradients/conv2d_17/Conv2D_grad/ShapeN"
  input: "conv2d_17/kernel/read"
  input: "gradients/conv2d_17/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_17/Conv2D_grad/Conv2DBackpropFilter"
  op: "Conv2DBackpropFilter"
  input: "concat_1"
  input: "gradients/conv2d_17/Conv2D_grad/Const"
  input: "gradients/conv2d_17/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_17/Conv2D_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/conv2d_17/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_17/Conv2D_grad/Conv2DBackpropInput"
}
node {
  name: "gradients/conv2d_17/Conv2D_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/conv2d_17/Conv2D_grad/Conv2DBackpropInput"
  input: "^gradients/conv2d_17/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_17/Conv2D_grad/Conv2DBackpropInput"
      }
    }
  }
}
node {
  name: "gradients/conv2d_17/Conv2D_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_17/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_17/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_17/Conv2D_grad/Conv2DBackpropFilter"
      }
    }
  }
}
node {
  name: "gradients/concat_1_grad/Rank"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
        }
        int_val: 4
      }
    }
  }
}
node {
  name: "gradients/concat_1_grad/mod"
  op: "FloorMod"
  input: "concat_1/axis"
  input: "gradients/concat_1_grad/Rank"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/concat_1_grad/Shape"
  op: "Shape"
  input: "LeakyRelu_18/Maximum"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/concat_1_grad/ShapeN"
  op: "ShapeN"
  input: "LeakyRelu_18/Maximum"
  input: "LeakyRelu_10/Maximum"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/concat_1_grad/ConcatOffset"
  op: "ConcatOffset"
  input: "gradients/concat_1_grad/mod"
  input: "gradients/concat_1_grad/ShapeN"
  input: "gradients/concat_1_grad/ShapeN:1"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
}
node {
  name: "gradients/concat_1_grad/Slice"
  op: "Slice"
  input: "gradients/conv2d_17/Conv2D_grad/tuple/control_dependency"
  input: "gradients/concat_1_grad/ConcatOffset"
  input: "gradients/concat_1_grad/ShapeN"
  attr {
    key: "Index"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/concat_1_grad/Slice_1"
  op: "Slice"
  input: "gradients/conv2d_17/Conv2D_grad/tuple/control_dependency"
  input: "gradients/concat_1_grad/ConcatOffset:1"
  input: "gradients/concat_1_grad/ShapeN:1"
  attr {
    key: "Index"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/concat_1_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/concat_1_grad/Slice"
  input: "^gradients/concat_1_grad/Slice_1"
}
node {
  name: "gradients/concat_1_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/concat_1_grad/Slice"
  input: "^gradients/concat_1_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/concat_1_grad/Slice"
      }
    }
  }
}
node {
  name: "gradients/concat_1_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/concat_1_grad/Slice_1"
  input: "^gradients/concat_1_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/concat_1_grad/Slice_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_18/Maximum_grad/Shape"
  op: "Shape"
  input: "LeakyRelu_18/mul"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_18/Maximum_grad/Shape_1"
  op: "Shape"
  input: "conv2d_transpose_1/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_18/Maximum_grad/Shape_2"
  op: "Shape"
  input: "gradients/concat_1_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_18/Maximum_grad/zeros/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_18/Maximum_grad/zeros"
  op: "Fill"
  input: "gradients/LeakyRelu_18/Maximum_grad/Shape_2"
  input: "gradients/LeakyRelu_18/Maximum_grad/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_18/Maximum_grad/GreaterEqual"
  op: "GreaterEqual"
  input: "LeakyRelu_18/mul"
  input: "conv2d_transpose_1/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_18/Maximum_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_18/Maximum_grad/Shape"
  input: "gradients/LeakyRelu_18/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_18/Maximum_grad/Select"
  op: "Select"
  input: "gradients/LeakyRelu_18/Maximum_grad/GreaterEqual"
  input: "gradients/concat_1_grad/tuple/control_dependency"
  input: "gradients/LeakyRelu_18/Maximum_grad/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_18/Maximum_grad/Select_1"
  op: "Select"
  input: "gradients/LeakyRelu_18/Maximum_grad/GreaterEqual"
  input: "gradients/LeakyRelu_18/Maximum_grad/zeros"
  input: "gradients/concat_1_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_18/Maximum_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_18/Maximum_grad/Select"
  input: "gradients/LeakyRelu_18/Maximum_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_18/Maximum_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_18/Maximum_grad/Sum"
  input: "gradients/LeakyRelu_18/Maximum_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_18/Maximum_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_18/Maximum_grad/Select_1"
  input: "gradients/LeakyRelu_18/Maximum_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_18/Maximum_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_18/Maximum_grad/Sum_1"
  input: "gradients/LeakyRelu_18/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_18/Maximum_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_18/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_18/Maximum_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_18/Maximum_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_18/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_18/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_18/Maximum_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_18/Maximum_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_18/Maximum_grad/Reshape_1"
  input: "^gradients/LeakyRelu_18/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_18/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_18/mul_grad/Shape"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
          }
        }
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_18/mul_grad/Shape_1"
  op: "Shape"
  input: "conv2d_transpose_1/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_18/mul_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_18/mul_grad/Shape"
  input: "gradients/LeakyRelu_18/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_18/mul_grad/Mul"
  op: "Mul"
  input: "gradients/LeakyRelu_18/Maximum_grad/tuple/control_dependency"
  input: "conv2d_transpose_1/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_18/mul_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_18/mul_grad/Mul"
  input: "gradients/LeakyRelu_18/mul_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_18/mul_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_18/mul_grad/Sum"
  input: "gradients/LeakyRelu_18/mul_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_18/mul_grad/Mul_1"
  op: "Mul"
  input: "LeakyRelu_18/alpha"
  input: "gradients/LeakyRelu_18/Maximum_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_18/mul_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_18/mul_grad/Mul_1"
  input: "gradients/LeakyRelu_18/mul_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_18/mul_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_18/mul_grad/Sum_1"
  input: "gradients/LeakyRelu_18/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_18/mul_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_18/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_18/mul_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_18/mul_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_18/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_18/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_18/mul_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_18/mul_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_18/mul_grad/Reshape_1"
  input: "^gradients/LeakyRelu_18/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_18/mul_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/AddN_12"
  op: "AddN"
  input: "gradients/LeakyRelu_18/Maximum_grad/tuple/control_dependency_1"
  input: "gradients/LeakyRelu_18/mul_grad/tuple/control_dependency_1"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_18/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_transpose_1/BiasAdd_grad/BiasAddGrad"
  op: "BiasAddGrad"
  input: "gradients/AddN_12"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "gradients/conv2d_transpose_1/BiasAdd_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/AddN_12"
  input: "^gradients/conv2d_transpose_1/BiasAdd_grad/BiasAddGrad"
}
node {
  name: "gradients/conv2d_transpose_1/BiasAdd_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/AddN_12"
  input: "^gradients/conv2d_transpose_1/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_18/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_transpose_1/BiasAdd_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_transpose_1/BiasAdd_grad/BiasAddGrad"
  input: "^gradients/conv2d_transpose_1/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_transpose_1/BiasAdd_grad/BiasAddGrad"
      }
    }
  }
}
node {
  name: "gradients/conv2d_transpose_1/conv2d_transpose_grad/Shape"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\003\000\000\000\003\000\000\000\010\000\000\000\010\000\000\000"
      }
    }
  }
}
node {
  name: "gradients/conv2d_transpose_1/conv2d_transpose_grad/Conv2DBackpropFilter"
  op: "Conv2DBackpropFilter"
  input: "gradients/conv2d_transpose_1/BiasAdd_grad/tuple/control_dependency"
  input: "gradients/conv2d_transpose_1/conv2d_transpose_grad/Shape"
  input: "LeakyRelu_17/Maximum"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 2
        i: 2
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_transpose_1/conv2d_transpose_grad/Conv2D"
  op: "Conv2D"
  input: "gradients/conv2d_transpose_1/BiasAdd_grad/tuple/control_dependency"
  input: "conv2d_transpose_1/kernel/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 2
        i: 2
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_transpose_1/conv2d_transpose_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/conv2d_transpose_1/conv2d_transpose_grad/Conv2D"
  input: "^gradients/conv2d_transpose_1/conv2d_transpose_grad/Conv2DBackpropFilter"
}
node {
  name: "gradients/conv2d_transpose_1/conv2d_transpose_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/conv2d_transpose_1/conv2d_transpose_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_transpose_1/conv2d_transpose_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_transpose_1/conv2d_transpose_grad/Conv2DBackpropFilter"
      }
    }
  }
}
node {
  name: "gradients/conv2d_transpose_1/conv2d_transpose_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_transpose_1/conv2d_transpose_grad/Conv2D"
  input: "^gradients/conv2d_transpose_1/conv2d_transpose_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_transpose_1/conv2d_transpose_grad/Conv2D"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_17/Maximum_grad/Shape"
  op: "Shape"
  input: "LeakyRelu_17/mul"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_17/Maximum_grad/Shape_1"
  op: "Shape"
  input: "conv2d_16/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_17/Maximum_grad/Shape_2"
  op: "Shape"
  input: "gradients/conv2d_transpose_1/conv2d_transpose_grad/tuple/control_dependency_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_17/Maximum_grad/zeros/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_17/Maximum_grad/zeros"
  op: "Fill"
  input: "gradients/LeakyRelu_17/Maximum_grad/Shape_2"
  input: "gradients/LeakyRelu_17/Maximum_grad/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_17/Maximum_grad/GreaterEqual"
  op: "GreaterEqual"
  input: "LeakyRelu_17/mul"
  input: "conv2d_16/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_17/Maximum_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_17/Maximum_grad/Shape"
  input: "gradients/LeakyRelu_17/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_17/Maximum_grad/Select"
  op: "Select"
  input: "gradients/LeakyRelu_17/Maximum_grad/GreaterEqual"
  input: "gradients/conv2d_transpose_1/conv2d_transpose_grad/tuple/control_dependency_1"
  input: "gradients/LeakyRelu_17/Maximum_grad/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_17/Maximum_grad/Select_1"
  op: "Select"
  input: "gradients/LeakyRelu_17/Maximum_grad/GreaterEqual"
  input: "gradients/LeakyRelu_17/Maximum_grad/zeros"
  input: "gradients/conv2d_transpose_1/conv2d_transpose_grad/tuple/control_dependency_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_17/Maximum_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_17/Maximum_grad/Select"
  input: "gradients/LeakyRelu_17/Maximum_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_17/Maximum_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_17/Maximum_grad/Sum"
  input: "gradients/LeakyRelu_17/Maximum_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_17/Maximum_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_17/Maximum_grad/Select_1"
  input: "gradients/LeakyRelu_17/Maximum_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_17/Maximum_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_17/Maximum_grad/Sum_1"
  input: "gradients/LeakyRelu_17/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_17/Maximum_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_17/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_17/Maximum_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_17/Maximum_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_17/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_17/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_17/Maximum_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_17/Maximum_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_17/Maximum_grad/Reshape_1"
  input: "^gradients/LeakyRelu_17/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_17/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_17/mul_grad/Shape"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
          }
        }
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_17/mul_grad/Shape_1"
  op: "Shape"
  input: "conv2d_16/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_17/mul_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_17/mul_grad/Shape"
  input: "gradients/LeakyRelu_17/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_17/mul_grad/Mul"
  op: "Mul"
  input: "gradients/LeakyRelu_17/Maximum_grad/tuple/control_dependency"
  input: "conv2d_16/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_17/mul_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_17/mul_grad/Mul"
  input: "gradients/LeakyRelu_17/mul_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_17/mul_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_17/mul_grad/Sum"
  input: "gradients/LeakyRelu_17/mul_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_17/mul_grad/Mul_1"
  op: "Mul"
  input: "LeakyRelu_17/alpha"
  input: "gradients/LeakyRelu_17/Maximum_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_17/mul_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_17/mul_grad/Mul_1"
  input: "gradients/LeakyRelu_17/mul_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_17/mul_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_17/mul_grad/Sum_1"
  input: "gradients/LeakyRelu_17/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_17/mul_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_17/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_17/mul_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_17/mul_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_17/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_17/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_17/mul_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_17/mul_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_17/mul_grad/Reshape_1"
  input: "^gradients/LeakyRelu_17/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_17/mul_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/AddN_13"
  op: "AddN"
  input: "gradients/LeakyRelu_17/Maximum_grad/tuple/control_dependency_1"
  input: "gradients/LeakyRelu_17/mul_grad/tuple/control_dependency_1"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_17/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_16/BiasAdd_grad/BiasAddGrad"
  op: "BiasAddGrad"
  input: "gradients/AddN_13"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "gradients/conv2d_16/BiasAdd_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/AddN_13"
  input: "^gradients/conv2d_16/BiasAdd_grad/BiasAddGrad"
}
node {
  name: "gradients/conv2d_16/BiasAdd_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/AddN_13"
  input: "^gradients/conv2d_16/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_17/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_16/BiasAdd_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_16/BiasAdd_grad/BiasAddGrad"
  input: "^gradients/conv2d_16/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_16/BiasAdd_grad/BiasAddGrad"
      }
    }
  }
}
node {
  name: "gradients/conv2d_16/Conv2D_grad/ShapeN"
  op: "ShapeN"
  input: "concat"
  input: "conv2d_16/kernel/read"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/conv2d_16/Conv2D_grad/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000\020\000\000\000\010\000\000\000"
      }
    }
  }
}
node {
  name: "gradients/conv2d_16/Conv2D_grad/Conv2DBackpropInput"
  op: "Conv2DBackpropInput"
  input: "gradients/conv2d_16/Conv2D_grad/ShapeN"
  input: "conv2d_16/kernel/read"
  input: "gradients/conv2d_16/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_16/Conv2D_grad/Conv2DBackpropFilter"
  op: "Conv2DBackpropFilter"
  input: "concat"
  input: "gradients/conv2d_16/Conv2D_grad/Const"
  input: "gradients/conv2d_16/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_16/Conv2D_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/conv2d_16/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_16/Conv2D_grad/Conv2DBackpropInput"
}
node {
  name: "gradients/conv2d_16/Conv2D_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/conv2d_16/Conv2D_grad/Conv2DBackpropInput"
  input: "^gradients/conv2d_16/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_16/Conv2D_grad/Conv2DBackpropInput"
      }
    }
  }
}
node {
  name: "gradients/conv2d_16/Conv2D_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_16/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_16/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_16/Conv2D_grad/Conv2DBackpropFilter"
      }
    }
  }
}
node {
  name: "gradients/concat_grad/Rank"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
        }
        int_val: 4
      }
    }
  }
}
node {
  name: "gradients/concat_grad/mod"
  op: "FloorMod"
  input: "concat/axis"
  input: "gradients/concat_grad/Rank"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/concat_grad/Shape"
  op: "Shape"
  input: "LeakyRelu_16/Maximum"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/concat_grad/ShapeN"
  op: "ShapeN"
  input: "LeakyRelu_16/Maximum"
  input: "LeakyRelu_12/Maximum"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/concat_grad/ConcatOffset"
  op: "ConcatOffset"
  input: "gradients/concat_grad/mod"
  input: "gradients/concat_grad/ShapeN"
  input: "gradients/concat_grad/ShapeN:1"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
}
node {
  name: "gradients/concat_grad/Slice"
  op: "Slice"
  input: "gradients/conv2d_16/Conv2D_grad/tuple/control_dependency"
  input: "gradients/concat_grad/ConcatOffset"
  input: "gradients/concat_grad/ShapeN"
  attr {
    key: "Index"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/concat_grad/Slice_1"
  op: "Slice"
  input: "gradients/conv2d_16/Conv2D_grad/tuple/control_dependency"
  input: "gradients/concat_grad/ConcatOffset:1"
  input: "gradients/concat_grad/ShapeN:1"
  attr {
    key: "Index"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/concat_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/concat_grad/Slice"
  input: "^gradients/concat_grad/Slice_1"
}
node {
  name: "gradients/concat_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/concat_grad/Slice"
  input: "^gradients/concat_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/concat_grad/Slice"
      }
    }
  }
}
node {
  name: "gradients/concat_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/concat_grad/Slice_1"
  input: "^gradients/concat_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/concat_grad/Slice_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_16/Maximum_grad/Shape"
  op: "Shape"
  input: "LeakyRelu_16/mul"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_16/Maximum_grad/Shape_1"
  op: "Shape"
  input: "conv2d_transpose/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_16/Maximum_grad/Shape_2"
  op: "Shape"
  input: "gradients/concat_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_16/Maximum_grad/zeros/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_16/Maximum_grad/zeros"
  op: "Fill"
  input: "gradients/LeakyRelu_16/Maximum_grad/Shape_2"
  input: "gradients/LeakyRelu_16/Maximum_grad/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_16/Maximum_grad/GreaterEqual"
  op: "GreaterEqual"
  input: "LeakyRelu_16/mul"
  input: "conv2d_transpose/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_16/Maximum_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_16/Maximum_grad/Shape"
  input: "gradients/LeakyRelu_16/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_16/Maximum_grad/Select"
  op: "Select"
  input: "gradients/LeakyRelu_16/Maximum_grad/GreaterEqual"
  input: "gradients/concat_grad/tuple/control_dependency"
  input: "gradients/LeakyRelu_16/Maximum_grad/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_16/Maximum_grad/Select_1"
  op: "Select"
  input: "gradients/LeakyRelu_16/Maximum_grad/GreaterEqual"
  input: "gradients/LeakyRelu_16/Maximum_grad/zeros"
  input: "gradients/concat_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_16/Maximum_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_16/Maximum_grad/Select"
  input: "gradients/LeakyRelu_16/Maximum_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_16/Maximum_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_16/Maximum_grad/Sum"
  input: "gradients/LeakyRelu_16/Maximum_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_16/Maximum_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_16/Maximum_grad/Select_1"
  input: "gradients/LeakyRelu_16/Maximum_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_16/Maximum_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_16/Maximum_grad/Sum_1"
  input: "gradients/LeakyRelu_16/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_16/Maximum_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_16/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_16/Maximum_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_16/Maximum_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_16/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_16/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_16/Maximum_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_16/Maximum_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_16/Maximum_grad/Reshape_1"
  input: "^gradients/LeakyRelu_16/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_16/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_16/mul_grad/Shape"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
          }
        }
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_16/mul_grad/Shape_1"
  op: "Shape"
  input: "conv2d_transpose/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_16/mul_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_16/mul_grad/Shape"
  input: "gradients/LeakyRelu_16/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_16/mul_grad/Mul"
  op: "Mul"
  input: "gradients/LeakyRelu_16/Maximum_grad/tuple/control_dependency"
  input: "conv2d_transpose/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_16/mul_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_16/mul_grad/Mul"
  input: "gradients/LeakyRelu_16/mul_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_16/mul_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_16/mul_grad/Sum"
  input: "gradients/LeakyRelu_16/mul_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_16/mul_grad/Mul_1"
  op: "Mul"
  input: "LeakyRelu_16/alpha"
  input: "gradients/LeakyRelu_16/Maximum_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_16/mul_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_16/mul_grad/Mul_1"
  input: "gradients/LeakyRelu_16/mul_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_16/mul_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_16/mul_grad/Sum_1"
  input: "gradients/LeakyRelu_16/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_16/mul_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_16/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_16/mul_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_16/mul_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_16/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_16/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_16/mul_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_16/mul_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_16/mul_grad/Reshape_1"
  input: "^gradients/LeakyRelu_16/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_16/mul_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/AddN_14"
  op: "AddN"
  input: "gradients/LeakyRelu_16/Maximum_grad/tuple/control_dependency_1"
  input: "gradients/LeakyRelu_16/mul_grad/tuple/control_dependency_1"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_16/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_transpose/BiasAdd_grad/BiasAddGrad"
  op: "BiasAddGrad"
  input: "gradients/AddN_14"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "gradients/conv2d_transpose/BiasAdd_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/AddN_14"
  input: "^gradients/conv2d_transpose/BiasAdd_grad/BiasAddGrad"
}
node {
  name: "gradients/conv2d_transpose/BiasAdd_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/AddN_14"
  input: "^gradients/conv2d_transpose/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_16/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_transpose/BiasAdd_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_transpose/BiasAdd_grad/BiasAddGrad"
  input: "^gradients/conv2d_transpose/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_transpose/BiasAdd_grad/BiasAddGrad"
      }
    }
  }
}
node {
  name: "gradients/conv2d_transpose/conv2d_transpose_grad/Shape"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\003\000\000\000\003\000\000\000\010\000\000\000\010\000\000\000"
      }
    }
  }
}
node {
  name: "gradients/conv2d_transpose/conv2d_transpose_grad/Conv2DBackpropFilter"
  op: "Conv2DBackpropFilter"
  input: "gradients/conv2d_transpose/BiasAdd_grad/tuple/control_dependency"
  input: "gradients/conv2d_transpose/conv2d_transpose_grad/Shape"
  input: "LeakyRelu_15/Maximum"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 2
        i: 2
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_transpose/conv2d_transpose_grad/Conv2D"
  op: "Conv2D"
  input: "gradients/conv2d_transpose/BiasAdd_grad/tuple/control_dependency"
  input: "conv2d_transpose/kernel/read"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 2
        i: 2
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_transpose/conv2d_transpose_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/conv2d_transpose/conv2d_transpose_grad/Conv2D"
  input: "^gradients/conv2d_transpose/conv2d_transpose_grad/Conv2DBackpropFilter"
}
node {
  name: "gradients/conv2d_transpose/conv2d_transpose_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/conv2d_transpose/conv2d_transpose_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_transpose/conv2d_transpose_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_transpose/conv2d_transpose_grad/Conv2DBackpropFilter"
      }
    }
  }
}
node {
  name: "gradients/conv2d_transpose/conv2d_transpose_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_transpose/conv2d_transpose_grad/Conv2D"
  input: "^gradients/conv2d_transpose/conv2d_transpose_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_transpose/conv2d_transpose_grad/Conv2D"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_15/Maximum_grad/Shape"
  op: "Shape"
  input: "LeakyRelu_15/mul"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_15/Maximum_grad/Shape_1"
  op: "Shape"
  input: "conv2d_15/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_15/Maximum_grad/Shape_2"
  op: "Shape"
  input: "gradients/conv2d_transpose/conv2d_transpose_grad/tuple/control_dependency_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_15/Maximum_grad/zeros/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_15/Maximum_grad/zeros"
  op: "Fill"
  input: "gradients/LeakyRelu_15/Maximum_grad/Shape_2"
  input: "gradients/LeakyRelu_15/Maximum_grad/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_15/Maximum_grad/GreaterEqual"
  op: "GreaterEqual"
  input: "LeakyRelu_15/mul"
  input: "conv2d_15/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_15/Maximum_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_15/Maximum_grad/Shape"
  input: "gradients/LeakyRelu_15/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_15/Maximum_grad/Select"
  op: "Select"
  input: "gradients/LeakyRelu_15/Maximum_grad/GreaterEqual"
  input: "gradients/conv2d_transpose/conv2d_transpose_grad/tuple/control_dependency_1"
  input: "gradients/LeakyRelu_15/Maximum_grad/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_15/Maximum_grad/Select_1"
  op: "Select"
  input: "gradients/LeakyRelu_15/Maximum_grad/GreaterEqual"
  input: "gradients/LeakyRelu_15/Maximum_grad/zeros"
  input: "gradients/conv2d_transpose/conv2d_transpose_grad/tuple/control_dependency_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_15/Maximum_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_15/Maximum_grad/Select"
  input: "gradients/LeakyRelu_15/Maximum_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_15/Maximum_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_15/Maximum_grad/Sum"
  input: "gradients/LeakyRelu_15/Maximum_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_15/Maximum_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_15/Maximum_grad/Select_1"
  input: "gradients/LeakyRelu_15/Maximum_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_15/Maximum_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_15/Maximum_grad/Sum_1"
  input: "gradients/LeakyRelu_15/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_15/Maximum_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_15/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_15/Maximum_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_15/Maximum_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_15/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_15/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_15/Maximum_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_15/Maximum_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_15/Maximum_grad/Reshape_1"
  input: "^gradients/LeakyRelu_15/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_15/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_15/mul_grad/Shape"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
          }
        }
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_15/mul_grad/Shape_1"
  op: "Shape"
  input: "conv2d_15/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_15/mul_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_15/mul_grad/Shape"
  input: "gradients/LeakyRelu_15/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_15/mul_grad/Mul"
  op: "Mul"
  input: "gradients/LeakyRelu_15/Maximum_grad/tuple/control_dependency"
  input: "conv2d_15/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_15/mul_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_15/mul_grad/Mul"
  input: "gradients/LeakyRelu_15/mul_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_15/mul_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_15/mul_grad/Sum"
  input: "gradients/LeakyRelu_15/mul_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_15/mul_grad/Mul_1"
  op: "Mul"
  input: "LeakyRelu_15/alpha"
  input: "gradients/LeakyRelu_15/Maximum_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_15/mul_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_15/mul_grad/Mul_1"
  input: "gradients/LeakyRelu_15/mul_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_15/mul_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_15/mul_grad/Sum_1"
  input: "gradients/LeakyRelu_15/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_15/mul_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_15/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_15/mul_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_15/mul_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_15/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_15/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_15/mul_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_15/mul_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_15/mul_grad/Reshape_1"
  input: "^gradients/LeakyRelu_15/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_15/mul_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/AddN_15"
  op: "AddN"
  input: "gradients/LeakyRelu_15/Maximum_grad/tuple/control_dependency_1"
  input: "gradients/LeakyRelu_15/mul_grad/tuple/control_dependency_1"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_15/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_15/BiasAdd_grad/BiasAddGrad"
  op: "BiasAddGrad"
  input: "gradients/AddN_15"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "gradients/conv2d_15/BiasAdd_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/AddN_15"
  input: "^gradients/conv2d_15/BiasAdd_grad/BiasAddGrad"
}
node {
  name: "gradients/conv2d_15/BiasAdd_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/AddN_15"
  input: "^gradients/conv2d_15/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_15/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_15/BiasAdd_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_15/BiasAdd_grad/BiasAddGrad"
  input: "^gradients/conv2d_15/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_15/BiasAdd_grad/BiasAddGrad"
      }
    }
  }
}
node {
  name: "gradients/conv2d_15/Conv2D_grad/ShapeN"
  op: "ShapeN"
  input: "LeakyRelu_14/Maximum"
  input: "conv2d_15/kernel/read"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/conv2d_15/Conv2D_grad/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000\010\000\000\000\010\000\000\000"
      }
    }
  }
}
node {
  name: "gradients/conv2d_15/Conv2D_grad/Conv2DBackpropInput"
  op: "Conv2DBackpropInput"
  input: "gradients/conv2d_15/Conv2D_grad/ShapeN"
  input: "conv2d_15/kernel/read"
  input: "gradients/conv2d_15/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_15/Conv2D_grad/Conv2DBackpropFilter"
  op: "Conv2DBackpropFilter"
  input: "LeakyRelu_14/Maximum"
  input: "gradients/conv2d_15/Conv2D_grad/Const"
  input: "gradients/conv2d_15/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_15/Conv2D_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/conv2d_15/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_15/Conv2D_grad/Conv2DBackpropInput"
}
node {
  name: "gradients/conv2d_15/Conv2D_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/conv2d_15/Conv2D_grad/Conv2DBackpropInput"
  input: "^gradients/conv2d_15/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_15/Conv2D_grad/Conv2DBackpropInput"
      }
    }
  }
}
node {
  name: "gradients/conv2d_15/Conv2D_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_15/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_15/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_15/Conv2D_grad/Conv2DBackpropFilter"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_14/Maximum_grad/Shape"
  op: "Shape"
  input: "LeakyRelu_14/mul"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_14/Maximum_grad/Shape_1"
  op: "Shape"
  input: "conv2d_14/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_14/Maximum_grad/Shape_2"
  op: "Shape"
  input: "gradients/conv2d_15/Conv2D_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_14/Maximum_grad/zeros/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_14/Maximum_grad/zeros"
  op: "Fill"
  input: "gradients/LeakyRelu_14/Maximum_grad/Shape_2"
  input: "gradients/LeakyRelu_14/Maximum_grad/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_14/Maximum_grad/GreaterEqual"
  op: "GreaterEqual"
  input: "LeakyRelu_14/mul"
  input: "conv2d_14/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_14/Maximum_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_14/Maximum_grad/Shape"
  input: "gradients/LeakyRelu_14/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_14/Maximum_grad/Select"
  op: "Select"
  input: "gradients/LeakyRelu_14/Maximum_grad/GreaterEqual"
  input: "gradients/conv2d_15/Conv2D_grad/tuple/control_dependency"
  input: "gradients/LeakyRelu_14/Maximum_grad/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_14/Maximum_grad/Select_1"
  op: "Select"
  input: "gradients/LeakyRelu_14/Maximum_grad/GreaterEqual"
  input: "gradients/LeakyRelu_14/Maximum_grad/zeros"
  input: "gradients/conv2d_15/Conv2D_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_14/Maximum_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_14/Maximum_grad/Select"
  input: "gradients/LeakyRelu_14/Maximum_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_14/Maximum_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_14/Maximum_grad/Sum"
  input: "gradients/LeakyRelu_14/Maximum_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_14/Maximum_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_14/Maximum_grad/Select_1"
  input: "gradients/LeakyRelu_14/Maximum_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_14/Maximum_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_14/Maximum_grad/Sum_1"
  input: "gradients/LeakyRelu_14/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_14/Maximum_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_14/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_14/Maximum_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_14/Maximum_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_14/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_14/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_14/Maximum_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_14/Maximum_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_14/Maximum_grad/Reshape_1"
  input: "^gradients/LeakyRelu_14/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_14/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_14/mul_grad/Shape"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
          }
        }
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_14/mul_grad/Shape_1"
  op: "Shape"
  input: "conv2d_14/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_14/mul_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_14/mul_grad/Shape"
  input: "gradients/LeakyRelu_14/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_14/mul_grad/Mul"
  op: "Mul"
  input: "gradients/LeakyRelu_14/Maximum_grad/tuple/control_dependency"
  input: "conv2d_14/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_14/mul_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_14/mul_grad/Mul"
  input: "gradients/LeakyRelu_14/mul_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_14/mul_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_14/mul_grad/Sum"
  input: "gradients/LeakyRelu_14/mul_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_14/mul_grad/Mul_1"
  op: "Mul"
  input: "LeakyRelu_14/alpha"
  input: "gradients/LeakyRelu_14/Maximum_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_14/mul_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_14/mul_grad/Mul_1"
  input: "gradients/LeakyRelu_14/mul_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_14/mul_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_14/mul_grad/Sum_1"
  input: "gradients/LeakyRelu_14/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_14/mul_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_14/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_14/mul_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_14/mul_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_14/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_14/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_14/mul_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_14/mul_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_14/mul_grad/Reshape_1"
  input: "^gradients/LeakyRelu_14/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_14/mul_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/AddN_16"
  op: "AddN"
  input: "gradients/LeakyRelu_14/Maximum_grad/tuple/control_dependency_1"
  input: "gradients/LeakyRelu_14/mul_grad/tuple/control_dependency_1"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_14/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_14/BiasAdd_grad/BiasAddGrad"
  op: "BiasAddGrad"
  input: "gradients/AddN_16"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "gradients/conv2d_14/BiasAdd_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/AddN_16"
  input: "^gradients/conv2d_14/BiasAdd_grad/BiasAddGrad"
}
node {
  name: "gradients/conv2d_14/BiasAdd_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/AddN_16"
  input: "^gradients/conv2d_14/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_14/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_14/BiasAdd_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_14/BiasAdd_grad/BiasAddGrad"
  input: "^gradients/conv2d_14/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_14/BiasAdd_grad/BiasAddGrad"
      }
    }
  }
}
node {
  name: "gradients/conv2d_14/Conv2D_grad/ShapeN"
  op: "ShapeN"
  input: "LeakyRelu_13/Maximum"
  input: "conv2d_14/kernel/read"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/conv2d_14/Conv2D_grad/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000\010\000\000\000\010\000\000\000"
      }
    }
  }
}
node {
  name: "gradients/conv2d_14/Conv2D_grad/Conv2DBackpropInput"
  op: "Conv2DBackpropInput"
  input: "gradients/conv2d_14/Conv2D_grad/ShapeN"
  input: "conv2d_14/kernel/read"
  input: "gradients/conv2d_14/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_14/Conv2D_grad/Conv2DBackpropFilter"
  op: "Conv2DBackpropFilter"
  input: "LeakyRelu_13/Maximum"
  input: "gradients/conv2d_14/Conv2D_grad/Const"
  input: "gradients/conv2d_14/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_14/Conv2D_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/conv2d_14/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_14/Conv2D_grad/Conv2DBackpropInput"
}
node {
  name: "gradients/conv2d_14/Conv2D_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/conv2d_14/Conv2D_grad/Conv2DBackpropInput"
  input: "^gradients/conv2d_14/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_14/Conv2D_grad/Conv2DBackpropInput"
      }
    }
  }
}
node {
  name: "gradients/conv2d_14/Conv2D_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_14/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_14/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_14/Conv2D_grad/Conv2DBackpropFilter"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_13/Maximum_grad/Shape"
  op: "Shape"
  input: "LeakyRelu_13/mul"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_13/Maximum_grad/Shape_1"
  op: "Shape"
  input: "conv2d_13/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_13/Maximum_grad/Shape_2"
  op: "Shape"
  input: "gradients/conv2d_14/Conv2D_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_13/Maximum_grad/zeros/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_13/Maximum_grad/zeros"
  op: "Fill"
  input: "gradients/LeakyRelu_13/Maximum_grad/Shape_2"
  input: "gradients/LeakyRelu_13/Maximum_grad/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_13/Maximum_grad/GreaterEqual"
  op: "GreaterEqual"
  input: "LeakyRelu_13/mul"
  input: "conv2d_13/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_13/Maximum_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_13/Maximum_grad/Shape"
  input: "gradients/LeakyRelu_13/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_13/Maximum_grad/Select"
  op: "Select"
  input: "gradients/LeakyRelu_13/Maximum_grad/GreaterEqual"
  input: "gradients/conv2d_14/Conv2D_grad/tuple/control_dependency"
  input: "gradients/LeakyRelu_13/Maximum_grad/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_13/Maximum_grad/Select_1"
  op: "Select"
  input: "gradients/LeakyRelu_13/Maximum_grad/GreaterEqual"
  input: "gradients/LeakyRelu_13/Maximum_grad/zeros"
  input: "gradients/conv2d_14/Conv2D_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_13/Maximum_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_13/Maximum_grad/Select"
  input: "gradients/LeakyRelu_13/Maximum_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_13/Maximum_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_13/Maximum_grad/Sum"
  input: "gradients/LeakyRelu_13/Maximum_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_13/Maximum_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_13/Maximum_grad/Select_1"
  input: "gradients/LeakyRelu_13/Maximum_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_13/Maximum_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_13/Maximum_grad/Sum_1"
  input: "gradients/LeakyRelu_13/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_13/Maximum_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_13/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_13/Maximum_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_13/Maximum_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_13/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_13/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_13/Maximum_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_13/Maximum_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_13/Maximum_grad/Reshape_1"
  input: "^gradients/LeakyRelu_13/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_13/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_13/mul_grad/Shape"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
          }
        }
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_13/mul_grad/Shape_1"
  op: "Shape"
  input: "conv2d_13/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_13/mul_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_13/mul_grad/Shape"
  input: "gradients/LeakyRelu_13/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_13/mul_grad/Mul"
  op: "Mul"
  input: "gradients/LeakyRelu_13/Maximum_grad/tuple/control_dependency"
  input: "conv2d_13/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_13/mul_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_13/mul_grad/Mul"
  input: "gradients/LeakyRelu_13/mul_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_13/mul_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_13/mul_grad/Sum"
  input: "gradients/LeakyRelu_13/mul_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_13/mul_grad/Mul_1"
  op: "Mul"
  input: "LeakyRelu_13/alpha"
  input: "gradients/LeakyRelu_13/Maximum_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_13/mul_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_13/mul_grad/Mul_1"
  input: "gradients/LeakyRelu_13/mul_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_13/mul_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_13/mul_grad/Sum_1"
  input: "gradients/LeakyRelu_13/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_13/mul_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_13/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_13/mul_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_13/mul_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_13/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_13/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_13/mul_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_13/mul_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_13/mul_grad/Reshape_1"
  input: "^gradients/LeakyRelu_13/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_13/mul_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/AddN_17"
  op: "AddN"
  input: "gradients/LeakyRelu_13/Maximum_grad/tuple/control_dependency_1"
  input: "gradients/LeakyRelu_13/mul_grad/tuple/control_dependency_1"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_13/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_13/BiasAdd_grad/BiasAddGrad"
  op: "BiasAddGrad"
  input: "gradients/AddN_17"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "gradients/conv2d_13/BiasAdd_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/AddN_17"
  input: "^gradients/conv2d_13/BiasAdd_grad/BiasAddGrad"
}
node {
  name: "gradients/conv2d_13/BiasAdd_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/AddN_17"
  input: "^gradients/conv2d_13/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_13/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_13/BiasAdd_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_13/BiasAdd_grad/BiasAddGrad"
  input: "^gradients/conv2d_13/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_13/BiasAdd_grad/BiasAddGrad"
      }
    }
  }
}
node {
  name: "gradients/conv2d_13/Conv2D_grad/ShapeN"
  op: "ShapeN"
  input: "LeakyRelu_12/Maximum"
  input: "conv2d_13/kernel/read"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/conv2d_13/Conv2D_grad/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\003\000\000\000\003\000\000\000\010\000\000\000\010\000\000\000"
      }
    }
  }
}
node {
  name: "gradients/conv2d_13/Conv2D_grad/Conv2DBackpropInput"
  op: "Conv2DBackpropInput"
  input: "gradients/conv2d_13/Conv2D_grad/ShapeN"
  input: "conv2d_13/kernel/read"
  input: "gradients/conv2d_13/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 2
        i: 2
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_13/Conv2D_grad/Conv2DBackpropFilter"
  op: "Conv2DBackpropFilter"
  input: "LeakyRelu_12/Maximum"
  input: "gradients/conv2d_13/Conv2D_grad/Const"
  input: "gradients/conv2d_13/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 2
        i: 2
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_13/Conv2D_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/conv2d_13/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_13/Conv2D_grad/Conv2DBackpropInput"
}
node {
  name: "gradients/conv2d_13/Conv2D_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/conv2d_13/Conv2D_grad/Conv2DBackpropInput"
  input: "^gradients/conv2d_13/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_13/Conv2D_grad/Conv2DBackpropInput"
      }
    }
  }
}
node {
  name: "gradients/conv2d_13/Conv2D_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_13/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_13/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_13/Conv2D_grad/Conv2DBackpropFilter"
      }
    }
  }
}
node {
  name: "gradients/AddN_18"
  op: "AddN"
  input: "gradients/concat_grad/tuple/control_dependency_1"
  input: "gradients/conv2d_13/Conv2D_grad/tuple/control_dependency"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/concat_grad/Slice_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_12/Maximum_grad/Shape"
  op: "Shape"
  input: "LeakyRelu_12/mul"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_12/Maximum_grad/Shape_1"
  op: "Shape"
  input: "conv2d_12/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_12/Maximum_grad/Shape_2"
  op: "Shape"
  input: "gradients/AddN_18"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_12/Maximum_grad/zeros/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_12/Maximum_grad/zeros"
  op: "Fill"
  input: "gradients/LeakyRelu_12/Maximum_grad/Shape_2"
  input: "gradients/LeakyRelu_12/Maximum_grad/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_12/Maximum_grad/GreaterEqual"
  op: "GreaterEqual"
  input: "LeakyRelu_12/mul"
  input: "conv2d_12/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_12/Maximum_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_12/Maximum_grad/Shape"
  input: "gradients/LeakyRelu_12/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_12/Maximum_grad/Select"
  op: "Select"
  input: "gradients/LeakyRelu_12/Maximum_grad/GreaterEqual"
  input: "gradients/AddN_18"
  input: "gradients/LeakyRelu_12/Maximum_grad/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_12/Maximum_grad/Select_1"
  op: "Select"
  input: "gradients/LeakyRelu_12/Maximum_grad/GreaterEqual"
  input: "gradients/LeakyRelu_12/Maximum_grad/zeros"
  input: "gradients/AddN_18"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_12/Maximum_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_12/Maximum_grad/Select"
  input: "gradients/LeakyRelu_12/Maximum_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_12/Maximum_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_12/Maximum_grad/Sum"
  input: "gradients/LeakyRelu_12/Maximum_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_12/Maximum_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_12/Maximum_grad/Select_1"
  input: "gradients/LeakyRelu_12/Maximum_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_12/Maximum_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_12/Maximum_grad/Sum_1"
  input: "gradients/LeakyRelu_12/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_12/Maximum_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_12/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_12/Maximum_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_12/Maximum_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_12/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_12/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_12/Maximum_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_12/Maximum_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_12/Maximum_grad/Reshape_1"
  input: "^gradients/LeakyRelu_12/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_12/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_12/mul_grad/Shape"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
          }
        }
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_12/mul_grad/Shape_1"
  op: "Shape"
  input: "conv2d_12/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_12/mul_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_12/mul_grad/Shape"
  input: "gradients/LeakyRelu_12/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_12/mul_grad/Mul"
  op: "Mul"
  input: "gradients/LeakyRelu_12/Maximum_grad/tuple/control_dependency"
  input: "conv2d_12/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_12/mul_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_12/mul_grad/Mul"
  input: "gradients/LeakyRelu_12/mul_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_12/mul_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_12/mul_grad/Sum"
  input: "gradients/LeakyRelu_12/mul_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_12/mul_grad/Mul_1"
  op: "Mul"
  input: "LeakyRelu_12/alpha"
  input: "gradients/LeakyRelu_12/Maximum_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_12/mul_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_12/mul_grad/Mul_1"
  input: "gradients/LeakyRelu_12/mul_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_12/mul_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_12/mul_grad/Sum_1"
  input: "gradients/LeakyRelu_12/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_12/mul_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_12/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_12/mul_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_12/mul_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_12/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_12/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_12/mul_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_12/mul_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_12/mul_grad/Reshape_1"
  input: "^gradients/LeakyRelu_12/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_12/mul_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/AddN_19"
  op: "AddN"
  input: "gradients/LeakyRelu_12/Maximum_grad/tuple/control_dependency_1"
  input: "gradients/LeakyRelu_12/mul_grad/tuple/control_dependency_1"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_12/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_12/BiasAdd_grad/BiasAddGrad"
  op: "BiasAddGrad"
  input: "gradients/AddN_19"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "gradients/conv2d_12/BiasAdd_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/AddN_19"
  input: "^gradients/conv2d_12/BiasAdd_grad/BiasAddGrad"
}
node {
  name: "gradients/conv2d_12/BiasAdd_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/AddN_19"
  input: "^gradients/conv2d_12/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_12/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_12/BiasAdd_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_12/BiasAdd_grad/BiasAddGrad"
  input: "^gradients/conv2d_12/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_12/BiasAdd_grad/BiasAddGrad"
      }
    }
  }
}
node {
  name: "gradients/conv2d_12/Conv2D_grad/ShapeN"
  op: "ShapeN"
  input: "LeakyRelu_11/Maximum"
  input: "conv2d_12/kernel/read"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/conv2d_12/Conv2D_grad/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000\010\000\000\000\010\000\000\000"
      }
    }
  }
}
node {
  name: "gradients/conv2d_12/Conv2D_grad/Conv2DBackpropInput"
  op: "Conv2DBackpropInput"
  input: "gradients/conv2d_12/Conv2D_grad/ShapeN"
  input: "conv2d_12/kernel/read"
  input: "gradients/conv2d_12/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_12/Conv2D_grad/Conv2DBackpropFilter"
  op: "Conv2DBackpropFilter"
  input: "LeakyRelu_11/Maximum"
  input: "gradients/conv2d_12/Conv2D_grad/Const"
  input: "gradients/conv2d_12/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_12/Conv2D_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/conv2d_12/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_12/Conv2D_grad/Conv2DBackpropInput"
}
node {
  name: "gradients/conv2d_12/Conv2D_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/conv2d_12/Conv2D_grad/Conv2DBackpropInput"
  input: "^gradients/conv2d_12/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_12/Conv2D_grad/Conv2DBackpropInput"
      }
    }
  }
}
node {
  name: "gradients/conv2d_12/Conv2D_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_12/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_12/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_12/Conv2D_grad/Conv2DBackpropFilter"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_11/Maximum_grad/Shape"
  op: "Shape"
  input: "LeakyRelu_11/mul"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_11/Maximum_grad/Shape_1"
  op: "Shape"
  input: "conv2d_11/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_11/Maximum_grad/Shape_2"
  op: "Shape"
  input: "gradients/conv2d_12/Conv2D_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_11/Maximum_grad/zeros/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_11/Maximum_grad/zeros"
  op: "Fill"
  input: "gradients/LeakyRelu_11/Maximum_grad/Shape_2"
  input: "gradients/LeakyRelu_11/Maximum_grad/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_11/Maximum_grad/GreaterEqual"
  op: "GreaterEqual"
  input: "LeakyRelu_11/mul"
  input: "conv2d_11/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_11/Maximum_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_11/Maximum_grad/Shape"
  input: "gradients/LeakyRelu_11/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_11/Maximum_grad/Select"
  op: "Select"
  input: "gradients/LeakyRelu_11/Maximum_grad/GreaterEqual"
  input: "gradients/conv2d_12/Conv2D_grad/tuple/control_dependency"
  input: "gradients/LeakyRelu_11/Maximum_grad/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_11/Maximum_grad/Select_1"
  op: "Select"
  input: "gradients/LeakyRelu_11/Maximum_grad/GreaterEqual"
  input: "gradients/LeakyRelu_11/Maximum_grad/zeros"
  input: "gradients/conv2d_12/Conv2D_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_11/Maximum_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_11/Maximum_grad/Select"
  input: "gradients/LeakyRelu_11/Maximum_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_11/Maximum_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_11/Maximum_grad/Sum"
  input: "gradients/LeakyRelu_11/Maximum_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_11/Maximum_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_11/Maximum_grad/Select_1"
  input: "gradients/LeakyRelu_11/Maximum_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_11/Maximum_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_11/Maximum_grad/Sum_1"
  input: "gradients/LeakyRelu_11/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_11/Maximum_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_11/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_11/Maximum_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_11/Maximum_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_11/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_11/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_11/Maximum_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_11/Maximum_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_11/Maximum_grad/Reshape_1"
  input: "^gradients/LeakyRelu_11/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_11/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_11/mul_grad/Shape"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
          }
        }
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_11/mul_grad/Shape_1"
  op: "Shape"
  input: "conv2d_11/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_11/mul_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_11/mul_grad/Shape"
  input: "gradients/LeakyRelu_11/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_11/mul_grad/Mul"
  op: "Mul"
  input: "gradients/LeakyRelu_11/Maximum_grad/tuple/control_dependency"
  input: "conv2d_11/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_11/mul_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_11/mul_grad/Mul"
  input: "gradients/LeakyRelu_11/mul_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_11/mul_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_11/mul_grad/Sum"
  input: "gradients/LeakyRelu_11/mul_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_11/mul_grad/Mul_1"
  op: "Mul"
  input: "LeakyRelu_11/alpha"
  input: "gradients/LeakyRelu_11/Maximum_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_11/mul_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_11/mul_grad/Mul_1"
  input: "gradients/LeakyRelu_11/mul_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_11/mul_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_11/mul_grad/Sum_1"
  input: "gradients/LeakyRelu_11/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_11/mul_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_11/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_11/mul_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_11/mul_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_11/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_11/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_11/mul_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_11/mul_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_11/mul_grad/Reshape_1"
  input: "^gradients/LeakyRelu_11/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_11/mul_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/AddN_20"
  op: "AddN"
  input: "gradients/LeakyRelu_11/Maximum_grad/tuple/control_dependency_1"
  input: "gradients/LeakyRelu_11/mul_grad/tuple/control_dependency_1"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_11/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_11/BiasAdd_grad/BiasAddGrad"
  op: "BiasAddGrad"
  input: "gradients/AddN_20"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "gradients/conv2d_11/BiasAdd_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/AddN_20"
  input: "^gradients/conv2d_11/BiasAdd_grad/BiasAddGrad"
}
node {
  name: "gradients/conv2d_11/BiasAdd_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/AddN_20"
  input: "^gradients/conv2d_11/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_11/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_11/BiasAdd_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_11/BiasAdd_grad/BiasAddGrad"
  input: "^gradients/conv2d_11/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_11/BiasAdd_grad/BiasAddGrad"
      }
    }
  }
}
node {
  name: "gradients/conv2d_11/Conv2D_grad/ShapeN"
  op: "ShapeN"
  input: "LeakyRelu_10/Maximum"
  input: "conv2d_11/kernel/read"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/conv2d_11/Conv2D_grad/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\003\000\000\000\003\000\000\000\010\000\000\000\010\000\000\000"
      }
    }
  }
}
node {
  name: "gradients/conv2d_11/Conv2D_grad/Conv2DBackpropInput"
  op: "Conv2DBackpropInput"
  input: "gradients/conv2d_11/Conv2D_grad/ShapeN"
  input: "conv2d_11/kernel/read"
  input: "gradients/conv2d_11/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 2
        i: 2
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_11/Conv2D_grad/Conv2DBackpropFilter"
  op: "Conv2DBackpropFilter"
  input: "LeakyRelu_10/Maximum"
  input: "gradients/conv2d_11/Conv2D_grad/Const"
  input: "gradients/conv2d_11/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 2
        i: 2
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_11/Conv2D_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/conv2d_11/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_11/Conv2D_grad/Conv2DBackpropInput"
}
node {
  name: "gradients/conv2d_11/Conv2D_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/conv2d_11/Conv2D_grad/Conv2DBackpropInput"
  input: "^gradients/conv2d_11/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_11/Conv2D_grad/Conv2DBackpropInput"
      }
    }
  }
}
node {
  name: "gradients/conv2d_11/Conv2D_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_11/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_11/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_11/Conv2D_grad/Conv2DBackpropFilter"
      }
    }
  }
}
node {
  name: "gradients/AddN_21"
  op: "AddN"
  input: "gradients/concat_1_grad/tuple/control_dependency_1"
  input: "gradients/conv2d_11/Conv2D_grad/tuple/control_dependency"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/concat_1_grad/Slice_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_10/Maximum_grad/Shape"
  op: "Shape"
  input: "LeakyRelu_10/mul"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_10/Maximum_grad/Shape_1"
  op: "Shape"
  input: "conv2d_10/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_10/Maximum_grad/Shape_2"
  op: "Shape"
  input: "gradients/AddN_21"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_10/Maximum_grad/zeros/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_10/Maximum_grad/zeros"
  op: "Fill"
  input: "gradients/LeakyRelu_10/Maximum_grad/Shape_2"
  input: "gradients/LeakyRelu_10/Maximum_grad/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_10/Maximum_grad/GreaterEqual"
  op: "GreaterEqual"
  input: "LeakyRelu_10/mul"
  input: "conv2d_10/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_10/Maximum_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_10/Maximum_grad/Shape"
  input: "gradients/LeakyRelu_10/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_10/Maximum_grad/Select"
  op: "Select"
  input: "gradients/LeakyRelu_10/Maximum_grad/GreaterEqual"
  input: "gradients/AddN_21"
  input: "gradients/LeakyRelu_10/Maximum_grad/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_10/Maximum_grad/Select_1"
  op: "Select"
  input: "gradients/LeakyRelu_10/Maximum_grad/GreaterEqual"
  input: "gradients/LeakyRelu_10/Maximum_grad/zeros"
  input: "gradients/AddN_21"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_10/Maximum_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_10/Maximum_grad/Select"
  input: "gradients/LeakyRelu_10/Maximum_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_10/Maximum_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_10/Maximum_grad/Sum"
  input: "gradients/LeakyRelu_10/Maximum_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_10/Maximum_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_10/Maximum_grad/Select_1"
  input: "gradients/LeakyRelu_10/Maximum_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_10/Maximum_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_10/Maximum_grad/Sum_1"
  input: "gradients/LeakyRelu_10/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_10/Maximum_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_10/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_10/Maximum_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_10/Maximum_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_10/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_10/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_10/Maximum_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_10/Maximum_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_10/Maximum_grad/Reshape_1"
  input: "^gradients/LeakyRelu_10/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_10/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_10/mul_grad/Shape"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
          }
        }
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_10/mul_grad/Shape_1"
  op: "Shape"
  input: "conv2d_10/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_10/mul_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_10/mul_grad/Shape"
  input: "gradients/LeakyRelu_10/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_10/mul_grad/Mul"
  op: "Mul"
  input: "gradients/LeakyRelu_10/Maximum_grad/tuple/control_dependency"
  input: "conv2d_10/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_10/mul_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_10/mul_grad/Mul"
  input: "gradients/LeakyRelu_10/mul_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_10/mul_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_10/mul_grad/Sum"
  input: "gradients/LeakyRelu_10/mul_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_10/mul_grad/Mul_1"
  op: "Mul"
  input: "LeakyRelu_10/alpha"
  input: "gradients/LeakyRelu_10/Maximum_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_10/mul_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_10/mul_grad/Mul_1"
  input: "gradients/LeakyRelu_10/mul_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_10/mul_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_10/mul_grad/Sum_1"
  input: "gradients/LeakyRelu_10/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_10/mul_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_10/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_10/mul_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_10/mul_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_10/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_10/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_10/mul_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_10/mul_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_10/mul_grad/Reshape_1"
  input: "^gradients/LeakyRelu_10/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_10/mul_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/AddN_22"
  op: "AddN"
  input: "gradients/LeakyRelu_10/Maximum_grad/tuple/control_dependency_1"
  input: "gradients/LeakyRelu_10/mul_grad/tuple/control_dependency_1"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_10/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_10/BiasAdd_grad/BiasAddGrad"
  op: "BiasAddGrad"
  input: "gradients/AddN_22"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "gradients/conv2d_10/BiasAdd_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/AddN_22"
  input: "^gradients/conv2d_10/BiasAdd_grad/BiasAddGrad"
}
node {
  name: "gradients/conv2d_10/BiasAdd_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/AddN_22"
  input: "^gradients/conv2d_10/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_10/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_10/BiasAdd_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_10/BiasAdd_grad/BiasAddGrad"
  input: "^gradients/conv2d_10/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_10/BiasAdd_grad/BiasAddGrad"
      }
    }
  }
}
node {
  name: "gradients/conv2d_10/Conv2D_grad/ShapeN"
  op: "ShapeN"
  input: "LeakyRelu_9/Maximum"
  input: "conv2d_10/kernel/read"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/conv2d_10/Conv2D_grad/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000\010\000\000\000\010\000\000\000"
      }
    }
  }
}
node {
  name: "gradients/conv2d_10/Conv2D_grad/Conv2DBackpropInput"
  op: "Conv2DBackpropInput"
  input: "gradients/conv2d_10/Conv2D_grad/ShapeN"
  input: "conv2d_10/kernel/read"
  input: "gradients/conv2d_10/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_10/Conv2D_grad/Conv2DBackpropFilter"
  op: "Conv2DBackpropFilter"
  input: "LeakyRelu_9/Maximum"
  input: "gradients/conv2d_10/Conv2D_grad/Const"
  input: "gradients/conv2d_10/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_10/Conv2D_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/conv2d_10/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_10/Conv2D_grad/Conv2DBackpropInput"
}
node {
  name: "gradients/conv2d_10/Conv2D_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/conv2d_10/Conv2D_grad/Conv2DBackpropInput"
  input: "^gradients/conv2d_10/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_10/Conv2D_grad/Conv2DBackpropInput"
      }
    }
  }
}
node {
  name: "gradients/conv2d_10/Conv2D_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_10/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_10/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_10/Conv2D_grad/Conv2DBackpropFilter"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_9/Maximum_grad/Shape"
  op: "Shape"
  input: "LeakyRelu_9/mul"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_9/Maximum_grad/Shape_1"
  op: "Shape"
  input: "conv2d_9/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_9/Maximum_grad/Shape_2"
  op: "Shape"
  input: "gradients/conv2d_10/Conv2D_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_9/Maximum_grad/zeros/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_9/Maximum_grad/zeros"
  op: "Fill"
  input: "gradients/LeakyRelu_9/Maximum_grad/Shape_2"
  input: "gradients/LeakyRelu_9/Maximum_grad/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_9/Maximum_grad/GreaterEqual"
  op: "GreaterEqual"
  input: "LeakyRelu_9/mul"
  input: "conv2d_9/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_9/Maximum_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_9/Maximum_grad/Shape"
  input: "gradients/LeakyRelu_9/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_9/Maximum_grad/Select"
  op: "Select"
  input: "gradients/LeakyRelu_9/Maximum_grad/GreaterEqual"
  input: "gradients/conv2d_10/Conv2D_grad/tuple/control_dependency"
  input: "gradients/LeakyRelu_9/Maximum_grad/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_9/Maximum_grad/Select_1"
  op: "Select"
  input: "gradients/LeakyRelu_9/Maximum_grad/GreaterEqual"
  input: "gradients/LeakyRelu_9/Maximum_grad/zeros"
  input: "gradients/conv2d_10/Conv2D_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_9/Maximum_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_9/Maximum_grad/Select"
  input: "gradients/LeakyRelu_9/Maximum_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_9/Maximum_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_9/Maximum_grad/Sum"
  input: "gradients/LeakyRelu_9/Maximum_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_9/Maximum_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_9/Maximum_grad/Select_1"
  input: "gradients/LeakyRelu_9/Maximum_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_9/Maximum_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_9/Maximum_grad/Sum_1"
  input: "gradients/LeakyRelu_9/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_9/Maximum_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_9/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_9/Maximum_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_9/Maximum_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_9/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_9/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_9/Maximum_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_9/Maximum_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_9/Maximum_grad/Reshape_1"
  input: "^gradients/LeakyRelu_9/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_9/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_9/mul_grad/Shape"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
          }
        }
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_9/mul_grad/Shape_1"
  op: "Shape"
  input: "conv2d_9/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_9/mul_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_9/mul_grad/Shape"
  input: "gradients/LeakyRelu_9/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_9/mul_grad/Mul"
  op: "Mul"
  input: "gradients/LeakyRelu_9/Maximum_grad/tuple/control_dependency"
  input: "conv2d_9/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_9/mul_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_9/mul_grad/Mul"
  input: "gradients/LeakyRelu_9/mul_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_9/mul_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_9/mul_grad/Sum"
  input: "gradients/LeakyRelu_9/mul_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_9/mul_grad/Mul_1"
  op: "Mul"
  input: "LeakyRelu_9/alpha"
  input: "gradients/LeakyRelu_9/Maximum_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_9/mul_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_9/mul_grad/Mul_1"
  input: "gradients/LeakyRelu_9/mul_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_9/mul_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_9/mul_grad/Sum_1"
  input: "gradients/LeakyRelu_9/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_9/mul_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_9/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_9/mul_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_9/mul_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_9/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_9/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_9/mul_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_9/mul_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_9/mul_grad/Reshape_1"
  input: "^gradients/LeakyRelu_9/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_9/mul_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/AddN_23"
  op: "AddN"
  input: "gradients/LeakyRelu_9/Maximum_grad/tuple/control_dependency_1"
  input: "gradients/LeakyRelu_9/mul_grad/tuple/control_dependency_1"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_9/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_9/BiasAdd_grad/BiasAddGrad"
  op: "BiasAddGrad"
  input: "gradients/AddN_23"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "gradients/conv2d_9/BiasAdd_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/AddN_23"
  input: "^gradients/conv2d_9/BiasAdd_grad/BiasAddGrad"
}
node {
  name: "gradients/conv2d_9/BiasAdd_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/AddN_23"
  input: "^gradients/conv2d_9/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_9/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_9/BiasAdd_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_9/BiasAdd_grad/BiasAddGrad"
  input: "^gradients/conv2d_9/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_9/BiasAdd_grad/BiasAddGrad"
      }
    }
  }
}
node {
  name: "gradients/conv2d_9/Conv2D_grad/ShapeN"
  op: "ShapeN"
  input: "LeakyRelu_8/Maximum"
  input: "conv2d_9/kernel/read"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/conv2d_9/Conv2D_grad/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\003\000\000\000\003\000\000\000\020\000\000\000\010\000\000\000"
      }
    }
  }
}
node {
  name: "gradients/conv2d_9/Conv2D_grad/Conv2DBackpropInput"
  op: "Conv2DBackpropInput"
  input: "gradients/conv2d_9/Conv2D_grad/ShapeN"
  input: "conv2d_9/kernel/read"
  input: "gradients/conv2d_9/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 2
        i: 2
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_9/Conv2D_grad/Conv2DBackpropFilter"
  op: "Conv2DBackpropFilter"
  input: "LeakyRelu_8/Maximum"
  input: "gradients/conv2d_9/Conv2D_grad/Const"
  input: "gradients/conv2d_9/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 2
        i: 2
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_9/Conv2D_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/conv2d_9/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_9/Conv2D_grad/Conv2DBackpropInput"
}
node {
  name: "gradients/conv2d_9/Conv2D_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/conv2d_9/Conv2D_grad/Conv2DBackpropInput"
  input: "^gradients/conv2d_9/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_9/Conv2D_grad/Conv2DBackpropInput"
      }
    }
  }
}
node {
  name: "gradients/conv2d_9/Conv2D_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_9/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_9/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_9/Conv2D_grad/Conv2DBackpropFilter"
      }
    }
  }
}
node {
  name: "gradients/AddN_24"
  op: "AddN"
  input: "gradients/concat_2_grad/tuple/control_dependency_1"
  input: "gradients/conv2d_9/Conv2D_grad/tuple/control_dependency"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/concat_2_grad/Slice_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_8/Maximum_grad/Shape"
  op: "Shape"
  input: "LeakyRelu_8/mul"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_8/Maximum_grad/Shape_1"
  op: "Shape"
  input: "conv2d_8/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_8/Maximum_grad/Shape_2"
  op: "Shape"
  input: "gradients/AddN_24"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_8/Maximum_grad/zeros/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_8/Maximum_grad/zeros"
  op: "Fill"
  input: "gradients/LeakyRelu_8/Maximum_grad/Shape_2"
  input: "gradients/LeakyRelu_8/Maximum_grad/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_8/Maximum_grad/GreaterEqual"
  op: "GreaterEqual"
  input: "LeakyRelu_8/mul"
  input: "conv2d_8/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_8/Maximum_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_8/Maximum_grad/Shape"
  input: "gradients/LeakyRelu_8/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_8/Maximum_grad/Select"
  op: "Select"
  input: "gradients/LeakyRelu_8/Maximum_grad/GreaterEqual"
  input: "gradients/AddN_24"
  input: "gradients/LeakyRelu_8/Maximum_grad/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_8/Maximum_grad/Select_1"
  op: "Select"
  input: "gradients/LeakyRelu_8/Maximum_grad/GreaterEqual"
  input: "gradients/LeakyRelu_8/Maximum_grad/zeros"
  input: "gradients/AddN_24"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_8/Maximum_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_8/Maximum_grad/Select"
  input: "gradients/LeakyRelu_8/Maximum_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_8/Maximum_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_8/Maximum_grad/Sum"
  input: "gradients/LeakyRelu_8/Maximum_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_8/Maximum_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_8/Maximum_grad/Select_1"
  input: "gradients/LeakyRelu_8/Maximum_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_8/Maximum_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_8/Maximum_grad/Sum_1"
  input: "gradients/LeakyRelu_8/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_8/Maximum_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_8/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_8/Maximum_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_8/Maximum_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_8/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_8/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_8/Maximum_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_8/Maximum_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_8/Maximum_grad/Reshape_1"
  input: "^gradients/LeakyRelu_8/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_8/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_8/mul_grad/Shape"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
          }
        }
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_8/mul_grad/Shape_1"
  op: "Shape"
  input: "conv2d_8/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_8/mul_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_8/mul_grad/Shape"
  input: "gradients/LeakyRelu_8/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_8/mul_grad/Mul"
  op: "Mul"
  input: "gradients/LeakyRelu_8/Maximum_grad/tuple/control_dependency"
  input: "conv2d_8/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_8/mul_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_8/mul_grad/Mul"
  input: "gradients/LeakyRelu_8/mul_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_8/mul_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_8/mul_grad/Sum"
  input: "gradients/LeakyRelu_8/mul_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_8/mul_grad/Mul_1"
  op: "Mul"
  input: "LeakyRelu_8/alpha"
  input: "gradients/LeakyRelu_8/Maximum_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_8/mul_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_8/mul_grad/Mul_1"
  input: "gradients/LeakyRelu_8/mul_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_8/mul_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_8/mul_grad/Sum_1"
  input: "gradients/LeakyRelu_8/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_8/mul_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_8/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_8/mul_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_8/mul_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_8/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_8/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_8/mul_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_8/mul_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_8/mul_grad/Reshape_1"
  input: "^gradients/LeakyRelu_8/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_8/mul_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/AddN_25"
  op: "AddN"
  input: "gradients/LeakyRelu_8/Maximum_grad/tuple/control_dependency_1"
  input: "gradients/LeakyRelu_8/mul_grad/tuple/control_dependency_1"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_8/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_8/BiasAdd_grad/BiasAddGrad"
  op: "BiasAddGrad"
  input: "gradients/AddN_25"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "gradients/conv2d_8/BiasAdd_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/AddN_25"
  input: "^gradients/conv2d_8/BiasAdd_grad/BiasAddGrad"
}
node {
  name: "gradients/conv2d_8/BiasAdd_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/AddN_25"
  input: "^gradients/conv2d_8/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_8/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_8/BiasAdd_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_8/BiasAdd_grad/BiasAddGrad"
  input: "^gradients/conv2d_8/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_8/BiasAdd_grad/BiasAddGrad"
      }
    }
  }
}
node {
  name: "gradients/conv2d_8/Conv2D_grad/ShapeN"
  op: "ShapeN"
  input: "LeakyRelu_7/Maximum"
  input: "conv2d_8/kernel/read"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/conv2d_8/Conv2D_grad/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000\020\000\000\000\020\000\000\000"
      }
    }
  }
}
node {
  name: "gradients/conv2d_8/Conv2D_grad/Conv2DBackpropInput"
  op: "Conv2DBackpropInput"
  input: "gradients/conv2d_8/Conv2D_grad/ShapeN"
  input: "conv2d_8/kernel/read"
  input: "gradients/conv2d_8/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_8/Conv2D_grad/Conv2DBackpropFilter"
  op: "Conv2DBackpropFilter"
  input: "LeakyRelu_7/Maximum"
  input: "gradients/conv2d_8/Conv2D_grad/Const"
  input: "gradients/conv2d_8/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_8/Conv2D_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/conv2d_8/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_8/Conv2D_grad/Conv2DBackpropInput"
}
node {
  name: "gradients/conv2d_8/Conv2D_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/conv2d_8/Conv2D_grad/Conv2DBackpropInput"
  input: "^gradients/conv2d_8/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_8/Conv2D_grad/Conv2DBackpropInput"
      }
    }
  }
}
node {
  name: "gradients/conv2d_8/Conv2D_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_8/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_8/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_8/Conv2D_grad/Conv2DBackpropFilter"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_7/Maximum_grad/Shape"
  op: "Shape"
  input: "LeakyRelu_7/mul"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_7/Maximum_grad/Shape_1"
  op: "Shape"
  input: "conv2d_7/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_7/Maximum_grad/Shape_2"
  op: "Shape"
  input: "gradients/conv2d_8/Conv2D_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_7/Maximum_grad/zeros/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_7/Maximum_grad/zeros"
  op: "Fill"
  input: "gradients/LeakyRelu_7/Maximum_grad/Shape_2"
  input: "gradients/LeakyRelu_7/Maximum_grad/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_7/Maximum_grad/GreaterEqual"
  op: "GreaterEqual"
  input: "LeakyRelu_7/mul"
  input: "conv2d_7/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_7/Maximum_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_7/Maximum_grad/Shape"
  input: "gradients/LeakyRelu_7/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_7/Maximum_grad/Select"
  op: "Select"
  input: "gradients/LeakyRelu_7/Maximum_grad/GreaterEqual"
  input: "gradients/conv2d_8/Conv2D_grad/tuple/control_dependency"
  input: "gradients/LeakyRelu_7/Maximum_grad/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_7/Maximum_grad/Select_1"
  op: "Select"
  input: "gradients/LeakyRelu_7/Maximum_grad/GreaterEqual"
  input: "gradients/LeakyRelu_7/Maximum_grad/zeros"
  input: "gradients/conv2d_8/Conv2D_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_7/Maximum_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_7/Maximum_grad/Select"
  input: "gradients/LeakyRelu_7/Maximum_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_7/Maximum_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_7/Maximum_grad/Sum"
  input: "gradients/LeakyRelu_7/Maximum_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_7/Maximum_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_7/Maximum_grad/Select_1"
  input: "gradients/LeakyRelu_7/Maximum_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_7/Maximum_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_7/Maximum_grad/Sum_1"
  input: "gradients/LeakyRelu_7/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_7/Maximum_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_7/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_7/Maximum_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_7/Maximum_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_7/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_7/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_7/Maximum_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_7/Maximum_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_7/Maximum_grad/Reshape_1"
  input: "^gradients/LeakyRelu_7/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_7/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_7/mul_grad/Shape"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
          }
        }
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_7/mul_grad/Shape_1"
  op: "Shape"
  input: "conv2d_7/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_7/mul_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_7/mul_grad/Shape"
  input: "gradients/LeakyRelu_7/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_7/mul_grad/Mul"
  op: "Mul"
  input: "gradients/LeakyRelu_7/Maximum_grad/tuple/control_dependency"
  input: "conv2d_7/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_7/mul_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_7/mul_grad/Mul"
  input: "gradients/LeakyRelu_7/mul_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_7/mul_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_7/mul_grad/Sum"
  input: "gradients/LeakyRelu_7/mul_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_7/mul_grad/Mul_1"
  op: "Mul"
  input: "LeakyRelu_7/alpha"
  input: "gradients/LeakyRelu_7/Maximum_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_7/mul_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_7/mul_grad/Mul_1"
  input: "gradients/LeakyRelu_7/mul_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_7/mul_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_7/mul_grad/Sum_1"
  input: "gradients/LeakyRelu_7/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_7/mul_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_7/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_7/mul_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_7/mul_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_7/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_7/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_7/mul_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_7/mul_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_7/mul_grad/Reshape_1"
  input: "^gradients/LeakyRelu_7/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_7/mul_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/AddN_26"
  op: "AddN"
  input: "gradients/LeakyRelu_7/Maximum_grad/tuple/control_dependency_1"
  input: "gradients/LeakyRelu_7/mul_grad/tuple/control_dependency_1"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_7/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_7/BiasAdd_grad/BiasAddGrad"
  op: "BiasAddGrad"
  input: "gradients/AddN_26"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "gradients/conv2d_7/BiasAdd_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/AddN_26"
  input: "^gradients/conv2d_7/BiasAdd_grad/BiasAddGrad"
}
node {
  name: "gradients/conv2d_7/BiasAdd_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/AddN_26"
  input: "^gradients/conv2d_7/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_7/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_7/BiasAdd_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_7/BiasAdd_grad/BiasAddGrad"
  input: "^gradients/conv2d_7/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_7/BiasAdd_grad/BiasAddGrad"
      }
    }
  }
}
node {
  name: "gradients/conv2d_7/Conv2D_grad/ShapeN"
  op: "ShapeN"
  input: "LeakyRelu_6/Maximum"
  input: "conv2d_7/kernel/read"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/conv2d_7/Conv2D_grad/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\003\000\000\000\003\000\000\000\020\000\000\000\020\000\000\000"
      }
    }
  }
}
node {
  name: "gradients/conv2d_7/Conv2D_grad/Conv2DBackpropInput"
  op: "Conv2DBackpropInput"
  input: "gradients/conv2d_7/Conv2D_grad/ShapeN"
  input: "conv2d_7/kernel/read"
  input: "gradients/conv2d_7/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_7/Conv2D_grad/Conv2DBackpropFilter"
  op: "Conv2DBackpropFilter"
  input: "LeakyRelu_6/Maximum"
  input: "gradients/conv2d_7/Conv2D_grad/Const"
  input: "gradients/conv2d_7/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_7/Conv2D_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/conv2d_7/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_7/Conv2D_grad/Conv2DBackpropInput"
}
node {
  name: "gradients/conv2d_7/Conv2D_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/conv2d_7/Conv2D_grad/Conv2DBackpropInput"
  input: "^gradients/conv2d_7/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_7/Conv2D_grad/Conv2DBackpropInput"
      }
    }
  }
}
node {
  name: "gradients/conv2d_7/Conv2D_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_7/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_7/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_7/Conv2D_grad/Conv2DBackpropFilter"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_6/Maximum_grad/Shape"
  op: "Shape"
  input: "LeakyRelu_6/mul"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_6/Maximum_grad/Shape_1"
  op: "Shape"
  input: "conv2d_6/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_6/Maximum_grad/Shape_2"
  op: "Shape"
  input: "gradients/conv2d_7/Conv2D_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_6/Maximum_grad/zeros/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_6/Maximum_grad/zeros"
  op: "Fill"
  input: "gradients/LeakyRelu_6/Maximum_grad/Shape_2"
  input: "gradients/LeakyRelu_6/Maximum_grad/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_6/Maximum_grad/GreaterEqual"
  op: "GreaterEqual"
  input: "LeakyRelu_6/mul"
  input: "conv2d_6/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_6/Maximum_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_6/Maximum_grad/Shape"
  input: "gradients/LeakyRelu_6/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_6/Maximum_grad/Select"
  op: "Select"
  input: "gradients/LeakyRelu_6/Maximum_grad/GreaterEqual"
  input: "gradients/conv2d_7/Conv2D_grad/tuple/control_dependency"
  input: "gradients/LeakyRelu_6/Maximum_grad/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_6/Maximum_grad/Select_1"
  op: "Select"
  input: "gradients/LeakyRelu_6/Maximum_grad/GreaterEqual"
  input: "gradients/LeakyRelu_6/Maximum_grad/zeros"
  input: "gradients/conv2d_7/Conv2D_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_6/Maximum_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_6/Maximum_grad/Select"
  input: "gradients/LeakyRelu_6/Maximum_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_6/Maximum_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_6/Maximum_grad/Sum"
  input: "gradients/LeakyRelu_6/Maximum_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_6/Maximum_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_6/Maximum_grad/Select_1"
  input: "gradients/LeakyRelu_6/Maximum_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_6/Maximum_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_6/Maximum_grad/Sum_1"
  input: "gradients/LeakyRelu_6/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_6/Maximum_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_6/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_6/Maximum_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_6/Maximum_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_6/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_6/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_6/Maximum_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_6/Maximum_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_6/Maximum_grad/Reshape_1"
  input: "^gradients/LeakyRelu_6/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_6/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_6/mul_grad/Shape"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
          }
        }
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_6/mul_grad/Shape_1"
  op: "Shape"
  input: "conv2d_6/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_6/mul_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_6/mul_grad/Shape"
  input: "gradients/LeakyRelu_6/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_6/mul_grad/Mul"
  op: "Mul"
  input: "gradients/LeakyRelu_6/Maximum_grad/tuple/control_dependency"
  input: "conv2d_6/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_6/mul_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_6/mul_grad/Mul"
  input: "gradients/LeakyRelu_6/mul_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_6/mul_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_6/mul_grad/Sum"
  input: "gradients/LeakyRelu_6/mul_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_6/mul_grad/Mul_1"
  op: "Mul"
  input: "LeakyRelu_6/alpha"
  input: "gradients/LeakyRelu_6/Maximum_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_6/mul_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_6/mul_grad/Mul_1"
  input: "gradients/LeakyRelu_6/mul_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_6/mul_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_6/mul_grad/Sum_1"
  input: "gradients/LeakyRelu_6/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_6/mul_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_6/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_6/mul_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_6/mul_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_6/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_6/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_6/mul_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_6/mul_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_6/mul_grad/Reshape_1"
  input: "^gradients/LeakyRelu_6/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_6/mul_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/AddN_27"
  op: "AddN"
  input: "gradients/LeakyRelu_6/Maximum_grad/tuple/control_dependency_1"
  input: "gradients/LeakyRelu_6/mul_grad/tuple/control_dependency_1"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_6/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_6/BiasAdd_grad/BiasAddGrad"
  op: "BiasAddGrad"
  input: "gradients/AddN_27"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "gradients/conv2d_6/BiasAdd_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/AddN_27"
  input: "^gradients/conv2d_6/BiasAdd_grad/BiasAddGrad"
}
node {
  name: "gradients/conv2d_6/BiasAdd_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/AddN_27"
  input: "^gradients/conv2d_6/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_6/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_6/BiasAdd_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_6/BiasAdd_grad/BiasAddGrad"
  input: "^gradients/conv2d_6/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_6/BiasAdd_grad/BiasAddGrad"
      }
    }
  }
}
node {
  name: "gradients/conv2d_6/Conv2D_grad/ShapeN"
  op: "ShapeN"
  input: "LeakyRelu_5/Maximum"
  input: "conv2d_6/kernel/read"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/conv2d_6/Conv2D_grad/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\003\000\000\000\003\000\000\000\020\000\000\000\020\000\000\000"
      }
    }
  }
}
node {
  name: "gradients/conv2d_6/Conv2D_grad/Conv2DBackpropInput"
  op: "Conv2DBackpropInput"
  input: "gradients/conv2d_6/Conv2D_grad/ShapeN"
  input: "conv2d_6/kernel/read"
  input: "gradients/conv2d_6/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 2
        i: 2
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_6/Conv2D_grad/Conv2DBackpropFilter"
  op: "Conv2DBackpropFilter"
  input: "LeakyRelu_5/Maximum"
  input: "gradients/conv2d_6/Conv2D_grad/Const"
  input: "gradients/conv2d_6/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 2
        i: 2
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_6/Conv2D_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/conv2d_6/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_6/Conv2D_grad/Conv2DBackpropInput"
}
node {
  name: "gradients/conv2d_6/Conv2D_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/conv2d_6/Conv2D_grad/Conv2DBackpropInput"
  input: "^gradients/conv2d_6/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_6/Conv2D_grad/Conv2DBackpropInput"
      }
    }
  }
}
node {
  name: "gradients/conv2d_6/Conv2D_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_6/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_6/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_6/Conv2D_grad/Conv2DBackpropFilter"
      }
    }
  }
}
node {
  name: "gradients/AddN_28"
  op: "AddN"
  input: "gradients/concat_3_grad/tuple/control_dependency_1"
  input: "gradients/conv2d_6/Conv2D_grad/tuple/control_dependency"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/concat_3_grad/Slice_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_5/Maximum_grad/Shape"
  op: "Shape"
  input: "LeakyRelu_5/mul"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_5/Maximum_grad/Shape_1"
  op: "Shape"
  input: "conv2d_5/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_5/Maximum_grad/Shape_2"
  op: "Shape"
  input: "gradients/AddN_28"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_5/Maximum_grad/zeros/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_5/Maximum_grad/zeros"
  op: "Fill"
  input: "gradients/LeakyRelu_5/Maximum_grad/Shape_2"
  input: "gradients/LeakyRelu_5/Maximum_grad/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_5/Maximum_grad/GreaterEqual"
  op: "GreaterEqual"
  input: "LeakyRelu_5/mul"
  input: "conv2d_5/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_5/Maximum_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_5/Maximum_grad/Shape"
  input: "gradients/LeakyRelu_5/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_5/Maximum_grad/Select"
  op: "Select"
  input: "gradients/LeakyRelu_5/Maximum_grad/GreaterEqual"
  input: "gradients/AddN_28"
  input: "gradients/LeakyRelu_5/Maximum_grad/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_5/Maximum_grad/Select_1"
  op: "Select"
  input: "gradients/LeakyRelu_5/Maximum_grad/GreaterEqual"
  input: "gradients/LeakyRelu_5/Maximum_grad/zeros"
  input: "gradients/AddN_28"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_5/Maximum_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_5/Maximum_grad/Select"
  input: "gradients/LeakyRelu_5/Maximum_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_5/Maximum_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_5/Maximum_grad/Sum"
  input: "gradients/LeakyRelu_5/Maximum_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_5/Maximum_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_5/Maximum_grad/Select_1"
  input: "gradients/LeakyRelu_5/Maximum_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_5/Maximum_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_5/Maximum_grad/Sum_1"
  input: "gradients/LeakyRelu_5/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_5/Maximum_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_5/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_5/Maximum_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_5/Maximum_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_5/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_5/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_5/Maximum_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_5/Maximum_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_5/Maximum_grad/Reshape_1"
  input: "^gradients/LeakyRelu_5/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_5/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_5/mul_grad/Shape"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
          }
        }
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_5/mul_grad/Shape_1"
  op: "Shape"
  input: "conv2d_5/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_5/mul_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_5/mul_grad/Shape"
  input: "gradients/LeakyRelu_5/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_5/mul_grad/Mul"
  op: "Mul"
  input: "gradients/LeakyRelu_5/Maximum_grad/tuple/control_dependency"
  input: "conv2d_5/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_5/mul_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_5/mul_grad/Mul"
  input: "gradients/LeakyRelu_5/mul_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_5/mul_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_5/mul_grad/Sum"
  input: "gradients/LeakyRelu_5/mul_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_5/mul_grad/Mul_1"
  op: "Mul"
  input: "LeakyRelu_5/alpha"
  input: "gradients/LeakyRelu_5/Maximum_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_5/mul_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_5/mul_grad/Mul_1"
  input: "gradients/LeakyRelu_5/mul_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_5/mul_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_5/mul_grad/Sum_1"
  input: "gradients/LeakyRelu_5/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_5/mul_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_5/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_5/mul_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_5/mul_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_5/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_5/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_5/mul_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_5/mul_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_5/mul_grad/Reshape_1"
  input: "^gradients/LeakyRelu_5/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_5/mul_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/AddN_29"
  op: "AddN"
  input: "gradients/LeakyRelu_5/Maximum_grad/tuple/control_dependency_1"
  input: "gradients/LeakyRelu_5/mul_grad/tuple/control_dependency_1"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_5/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_5/BiasAdd_grad/BiasAddGrad"
  op: "BiasAddGrad"
  input: "gradients/AddN_29"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "gradients/conv2d_5/BiasAdd_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/AddN_29"
  input: "^gradients/conv2d_5/BiasAdd_grad/BiasAddGrad"
}
node {
  name: "gradients/conv2d_5/BiasAdd_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/AddN_29"
  input: "^gradients/conv2d_5/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_5/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_5/BiasAdd_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_5/BiasAdd_grad/BiasAddGrad"
  input: "^gradients/conv2d_5/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_5/BiasAdd_grad/BiasAddGrad"
      }
    }
  }
}
node {
  name: "gradients/conv2d_5/Conv2D_grad/ShapeN"
  op: "ShapeN"
  input: "LeakyRelu_4/Maximum"
  input: "conv2d_5/kernel/read"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/conv2d_5/Conv2D_grad/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\001\000\000\000\001\000\000\000\030\000\000\000\020\000\000\000"
      }
    }
  }
}
node {
  name: "gradients/conv2d_5/Conv2D_grad/Conv2DBackpropInput"
  op: "Conv2DBackpropInput"
  input: "gradients/conv2d_5/Conv2D_grad/ShapeN"
  input: "conv2d_5/kernel/read"
  input: "gradients/conv2d_5/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_5/Conv2D_grad/Conv2DBackpropFilter"
  op: "Conv2DBackpropFilter"
  input: "LeakyRelu_4/Maximum"
  input: "gradients/conv2d_5/Conv2D_grad/Const"
  input: "gradients/conv2d_5/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_5/Conv2D_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/conv2d_5/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_5/Conv2D_grad/Conv2DBackpropInput"
}
node {
  name: "gradients/conv2d_5/Conv2D_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/conv2d_5/Conv2D_grad/Conv2DBackpropInput"
  input: "^gradients/conv2d_5/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_5/Conv2D_grad/Conv2DBackpropInput"
      }
    }
  }
}
node {
  name: "gradients/conv2d_5/Conv2D_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_5/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_5/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_5/Conv2D_grad/Conv2DBackpropFilter"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_4/Maximum_grad/Shape"
  op: "Shape"
  input: "LeakyRelu_4/mul"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_4/Maximum_grad/Shape_1"
  op: "Shape"
  input: "conv2d_4/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_4/Maximum_grad/Shape_2"
  op: "Shape"
  input: "gradients/conv2d_5/Conv2D_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_4/Maximum_grad/zeros/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_4/Maximum_grad/zeros"
  op: "Fill"
  input: "gradients/LeakyRelu_4/Maximum_grad/Shape_2"
  input: "gradients/LeakyRelu_4/Maximum_grad/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_4/Maximum_grad/GreaterEqual"
  op: "GreaterEqual"
  input: "LeakyRelu_4/mul"
  input: "conv2d_4/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_4/Maximum_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_4/Maximum_grad/Shape"
  input: "gradients/LeakyRelu_4/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_4/Maximum_grad/Select"
  op: "Select"
  input: "gradients/LeakyRelu_4/Maximum_grad/GreaterEqual"
  input: "gradients/conv2d_5/Conv2D_grad/tuple/control_dependency"
  input: "gradients/LeakyRelu_4/Maximum_grad/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_4/Maximum_grad/Select_1"
  op: "Select"
  input: "gradients/LeakyRelu_4/Maximum_grad/GreaterEqual"
  input: "gradients/LeakyRelu_4/Maximum_grad/zeros"
  input: "gradients/conv2d_5/Conv2D_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_4/Maximum_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_4/Maximum_grad/Select"
  input: "gradients/LeakyRelu_4/Maximum_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_4/Maximum_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_4/Maximum_grad/Sum"
  input: "gradients/LeakyRelu_4/Maximum_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_4/Maximum_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_4/Maximum_grad/Select_1"
  input: "gradients/LeakyRelu_4/Maximum_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_4/Maximum_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_4/Maximum_grad/Sum_1"
  input: "gradients/LeakyRelu_4/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_4/Maximum_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_4/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_4/Maximum_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_4/Maximum_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_4/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_4/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_4/Maximum_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_4/Maximum_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_4/Maximum_grad/Reshape_1"
  input: "^gradients/LeakyRelu_4/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_4/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_4/mul_grad/Shape"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
          }
        }
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_4/mul_grad/Shape_1"
  op: "Shape"
  input: "conv2d_4/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_4/mul_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_4/mul_grad/Shape"
  input: "gradients/LeakyRelu_4/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_4/mul_grad/Mul"
  op: "Mul"
  input: "gradients/LeakyRelu_4/Maximum_grad/tuple/control_dependency"
  input: "conv2d_4/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_4/mul_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_4/mul_grad/Mul"
  input: "gradients/LeakyRelu_4/mul_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_4/mul_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_4/mul_grad/Sum"
  input: "gradients/LeakyRelu_4/mul_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_4/mul_grad/Mul_1"
  op: "Mul"
  input: "LeakyRelu_4/alpha"
  input: "gradients/LeakyRelu_4/Maximum_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_4/mul_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_4/mul_grad/Mul_1"
  input: "gradients/LeakyRelu_4/mul_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_4/mul_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_4/mul_grad/Sum_1"
  input: "gradients/LeakyRelu_4/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_4/mul_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_4/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_4/mul_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_4/mul_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_4/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_4/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_4/mul_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_4/mul_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_4/mul_grad/Reshape_1"
  input: "^gradients/LeakyRelu_4/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_4/mul_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/AddN_30"
  op: "AddN"
  input: "gradients/LeakyRelu_4/Maximum_grad/tuple/control_dependency_1"
  input: "gradients/LeakyRelu_4/mul_grad/tuple/control_dependency_1"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_4/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_4/BiasAdd_grad/BiasAddGrad"
  op: "BiasAddGrad"
  input: "gradients/AddN_30"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "gradients/conv2d_4/BiasAdd_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/AddN_30"
  input: "^gradients/conv2d_4/BiasAdd_grad/BiasAddGrad"
}
node {
  name: "gradients/conv2d_4/BiasAdd_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/AddN_30"
  input: "^gradients/conv2d_4/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_4/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_4/BiasAdd_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_4/BiasAdd_grad/BiasAddGrad"
  input: "^gradients/conv2d_4/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_4/BiasAdd_grad/BiasAddGrad"
      }
    }
  }
}
node {
  name: "gradients/conv2d_4/Conv2D_grad/ShapeN"
  op: "ShapeN"
  input: "LeakyRelu_3/Maximum"
  input: "conv2d_4/kernel/read"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/conv2d_4/Conv2D_grad/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\004\000\000\000\004\000\000\000\030\000\000\000\030\000\000\000"
      }
    }
  }
}
node {
  name: "gradients/conv2d_4/Conv2D_grad/Conv2DBackpropInput"
  op: "Conv2DBackpropInput"
  input: "gradients/conv2d_4/Conv2D_grad/ShapeN"
  input: "conv2d_4/kernel/read"
  input: "gradients/conv2d_4/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_4/Conv2D_grad/Conv2DBackpropFilter"
  op: "Conv2DBackpropFilter"
  input: "LeakyRelu_3/Maximum"
  input: "gradients/conv2d_4/Conv2D_grad/Const"
  input: "gradients/conv2d_4/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_4/Conv2D_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/conv2d_4/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_4/Conv2D_grad/Conv2DBackpropInput"
}
node {
  name: "gradients/conv2d_4/Conv2D_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/conv2d_4/Conv2D_grad/Conv2DBackpropInput"
  input: "^gradients/conv2d_4/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_4/Conv2D_grad/Conv2DBackpropInput"
      }
    }
  }
}
node {
  name: "gradients/conv2d_4/Conv2D_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_4/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_4/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_4/Conv2D_grad/Conv2DBackpropFilter"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_3/Maximum_grad/Shape"
  op: "Shape"
  input: "LeakyRelu_3/mul"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_3/Maximum_grad/Shape_1"
  op: "Shape"
  input: "conv2d_3/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_3/Maximum_grad/Shape_2"
  op: "Shape"
  input: "gradients/conv2d_4/Conv2D_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_3/Maximum_grad/zeros/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_3/Maximum_grad/zeros"
  op: "Fill"
  input: "gradients/LeakyRelu_3/Maximum_grad/Shape_2"
  input: "gradients/LeakyRelu_3/Maximum_grad/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_3/Maximum_grad/GreaterEqual"
  op: "GreaterEqual"
  input: "LeakyRelu_3/mul"
  input: "conv2d_3/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_3/Maximum_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_3/Maximum_grad/Shape"
  input: "gradients/LeakyRelu_3/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_3/Maximum_grad/Select"
  op: "Select"
  input: "gradients/LeakyRelu_3/Maximum_grad/GreaterEqual"
  input: "gradients/conv2d_4/Conv2D_grad/tuple/control_dependency"
  input: "gradients/LeakyRelu_3/Maximum_grad/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_3/Maximum_grad/Select_1"
  op: "Select"
  input: "gradients/LeakyRelu_3/Maximum_grad/GreaterEqual"
  input: "gradients/LeakyRelu_3/Maximum_grad/zeros"
  input: "gradients/conv2d_4/Conv2D_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_3/Maximum_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_3/Maximum_grad/Select"
  input: "gradients/LeakyRelu_3/Maximum_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_3/Maximum_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_3/Maximum_grad/Sum"
  input: "gradients/LeakyRelu_3/Maximum_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_3/Maximum_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_3/Maximum_grad/Select_1"
  input: "gradients/LeakyRelu_3/Maximum_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_3/Maximum_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_3/Maximum_grad/Sum_1"
  input: "gradients/LeakyRelu_3/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_3/Maximum_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_3/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_3/Maximum_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_3/Maximum_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_3/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_3/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_3/Maximum_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_3/Maximum_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_3/Maximum_grad/Reshape_1"
  input: "^gradients/LeakyRelu_3/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_3/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_3/mul_grad/Shape"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
          }
        }
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_3/mul_grad/Shape_1"
  op: "Shape"
  input: "conv2d_3/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_3/mul_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_3/mul_grad/Shape"
  input: "gradients/LeakyRelu_3/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_3/mul_grad/Mul"
  op: "Mul"
  input: "gradients/LeakyRelu_3/Maximum_grad/tuple/control_dependency"
  input: "conv2d_3/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_3/mul_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_3/mul_grad/Mul"
  input: "gradients/LeakyRelu_3/mul_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_3/mul_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_3/mul_grad/Sum"
  input: "gradients/LeakyRelu_3/mul_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_3/mul_grad/Mul_1"
  op: "Mul"
  input: "LeakyRelu_3/alpha"
  input: "gradients/LeakyRelu_3/Maximum_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_3/mul_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_3/mul_grad/Mul_1"
  input: "gradients/LeakyRelu_3/mul_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_3/mul_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_3/mul_grad/Sum_1"
  input: "gradients/LeakyRelu_3/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_3/mul_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_3/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_3/mul_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_3/mul_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_3/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_3/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_3/mul_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_3/mul_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_3/mul_grad/Reshape_1"
  input: "^gradients/LeakyRelu_3/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_3/mul_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/AddN_31"
  op: "AddN"
  input: "gradients/LeakyRelu_3/Maximum_grad/tuple/control_dependency_1"
  input: "gradients/LeakyRelu_3/mul_grad/tuple/control_dependency_1"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_3/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_3/BiasAdd_grad/BiasAddGrad"
  op: "BiasAddGrad"
  input: "gradients/AddN_31"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "gradients/conv2d_3/BiasAdd_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/AddN_31"
  input: "^gradients/conv2d_3/BiasAdd_grad/BiasAddGrad"
}
node {
  name: "gradients/conv2d_3/BiasAdd_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/AddN_31"
  input: "^gradients/conv2d_3/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_3/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_3/BiasAdd_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_3/BiasAdd_grad/BiasAddGrad"
  input: "^gradients/conv2d_3/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_3/BiasAdd_grad/BiasAddGrad"
      }
    }
  }
}
node {
  name: "gradients/conv2d_3/Conv2D_grad/ShapeN"
  op: "ShapeN"
  input: "LeakyRelu_2/Maximum"
  input: "conv2d_3/kernel/read"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/conv2d_3/Conv2D_grad/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\004\000\000\000\004\000\000\000\020\000\000\000\030\000\000\000"
      }
    }
  }
}
node {
  name: "gradients/conv2d_3/Conv2D_grad/Conv2DBackpropInput"
  op: "Conv2DBackpropInput"
  input: "gradients/conv2d_3/Conv2D_grad/ShapeN"
  input: "conv2d_3/kernel/read"
  input: "gradients/conv2d_3/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 2
        i: 2
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_3/Conv2D_grad/Conv2DBackpropFilter"
  op: "Conv2DBackpropFilter"
  input: "LeakyRelu_2/Maximum"
  input: "gradients/conv2d_3/Conv2D_grad/Const"
  input: "gradients/conv2d_3/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 2
        i: 2
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_3/Conv2D_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/conv2d_3/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_3/Conv2D_grad/Conv2DBackpropInput"
}
node {
  name: "gradients/conv2d_3/Conv2D_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/conv2d_3/Conv2D_grad/Conv2DBackpropInput"
  input: "^gradients/conv2d_3/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_3/Conv2D_grad/Conv2DBackpropInput"
      }
    }
  }
}
node {
  name: "gradients/conv2d_3/Conv2D_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_3/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_3/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_3/Conv2D_grad/Conv2DBackpropFilter"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_2/Maximum_grad/Shape"
  op: "Shape"
  input: "LeakyRelu_2/mul"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_2/Maximum_grad/Shape_1"
  op: "Shape"
  input: "conv2d_2/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_2/Maximum_grad/Shape_2"
  op: "Shape"
  input: "gradients/conv2d_3/Conv2D_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_2/Maximum_grad/zeros/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_2/Maximum_grad/zeros"
  op: "Fill"
  input: "gradients/LeakyRelu_2/Maximum_grad/Shape_2"
  input: "gradients/LeakyRelu_2/Maximum_grad/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_2/Maximum_grad/GreaterEqual"
  op: "GreaterEqual"
  input: "LeakyRelu_2/mul"
  input: "conv2d_2/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_2/Maximum_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_2/Maximum_grad/Shape"
  input: "gradients/LeakyRelu_2/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_2/Maximum_grad/Select"
  op: "Select"
  input: "gradients/LeakyRelu_2/Maximum_grad/GreaterEqual"
  input: "gradients/conv2d_3/Conv2D_grad/tuple/control_dependency"
  input: "gradients/LeakyRelu_2/Maximum_grad/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_2/Maximum_grad/Select_1"
  op: "Select"
  input: "gradients/LeakyRelu_2/Maximum_grad/GreaterEqual"
  input: "gradients/LeakyRelu_2/Maximum_grad/zeros"
  input: "gradients/conv2d_3/Conv2D_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_2/Maximum_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_2/Maximum_grad/Select"
  input: "gradients/LeakyRelu_2/Maximum_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_2/Maximum_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_2/Maximum_grad/Sum"
  input: "gradients/LeakyRelu_2/Maximum_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_2/Maximum_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_2/Maximum_grad/Select_1"
  input: "gradients/LeakyRelu_2/Maximum_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_2/Maximum_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_2/Maximum_grad/Sum_1"
  input: "gradients/LeakyRelu_2/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_2/Maximum_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_2/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_2/Maximum_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_2/Maximum_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_2/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_2/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_2/Maximum_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_2/Maximum_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_2/Maximum_grad/Reshape_1"
  input: "^gradients/LeakyRelu_2/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_2/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_2/mul_grad/Shape"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
          }
        }
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_2/mul_grad/Shape_1"
  op: "Shape"
  input: "conv2d_2/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_2/mul_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_2/mul_grad/Shape"
  input: "gradients/LeakyRelu_2/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_2/mul_grad/Mul"
  op: "Mul"
  input: "gradients/LeakyRelu_2/Maximum_grad/tuple/control_dependency"
  input: "conv2d_2/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_2/mul_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_2/mul_grad/Mul"
  input: "gradients/LeakyRelu_2/mul_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_2/mul_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_2/mul_grad/Sum"
  input: "gradients/LeakyRelu_2/mul_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_2/mul_grad/Mul_1"
  op: "Mul"
  input: "LeakyRelu_2/alpha"
  input: "gradients/LeakyRelu_2/Maximum_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_2/mul_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_2/mul_grad/Mul_1"
  input: "gradients/LeakyRelu_2/mul_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_2/mul_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_2/mul_grad/Sum_1"
  input: "gradients/LeakyRelu_2/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_2/mul_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_2/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_2/mul_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_2/mul_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_2/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_2/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_2/mul_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_2/mul_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_2/mul_grad/Reshape_1"
  input: "^gradients/LeakyRelu_2/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_2/mul_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/AddN_32"
  op: "AddN"
  input: "gradients/LeakyRelu_2/Maximum_grad/tuple/control_dependency_1"
  input: "gradients/LeakyRelu_2/mul_grad/tuple/control_dependency_1"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_2/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_2/BiasAdd_grad/BiasAddGrad"
  op: "BiasAddGrad"
  input: "gradients/AddN_32"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "gradients/conv2d_2/BiasAdd_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/AddN_32"
  input: "^gradients/conv2d_2/BiasAdd_grad/BiasAddGrad"
}
node {
  name: "gradients/conv2d_2/BiasAdd_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/AddN_32"
  input: "^gradients/conv2d_2/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_2/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_2/BiasAdd_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_2/BiasAdd_grad/BiasAddGrad"
  input: "^gradients/conv2d_2/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_2/BiasAdd_grad/BiasAddGrad"
      }
    }
  }
}
node {
  name: "gradients/conv2d_2/Conv2D_grad/ShapeN"
  op: "ShapeN"
  input: "LeakyRelu_1/Maximum"
  input: "conv2d_2/kernel/read"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/conv2d_2/Conv2D_grad/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\005\000\000\000\005\000\000\000\030\000\000\000\020\000\000\000"
      }
    }
  }
}
node {
  name: "gradients/conv2d_2/Conv2D_grad/Conv2DBackpropInput"
  op: "Conv2DBackpropInput"
  input: "gradients/conv2d_2/Conv2D_grad/ShapeN"
  input: "conv2d_2/kernel/read"
  input: "gradients/conv2d_2/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_2/Conv2D_grad/Conv2DBackpropFilter"
  op: "Conv2DBackpropFilter"
  input: "LeakyRelu_1/Maximum"
  input: "gradients/conv2d_2/Conv2D_grad/Const"
  input: "gradients/conv2d_2/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_2/Conv2D_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/conv2d_2/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_2/Conv2D_grad/Conv2DBackpropInput"
}
node {
  name: "gradients/conv2d_2/Conv2D_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/conv2d_2/Conv2D_grad/Conv2DBackpropInput"
  input: "^gradients/conv2d_2/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_2/Conv2D_grad/Conv2DBackpropInput"
      }
    }
  }
}
node {
  name: "gradients/conv2d_2/Conv2D_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_2/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_2/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_2/Conv2D_grad/Conv2DBackpropFilter"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_1/Maximum_grad/Shape"
  op: "Shape"
  input: "LeakyRelu_1/mul"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_1/Maximum_grad/Shape_1"
  op: "Shape"
  input: "conv2d_1/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_1/Maximum_grad/Shape_2"
  op: "Shape"
  input: "gradients/conv2d_2/Conv2D_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_1/Maximum_grad/zeros/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_1/Maximum_grad/zeros"
  op: "Fill"
  input: "gradients/LeakyRelu_1/Maximum_grad/Shape_2"
  input: "gradients/LeakyRelu_1/Maximum_grad/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_1/Maximum_grad/GreaterEqual"
  op: "GreaterEqual"
  input: "LeakyRelu_1/mul"
  input: "conv2d_1/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_1/Maximum_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_1/Maximum_grad/Shape"
  input: "gradients/LeakyRelu_1/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_1/Maximum_grad/Select"
  op: "Select"
  input: "gradients/LeakyRelu_1/Maximum_grad/GreaterEqual"
  input: "gradients/conv2d_2/Conv2D_grad/tuple/control_dependency"
  input: "gradients/LeakyRelu_1/Maximum_grad/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_1/Maximum_grad/Select_1"
  op: "Select"
  input: "gradients/LeakyRelu_1/Maximum_grad/GreaterEqual"
  input: "gradients/LeakyRelu_1/Maximum_grad/zeros"
  input: "gradients/conv2d_2/Conv2D_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_1/Maximum_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_1/Maximum_grad/Select"
  input: "gradients/LeakyRelu_1/Maximum_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_1/Maximum_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_1/Maximum_grad/Sum"
  input: "gradients/LeakyRelu_1/Maximum_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_1/Maximum_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_1/Maximum_grad/Select_1"
  input: "gradients/LeakyRelu_1/Maximum_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_1/Maximum_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_1/Maximum_grad/Sum_1"
  input: "gradients/LeakyRelu_1/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_1/Maximum_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_1/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_1/Maximum_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_1/Maximum_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_1/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu_1/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_1/Maximum_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_1/Maximum_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_1/Maximum_grad/Reshape_1"
  input: "^gradients/LeakyRelu_1/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_1/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_1/mul_grad/Shape"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
          }
        }
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_1/mul_grad/Shape_1"
  op: "Shape"
  input: "conv2d_1/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_1/mul_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu_1/mul_grad/Shape"
  input: "gradients/LeakyRelu_1/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_1/mul_grad/Mul"
  op: "Mul"
  input: "gradients/LeakyRelu_1/Maximum_grad/tuple/control_dependency"
  input: "conv2d_1/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_1/mul_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu_1/mul_grad/Mul"
  input: "gradients/LeakyRelu_1/mul_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_1/mul_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu_1/mul_grad/Sum"
  input: "gradients/LeakyRelu_1/mul_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_1/mul_grad/Mul_1"
  op: "Mul"
  input: "LeakyRelu_1/alpha"
  input: "gradients/LeakyRelu_1/Maximum_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu_1/mul_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu_1/mul_grad/Mul_1"
  input: "gradients/LeakyRelu_1/mul_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu_1/mul_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu_1/mul_grad/Sum_1"
  input: "gradients/LeakyRelu_1/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu_1/mul_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu_1/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_1/mul_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu_1/mul_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu_1/mul_grad/Reshape"
  input: "^gradients/LeakyRelu_1/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_1/mul_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu_1/mul_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu_1/mul_grad/Reshape_1"
  input: "^gradients/LeakyRelu_1/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_1/mul_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/AddN_33"
  op: "AddN"
  input: "gradients/LeakyRelu_1/Maximum_grad/tuple/control_dependency_1"
  input: "gradients/LeakyRelu_1/mul_grad/tuple/control_dependency_1"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_1/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_1/BiasAdd_grad/BiasAddGrad"
  op: "BiasAddGrad"
  input: "gradients/AddN_33"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "gradients/conv2d_1/BiasAdd_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/AddN_33"
  input: "^gradients/conv2d_1/BiasAdd_grad/BiasAddGrad"
}
node {
  name: "gradients/conv2d_1/BiasAdd_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/AddN_33"
  input: "^gradients/conv2d_1/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu_1/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d_1/BiasAdd_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_1/BiasAdd_grad/BiasAddGrad"
  input: "^gradients/conv2d_1/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_1/BiasAdd_grad/BiasAddGrad"
      }
    }
  }
}
node {
  name: "gradients/conv2d_1/Conv2D_grad/ShapeN"
  op: "ShapeN"
  input: "LeakyRelu/Maximum"
  input: "conv2d_1/kernel/read"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/conv2d_1/Conv2D_grad/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\006\000\000\000\006\000\000\000 \000\000\000\030\000\000\000"
      }
    }
  }
}
node {
  name: "gradients/conv2d_1/Conv2D_grad/Conv2DBackpropInput"
  op: "Conv2DBackpropInput"
  input: "gradients/conv2d_1/Conv2D_grad/ShapeN"
  input: "conv2d_1/kernel/read"
  input: "gradients/conv2d_1/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_1/Conv2D_grad/Conv2DBackpropFilter"
  op: "Conv2DBackpropFilter"
  input: "LeakyRelu/Maximum"
  input: "gradients/conv2d_1/Conv2D_grad/Const"
  input: "gradients/conv2d_1/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d_1/Conv2D_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/conv2d_1/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_1/Conv2D_grad/Conv2DBackpropInput"
}
node {
  name: "gradients/conv2d_1/Conv2D_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/conv2d_1/Conv2D_grad/Conv2DBackpropInput"
  input: "^gradients/conv2d_1/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_1/Conv2D_grad/Conv2DBackpropInput"
      }
    }
  }
}
node {
  name: "gradients/conv2d_1/Conv2D_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d_1/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d_1/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d_1/Conv2D_grad/Conv2DBackpropFilter"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu/Maximum_grad/Shape"
  op: "Shape"
  input: "LeakyRelu/mul"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu/Maximum_grad/Shape_1"
  op: "Shape"
  input: "conv2d/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu/Maximum_grad/Shape_2"
  op: "Shape"
  input: "gradients/conv2d_1/Conv2D_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu/Maximum_grad/zeros/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu/Maximum_grad/zeros"
  op: "Fill"
  input: "gradients/LeakyRelu/Maximum_grad/Shape_2"
  input: "gradients/LeakyRelu/Maximum_grad/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu/Maximum_grad/GreaterEqual"
  op: "GreaterEqual"
  input: "LeakyRelu/mul"
  input: "conv2d/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu/Maximum_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu/Maximum_grad/Shape"
  input: "gradients/LeakyRelu/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu/Maximum_grad/Select"
  op: "Select"
  input: "gradients/LeakyRelu/Maximum_grad/GreaterEqual"
  input: "gradients/conv2d_1/Conv2D_grad/tuple/control_dependency"
  input: "gradients/LeakyRelu/Maximum_grad/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu/Maximum_grad/Select_1"
  op: "Select"
  input: "gradients/LeakyRelu/Maximum_grad/GreaterEqual"
  input: "gradients/LeakyRelu/Maximum_grad/zeros"
  input: "gradients/conv2d_1/Conv2D_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu/Maximum_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu/Maximum_grad/Select"
  input: "gradients/LeakyRelu/Maximum_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu/Maximum_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu/Maximum_grad/Sum"
  input: "gradients/LeakyRelu/Maximum_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu/Maximum_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu/Maximum_grad/Select_1"
  input: "gradients/LeakyRelu/Maximum_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu/Maximum_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu/Maximum_grad/Sum_1"
  input: "gradients/LeakyRelu/Maximum_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu/Maximum_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu/Maximum_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu/Maximum_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu/Maximum_grad/Reshape"
  input: "^gradients/LeakyRelu/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu/Maximum_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu/Maximum_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu/Maximum_grad/Reshape_1"
  input: "^gradients/LeakyRelu/Maximum_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu/mul_grad/Shape"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
          }
        }
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu/mul_grad/Shape_1"
  op: "Shape"
  input: "conv2d/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu/mul_grad/BroadcastGradientArgs"
  op: "BroadcastGradientArgs"
  input: "gradients/LeakyRelu/mul_grad/Shape"
  input: "gradients/LeakyRelu/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu/mul_grad/Mul"
  op: "Mul"
  input: "gradients/LeakyRelu/Maximum_grad/tuple/control_dependency"
  input: "conv2d/BiasAdd"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu/mul_grad/Sum"
  op: "Sum"
  input: "gradients/LeakyRelu/mul_grad/Mul"
  input: "gradients/LeakyRelu/mul_grad/BroadcastGradientArgs"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu/mul_grad/Reshape"
  op: "Reshape"
  input: "gradients/LeakyRelu/mul_grad/Sum"
  input: "gradients/LeakyRelu/mul_grad/Shape"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu/mul_grad/Mul_1"
  op: "Mul"
  input: "LeakyRelu/alpha"
  input: "gradients/LeakyRelu/Maximum_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
}
node {
  name: "gradients/LeakyRelu/mul_grad/Sum_1"
  op: "Sum"
  input: "gradients/LeakyRelu/mul_grad/Mul_1"
  input: "gradients/LeakyRelu/mul_grad/BroadcastGradientArgs:1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tidx"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "keep_dims"
    value {
      b: false
    }
  }
}
node {
  name: "gradients/LeakyRelu/mul_grad/Reshape_1"
  op: "Reshape"
  input: "gradients/LeakyRelu/mul_grad/Sum_1"
  input: "gradients/LeakyRelu/mul_grad/Shape_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "Tshape"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/LeakyRelu/mul_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/LeakyRelu/mul_grad/Reshape"
  input: "^gradients/LeakyRelu/mul_grad/Reshape_1"
}
node {
  name: "gradients/LeakyRelu/mul_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/LeakyRelu/mul_grad/Reshape"
  input: "^gradients/LeakyRelu/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu/mul_grad/Reshape"
      }
    }
  }
}
node {
  name: "gradients/LeakyRelu/mul_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/LeakyRelu/mul_grad/Reshape_1"
  input: "^gradients/LeakyRelu/mul_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu/mul_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/AddN_34"
  op: "AddN"
  input: "gradients/LeakyRelu/Maximum_grad/tuple/control_dependency_1"
  input: "gradients/LeakyRelu/mul_grad/tuple/control_dependency_1"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d/BiasAdd_grad/BiasAddGrad"
  op: "BiasAddGrad"
  input: "gradients/AddN_34"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
}
node {
  name: "gradients/conv2d/BiasAdd_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/AddN_34"
  input: "^gradients/conv2d/BiasAdd_grad/BiasAddGrad"
}
node {
  name: "gradients/conv2d/BiasAdd_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/AddN_34"
  input: "^gradients/conv2d/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/LeakyRelu/Maximum_grad/Reshape_1"
      }
    }
  }
}
node {
  name: "gradients/conv2d/BiasAdd_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d/BiasAdd_grad/BiasAddGrad"
  input: "^gradients/conv2d/BiasAdd_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d/BiasAdd_grad/BiasAddGrad"
      }
    }
  }
}
node {
  name: "gradients/conv2d/Conv2D_grad/ShapeN"
  op: "ShapeN"
  input: "Reshape"
  input: "conv2d/kernel/read"
  attr {
    key: "N"
    value {
      i: 2
    }
  }
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "out_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "gradients/conv2d/Conv2D_grad/Const"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\010\000\000\000\010\000\000\000\003\000\000\000 \000\000\000"
      }
    }
  }
}
node {
  name: "gradients/conv2d/Conv2D_grad/Conv2DBackpropInput"
  op: "Conv2DBackpropInput"
  input: "gradients/conv2d/Conv2D_grad/ShapeN"
  input: "conv2d/kernel/read"
  input: "gradients/conv2d/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d/Conv2D_grad/Conv2DBackpropFilter"
  op: "Conv2DBackpropFilter"
  input: "Reshape"
  input: "gradients/conv2d/Conv2D_grad/Const"
  input: "gradients/conv2d/BiasAdd_grad/tuple/control_dependency"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "data_format"
    value {
      s: "NHWC"
    }
  }
  attr {
    key: "dilations"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "padding"
    value {
      s: "SAME"
    }
  }
  attr {
    key: "strides"
    value {
      list {
        i: 1
        i: 1
        i: 1
        i: 1
      }
    }
  }
  attr {
    key: "use_cudnn_on_gpu"
    value {
      b: true
    }
  }
}
node {
  name: "gradients/conv2d/Conv2D_grad/tuple/group_deps"
  op: "NoOp"
  input: "^gradients/conv2d/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d/Conv2D_grad/Conv2DBackpropInput"
}
node {
  name: "gradients/conv2d/Conv2D_grad/tuple/control_dependency"
  op: "Identity"
  input: "gradients/conv2d/Conv2D_grad/Conv2DBackpropInput"
  input: "^gradients/conv2d/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d/Conv2D_grad/Conv2DBackpropInput"
      }
    }
  }
}
node {
  name: "gradients/conv2d/Conv2D_grad/tuple/control_dependency_1"
  op: "Identity"
  input: "gradients/conv2d/Conv2D_grad/Conv2DBackpropFilter"
  input: "^gradients/conv2d/Conv2D_grad/tuple/group_deps"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@gradients/conv2d/Conv2D_grad/Conv2DBackpropFilter"
      }
    }
  }
}
node {
  name: "beta1_power/initial_value"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.8999999761581421
      }
    }
  }
}
node {
  name: "beta1_power"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "beta1_power/Assign"
  op: "Assign"
  input: "beta1_power"
  input: "beta1_power/initial_value"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "beta1_power/read"
  op: "Identity"
  input: "beta1_power"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/bias"
      }
    }
  }
}
node {
  name: "beta2_power/initial_value"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.9990000128746033
      }
    }
  }
}
node {
  name: "beta2_power"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "beta2_power/Assign"
  op: "Assign"
  input: "beta2_power"
  input: "beta2_power/initial_value"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "beta2_power/read"
  op: "Identity"
  input: "beta2_power"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/bias"
      }
    }
  }
}
node {
  name: "conv2d/kernel/Adam/Initializer/zeros/shape_as_tensor"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\010\000\000\000\010\000\000\000\003\000\000\000 \000\000\000"
      }
    }
  }
}
node {
  name: "conv2d/kernel/Adam/Initializer/zeros/Const"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d/kernel/Adam/Initializer/zeros"
  op: "Fill"
  input: "conv2d/kernel/Adam/Initializer/zeros/shape_as_tensor"
  input: "conv2d/kernel/Adam/Initializer/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/kernel"
      }
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d/kernel/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
        dim {
          size: 8
        }
        dim {
          size: 3
        }
        dim {
          size: 32
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d/kernel/Adam/Assign"
  op: "Assign"
  input: "conv2d/kernel/Adam"
  input: "conv2d/kernel/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d/kernel/Adam/read"
  op: "Identity"
  input: "conv2d/kernel/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/kernel"
      }
    }
  }
}
node {
  name: "conv2d/kernel/Adam_1/Initializer/zeros/shape_as_tensor"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\010\000\000\000\010\000\000\000\003\000\000\000 \000\000\000"
      }
    }
  }
}
node {
  name: "conv2d/kernel/Adam_1/Initializer/zeros/Const"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d/kernel/Adam_1/Initializer/zeros"
  op: "Fill"
  input: "conv2d/kernel/Adam_1/Initializer/zeros/shape_as_tensor"
  input: "conv2d/kernel/Adam_1/Initializer/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/kernel"
      }
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d/kernel/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
        dim {
          size: 8
        }
        dim {
          size: 3
        }
        dim {
          size: 32
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d/kernel/Adam_1/Assign"
  op: "Assign"
  input: "conv2d/kernel/Adam_1"
  input: "conv2d/kernel/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d/kernel/Adam_1/read"
  op: "Identity"
  input: "conv2d/kernel/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/kernel"
      }
    }
  }
}
node {
  name: "conv2d/bias/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 32
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d/bias/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 32
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d/bias/Adam/Assign"
  op: "Assign"
  input: "conv2d/bias/Adam"
  input: "conv2d/bias/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d/bias/Adam/read"
  op: "Identity"
  input: "conv2d/bias/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/bias"
      }
    }
  }
}
node {
  name: "conv2d/bias/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 32
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d/bias/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 32
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d/bias/Adam_1/Assign"
  op: "Assign"
  input: "conv2d/bias/Adam_1"
  input: "conv2d/bias/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d/bias/Adam_1/read"
  op: "Identity"
  input: "conv2d/bias/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/bias"
      }
    }
  }
}
node {
  name: "conv2d_1/kernel/Adam/Initializer/zeros/shape_as_tensor"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_1/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\006\000\000\000\006\000\000\000 \000\000\000\030\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_1/kernel/Adam/Initializer/zeros/Const"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_1/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_1/kernel/Adam/Initializer/zeros"
  op: "Fill"
  input: "conv2d_1/kernel/Adam/Initializer/zeros/shape_as_tensor"
  input: "conv2d_1/kernel/Adam/Initializer/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_1/kernel"
      }
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_1/kernel/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_1/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 6
        }
        dim {
          size: 6
        }
        dim {
          size: 32
        }
        dim {
          size: 24
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_1/kernel/Adam/Assign"
  op: "Assign"
  input: "conv2d_1/kernel/Adam"
  input: "conv2d_1/kernel/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_1/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_1/kernel/Adam/read"
  op: "Identity"
  input: "conv2d_1/kernel/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_1/kernel"
      }
    }
  }
}
node {
  name: "conv2d_1/kernel/Adam_1/Initializer/zeros/shape_as_tensor"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_1/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\006\000\000\000\006\000\000\000 \000\000\000\030\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_1/kernel/Adam_1/Initializer/zeros/Const"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_1/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_1/kernel/Adam_1/Initializer/zeros"
  op: "Fill"
  input: "conv2d_1/kernel/Adam_1/Initializer/zeros/shape_as_tensor"
  input: "conv2d_1/kernel/Adam_1/Initializer/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_1/kernel"
      }
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_1/kernel/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_1/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 6
        }
        dim {
          size: 6
        }
        dim {
          size: 32
        }
        dim {
          size: 24
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_1/kernel/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_1/kernel/Adam_1"
  input: "conv2d_1/kernel/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_1/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_1/kernel/Adam_1/read"
  op: "Identity"
  input: "conv2d_1/kernel/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_1/kernel"
      }
    }
  }
}
node {
  name: "conv2d_1/bias/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_1/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 24
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_1/bias/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_1/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 24
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_1/bias/Adam/Assign"
  op: "Assign"
  input: "conv2d_1/bias/Adam"
  input: "conv2d_1/bias/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_1/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_1/bias/Adam/read"
  op: "Identity"
  input: "conv2d_1/bias/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_1/bias"
      }
    }
  }
}
node {
  name: "conv2d_1/bias/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_1/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 24
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_1/bias/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_1/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 24
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_1/bias/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_1/bias/Adam_1"
  input: "conv2d_1/bias/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_1/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_1/bias/Adam_1/read"
  op: "Identity"
  input: "conv2d_1/bias/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_1/bias"
      }
    }
  }
}
node {
  name: "conv2d_2/kernel/Adam/Initializer/zeros/shape_as_tensor"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_2/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\005\000\000\000\005\000\000\000\030\000\000\000\020\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_2/kernel/Adam/Initializer/zeros/Const"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_2/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_2/kernel/Adam/Initializer/zeros"
  op: "Fill"
  input: "conv2d_2/kernel/Adam/Initializer/zeros/shape_as_tensor"
  input: "conv2d_2/kernel/Adam/Initializer/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_2/kernel"
      }
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_2/kernel/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_2/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 5
        }
        dim {
          size: 5
        }
        dim {
          size: 24
        }
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_2/kernel/Adam/Assign"
  op: "Assign"
  input: "conv2d_2/kernel/Adam"
  input: "conv2d_2/kernel/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_2/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_2/kernel/Adam/read"
  op: "Identity"
  input: "conv2d_2/kernel/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_2/kernel"
      }
    }
  }
}
node {
  name: "conv2d_2/kernel/Adam_1/Initializer/zeros/shape_as_tensor"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_2/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\005\000\000\000\005\000\000\000\030\000\000\000\020\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_2/kernel/Adam_1/Initializer/zeros/Const"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_2/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_2/kernel/Adam_1/Initializer/zeros"
  op: "Fill"
  input: "conv2d_2/kernel/Adam_1/Initializer/zeros/shape_as_tensor"
  input: "conv2d_2/kernel/Adam_1/Initializer/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_2/kernel"
      }
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_2/kernel/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_2/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 5
        }
        dim {
          size: 5
        }
        dim {
          size: 24
        }
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_2/kernel/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_2/kernel/Adam_1"
  input: "conv2d_2/kernel/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_2/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_2/kernel/Adam_1/read"
  op: "Identity"
  input: "conv2d_2/kernel/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_2/kernel"
      }
    }
  }
}
node {
  name: "conv2d_2/bias/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_2/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 16
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_2/bias/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_2/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_2/bias/Adam/Assign"
  op: "Assign"
  input: "conv2d_2/bias/Adam"
  input: "conv2d_2/bias/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_2/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_2/bias/Adam/read"
  op: "Identity"
  input: "conv2d_2/bias/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_2/bias"
      }
    }
  }
}
node {
  name: "conv2d_2/bias/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_2/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 16
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_2/bias/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_2/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_2/bias/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_2/bias/Adam_1"
  input: "conv2d_2/bias/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_2/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_2/bias/Adam_1/read"
  op: "Identity"
  input: "conv2d_2/bias/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_2/bias"
      }
    }
  }
}
node {
  name: "conv2d_3/kernel/Adam/Initializer/zeros/shape_as_tensor"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_3/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\004\000\000\000\004\000\000\000\020\000\000\000\030\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_3/kernel/Adam/Initializer/zeros/Const"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_3/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_3/kernel/Adam/Initializer/zeros"
  op: "Fill"
  input: "conv2d_3/kernel/Adam/Initializer/zeros/shape_as_tensor"
  input: "conv2d_3/kernel/Adam/Initializer/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_3/kernel"
      }
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_3/kernel/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_3/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 4
        }
        dim {
          size: 4
        }
        dim {
          size: 16
        }
        dim {
          size: 24
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_3/kernel/Adam/Assign"
  op: "Assign"
  input: "conv2d_3/kernel/Adam"
  input: "conv2d_3/kernel/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_3/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_3/kernel/Adam/read"
  op: "Identity"
  input: "conv2d_3/kernel/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_3/kernel"
      }
    }
  }
}
node {
  name: "conv2d_3/kernel/Adam_1/Initializer/zeros/shape_as_tensor"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_3/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\004\000\000\000\004\000\000\000\020\000\000\000\030\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_3/kernel/Adam_1/Initializer/zeros/Const"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_3/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_3/kernel/Adam_1/Initializer/zeros"
  op: "Fill"
  input: "conv2d_3/kernel/Adam_1/Initializer/zeros/shape_as_tensor"
  input: "conv2d_3/kernel/Adam_1/Initializer/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_3/kernel"
      }
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_3/kernel/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_3/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 4
        }
        dim {
          size: 4
        }
        dim {
          size: 16
        }
        dim {
          size: 24
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_3/kernel/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_3/kernel/Adam_1"
  input: "conv2d_3/kernel/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_3/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_3/kernel/Adam_1/read"
  op: "Identity"
  input: "conv2d_3/kernel/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_3/kernel"
      }
    }
  }
}
node {
  name: "conv2d_3/bias/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_3/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 24
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_3/bias/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_3/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 24
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_3/bias/Adam/Assign"
  op: "Assign"
  input: "conv2d_3/bias/Adam"
  input: "conv2d_3/bias/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_3/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_3/bias/Adam/read"
  op: "Identity"
  input: "conv2d_3/bias/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_3/bias"
      }
    }
  }
}
node {
  name: "conv2d_3/bias/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_3/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 24
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_3/bias/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_3/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 24
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_3/bias/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_3/bias/Adam_1"
  input: "conv2d_3/bias/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_3/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_3/bias/Adam_1/read"
  op: "Identity"
  input: "conv2d_3/bias/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_3/bias"
      }
    }
  }
}
node {
  name: "conv2d_4/kernel/Adam/Initializer/zeros/shape_as_tensor"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_4/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\004\000\000\000\004\000\000\000\030\000\000\000\030\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_4/kernel/Adam/Initializer/zeros/Const"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_4/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_4/kernel/Adam/Initializer/zeros"
  op: "Fill"
  input: "conv2d_4/kernel/Adam/Initializer/zeros/shape_as_tensor"
  input: "conv2d_4/kernel/Adam/Initializer/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_4/kernel"
      }
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_4/kernel/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_4/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 4
        }
        dim {
          size: 4
        }
        dim {
          size: 24
        }
        dim {
          size: 24
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_4/kernel/Adam/Assign"
  op: "Assign"
  input: "conv2d_4/kernel/Adam"
  input: "conv2d_4/kernel/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_4/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_4/kernel/Adam/read"
  op: "Identity"
  input: "conv2d_4/kernel/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_4/kernel"
      }
    }
  }
}
node {
  name: "conv2d_4/kernel/Adam_1/Initializer/zeros/shape_as_tensor"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_4/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\004\000\000\000\004\000\000\000\030\000\000\000\030\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_4/kernel/Adam_1/Initializer/zeros/Const"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_4/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_4/kernel/Adam_1/Initializer/zeros"
  op: "Fill"
  input: "conv2d_4/kernel/Adam_1/Initializer/zeros/shape_as_tensor"
  input: "conv2d_4/kernel/Adam_1/Initializer/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_4/kernel"
      }
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_4/kernel/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_4/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 4
        }
        dim {
          size: 4
        }
        dim {
          size: 24
        }
        dim {
          size: 24
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_4/kernel/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_4/kernel/Adam_1"
  input: "conv2d_4/kernel/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_4/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_4/kernel/Adam_1/read"
  op: "Identity"
  input: "conv2d_4/kernel/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_4/kernel"
      }
    }
  }
}
node {
  name: "conv2d_4/bias/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_4/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 24
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_4/bias/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_4/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 24
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_4/bias/Adam/Assign"
  op: "Assign"
  input: "conv2d_4/bias/Adam"
  input: "conv2d_4/bias/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_4/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_4/bias/Adam/read"
  op: "Identity"
  input: "conv2d_4/bias/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_4/bias"
      }
    }
  }
}
node {
  name: "conv2d_4/bias/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_4/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 24
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_4/bias/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_4/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 24
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_4/bias/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_4/bias/Adam_1"
  input: "conv2d_4/bias/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_4/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_4/bias/Adam_1/read"
  op: "Identity"
  input: "conv2d_4/bias/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_4/bias"
      }
    }
  }
}
node {
  name: "conv2d_5/kernel/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_5/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 1
          }
          dim {
            size: 1
          }
          dim {
            size: 24
          }
          dim {
            size: 16
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_5/kernel/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_5/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 1
        }
        dim {
          size: 1
        }
        dim {
          size: 24
        }
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_5/kernel/Adam/Assign"
  op: "Assign"
  input: "conv2d_5/kernel/Adam"
  input: "conv2d_5/kernel/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_5/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_5/kernel/Adam/read"
  op: "Identity"
  input: "conv2d_5/kernel/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_5/kernel"
      }
    }
  }
}
node {
  name: "conv2d_5/kernel/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_5/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 1
          }
          dim {
            size: 1
          }
          dim {
            size: 24
          }
          dim {
            size: 16
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_5/kernel/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_5/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 1
        }
        dim {
          size: 1
        }
        dim {
          size: 24
        }
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_5/kernel/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_5/kernel/Adam_1"
  input: "conv2d_5/kernel/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_5/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_5/kernel/Adam_1/read"
  op: "Identity"
  input: "conv2d_5/kernel/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_5/kernel"
      }
    }
  }
}
node {
  name: "conv2d_5/bias/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_5/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 16
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_5/bias/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_5/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_5/bias/Adam/Assign"
  op: "Assign"
  input: "conv2d_5/bias/Adam"
  input: "conv2d_5/bias/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_5/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_5/bias/Adam/read"
  op: "Identity"
  input: "conv2d_5/bias/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_5/bias"
      }
    }
  }
}
node {
  name: "conv2d_5/bias/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_5/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 16
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_5/bias/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_5/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_5/bias/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_5/bias/Adam_1"
  input: "conv2d_5/bias/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_5/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_5/bias/Adam_1/read"
  op: "Identity"
  input: "conv2d_5/bias/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_5/bias"
      }
    }
  }
}
node {
  name: "conv2d_6/kernel/Adam/Initializer/zeros/shape_as_tensor"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_6/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\003\000\000\000\003\000\000\000\020\000\000\000\020\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_6/kernel/Adam/Initializer/zeros/Const"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_6/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_6/kernel/Adam/Initializer/zeros"
  op: "Fill"
  input: "conv2d_6/kernel/Adam/Initializer/zeros/shape_as_tensor"
  input: "conv2d_6/kernel/Adam/Initializer/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_6/kernel"
      }
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_6/kernel/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_6/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 3
        }
        dim {
          size: 3
        }
        dim {
          size: 16
        }
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_6/kernel/Adam/Assign"
  op: "Assign"
  input: "conv2d_6/kernel/Adam"
  input: "conv2d_6/kernel/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_6/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_6/kernel/Adam/read"
  op: "Identity"
  input: "conv2d_6/kernel/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_6/kernel"
      }
    }
  }
}
node {
  name: "conv2d_6/kernel/Adam_1/Initializer/zeros/shape_as_tensor"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_6/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\003\000\000\000\003\000\000\000\020\000\000\000\020\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_6/kernel/Adam_1/Initializer/zeros/Const"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_6/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_6/kernel/Adam_1/Initializer/zeros"
  op: "Fill"
  input: "conv2d_6/kernel/Adam_1/Initializer/zeros/shape_as_tensor"
  input: "conv2d_6/kernel/Adam_1/Initializer/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_6/kernel"
      }
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_6/kernel/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_6/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 3
        }
        dim {
          size: 3
        }
        dim {
          size: 16
        }
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_6/kernel/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_6/kernel/Adam_1"
  input: "conv2d_6/kernel/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_6/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_6/kernel/Adam_1/read"
  op: "Identity"
  input: "conv2d_6/kernel/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_6/kernel"
      }
    }
  }
}
node {
  name: "conv2d_6/bias/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_6/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 16
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_6/bias/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_6/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_6/bias/Adam/Assign"
  op: "Assign"
  input: "conv2d_6/bias/Adam"
  input: "conv2d_6/bias/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_6/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_6/bias/Adam/read"
  op: "Identity"
  input: "conv2d_6/bias/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_6/bias"
      }
    }
  }
}
node {
  name: "conv2d_6/bias/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_6/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 16
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_6/bias/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_6/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_6/bias/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_6/bias/Adam_1"
  input: "conv2d_6/bias/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_6/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_6/bias/Adam_1/read"
  op: "Identity"
  input: "conv2d_6/bias/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_6/bias"
      }
    }
  }
}
node {
  name: "conv2d_7/kernel/Adam/Initializer/zeros/shape_as_tensor"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_7/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\003\000\000\000\003\000\000\000\020\000\000\000\020\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_7/kernel/Adam/Initializer/zeros/Const"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_7/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_7/kernel/Adam/Initializer/zeros"
  op: "Fill"
  input: "conv2d_7/kernel/Adam/Initializer/zeros/shape_as_tensor"
  input: "conv2d_7/kernel/Adam/Initializer/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_7/kernel"
      }
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_7/kernel/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_7/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 3
        }
        dim {
          size: 3
        }
        dim {
          size: 16
        }
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_7/kernel/Adam/Assign"
  op: "Assign"
  input: "conv2d_7/kernel/Adam"
  input: "conv2d_7/kernel/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_7/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_7/kernel/Adam/read"
  op: "Identity"
  input: "conv2d_7/kernel/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_7/kernel"
      }
    }
  }
}
node {
  name: "conv2d_7/kernel/Adam_1/Initializer/zeros/shape_as_tensor"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_7/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\003\000\000\000\003\000\000\000\020\000\000\000\020\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_7/kernel/Adam_1/Initializer/zeros/Const"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_7/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_7/kernel/Adam_1/Initializer/zeros"
  op: "Fill"
  input: "conv2d_7/kernel/Adam_1/Initializer/zeros/shape_as_tensor"
  input: "conv2d_7/kernel/Adam_1/Initializer/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_7/kernel"
      }
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_7/kernel/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_7/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 3
        }
        dim {
          size: 3
        }
        dim {
          size: 16
        }
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_7/kernel/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_7/kernel/Adam_1"
  input: "conv2d_7/kernel/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_7/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_7/kernel/Adam_1/read"
  op: "Identity"
  input: "conv2d_7/kernel/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_7/kernel"
      }
    }
  }
}
node {
  name: "conv2d_7/bias/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_7/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 16
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_7/bias/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_7/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_7/bias/Adam/Assign"
  op: "Assign"
  input: "conv2d_7/bias/Adam"
  input: "conv2d_7/bias/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_7/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_7/bias/Adam/read"
  op: "Identity"
  input: "conv2d_7/bias/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_7/bias"
      }
    }
  }
}
node {
  name: "conv2d_7/bias/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_7/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 16
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_7/bias/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_7/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_7/bias/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_7/bias/Adam_1"
  input: "conv2d_7/bias/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_7/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_7/bias/Adam_1/read"
  op: "Identity"
  input: "conv2d_7/bias/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_7/bias"
      }
    }
  }
}
node {
  name: "conv2d_8/kernel/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_8/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 1
          }
          dim {
            size: 1
          }
          dim {
            size: 16
          }
          dim {
            size: 16
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_8/kernel/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_8/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 1
        }
        dim {
          size: 1
        }
        dim {
          size: 16
        }
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_8/kernel/Adam/Assign"
  op: "Assign"
  input: "conv2d_8/kernel/Adam"
  input: "conv2d_8/kernel/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_8/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_8/kernel/Adam/read"
  op: "Identity"
  input: "conv2d_8/kernel/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_8/kernel"
      }
    }
  }
}
node {
  name: "conv2d_8/kernel/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_8/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 1
          }
          dim {
            size: 1
          }
          dim {
            size: 16
          }
          dim {
            size: 16
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_8/kernel/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_8/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 1
        }
        dim {
          size: 1
        }
        dim {
          size: 16
        }
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_8/kernel/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_8/kernel/Adam_1"
  input: "conv2d_8/kernel/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_8/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_8/kernel/Adam_1/read"
  op: "Identity"
  input: "conv2d_8/kernel/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_8/kernel"
      }
    }
  }
}
node {
  name: "conv2d_8/bias/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_8/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 16
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_8/bias/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_8/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_8/bias/Adam/Assign"
  op: "Assign"
  input: "conv2d_8/bias/Adam"
  input: "conv2d_8/bias/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_8/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_8/bias/Adam/read"
  op: "Identity"
  input: "conv2d_8/bias/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_8/bias"
      }
    }
  }
}
node {
  name: "conv2d_8/bias/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_8/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 16
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_8/bias/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_8/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_8/bias/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_8/bias/Adam_1"
  input: "conv2d_8/bias/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_8/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_8/bias/Adam_1/read"
  op: "Identity"
  input: "conv2d_8/bias/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_8/bias"
      }
    }
  }
}
node {
  name: "conv2d_9/kernel/Adam/Initializer/zeros/shape_as_tensor"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_9/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\003\000\000\000\003\000\000\000\020\000\000\000\010\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_9/kernel/Adam/Initializer/zeros/Const"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_9/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_9/kernel/Adam/Initializer/zeros"
  op: "Fill"
  input: "conv2d_9/kernel/Adam/Initializer/zeros/shape_as_tensor"
  input: "conv2d_9/kernel/Adam/Initializer/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_9/kernel"
      }
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_9/kernel/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_9/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 3
        }
        dim {
          size: 3
        }
        dim {
          size: 16
        }
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_9/kernel/Adam/Assign"
  op: "Assign"
  input: "conv2d_9/kernel/Adam"
  input: "conv2d_9/kernel/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_9/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_9/kernel/Adam/read"
  op: "Identity"
  input: "conv2d_9/kernel/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_9/kernel"
      }
    }
  }
}
node {
  name: "conv2d_9/kernel/Adam_1/Initializer/zeros/shape_as_tensor"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_9/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\003\000\000\000\003\000\000\000\020\000\000\000\010\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_9/kernel/Adam_1/Initializer/zeros/Const"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_9/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_9/kernel/Adam_1/Initializer/zeros"
  op: "Fill"
  input: "conv2d_9/kernel/Adam_1/Initializer/zeros/shape_as_tensor"
  input: "conv2d_9/kernel/Adam_1/Initializer/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_9/kernel"
      }
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_9/kernel/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_9/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 3
        }
        dim {
          size: 3
        }
        dim {
          size: 16
        }
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_9/kernel/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_9/kernel/Adam_1"
  input: "conv2d_9/kernel/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_9/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_9/kernel/Adam_1/read"
  op: "Identity"
  input: "conv2d_9/kernel/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_9/kernel"
      }
    }
  }
}
node {
  name: "conv2d_9/bias/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_9/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_9/bias/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_9/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_9/bias/Adam/Assign"
  op: "Assign"
  input: "conv2d_9/bias/Adam"
  input: "conv2d_9/bias/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_9/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_9/bias/Adam/read"
  op: "Identity"
  input: "conv2d_9/bias/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_9/bias"
      }
    }
  }
}
node {
  name: "conv2d_9/bias/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_9/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_9/bias/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_9/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_9/bias/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_9/bias/Adam_1"
  input: "conv2d_9/bias/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_9/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_9/bias/Adam_1/read"
  op: "Identity"
  input: "conv2d_9/bias/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_9/bias"
      }
    }
  }
}
node {
  name: "conv2d_10/kernel/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_10/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 1
          }
          dim {
            size: 1
          }
          dim {
            size: 8
          }
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_10/kernel/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_10/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 1
        }
        dim {
          size: 1
        }
        dim {
          size: 8
        }
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_10/kernel/Adam/Assign"
  op: "Assign"
  input: "conv2d_10/kernel/Adam"
  input: "conv2d_10/kernel/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_10/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_10/kernel/Adam/read"
  op: "Identity"
  input: "conv2d_10/kernel/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_10/kernel"
      }
    }
  }
}
node {
  name: "conv2d_10/kernel/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_10/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 1
          }
          dim {
            size: 1
          }
          dim {
            size: 8
          }
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_10/kernel/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_10/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 1
        }
        dim {
          size: 1
        }
        dim {
          size: 8
        }
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_10/kernel/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_10/kernel/Adam_1"
  input: "conv2d_10/kernel/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_10/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_10/kernel/Adam_1/read"
  op: "Identity"
  input: "conv2d_10/kernel/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_10/kernel"
      }
    }
  }
}
node {
  name: "conv2d_10/bias/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_10/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_10/bias/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_10/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_10/bias/Adam/Assign"
  op: "Assign"
  input: "conv2d_10/bias/Adam"
  input: "conv2d_10/bias/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_10/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_10/bias/Adam/read"
  op: "Identity"
  input: "conv2d_10/bias/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_10/bias"
      }
    }
  }
}
node {
  name: "conv2d_10/bias/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_10/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_10/bias/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_10/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_10/bias/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_10/bias/Adam_1"
  input: "conv2d_10/bias/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_10/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_10/bias/Adam_1/read"
  op: "Identity"
  input: "conv2d_10/bias/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_10/bias"
      }
    }
  }
}
node {
  name: "conv2d_11/kernel/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_11/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 3
          }
          dim {
            size: 3
          }
          dim {
            size: 8
          }
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_11/kernel/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_11/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 3
        }
        dim {
          size: 3
        }
        dim {
          size: 8
        }
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_11/kernel/Adam/Assign"
  op: "Assign"
  input: "conv2d_11/kernel/Adam"
  input: "conv2d_11/kernel/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_11/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_11/kernel/Adam/read"
  op: "Identity"
  input: "conv2d_11/kernel/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_11/kernel"
      }
    }
  }
}
node {
  name: "conv2d_11/kernel/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_11/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 3
          }
          dim {
            size: 3
          }
          dim {
            size: 8
          }
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_11/kernel/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_11/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 3
        }
        dim {
          size: 3
        }
        dim {
          size: 8
        }
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_11/kernel/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_11/kernel/Adam_1"
  input: "conv2d_11/kernel/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_11/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_11/kernel/Adam_1/read"
  op: "Identity"
  input: "conv2d_11/kernel/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_11/kernel"
      }
    }
  }
}
node {
  name: "conv2d_11/bias/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_11/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_11/bias/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_11/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_11/bias/Adam/Assign"
  op: "Assign"
  input: "conv2d_11/bias/Adam"
  input: "conv2d_11/bias/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_11/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_11/bias/Adam/read"
  op: "Identity"
  input: "conv2d_11/bias/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_11/bias"
      }
    }
  }
}
node {
  name: "conv2d_11/bias/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_11/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_11/bias/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_11/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_11/bias/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_11/bias/Adam_1"
  input: "conv2d_11/bias/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_11/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_11/bias/Adam_1/read"
  op: "Identity"
  input: "conv2d_11/bias/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_11/bias"
      }
    }
  }
}
node {
  name: "conv2d_12/kernel/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_12/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 1
          }
          dim {
            size: 1
          }
          dim {
            size: 8
          }
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_12/kernel/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_12/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 1
        }
        dim {
          size: 1
        }
        dim {
          size: 8
        }
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_12/kernel/Adam/Assign"
  op: "Assign"
  input: "conv2d_12/kernel/Adam"
  input: "conv2d_12/kernel/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_12/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_12/kernel/Adam/read"
  op: "Identity"
  input: "conv2d_12/kernel/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_12/kernel"
      }
    }
  }
}
node {
  name: "conv2d_12/kernel/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_12/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 1
          }
          dim {
            size: 1
          }
          dim {
            size: 8
          }
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_12/kernel/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_12/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 1
        }
        dim {
          size: 1
        }
        dim {
          size: 8
        }
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_12/kernel/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_12/kernel/Adam_1"
  input: "conv2d_12/kernel/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_12/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_12/kernel/Adam_1/read"
  op: "Identity"
  input: "conv2d_12/kernel/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_12/kernel"
      }
    }
  }
}
node {
  name: "conv2d_12/bias/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_12/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_12/bias/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_12/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_12/bias/Adam/Assign"
  op: "Assign"
  input: "conv2d_12/bias/Adam"
  input: "conv2d_12/bias/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_12/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_12/bias/Adam/read"
  op: "Identity"
  input: "conv2d_12/bias/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_12/bias"
      }
    }
  }
}
node {
  name: "conv2d_12/bias/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_12/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_12/bias/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_12/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_12/bias/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_12/bias/Adam_1"
  input: "conv2d_12/bias/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_12/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_12/bias/Adam_1/read"
  op: "Identity"
  input: "conv2d_12/bias/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_12/bias"
      }
    }
  }
}
node {
  name: "conv2d_13/kernel/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_13/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 3
          }
          dim {
            size: 3
          }
          dim {
            size: 8
          }
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_13/kernel/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_13/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 3
        }
        dim {
          size: 3
        }
        dim {
          size: 8
        }
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_13/kernel/Adam/Assign"
  op: "Assign"
  input: "conv2d_13/kernel/Adam"
  input: "conv2d_13/kernel/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_13/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_13/kernel/Adam/read"
  op: "Identity"
  input: "conv2d_13/kernel/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_13/kernel"
      }
    }
  }
}
node {
  name: "conv2d_13/kernel/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_13/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 3
          }
          dim {
            size: 3
          }
          dim {
            size: 8
          }
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_13/kernel/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_13/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 3
        }
        dim {
          size: 3
        }
        dim {
          size: 8
        }
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_13/kernel/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_13/kernel/Adam_1"
  input: "conv2d_13/kernel/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_13/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_13/kernel/Adam_1/read"
  op: "Identity"
  input: "conv2d_13/kernel/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_13/kernel"
      }
    }
  }
}
node {
  name: "conv2d_13/bias/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_13/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_13/bias/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_13/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_13/bias/Adam/Assign"
  op: "Assign"
  input: "conv2d_13/bias/Adam"
  input: "conv2d_13/bias/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_13/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_13/bias/Adam/read"
  op: "Identity"
  input: "conv2d_13/bias/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_13/bias"
      }
    }
  }
}
node {
  name: "conv2d_13/bias/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_13/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_13/bias/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_13/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_13/bias/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_13/bias/Adam_1"
  input: "conv2d_13/bias/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_13/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_13/bias/Adam_1/read"
  op: "Identity"
  input: "conv2d_13/bias/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_13/bias"
      }
    }
  }
}
node {
  name: "conv2d_14/kernel/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_14/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 1
          }
          dim {
            size: 1
          }
          dim {
            size: 8
          }
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_14/kernel/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_14/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 1
        }
        dim {
          size: 1
        }
        dim {
          size: 8
        }
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_14/kernel/Adam/Assign"
  op: "Assign"
  input: "conv2d_14/kernel/Adam"
  input: "conv2d_14/kernel/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_14/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_14/kernel/Adam/read"
  op: "Identity"
  input: "conv2d_14/kernel/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_14/kernel"
      }
    }
  }
}
node {
  name: "conv2d_14/kernel/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_14/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 1
          }
          dim {
            size: 1
          }
          dim {
            size: 8
          }
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_14/kernel/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_14/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 1
        }
        dim {
          size: 1
        }
        dim {
          size: 8
        }
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_14/kernel/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_14/kernel/Adam_1"
  input: "conv2d_14/kernel/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_14/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_14/kernel/Adam_1/read"
  op: "Identity"
  input: "conv2d_14/kernel/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_14/kernel"
      }
    }
  }
}
node {
  name: "conv2d_14/bias/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_14/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_14/bias/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_14/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_14/bias/Adam/Assign"
  op: "Assign"
  input: "conv2d_14/bias/Adam"
  input: "conv2d_14/bias/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_14/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_14/bias/Adam/read"
  op: "Identity"
  input: "conv2d_14/bias/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_14/bias"
      }
    }
  }
}
node {
  name: "conv2d_14/bias/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_14/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_14/bias/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_14/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_14/bias/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_14/bias/Adam_1"
  input: "conv2d_14/bias/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_14/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_14/bias/Adam_1/read"
  op: "Identity"
  input: "conv2d_14/bias/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_14/bias"
      }
    }
  }
}
node {
  name: "conv2d_15/kernel/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_15/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 1
          }
          dim {
            size: 1
          }
          dim {
            size: 8
          }
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_15/kernel/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_15/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 1
        }
        dim {
          size: 1
        }
        dim {
          size: 8
        }
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_15/kernel/Adam/Assign"
  op: "Assign"
  input: "conv2d_15/kernel/Adam"
  input: "conv2d_15/kernel/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_15/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_15/kernel/Adam/read"
  op: "Identity"
  input: "conv2d_15/kernel/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_15/kernel"
      }
    }
  }
}
node {
  name: "conv2d_15/kernel/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_15/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 1
          }
          dim {
            size: 1
          }
          dim {
            size: 8
          }
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_15/kernel/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_15/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 1
        }
        dim {
          size: 1
        }
        dim {
          size: 8
        }
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_15/kernel/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_15/kernel/Adam_1"
  input: "conv2d_15/kernel/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_15/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_15/kernel/Adam_1/read"
  op: "Identity"
  input: "conv2d_15/kernel/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_15/kernel"
      }
    }
  }
}
node {
  name: "conv2d_15/bias/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_15/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_15/bias/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_15/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_15/bias/Adam/Assign"
  op: "Assign"
  input: "conv2d_15/bias/Adam"
  input: "conv2d_15/bias/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_15/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_15/bias/Adam/read"
  op: "Identity"
  input: "conv2d_15/bias/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_15/bias"
      }
    }
  }
}
node {
  name: "conv2d_15/bias/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_15/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_15/bias/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_15/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_15/bias/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_15/bias/Adam_1"
  input: "conv2d_15/bias/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_15/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_15/bias/Adam_1/read"
  op: "Identity"
  input: "conv2d_15/bias/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_15/bias"
      }
    }
  }
}
node {
  name: "conv2d_transpose/kernel/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 3
          }
          dim {
            size: 3
          }
          dim {
            size: 8
          }
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_transpose/kernel/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 3
        }
        dim {
          size: 3
        }
        dim {
          size: 8
        }
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_transpose/kernel/Adam/Assign"
  op: "Assign"
  input: "conv2d_transpose/kernel/Adam"
  input: "conv2d_transpose/kernel/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_transpose/kernel/Adam/read"
  op: "Identity"
  input: "conv2d_transpose/kernel/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose/kernel"
      }
    }
  }
}
node {
  name: "conv2d_transpose/kernel/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 3
          }
          dim {
            size: 3
          }
          dim {
            size: 8
          }
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_transpose/kernel/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 3
        }
        dim {
          size: 3
        }
        dim {
          size: 8
        }
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_transpose/kernel/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_transpose/kernel/Adam_1"
  input: "conv2d_transpose/kernel/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_transpose/kernel/Adam_1/read"
  op: "Identity"
  input: "conv2d_transpose/kernel/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose/kernel"
      }
    }
  }
}
node {
  name: "conv2d_transpose/bias/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_transpose/bias/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_transpose/bias/Adam/Assign"
  op: "Assign"
  input: "conv2d_transpose/bias/Adam"
  input: "conv2d_transpose/bias/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_transpose/bias/Adam/read"
  op: "Identity"
  input: "conv2d_transpose/bias/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose/bias"
      }
    }
  }
}
node {
  name: "conv2d_transpose/bias/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_transpose/bias/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_transpose/bias/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_transpose/bias/Adam_1"
  input: "conv2d_transpose/bias/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_transpose/bias/Adam_1/read"
  op: "Identity"
  input: "conv2d_transpose/bias/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose/bias"
      }
    }
  }
}
node {
  name: "conv2d_16/kernel/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_16/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 1
          }
          dim {
            size: 1
          }
          dim {
            size: 16
          }
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_16/kernel/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_16/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 1
        }
        dim {
          size: 1
        }
        dim {
          size: 16
        }
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_16/kernel/Adam/Assign"
  op: "Assign"
  input: "conv2d_16/kernel/Adam"
  input: "conv2d_16/kernel/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_16/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_16/kernel/Adam/read"
  op: "Identity"
  input: "conv2d_16/kernel/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_16/kernel"
      }
    }
  }
}
node {
  name: "conv2d_16/kernel/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_16/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 1
          }
          dim {
            size: 1
          }
          dim {
            size: 16
          }
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_16/kernel/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_16/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 1
        }
        dim {
          size: 1
        }
        dim {
          size: 16
        }
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_16/kernel/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_16/kernel/Adam_1"
  input: "conv2d_16/kernel/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_16/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_16/kernel/Adam_1/read"
  op: "Identity"
  input: "conv2d_16/kernel/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_16/kernel"
      }
    }
  }
}
node {
  name: "conv2d_16/bias/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_16/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_16/bias/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_16/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_16/bias/Adam/Assign"
  op: "Assign"
  input: "conv2d_16/bias/Adam"
  input: "conv2d_16/bias/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_16/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_16/bias/Adam/read"
  op: "Identity"
  input: "conv2d_16/bias/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_16/bias"
      }
    }
  }
}
node {
  name: "conv2d_16/bias/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_16/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_16/bias/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_16/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_16/bias/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_16/bias/Adam_1"
  input: "conv2d_16/bias/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_16/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_16/bias/Adam_1/read"
  op: "Identity"
  input: "conv2d_16/bias/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_16/bias"
      }
    }
  }
}
node {
  name: "conv2d_transpose_1/kernel/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_1/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 3
          }
          dim {
            size: 3
          }
          dim {
            size: 8
          }
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_transpose_1/kernel/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_1/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 3
        }
        dim {
          size: 3
        }
        dim {
          size: 8
        }
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_transpose_1/kernel/Adam/Assign"
  op: "Assign"
  input: "conv2d_transpose_1/kernel/Adam"
  input: "conv2d_transpose_1/kernel/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_1/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_transpose_1/kernel/Adam/read"
  op: "Identity"
  input: "conv2d_transpose_1/kernel/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_1/kernel"
      }
    }
  }
}
node {
  name: "conv2d_transpose_1/kernel/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_1/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 3
          }
          dim {
            size: 3
          }
          dim {
            size: 8
          }
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_transpose_1/kernel/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_1/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 3
        }
        dim {
          size: 3
        }
        dim {
          size: 8
        }
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_transpose_1/kernel/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_transpose_1/kernel/Adam_1"
  input: "conv2d_transpose_1/kernel/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_1/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_transpose_1/kernel/Adam_1/read"
  op: "Identity"
  input: "conv2d_transpose_1/kernel/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_1/kernel"
      }
    }
  }
}
node {
  name: "conv2d_transpose_1/bias/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_1/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_transpose_1/bias/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_1/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_transpose_1/bias/Adam/Assign"
  op: "Assign"
  input: "conv2d_transpose_1/bias/Adam"
  input: "conv2d_transpose_1/bias/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_1/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_transpose_1/bias/Adam/read"
  op: "Identity"
  input: "conv2d_transpose_1/bias/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_1/bias"
      }
    }
  }
}
node {
  name: "conv2d_transpose_1/bias/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_1/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_transpose_1/bias/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_1/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_transpose_1/bias/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_transpose_1/bias/Adam_1"
  input: "conv2d_transpose_1/bias/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_1/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_transpose_1/bias/Adam_1/read"
  op: "Identity"
  input: "conv2d_transpose_1/bias/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_1/bias"
      }
    }
  }
}
node {
  name: "conv2d_17/kernel/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_17/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 1
          }
          dim {
            size: 1
          }
          dim {
            size: 16
          }
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_17/kernel/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_17/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 1
        }
        dim {
          size: 1
        }
        dim {
          size: 16
        }
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_17/kernel/Adam/Assign"
  op: "Assign"
  input: "conv2d_17/kernel/Adam"
  input: "conv2d_17/kernel/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_17/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_17/kernel/Adam/read"
  op: "Identity"
  input: "conv2d_17/kernel/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_17/kernel"
      }
    }
  }
}
node {
  name: "conv2d_17/kernel/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_17/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 1
          }
          dim {
            size: 1
          }
          dim {
            size: 16
          }
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_17/kernel/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_17/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 1
        }
        dim {
          size: 1
        }
        dim {
          size: 16
        }
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_17/kernel/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_17/kernel/Adam_1"
  input: "conv2d_17/kernel/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_17/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_17/kernel/Adam_1/read"
  op: "Identity"
  input: "conv2d_17/kernel/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_17/kernel"
      }
    }
  }
}
node {
  name: "conv2d_17/bias/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_17/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_17/bias/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_17/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_17/bias/Adam/Assign"
  op: "Assign"
  input: "conv2d_17/bias/Adam"
  input: "conv2d_17/bias/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_17/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_17/bias/Adam/read"
  op: "Identity"
  input: "conv2d_17/bias/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_17/bias"
      }
    }
  }
}
node {
  name: "conv2d_17/bias/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_17/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_17/bias/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_17/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_17/bias/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_17/bias/Adam_1"
  input: "conv2d_17/bias/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_17/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_17/bias/Adam_1/read"
  op: "Identity"
  input: "conv2d_17/bias/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_17/bias"
      }
    }
  }
}
node {
  name: "conv2d_transpose_2/kernel/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_2/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 3
          }
          dim {
            size: 3
          }
          dim {
            size: 8
          }
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_transpose_2/kernel/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_2/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 3
        }
        dim {
          size: 3
        }
        dim {
          size: 8
        }
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_transpose_2/kernel/Adam/Assign"
  op: "Assign"
  input: "conv2d_transpose_2/kernel/Adam"
  input: "conv2d_transpose_2/kernel/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_2/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_transpose_2/kernel/Adam/read"
  op: "Identity"
  input: "conv2d_transpose_2/kernel/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_2/kernel"
      }
    }
  }
}
node {
  name: "conv2d_transpose_2/kernel/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_2/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 3
          }
          dim {
            size: 3
          }
          dim {
            size: 8
          }
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_transpose_2/kernel/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_2/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 3
        }
        dim {
          size: 3
        }
        dim {
          size: 8
        }
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_transpose_2/kernel/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_transpose_2/kernel/Adam_1"
  input: "conv2d_transpose_2/kernel/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_2/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_transpose_2/kernel/Adam_1/read"
  op: "Identity"
  input: "conv2d_transpose_2/kernel/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_2/kernel"
      }
    }
  }
}
node {
  name: "conv2d_transpose_2/bias/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_2/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_transpose_2/bias/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_2/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_transpose_2/bias/Adam/Assign"
  op: "Assign"
  input: "conv2d_transpose_2/bias/Adam"
  input: "conv2d_transpose_2/bias/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_2/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_transpose_2/bias/Adam/read"
  op: "Identity"
  input: "conv2d_transpose_2/bias/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_2/bias"
      }
    }
  }
}
node {
  name: "conv2d_transpose_2/bias/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_2/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 8
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_transpose_2/bias/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_2/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_transpose_2/bias/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_transpose_2/bias/Adam_1"
  input: "conv2d_transpose_2/bias/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_2/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_transpose_2/bias/Adam_1/read"
  op: "Identity"
  input: "conv2d_transpose_2/bias/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_2/bias"
      }
    }
  }
}
node {
  name: "conv2d_18/kernel/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_18/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 1
          }
          dim {
            size: 1
          }
          dim {
            size: 24
          }
          dim {
            size: 16
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_18/kernel/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_18/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 1
        }
        dim {
          size: 1
        }
        dim {
          size: 24
        }
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_18/kernel/Adam/Assign"
  op: "Assign"
  input: "conv2d_18/kernel/Adam"
  input: "conv2d_18/kernel/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_18/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_18/kernel/Adam/read"
  op: "Identity"
  input: "conv2d_18/kernel/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_18/kernel"
      }
    }
  }
}
node {
  name: "conv2d_18/kernel/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_18/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 1
          }
          dim {
            size: 1
          }
          dim {
            size: 24
          }
          dim {
            size: 16
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_18/kernel/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_18/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 1
        }
        dim {
          size: 1
        }
        dim {
          size: 24
        }
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_18/kernel/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_18/kernel/Adam_1"
  input: "conv2d_18/kernel/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_18/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_18/kernel/Adam_1/read"
  op: "Identity"
  input: "conv2d_18/kernel/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_18/kernel"
      }
    }
  }
}
node {
  name: "conv2d_18/bias/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_18/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 16
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_18/bias/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_18/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_18/bias/Adam/Assign"
  op: "Assign"
  input: "conv2d_18/bias/Adam"
  input: "conv2d_18/bias/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_18/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_18/bias/Adam/read"
  op: "Identity"
  input: "conv2d_18/bias/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_18/bias"
      }
    }
  }
}
node {
  name: "conv2d_18/bias/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_18/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 16
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_18/bias/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_18/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_18/bias/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_18/bias/Adam_1"
  input: "conv2d_18/bias/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_18/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_18/bias/Adam_1/read"
  op: "Identity"
  input: "conv2d_18/bias/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_18/bias"
      }
    }
  }
}
node {
  name: "conv2d_19/kernel/Adam/Initializer/zeros/shape_as_tensor"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_19/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\003\000\000\000\003\000\000\000\020\000\000\000\020\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_19/kernel/Adam/Initializer/zeros/Const"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_19/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_19/kernel/Adam/Initializer/zeros"
  op: "Fill"
  input: "conv2d_19/kernel/Adam/Initializer/zeros/shape_as_tensor"
  input: "conv2d_19/kernel/Adam/Initializer/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_19/kernel"
      }
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_19/kernel/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_19/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 3
        }
        dim {
          size: 3
        }
        dim {
          size: 16
        }
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_19/kernel/Adam/Assign"
  op: "Assign"
  input: "conv2d_19/kernel/Adam"
  input: "conv2d_19/kernel/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_19/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_19/kernel/Adam/read"
  op: "Identity"
  input: "conv2d_19/kernel/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_19/kernel"
      }
    }
  }
}
node {
  name: "conv2d_19/kernel/Adam_1/Initializer/zeros/shape_as_tensor"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_19/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\003\000\000\000\003\000\000\000\020\000\000\000\020\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_19/kernel/Adam_1/Initializer/zeros/Const"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_19/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_19/kernel/Adam_1/Initializer/zeros"
  op: "Fill"
  input: "conv2d_19/kernel/Adam_1/Initializer/zeros/shape_as_tensor"
  input: "conv2d_19/kernel/Adam_1/Initializer/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_19/kernel"
      }
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_19/kernel/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_19/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 3
        }
        dim {
          size: 3
        }
        dim {
          size: 16
        }
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_19/kernel/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_19/kernel/Adam_1"
  input: "conv2d_19/kernel/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_19/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_19/kernel/Adam_1/read"
  op: "Identity"
  input: "conv2d_19/kernel/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_19/kernel"
      }
    }
  }
}
node {
  name: "conv2d_19/bias/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_19/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 16
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_19/bias/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_19/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_19/bias/Adam/Assign"
  op: "Assign"
  input: "conv2d_19/bias/Adam"
  input: "conv2d_19/bias/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_19/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_19/bias/Adam/read"
  op: "Identity"
  input: "conv2d_19/bias/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_19/bias"
      }
    }
  }
}
node {
  name: "conv2d_19/bias/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_19/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 16
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_19/bias/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_19/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_19/bias/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_19/bias/Adam_1"
  input: "conv2d_19/bias/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_19/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_19/bias/Adam_1/read"
  op: "Identity"
  input: "conv2d_19/bias/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_19/bias"
      }
    }
  }
}
node {
  name: "conv2d_transpose_3/kernel/Adam/Initializer/zeros/shape_as_tensor"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_3/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\003\000\000\000\003\000\000\000\020\000\000\000\020\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_transpose_3/kernel/Adam/Initializer/zeros/Const"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_3/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_transpose_3/kernel/Adam/Initializer/zeros"
  op: "Fill"
  input: "conv2d_transpose_3/kernel/Adam/Initializer/zeros/shape_as_tensor"
  input: "conv2d_transpose_3/kernel/Adam/Initializer/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_3/kernel"
      }
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_transpose_3/kernel/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_3/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 3
        }
        dim {
          size: 3
        }
        dim {
          size: 16
        }
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_transpose_3/kernel/Adam/Assign"
  op: "Assign"
  input: "conv2d_transpose_3/kernel/Adam"
  input: "conv2d_transpose_3/kernel/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_3/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_transpose_3/kernel/Adam/read"
  op: "Identity"
  input: "conv2d_transpose_3/kernel/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_3/kernel"
      }
    }
  }
}
node {
  name: "conv2d_transpose_3/kernel/Adam_1/Initializer/zeros/shape_as_tensor"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_3/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\003\000\000\000\003\000\000\000\020\000\000\000\020\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_transpose_3/kernel/Adam_1/Initializer/zeros/Const"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_3/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_transpose_3/kernel/Adam_1/Initializer/zeros"
  op: "Fill"
  input: "conv2d_transpose_3/kernel/Adam_1/Initializer/zeros/shape_as_tensor"
  input: "conv2d_transpose_3/kernel/Adam_1/Initializer/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_3/kernel"
      }
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_transpose_3/kernel/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_3/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 3
        }
        dim {
          size: 3
        }
        dim {
          size: 16
        }
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_transpose_3/kernel/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_transpose_3/kernel/Adam_1"
  input: "conv2d_transpose_3/kernel/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_3/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_transpose_3/kernel/Adam_1/read"
  op: "Identity"
  input: "conv2d_transpose_3/kernel/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_3/kernel"
      }
    }
  }
}
node {
  name: "conv2d_transpose_3/bias/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_3/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 16
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_transpose_3/bias/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_3/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_transpose_3/bias/Adam/Assign"
  op: "Assign"
  input: "conv2d_transpose_3/bias/Adam"
  input: "conv2d_transpose_3/bias/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_3/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_transpose_3/bias/Adam/read"
  op: "Identity"
  input: "conv2d_transpose_3/bias/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_3/bias"
      }
    }
  }
}
node {
  name: "conv2d_transpose_3/bias/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_3/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 16
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_transpose_3/bias/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_3/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_transpose_3/bias/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_transpose_3/bias/Adam_1"
  input: "conv2d_transpose_3/bias/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_3/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_transpose_3/bias/Adam_1/read"
  op: "Identity"
  input: "conv2d_transpose_3/bias/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_3/bias"
      }
    }
  }
}
node {
  name: "conv2d_20/kernel/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_20/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 1
          }
          dim {
            size: 1
          }
          dim {
            size: 32
          }
          dim {
            size: 16
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_20/kernel/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_20/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 1
        }
        dim {
          size: 1
        }
        dim {
          size: 32
        }
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_20/kernel/Adam/Assign"
  op: "Assign"
  input: "conv2d_20/kernel/Adam"
  input: "conv2d_20/kernel/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_20/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_20/kernel/Adam/read"
  op: "Identity"
  input: "conv2d_20/kernel/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_20/kernel"
      }
    }
  }
}
node {
  name: "conv2d_20/kernel/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_20/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 1
          }
          dim {
            size: 1
          }
          dim {
            size: 32
          }
          dim {
            size: 16
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_20/kernel/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_20/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 1
        }
        dim {
          size: 1
        }
        dim {
          size: 32
        }
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_20/kernel/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_20/kernel/Adam_1"
  input: "conv2d_20/kernel/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_20/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_20/kernel/Adam_1/read"
  op: "Identity"
  input: "conv2d_20/kernel/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_20/kernel"
      }
    }
  }
}
node {
  name: "conv2d_20/bias/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_20/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 16
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_20/bias/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_20/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_20/bias/Adam/Assign"
  op: "Assign"
  input: "conv2d_20/bias/Adam"
  input: "conv2d_20/bias/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_20/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_20/bias/Adam/read"
  op: "Identity"
  input: "conv2d_20/bias/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_20/bias"
      }
    }
  }
}
node {
  name: "conv2d_20/bias/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_20/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 16
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_20/bias/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_20/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_20/bias/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_20/bias/Adam_1"
  input: "conv2d_20/bias/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_20/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_20/bias/Adam_1/read"
  op: "Identity"
  input: "conv2d_20/bias/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_20/bias"
      }
    }
  }
}
node {
  name: "conv2d_21/kernel/Adam/Initializer/zeros/shape_as_tensor"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_21/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\004\000\000\000\004\000\000\000\020\000\000\000\030\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_21/kernel/Adam/Initializer/zeros/Const"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_21/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_21/kernel/Adam/Initializer/zeros"
  op: "Fill"
  input: "conv2d_21/kernel/Adam/Initializer/zeros/shape_as_tensor"
  input: "conv2d_21/kernel/Adam/Initializer/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_21/kernel"
      }
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_21/kernel/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_21/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 4
        }
        dim {
          size: 4
        }
        dim {
          size: 16
        }
        dim {
          size: 24
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_21/kernel/Adam/Assign"
  op: "Assign"
  input: "conv2d_21/kernel/Adam"
  input: "conv2d_21/kernel/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_21/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_21/kernel/Adam/read"
  op: "Identity"
  input: "conv2d_21/kernel/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_21/kernel"
      }
    }
  }
}
node {
  name: "conv2d_21/kernel/Adam_1/Initializer/zeros/shape_as_tensor"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_21/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\004\000\000\000\004\000\000\000\020\000\000\000\030\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_21/kernel/Adam_1/Initializer/zeros/Const"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_21/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_21/kernel/Adam_1/Initializer/zeros"
  op: "Fill"
  input: "conv2d_21/kernel/Adam_1/Initializer/zeros/shape_as_tensor"
  input: "conv2d_21/kernel/Adam_1/Initializer/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_21/kernel"
      }
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_21/kernel/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_21/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 4
        }
        dim {
          size: 4
        }
        dim {
          size: 16
        }
        dim {
          size: 24
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_21/kernel/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_21/kernel/Adam_1"
  input: "conv2d_21/kernel/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_21/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_21/kernel/Adam_1/read"
  op: "Identity"
  input: "conv2d_21/kernel/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_21/kernel"
      }
    }
  }
}
node {
  name: "conv2d_21/bias/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_21/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 24
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_21/bias/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_21/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 24
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_21/bias/Adam/Assign"
  op: "Assign"
  input: "conv2d_21/bias/Adam"
  input: "conv2d_21/bias/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_21/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_21/bias/Adam/read"
  op: "Identity"
  input: "conv2d_21/bias/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_21/bias"
      }
    }
  }
}
node {
  name: "conv2d_21/bias/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_21/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 24
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_21/bias/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_21/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 24
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_21/bias/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_21/bias/Adam_1"
  input: "conv2d_21/bias/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_21/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_21/bias/Adam_1/read"
  op: "Identity"
  input: "conv2d_21/bias/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_21/bias"
      }
    }
  }
}
node {
  name: "conv2d_transpose_4/kernel/Adam/Initializer/zeros/shape_as_tensor"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_4/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\004\000\000\000\004\000\000\000\030\000\000\000\030\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_transpose_4/kernel/Adam/Initializer/zeros/Const"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_4/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_transpose_4/kernel/Adam/Initializer/zeros"
  op: "Fill"
  input: "conv2d_transpose_4/kernel/Adam/Initializer/zeros/shape_as_tensor"
  input: "conv2d_transpose_4/kernel/Adam/Initializer/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_4/kernel"
      }
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_transpose_4/kernel/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_4/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 4
        }
        dim {
          size: 4
        }
        dim {
          size: 24
        }
        dim {
          size: 24
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_transpose_4/kernel/Adam/Assign"
  op: "Assign"
  input: "conv2d_transpose_4/kernel/Adam"
  input: "conv2d_transpose_4/kernel/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_4/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_transpose_4/kernel/Adam/read"
  op: "Identity"
  input: "conv2d_transpose_4/kernel/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_4/kernel"
      }
    }
  }
}
node {
  name: "conv2d_transpose_4/kernel/Adam_1/Initializer/zeros/shape_as_tensor"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_4/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\004\000\000\000\004\000\000\000\030\000\000\000\030\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_transpose_4/kernel/Adam_1/Initializer/zeros/Const"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_4/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_transpose_4/kernel/Adam_1/Initializer/zeros"
  op: "Fill"
  input: "conv2d_transpose_4/kernel/Adam_1/Initializer/zeros/shape_as_tensor"
  input: "conv2d_transpose_4/kernel/Adam_1/Initializer/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_4/kernel"
      }
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_transpose_4/kernel/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_4/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 4
        }
        dim {
          size: 4
        }
        dim {
          size: 24
        }
        dim {
          size: 24
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_transpose_4/kernel/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_transpose_4/kernel/Adam_1"
  input: "conv2d_transpose_4/kernel/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_4/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_transpose_4/kernel/Adam_1/read"
  op: "Identity"
  input: "conv2d_transpose_4/kernel/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_4/kernel"
      }
    }
  }
}
node {
  name: "conv2d_transpose_4/bias/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_4/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 24
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_transpose_4/bias/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_4/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 24
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_transpose_4/bias/Adam/Assign"
  op: "Assign"
  input: "conv2d_transpose_4/bias/Adam"
  input: "conv2d_transpose_4/bias/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_4/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_transpose_4/bias/Adam/read"
  op: "Identity"
  input: "conv2d_transpose_4/bias/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_4/bias"
      }
    }
  }
}
node {
  name: "conv2d_transpose_4/bias/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_4/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 24
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_transpose_4/bias/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_4/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 24
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_transpose_4/bias/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_transpose_4/bias/Adam_1"
  input: "conv2d_transpose_4/bias/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_4/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_transpose_4/bias/Adam_1/read"
  op: "Identity"
  input: "conv2d_transpose_4/bias/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_transpose_4/bias"
      }
    }
  }
}
node {
  name: "conv2d_22/kernel/Adam/Initializer/zeros/shape_as_tensor"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_22/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\005\000\000\000\005\000\000\000\033\000\000\000\020\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_22/kernel/Adam/Initializer/zeros/Const"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_22/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_22/kernel/Adam/Initializer/zeros"
  op: "Fill"
  input: "conv2d_22/kernel/Adam/Initializer/zeros/shape_as_tensor"
  input: "conv2d_22/kernel/Adam/Initializer/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_22/kernel"
      }
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_22/kernel/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_22/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 5
        }
        dim {
          size: 5
        }
        dim {
          size: 27
        }
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_22/kernel/Adam/Assign"
  op: "Assign"
  input: "conv2d_22/kernel/Adam"
  input: "conv2d_22/kernel/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_22/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_22/kernel/Adam/read"
  op: "Identity"
  input: "conv2d_22/kernel/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_22/kernel"
      }
    }
  }
}
node {
  name: "conv2d_22/kernel/Adam_1/Initializer/zeros/shape_as_tensor"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_22/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\005\000\000\000\005\000\000\000\033\000\000\000\020\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_22/kernel/Adam_1/Initializer/zeros/Const"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_22/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_22/kernel/Adam_1/Initializer/zeros"
  op: "Fill"
  input: "conv2d_22/kernel/Adam_1/Initializer/zeros/shape_as_tensor"
  input: "conv2d_22/kernel/Adam_1/Initializer/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_22/kernel"
      }
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_22/kernel/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_22/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 5
        }
        dim {
          size: 5
        }
        dim {
          size: 27
        }
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_22/kernel/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_22/kernel/Adam_1"
  input: "conv2d_22/kernel/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_22/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_22/kernel/Adam_1/read"
  op: "Identity"
  input: "conv2d_22/kernel/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_22/kernel"
      }
    }
  }
}
node {
  name: "conv2d_22/bias/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_22/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 16
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_22/bias/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_22/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_22/bias/Adam/Assign"
  op: "Assign"
  input: "conv2d_22/bias/Adam"
  input: "conv2d_22/bias/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_22/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_22/bias/Adam/read"
  op: "Identity"
  input: "conv2d_22/bias/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_22/bias"
      }
    }
  }
}
node {
  name: "conv2d_22/bias/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_22/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 16
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_22/bias/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_22/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 16
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_22/bias/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_22/bias/Adam_1"
  input: "conv2d_22/bias/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_22/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_22/bias/Adam_1/read"
  op: "Identity"
  input: "conv2d_22/bias/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_22/bias"
      }
    }
  }
}
node {
  name: "conv2d_23/kernel/Adam/Initializer/zeros/shape_as_tensor"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_23/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\006\000\000\000\006\000\000\000\020\000\000\000\030\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_23/kernel/Adam/Initializer/zeros/Const"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_23/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_23/kernel/Adam/Initializer/zeros"
  op: "Fill"
  input: "conv2d_23/kernel/Adam/Initializer/zeros/shape_as_tensor"
  input: "conv2d_23/kernel/Adam/Initializer/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_23/kernel"
      }
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_23/kernel/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_23/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 6
        }
        dim {
          size: 6
        }
        dim {
          size: 16
        }
        dim {
          size: 24
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_23/kernel/Adam/Assign"
  op: "Assign"
  input: "conv2d_23/kernel/Adam"
  input: "conv2d_23/kernel/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_23/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_23/kernel/Adam/read"
  op: "Identity"
  input: "conv2d_23/kernel/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_23/kernel"
      }
    }
  }
}
node {
  name: "conv2d_23/kernel/Adam_1/Initializer/zeros/shape_as_tensor"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_23/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\006\000\000\000\006\000\000\000\020\000\000\000\030\000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_23/kernel/Adam_1/Initializer/zeros/Const"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_23/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_23/kernel/Adam_1/Initializer/zeros"
  op: "Fill"
  input: "conv2d_23/kernel/Adam_1/Initializer/zeros/shape_as_tensor"
  input: "conv2d_23/kernel/Adam_1/Initializer/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_23/kernel"
      }
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_23/kernel/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_23/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 6
        }
        dim {
          size: 6
        }
        dim {
          size: 16
        }
        dim {
          size: 24
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_23/kernel/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_23/kernel/Adam_1"
  input: "conv2d_23/kernel/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_23/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_23/kernel/Adam_1/read"
  op: "Identity"
  input: "conv2d_23/kernel/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_23/kernel"
      }
    }
  }
}
node {
  name: "conv2d_23/bias/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_23/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 24
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_23/bias/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_23/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 24
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_23/bias/Adam/Assign"
  op: "Assign"
  input: "conv2d_23/bias/Adam"
  input: "conv2d_23/bias/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_23/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_23/bias/Adam/read"
  op: "Identity"
  input: "conv2d_23/bias/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_23/bias"
      }
    }
  }
}
node {
  name: "conv2d_23/bias/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_23/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 24
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_23/bias/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_23/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 24
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_23/bias/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_23/bias/Adam_1"
  input: "conv2d_23/bias/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_23/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_23/bias/Adam_1/read"
  op: "Identity"
  input: "conv2d_23/bias/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_23/bias"
      }
    }
  }
}
node {
  name: "conv2d_24/kernel/Adam/Initializer/zeros/shape_as_tensor"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_24/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\010\000\000\000\010\000\000\000\030\000\000\000 \000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_24/kernel/Adam/Initializer/zeros/Const"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_24/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_24/kernel/Adam/Initializer/zeros"
  op: "Fill"
  input: "conv2d_24/kernel/Adam/Initializer/zeros/shape_as_tensor"
  input: "conv2d_24/kernel/Adam/Initializer/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_24/kernel"
      }
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_24/kernel/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_24/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
        dim {
          size: 8
        }
        dim {
          size: 24
        }
        dim {
          size: 32
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_24/kernel/Adam/Assign"
  op: "Assign"
  input: "conv2d_24/kernel/Adam"
  input: "conv2d_24/kernel/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_24/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_24/kernel/Adam/read"
  op: "Identity"
  input: "conv2d_24/kernel/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_24/kernel"
      }
    }
  }
}
node {
  name: "conv2d_24/kernel/Adam_1/Initializer/zeros/shape_as_tensor"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_24/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_INT32
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_INT32
        tensor_shape {
          dim {
            size: 4
          }
        }
        tensor_content: "\010\000\000\000\010\000\000\000\030\000\000\000 \000\000\000"
      }
    }
  }
}
node {
  name: "conv2d_24/kernel/Adam_1/Initializer/zeros/Const"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_24/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_24/kernel/Adam_1/Initializer/zeros"
  op: "Fill"
  input: "conv2d_24/kernel/Adam_1/Initializer/zeros/shape_as_tensor"
  input: "conv2d_24/kernel/Adam_1/Initializer/zeros/Const"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_24/kernel"
      }
    }
  }
  attr {
    key: "index_type"
    value {
      type: DT_INT32
    }
  }
}
node {
  name: "conv2d_24/kernel/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_24/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 8
        }
        dim {
          size: 8
        }
        dim {
          size: 24
        }
        dim {
          size: 32
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_24/kernel/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_24/kernel/Adam_1"
  input: "conv2d_24/kernel/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_24/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_24/kernel/Adam_1/read"
  op: "Identity"
  input: "conv2d_24/kernel/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_24/kernel"
      }
    }
  }
}
node {
  name: "conv2d_24/bias/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_24/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 32
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_24/bias/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_24/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 32
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_24/bias/Adam/Assign"
  op: "Assign"
  input: "conv2d_24/bias/Adam"
  input: "conv2d_24/bias/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_24/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_24/bias/Adam/read"
  op: "Identity"
  input: "conv2d_24/bias/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_24/bias"
      }
    }
  }
}
node {
  name: "conv2d_24/bias/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_24/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 32
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_24/bias/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_24/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 32
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_24/bias/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_24/bias/Adam_1"
  input: "conv2d_24/bias/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_24/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_24/bias/Adam_1/read"
  op: "Identity"
  input: "conv2d_24/bias/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_24/bias"
      }
    }
  }
}
node {
  name: "conv2d_25/kernel/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_25/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 2
          }
          dim {
            size: 2
          }
          dim {
            size: 32
          }
          dim {
            size: 3
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_25/kernel/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_25/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 2
        }
        dim {
          size: 2
        }
        dim {
          size: 32
        }
        dim {
          size: 3
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_25/kernel/Adam/Assign"
  op: "Assign"
  input: "conv2d_25/kernel/Adam"
  input: "conv2d_25/kernel/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_25/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_25/kernel/Adam/read"
  op: "Identity"
  input: "conv2d_25/kernel/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_25/kernel"
      }
    }
  }
}
node {
  name: "conv2d_25/kernel/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_25/kernel"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 2
          }
          dim {
            size: 2
          }
          dim {
            size: 32
          }
          dim {
            size: 3
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_25/kernel/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_25/kernel"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 2
        }
        dim {
          size: 2
        }
        dim {
          size: 32
        }
        dim {
          size: 3
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_25/kernel/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_25/kernel/Adam_1"
  input: "conv2d_25/kernel/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_25/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_25/kernel/Adam_1/read"
  op: "Identity"
  input: "conv2d_25/kernel/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_25/kernel"
      }
    }
  }
}
node {
  name: "conv2d_25/bias/Adam/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_25/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 3
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_25/bias/Adam"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_25/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 3
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_25/bias/Adam/Assign"
  op: "Assign"
  input: "conv2d_25/bias/Adam"
  input: "conv2d_25/bias/Adam/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_25/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_25/bias/Adam/read"
  op: "Identity"
  input: "conv2d_25/bias/Adam"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_25/bias"
      }
    }
  }
}
node {
  name: "conv2d_25/bias/Adam_1/Initializer/zeros"
  op: "Const"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_25/bias"
      }
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
          dim {
            size: 3
          }
        }
        float_val: 0.0
      }
    }
  }
}
node {
  name: "conv2d_25/bias/Adam_1"
  op: "VariableV2"
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_25/bias"
      }
    }
  }
  attr {
    key: "container"
    value {
      s: ""
    }
  }
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "shape"
    value {
      shape {
        dim {
          size: 3
        }
      }
    }
  }
  attr {
    key: "shared_name"
    value {
      s: ""
    }
  }
}
node {
  name: "conv2d_25/bias/Adam_1/Assign"
  op: "Assign"
  input: "conv2d_25/bias/Adam_1"
  input: "conv2d_25/bias/Adam_1/Initializer/zeros"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_25/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: true
    }
  }
  attr {
    key: "validate_shape"
    value {
      b: true
    }
  }
}
node {
  name: "conv2d_25/bias/Adam_1/read"
  op: "Identity"
  input: "conv2d_25/bias/Adam_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_25/bias"
      }
    }
  }
}
node {
  name: "Adam/learning_rate"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 1.9999999494757503e-05
      }
    }
  }
}
node {
  name: "Adam/beta1"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.8999999761581421
      }
    }
  }
}
node {
  name: "Adam/beta2"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 0.9990000128746033
      }
    }
  }
}
node {
  name: "Adam/epsilon"
  op: "Const"
  attr {
    key: "dtype"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "value"
    value {
      tensor {
        dtype: DT_FLOAT
        tensor_shape {
        }
        float_val: 9.99999993922529e-09
      }
    }
  }
}
node {
  name: "Adam/update_conv2d/kernel/ApplyAdam"
  op: "ApplyAdam"
  input: "conv2d/kernel"
  input: "conv2d/kernel/Adam"
  input: "conv2d/kernel/Adam_1"
  input: "beta1_power/read"
  input: "beta2_power/read"
  input: "Adam/learning_rate"
  input: "Adam/beta1"
  input: "Adam/beta2"
  input: "Adam/epsilon"
  input: "gradients/conv2d/Conv2D_grad/tuple/control_dependency_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: false
    }
  }
  attr {
    key: "use_nesterov"
    value {
      b: false
    }
  }
}
node {
  name: "Adam/update_conv2d/bias/ApplyAdam"
  op: "ApplyAdam"
  input: "conv2d/bias"
  input: "conv2d/bias/Adam"
  input: "conv2d/bias/Adam_1"
  input: "beta1_power/read"
  input: "beta2_power/read"
  input: "Adam/learning_rate"
  input: "Adam/beta1"
  input: "Adam/beta2"
  input: "Adam/epsilon"
  input: "gradients/conv2d/BiasAdd_grad/tuple/control_dependency_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: false
    }
  }
  attr {
    key: "use_nesterov"
    value {
      b: false
    }
  }
}
node {
  name: "Adam/update_conv2d_1/kernel/ApplyAdam"
  op: "ApplyAdam"
  input: "conv2d_1/kernel"
  input: "conv2d_1/kernel/Adam"
  input: "conv2d_1/kernel/Adam_1"
  input: "beta1_power/read"
  input: "beta2_power/read"
  input: "Adam/learning_rate"
  input: "Adam/beta1"
  input: "Adam/beta2"
  input: "Adam/epsilon"
  input: "gradients/conv2d_1/Conv2D_grad/tuple/control_dependency_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_1/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: false
    }
  }
  attr {
    key: "use_nesterov"
    value {
      b: false
    }
  }
}
node {
  name: "Adam/update_conv2d_1/bias/ApplyAdam"
  op: "ApplyAdam"
  input: "conv2d_1/bias"
  input: "conv2d_1/bias/Adam"
  input: "conv2d_1/bias/Adam_1"
  input: "beta1_power/read"
  input: "beta2_power/read"
  input: "Adam/learning_rate"
  input: "Adam/beta1"
  input: "Adam/beta2"
  input: "Adam/epsilon"
  input: "gradients/conv2d_1/BiasAdd_grad/tuple/control_dependency_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_1/bias"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: false
    }
  }
  attr {
    key: "use_nesterov"
    value {
      b: false
    }
  }
}
node {
  name: "Adam/update_conv2d_2/kernel/ApplyAdam"
  op: "ApplyAdam"
  input: "conv2d_2/kernel"
  input: "conv2d_2/kernel/Adam"
  input: "conv2d_2/kernel/Adam_1"
  input: "beta1_power/read"
  input: "beta2_power/read"
  input: "Adam/learning_rate"
  input: "Adam/beta1"
  input: "Adam/beta2"
  input: "Adam/epsilon"
  input: "gradients/conv2d_2/Conv2D_grad/tuple/control_dependency_1"
  attr {
    key: "T"
    value {
      type: DT_FLOAT
    }
  }
  attr {
    key: "_class"
    value {
      list {
        s: "loc:@conv2d_2/kernel"
      }
    }
  }
  attr {
    key: "use_locking"
    value {
      b: false
    }
  }
  attr {
    key: "use_nesterov"
    value {
      b: false
    }
  }
}
node {
  name: "Adam/update_conv2d_2/bias/ApplyAdam"
  attr {