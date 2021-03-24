set -e
ABI="armeabi-v7a"
OPENMP="ON"
VULKAN="ON"
OPENCL="ON"
OPENGL="OFF"
RUN_LOOP=10
FORWARD_TYPE=0
CLEAN=""
PUSH_MODEL=""
BUILD=""

WORK_DIR=`pwd`
BENCHMARK_MODEL_DIR=$WORK_DIR/models
BENCHMARK_QUANT_MODEL_DIR=$WORK_DIR/models_int8
ANDROID_DIR=/data/local/tmp/benchmark_mnn

# ip addr of android device, must set before running script
SERIAL_ID=""
ANDROID_NDK="/root/peter/android-ndk-r16b"

function usage() {
    echo "-b\tMake Project"
    echo "-64\tBuild 64bit."
    echo "-c\tClean up build folders."
    echo "-p\tPush models to device"
}
function die() {
    echo $1
    exit 1
}

function clean_build() {
    echo $1 | grep "$BUILD_DIR\b" > /dev/null
    if [[ "$?" != "0" ]]; then
        die "Warnning: $1 seems not to be a BUILD folder."
    fi
    rm -rf $1
    mkdir $1
}

function build_android_bench() {
    if [ "-c" == "$CLEAN" ]; then
        clean_build $BUILD_DIR
    fi
    mkdir -p ${BUILD_DIR}
    cd $BUILD_DIR
    cmake ../../ \
          -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake \
          -DCMAKE_BUILD_TYPE=Release \
          -DANDROID_ABI="${ABI}" \
          -DANDROID_STL=c++_static \
          -DCMAKE_BUILD_TYPE=Release \
          -DANDROID_NATIVE_API_LEVEL=android-21  \
          -DANDROID_TOOLCHAIN=clang \
          -DMNN_VULKAN:BOOL=$VULKAN \
          -DMNN_OPENCL:BOOL=$OPENCL \
          -DMNN_OPENMP:BOOL=$OPENMP \
          -DMNN_OPENGL:BOOL=$OPENGL \
          -DMNN_DEBUG:BOOL=OFF \
          -DMNN_BUILD_BENCHMARK:BOOL=ON \
          -DMNN_BUILD_FOR_ANDROID_COMMAND=true \
          -DNATIVE_LIBRARY_OUTPUT=.
    make -j20 benchmark.out timeProfile.out
}

function bench_android() {
    build_android_bench
    find . -name "*.so" | while read solib; do
        adb -s $SERIAL_ID push $solib  $ANDROID_DIR
    done
    adb -s $SERIAL_ID push benchmark.out $ANDROID_DIR
    adb -s $SERIAL_ID push timeProfile.out $ANDROID_DIR
    adb -s $SERIAL_ID shell chmod 0777 $ANDROID_DIR/benchmark.out

    if [ "" != "$PUSH_MODEL" ]; then
        adb -s $SERIAL_ID shell "rm -rf $ANDROID_DIR/benchmark_models"
        adb -s $SERIAL_ID push $BENCHMARK_MODEL_DIR $ANDROID_DIR/benchmark_models
    fi
    adb -s $SERIAL_ID shell "cat /proc/cpuinfo > $ANDROID_DIR/benchmark.txt"
    adb -s $SERIAL_ID shell "echo >> $ANDROID_DIR/benchmark.txt"
    adb -s $SERIAL_ID shell "echo Build Flags: ABI=$ABI  OpenMP=$OPENMP Vulkan=$VULKAN OpenCL=$OPENCL >> $ANDROID_DIR/benchmark.txt"
    #benchmark  CPU
    adb -s $SERIAL_ID shell "LD_LIBRARY_PATH=$ANDROID_DIR $ANDROID_DIR/benchmark.out $ANDROID_DIR/benchmark_models $RUN_LOOP $FORWARD_TYPE 2>$ANDROID_DIR/benchmark.err >> $ANDROID_DIR/benchmark.txt"
    #benchmark  Vulkan
    adb -s $SERIAL_ID shell "LD_LIBRARY_PATH=$ANDROID_DIR $ANDROID_DIR/benchmark.out $ANDROID_DIR/benchmark_models $RUN_LOOP 7 2>$ANDROID_DIR/benchmark.err >> $ANDROID_DIR/benchmark.txt"
    #benchmark OpenGL
    #adb -s $SERIAL_ID shell "LD_LIBRARY_PATH=$ANDROID_DIR $ANDROID_DIR/benchmark.out $ANDROID_DIR/benchmark_models 10 6 2>$ANDROID_DIR/benchmark.err >> $ANDROID_DIR/benchmark.txt"
    #benchmark OpenCL
    #adb -s $SERIAL_ID shell "LD_LIBRARY_PATH=$ANDROID_DIR $ANDROID_DIR/benchmark.out $ANDROID_DIR/benchmark_models $RUN_LOOP 3 2>$ANDROID_DIR/benchmark.err >> $ANDROID_DIR/benchmark.txt"
    adb -s $SERIAL_ID pull $ANDROID_DIR/benchmark.txt ../
}

