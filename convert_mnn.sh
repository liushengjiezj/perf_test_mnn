#!/bin/bash

bench=""
convert_caffe=""
convert_onnx=""
convert_tf=""
convert_tflite=""

function usage() {
    echo "-b\tConvert models with performance type"
    echo "-c\tConvert caffe models"
    echo "-o\tConvert ONNX models"
    echo "-tf\tConvert tensorflow models"
    echo "-tflite\Convert tensorflow lite models"
}

function caffe() {
    # caffe
    ./MNNConvert -f CAFFE --modelFile /root/peter/autoTest/models/MobileNetSSD_deploy.caffemodel --prototxt /root/peter/autoTest/models/MobileNetSSD_deploy.prototxt --MNNModel models/Caffe_MobileNetSSD.mnn --bizCode MNN ${bench}

    ./MNNConvert -f CAFFE --modelFile /root/peter/autoTest/models/yufacedetect/yufacedetectnet-open-v1_new.caffemodel --prototxt /root/peter/autoTest/models/yufacedetect/yufacedetectnet-open-v1_new.prototxt --MNNModel models/Caffe_yufacedetect.mnn --bizCode MNN ${bench}

    ./MNNConvert -f CAFFE --modelFile /root/peter/autoTest/models/alexnet.caffemodel --prototxt /root/peter/autoTest/models/alex_deploy.prototxt --MNNModel models/Caffe_alexnet.mnn --bizCode MNN ${bench}

    ./MNNConvert -f CAFFE --modelFile /root/peter/autoTest/models/googlenet.caffemodel --prototxt /root/peter/autoTest/models/googlenet.prototxt --MNNModel models/Caffe_googlenet.mnn --bizCode MNN ${bench}

    ./MNNConvert -f CAFFE --modelFile /root/peter/autoTest/models/deploy_inceptionV3.caffemodel --prototxt /root/peter/autoTest/models/deploy_inceptionV3.prototxt --MNNModel models/Caffe_inception_v3.mnn --bizCode MNN ${bench}

    ./MNNConvert -f CAFFE --modelFile /root/peter/autoTest/models/mnasnet.caffemodel --prototxt /root/peter/autoTest/models/mnasnet.prototxt --MNNModel models/Caffe_mnasnet.mnn --bizCode MNN ${bench}

    ./MNNConvert -f CAFFE --modelFile /root/peter/autoTest/models/mobilenet.caffemodel --prototxt /root/peter/autoTest/models/mobilenet_deploy.prototxt --MNNModel models/Caffe_mobilenet_V1_0.mnn --bizCode MNN ${bench}

    ./MNNConvert -f CAFFE --modelFile /root/peter/autoTest/models/mobilenet_v2.caffemodel --prototxt /root/peter/autoTest/models/mobilenet_v2_deploy.prototxt --MNNModel models/Caffe_mobilenetv2_1_0.mnn --bizCode MNN ${bench}

    ./MNNConvert -f CAFFE --modelFile /root/peter/autoTest/models/mobilenet_yolov3_lite_deploy.caffemodel --prototxt /root/peter/autoTest/models/mobilenet_yolov3_lite_deploy.prototxt --MNNModel models/Caffe_mobilenetv2_yolov3.mnn --bizCode MNN ${bench}

    ./MNNConvert -f CAFFE --modelFile /root/peter/autoTest/models/resnet50.caffemodel --prototxt /root/peter/autoTest/models/resnet50.prototxt --MNNModel models/Caffe_resnet50.mnn --bizCode MNN ${bench}

    ./MNNConvert -f CAFFE --modelFile /root/peter/autoTest/models/shufflenet_1x_g3.caffemodel --prototxt /root/peter/autoTest/models/shufflenet_1x_g3.prototxt --MNNModel models/Caffe_shufflenet_1xg3.mnn --bizCode MNN ${bench}

    ./MNNConvert -f CAFFE --modelFile /root/peter/autoTest/models/shufflenet_v2_x0.5.caffemodel --prototxt /root/peter/autoTest/models/shufflenet_v2_x0.5.prototxt --MNNModel models/Caffe_shufflenet_v2.mnn --bizCode MNN ${bench}

    ./MNNConvert -f CAFFE --modelFile /root/peter/autoTest/models/squeezenet_v1.1.caffemodel --prototxt /root/peter/autoTest/models/sqz.prototxt --MNNModel models/Caffe_squeezenet_V1_1.mnn --bizCode MNN ${bench}

    ./MNNConvert -f CAFFE --modelFile /root/peter/autoTest/models/squeezenet_ssd.caffemodel --prototxt /root/peter/autoTest/models/squeezenet_ssd.prototxt --MNNModel models/Caffe_squeezenet_ssd.mnn --bizCode MNN ${bench}

    ./MNNConvert -f CAFFE --modelFile /root/peter/autoTest/models/vgg16.caffemodel --prototxt /root/peter/autoTest/models/vgg16.prototxt --MNNModel models/Caffe_vgg16.mnn --bizCode MNN ${bench}

    ./MNNConvert -f CAFFE --modelFile /root/peter/autoTest/models/shufflenet_1x_g3.caffemodel --prototxt /root/peter/autoTest/models/shufflenet_1x_g3.prototxt --MNNModel models/Caffe_shufflenet_1xg3.mnn --bizCode MNN ${bench}
}

