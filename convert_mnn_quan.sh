#!/bin/bash

if [ ! -d "models_int8" ];then
    mkdir models_int8
fi

rm -rf models_int8/*

path="/root/peter/autoTest/sj/perf_test_mnn/build/models"
files=$(ls $path)
for filename in $files
do
    echo $filename
    var=${filename//.mnn/}
    echo $var
    echo "./quantized.out models/${filename} models_int8/${var}_quan.mnn pretreatConfig.json"
    ./quantized.out models/${filename} models_int8/${var}_quan.mnn pretreatConfig.json
done
