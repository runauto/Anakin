#!/bin/bash
# This script shows how one can build a anakin for the Android platform using android-tool-chain. 
#export ANDROID_NDK=/Users/lixiaoyang05/Library/Android/sdk/ndk-bundle/
export ANDROID_NDK=/home/xiaoE/anakin-v2/arm_relevant/android-ndk-r14b/
ANAKIN_ROOT="$( cd "$(dirname "$0")"/.. ; pwd -P)"
echo "-- Anakin root dir is: $ANAKIN_ROOT"

if [ -z "$ANDROID_NDK" ]; then
    echo "-- Did you set ANDROID_NDK variable?"
    exit 1
fi

if [ -d "$ANDROID_NDK" ]; then
    echo "-- Using Android ndk at $ANDROID_NDK"
else
    echo "-- Cannot find ndk: did you install it under $ANDROID_NDK ?"
    exit 1
fi

# build the target into build_android.
BUILD_ROOT=$ANAKIN_ROOT/android_build

mkdir -p $BUILD_ROOT
echo "-- Build anakin Android into: $BUILD_ROOT"

# Now, actually build the android target.
echo "-- Building anakin ..."
cd $BUILD_ROOT

cmake .. \
    -DCMAKE_TOOLCHAIN_FILE=../cmake/android/android.toolchain.cmake \
    -DANDROID_NDK=$ANDROID_NDK \
    -DCMAKE_BUILD_TYPE=Release \
    -DANDROID_ABI="armeabi-v7a with NEON" \
	-DANDROID_NATIVE_API_LEVEL=21 \
	-DUSE_ARM_PLACE=YES \
	-DUSE_GPU_PLACE=NO \
	-DUSE_X86_PLACE=NO \
	-DTARGET_ANDRIOD=YES \
	-DBUILD_WITH_UNIT_TEST=YES \
    -DUSE_PYTHON=OFF \
	-DENABLE_DEBUG=YES \
	-DENABLE_VERBOSE_MSG=NO \
	-DDISABLE_ALL_WARNINGS=YES \
	-DENABLE_NOISY_WARNINGS=NO \
    -DUSE_OPENMP=YES\
	-DBUILD_SHARED=NO

# build target lib or unit test.
if [ "$(uname)" = 'Darwin' ]; then
    make "-j$(sysctl -n hw.ncpu)" && make install
else
    make "-j$(nproc)" && make install
fi