function init_env() {
    cd $BUILD_DIR
    find . -name "*.so" | while read solib; do
        adb -s $SERIAL_ID push $solib  $ANDROID_DIR
    done
    adb -s $SERIAL_ID push benchmark.out $ANDROID_DIR
    adb -s $SERIAL_ID push timeProfile.out $ANDROID_DIR
    adb -s $SERIAL_ID shell chmod 0777 $ANDROID_DIR/benchmark.out

    if [ "" != "$PUSH_MODEL" ]; then
        adb -s $SERIAL_ID shell "rm -rf $ANDROID_DIR/benchmark_models"
        adb -s $SERIAL_ID push $BENCHMARK_MODEL_DIR $ANDROID_DIR/benchmark_models
        adb -s $SERIAL_ID shell rm -rf $ANDROID_DIR/benchmark_quant_models
        adb -s $SERIAL_ID push $BENCHMARK_QUANT_MODEL_DIR $ANDROID_DIR/benchmark_quant_models
    fi
}

function run_bench() {
    adb -s $SERIAL_ID shell "cat /proc/cpuinfo > $ANDROID_DIR/benchmark.txt"
    adb -s $SERIAL_ID shell "echo >> $ANDROID_DIR/benchmark.txt"
    adb -s $SERIAL_ID shell "echo Build Flags: ABI=$ABI  OpenMP=$OPENMP Vulkan=$VULKAN OpenCL=$OPENCL >> $ANDROID_DIR/benchmark.txt"
    #benchmark  CPU
    adb -s $SERIAL_ID shell "LD_LIBRARY_PATH=$ANDROID_DIR $ANDROID_DIR/benchmark.out $ANDROID_DIR/benchmark_models $RUN_LOOP $FORWARD_TYPE 2>$ANDROID_DIR/benchmark.err >> $ANDROID_DIR/benchmark.txt"
    #benchmark  Vulkan
    adb -s $SERIAL_ID shell "LD_LIBRARY_PATH=$ANDROID_DIR $ANDROID_DIR/benchmark.out $ANDROID_DIR/benchmark_models $RUN_LOOP 7 2>$ANDROID_DIR/benchmark.err >> $ANDROID_DIR/benchmark.txt"
    #benchmark OpenGL
    #adb -s $SERIAL_ID shell "LD_LIBRARY_PATH=$ANDROID_DIR $ANDROID_DIR/benchmark.out $ANDROID_DIR/benchmark_models 10 6 2>$ANDROID_DIR/benchmark.err >> $ANDROID_DIR/benchmark.txt"
    #benchmark OpenCL
    #adb -s $SERIAL_ID shell "LD_LIBRARY_PATH=$ANDROID_DIR $ANDROID_DIR/benchmark.out $ANDROID_DIR/benchmark_models $RUN_LOOP 3 2>$ANDROID_DIR/benchmark.err >> $ANDROID_DIR/benchmark.txt"
    adb -s $SERIAL_ID pull $ANDROID_DIR/benchmark.txt ../
}

while [ "$1" != "" ]; do
    case $1 in
        -b)
            shift
            BUILD="build"
            ;;
        -64)
            shift
            ABI="arm64-v8a"
            ;;
        -c)
            shift
            CLEAN="-c"
            ;;
        -p)
            shift
            PUSH_MODEL="-p"
            ;;
        *)
            usage
            exit 1
    esac
done

BUILD_DIR=build-android-${ABI}

# bench_android
if [[ ${BUILD} = "build" ]];then
    build_android_bench
fi

if [[ ${PUSH_MODEL} = "-p" ]];then
    init_env
fi
# run_bench