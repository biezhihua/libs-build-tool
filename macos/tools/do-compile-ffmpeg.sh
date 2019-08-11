#! /usr/bin/env bash

RED='\033[0;31m'
Green='\033[0;33m'
NC='\033[0m' # No Color

echo "--------------------"
echo "${RED}[*] check input params [检查输入参数] $1 ${NC}"
echo "--------------------"

ARCH=$1
BUILD_OPT=$2

echo "ARCH[架构] = $ARCH"
echo "BUILD_OPT[构建参数] = $BUILD_OPT"

if [ -z "$ARCH" ]; then
    echo "You must specific an architecture 'x86_64, ...'."
    exit 1
fi


BUILD_ROOT=`pwd`/tools

BUILD_NAME=

FFMPEG_SOURCE_PATH=

CFG_FLAGS=

# --extra-cflags would provide extra command-line switches for the C compiler,
CFLAGS=

# --extra-ldflags would provide extra flags for the linker. 
LDFLAGS=

PRODUCT=product

SO_SIMPLE_NAME=sffmpeg
SO_NAME=lib${SPLAYER_SO_SIMPLE_NAME}.so

echo ""
echo "--------------------"
echo "${RED}[*] make pre params [确定预参数] ${NC}"
echo "--------------------"

if [ "$ARCH" = "x86_64" ]; then
    
    BUILD_NAME=ffmpeg-x86_64

    FFMPEG_SOURCE_PATH=${BUILD_ROOT}/${BUILD_NAME}

    CFG_FLAGS="$CFG_FLAGS "

    CFLAGS="$CFLAGS "

    LDFLAGS="$LDFLAGS "

else
    echo "unknown architecture $ARCH";
    exit 1
fi

if [ ! -d ${FFMPEG_SOURCE_PATH} ]; then
    echo ""
    echo "!! ERROR"
    echo "!! Can not find FFmpeg directory for $BUILD_NAME"
    echo ""
    exit 1
fi

FFMPEG_OUTPUT_PATH=${BUILD_ROOT}/build/${BUILD_NAME}/output
SHARED_OUTPUT_PATH=${BUILD_ROOT}/../${PRODUCT}/${BUILD_NAME}

rm -rf ${BUILD_ROOT}/build/${BUILD_NAME}
mkdir -p ${FFMPEG_OUTPUT_PATH}
mkdir -p ${SHARED_OUTPUT_PATH}

echo "BUILD_NAME[构建名称] = $BUILD_NAME"
echo ""
echo "CFG_FLAGS[编译参数] = $CFG_FLAGS"
echo ""
echo "CFLAGS[编译器参数] = $CFLAGS"
echo ""
echo "LDFLAGS[链接器参数] = $LDFLAGS"
echo ""
echo "FFMPEG_SOURCE_PATH[源码目录] = $FFMPEG_SOURCE_PATH"
echo ""
echo "FFMPEG_OUTPUT_PATH[编译输出目录] = $FFMPEG_OUTPUT_PATH"

echo ""
echo "--------------------"
echo "${RED}[*] make ffmpeg params [确定FFmpeg编译参数]  ${NC}"
echo "--------------------"

CFG_FLAGS="$CFG_FLAGS --prefix=$FFMPEG_OUTPUT_PATH"
CFG_FLAGS="$CFG_FLAGS --cc=clang --host-cflags= --host-ldflags="

case "$BUILD_OPT" in
    debug)
        CFG_FLAGS="$CFG_FLAGS --disable-optimizations"
        CFG_FLAGS="$CFG_FLAGS --enable-debug"
        CFG_FLAGS="$CFG_FLAGS --disable-small"
    ;;
    *)
        CFG_FLAGS="$CFG_FLAGS --enable-optimizations"
        CFG_FLAGS="$CFG_FLAGS --disable-debug"
        CFG_FLAGS="$CFG_FLAGS --enable-small"
    ;;
esac

export COMMON_CFG_FLAGS=
. ${BUILD_ROOT}/../config/module.sh

CFG_FLAGS="$CFG_FLAGS $COMMON_CFG_FLAGS"

echo "PATH[环境变量] = $PATH"
echo ""
echo "CFG_FLAGS[编译参数] = $CFG_FLAGS"
echo ""
echo "CFLAGS[编译器参数] = $CFLAGS"
echo ""
echo "LDFLAGS[链接器参数] = $LDFLAGS"

echo "--------------------"
echo "${RED}[*] configurate ffmpeg [配置FFmpeg] ${NC}"
echo "--------------------"

cd ${FFMPEG_SOURCE_PATH}

./configure ${CFG_FLAGS} \
    --extra-cflags="$CFLAGS" \
    --extra-ldflags="$LDFLAGS" 

make clean

echo ""
echo "--------------------"
echo "${RED}[*] compile ffmpeg [编译FFmpeg] ${NC}"
echo "--------------------"
echo "FFMPEG_OUTPUT_PATH = $FFMPEG_OUTPUT_PATH"

cp config.* ${FFMPEG_OUTPUT_PATH}

make -j8 > /dev/null

make install > /dev/null

mkdir -p ${FFMPEG_OUTPUT_PATH}/include/libffmpeg
cp -f config.h ${FFMPEG_OUTPUT_PATH}/include/libffmpeg/config.h

echo "LIB_CONFIG = ${FFMPEG_OUTPUT_PATH}/include/libffmpeg/config.h"
echo "FFmpeg install success"