function onnx() {
    # onnx
    ./MNNConvert -f ONNX --modelFile /root/peter/autoTest/models/sqz.onnx.model --MNNModel models/Onnx_squeezenet.mnn --bizCode MNN ${bench}
}

function tensorflow() {
    # tensorflow
    ./MNNConvert -f TF --modelFile /root/peter/autoTest/models/squeezenet.pb --MNNModel models/tensorflow_squeezenet.mnn --bizCode MNN ${bench}
    ./MNNConvert -f TF --modelFile /root/peter/autoTest/models/mobilenet_v1_1.0_224_frozen.pb --MNNModel models/tensorflow_mobilenet_v1_0.mnn --bizCode MNN ${bench}
    ./MNNConvert -f TF --modelFile /root/peter/autoTest/models/mobilenet_v2_1.0_224_frozen.pb --MNNModel models/tensorflow_mobilenet_v2.mnn --bizCode MNN ${bench}
    ./MNNConvert -f TF --modelFile /root/peter/autoTest/models/inception_v3.pb --MNNModel models/tensorflow_inception_v3.mnn --bizCode MNN ${bench}
    ./MNNConvert -f TF --modelFile /root/peter/autoTest/models/frozen_resnet50v1.pb --MNNModel models/tensorflow_resnet50.mnn --bizCode MNN ${bench}
    ./MNNConvert -f TF --modelFile /root/peter/autoTest/models/resnet_v2_101_299_frozen.pb --MNNModel models/tensorflow_resnet_v2.mnn --bizCode MNN ${bench}
    ./MNNConvert -f TF --modelFile /root/peter/autoTest/models/nasnet_mobile.pb --MNNModel models/tensorflow_nasnet.mnn --bizCode MNN ${bench}
    ./MNNConvert -f TF --modelFile /root/peter/autoTest/models/densenet.pb --MNNModel models/tensorflow_densenet.mnn --bizCode MNN ${bench}
}

function tflite() {
    # tensorflow lite
    ./MNNConvert -f TFLITE --modelFile /root/peter/autoTest/models/mobilenet_quant_v1_224.tflite --MNNModel models/tflite_mobilenet_v1_0.mnn --bizCode MNN ${bench}
    ./MNNConvert -f TFLITE --modelFile /root/peter/autoTest/models/mobilenet_v2_1.0_224_quant.tflite --MNNModel models/tflite_mobilenet_v2.mnn --bizCode MNN ${bench}
    ./MNNConvert -f TFLITE --modelFile /root/peter/autoTest/models/inception_v3_quant.tflite --MNNModel models/tflite_inception_v3.mnn --bizCode MNN ${bench}
}

while [ "$1" != "" ]; do
    case $1 in
        -b)
            shift
            bench="--benchmarkModel"
            ;;
        -c)
            shift
            convert_caffe="true"
            ;;
        -o)
            shift
            convert_onnx="true"
            ;;
        -tf)
            shift
            convert_tf="true"
            ;;
        -tflite)
            shift
            convert_tflite="true"
            ;;
        *)
            usage
            exit 1
    esac
done

# fp32
if [ ! -d "models" ];then
    mkdir models
fi

rm -rf models/*

if [[ ${convert_caffe} = "true" ]];then
    caffe
fi

if [[ ${convert_onnx} = "true" ]];then
    onnx
fi

if [[ ${convert_tf} = "true" ]];then
    tensorflow
fi

if [[ ${convert_tflite} = "true" ]];then
    tflite
fi
