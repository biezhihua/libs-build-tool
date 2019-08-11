#! /usr/bin/env bash

#normal=$(tput sgr0)                      # normal text
# Black        0;30     Dark Gray     1;30
# Red          0;31     Light Red     1;31
# Green        0;32     Light Green   1;32
# Brown/Orange 0;33     Yellow        1;33
# Blue         0;34     Light Blue    1;34
# Purple       0;35     Light Purple  1;35
# Cyan         0;36     Light Cyan    1;36
# Light Gray   0;37     White         1;37

RED='\033[0;31m'
Green='\033[0;33m'
NC='\033[0m' # No Color

echo "--------------------"
echo "${RED}[*] check env ing $1 ${NC}"
echo "--------------------"

ARCH=$1
BUILD_OPT=$2
REAL_OUTPUT_PATH=$3

echo "ARCH=$ARCH"
echo "BUILD_OPT=$BUILD_OPT"
echo "REAL_OUTPUT_PATH=$REAL_OUTPUT_PATH"

# -z 字符串	字符串的长度为零则为真
if [ -z "$ARCH" ]; then
    echo "You must specific an architecture 'armv8a, armv7a, x86, ...'."
    exit 1
fi

BUILD_ROOT=`pwd`/tools

PRODUCT=product

ANDROID_PLATFORM=android-21

BUILD_NAME=

OPENSOURCE_PATH=

CROSS_PREFIX_NAME=

CFG_FLAGS=
EXTRA_CFLAGS=

EXTRA_LDFLAGS=
DEP_LIBS=

LINK_MODULE_DIRS="compat libavcodec libavfilter libavformat libavutil libswresample libswscale"
ASSEMBLER_SUB_DIRS=

STANDALONE_TOOLCHAIN_FLAGS=
STANDALONE_TOOLCHAIN_NAME=
STANDALONE_TOOLCHAIN_ARCH=arm
STANDALONE_TOOLCHAIN_CLANG=clang3.6

PLATFORM_CFG_FLAGS=

echo ""
echo "--------------------"
echo "${RED}[*] make NDK env${NC}"
echo "--------------------"

UNAME_S=$(uname -s)
UNAME_SM=$(uname -sm)

echo "BUILD PLATFORM = $UNAME_SM"
echo "ANDROID_NDK = $ANDROID_NDK"

if [ -z "$ANDROID_NDK" ]; then
    echo "You must define ANDROID_NDK before starting."
    echo "They must point to your NDK directories."
    echo ""
    exit 1
fi

NDK_REL=$(grep -o '^Pkg\.Revision.*=[0-9]*.*' ${ANDROID_NDK}/source.properties 2>/dev/null | sed 's/[[:space:]]*//g' | cut -d "=" -f 2)

echo "NDK_REL = $NDK_REL"

case "$NDK_REL" in
    13*|14*|15*|16*|17*|18*|19*)
        if test -d ${ANDROID_NDK}/toolchains/arm-linux-androideabi-4.9
        then
            echo "NDK VERSION = r$NDK_REL"
        else
            echo "You need the NDK r16b r17c 18b 19"
            echo "https://developer.android.com/ndk/downloads/"
            exit 1
        fi
    ;;
    *)
        echo "You need the NDK r16b r17c 18b 19"
        echo "https://developer.android.com/ndk/downloads/"
        exit 1
    ;;
esac

echo ""
echo "--------------------"
echo "${RED}[*] make params${NC}"
echo "--------------------"

if [ "$ARCH" = "armv7a" ]; then
    
    BUILD_NAME=openssl-armv7a
    
    ANDROID_PLATFORM=android-21
    
    OPENSOURCE_PATH=${BUILD_ROOT}/${BUILD_NAME}
    
    CROSS_PREFIX_NAME=arm-linux-androideabi
    
    STANDALONE_TOOLCHAIN_NAME=arm-linux-android-${STANDALONE_TOOLCHAIN_CLANG}
    
    PLATFORM_CFG_FLAGS="android-arm"
    
    elif [ "$ARCH" = "armv8a" ]; then
    BUILD_NAME=openssl-armv8a
    
    ANDROID_PLATFORM=android-21
    
    OPENSOURCE_PATH=${BUILD_ROOT}/${BUILD_NAME}
    
    CROSS_PREFIX_NAME=aarch64-linux-android
    
    STANDALONE_TOOLCHAIN_NAME=aarch64-linux-android-${STANDALONE_TOOLCHAIN_CLANG}
    
    PLATFORM_CFG_FLAGS="android-arm64"
    
    elif [ "$ARCH" = "x86" ]; then
    
    BUILD_NAME=openssl-x86
    
    ANDROID_PLATFORM=android-21
    
    OPENSOURCE_PATH=${BUILD_ROOT}/${BUILD_NAME}
    
    CROSS_PREFIX_NAME=i686-linux-android
    
    STANDALONE_TOOLCHAIN_NAME=x86-linux-android-${STANDALONE_TOOLCHAIN_CLANG}
    
    CFG_FLAGS="$CFG_FLAGS no-asm"
    
    PLATFORM_CFG_FLAGS="android-x86"
    
    elif [ "$ARCH" = "x86_64" ]; then
    
    BUILD_NAME=openssl-x86_64
    
    case "$NDK_REL" in
        18*|19*)
            ANDROID_PLATFORM=android-23
        ;;
        13*|14*|15*|16*|17*)
            ANDROID_PLATFORM=android-21
        ;;
    esac
    
    OPENSOURCE_PATH=${BUILD_ROOT}/${BUILD_NAME}
    
    CROSS_PREFIX_NAME=x86_64-linux-android
    
    STANDALONE_TOOLCHAIN_NAME=x86_64-linux-android-${STANDALONE_TOOLCHAIN_CLANG}
    
    PLATFORM_CFG_FLAGS="android-x86_64"
    
else
    echo "unknown architecture $ARCH";
    exit 1
fi

if [ ! -d ${OPENSOURCE_PATH} ]; then
    echo ""
    echo "!! ERROR"
    echo "!! Can not find Openssl directory for $BUILD_NAME"
    echo "!! Run 'sh init-android-openssl.sh' first"
    echo ""
    exit 1
fi

OUTPUT_PATH=${BUILD_ROOT}/build/${BUILD_NAME}/output
SHARED_OUTPUT_PATH=${BUILD_ROOT}/../${PRODUCT}/${BUILD_NAME}
TOOLCHAIN_PATH=${BUILD_ROOT}/build/${BUILD_NAME}/toolchain
TOOLCHAIN_SYSROOT_PATH=${TOOLCHAIN_PATH}/sysroot

rm -rf ${BUILD_ROOT}/build/${BUILD_NAME}
rm -rf ${OUTPUT_PATH}
rm -rf ${SHARED_OUTPUT_PATH}
mkdir -p ${OUTPUT_PATH}
mkdir -p ${SHARED_OUTPUT_PATH}

echo "OPENSOURCE_PATH = $OPENSOURCE_PATH"
echo ""
echo "BUILD_NAME = $BUILD_NAME"
echo "BUILD_NAME_OPENSSL = $BUILD_NAME_OPENSSL"
echo "BUILD_NAME_LIBSOXR = $BUILD_NAME_LIBSOXR"
echo "CROSS_PREFIX_NAME = $CROSS_PREFIX_NAME"
echo "STANDALONE_TOOLCHAIN_NAME = $STANDALONE_TOOLCHAIN_NAME"
echo ""
echo "CFG_FLAGS = $CFG_FLAGS"
echo "EXTRA_CFLAGS = $EXTRA_CFLAGS"
echo "EXTRA_LDFLAGS = $EXTRA_LDFLAGS"
echo "ASSEMBLER_SUB_DIRS = $ASSEMBLER_SUB_DIRS"
echo ""
echo "OUTPUT_PATH = $OUTPUT_PATH"
echo "TOOLCHAIN_PATH = $TOOLCHAIN_PATH"
echo "TOOLCHAIN_SYSROOT_PATH = $TOOLCHAIN_SYSROOT_PATH"

echo ""
echo "--------------------"
echo "${RED}[*] make NDK standalone toolchain${NC}"
echo "--------------------"

STANDALONE_TOOLCHAIN_FLAGS="$STANDALONE_TOOLCHAIN_FLAGS --install-dir=$TOOLCHAIN_PATH"

echo "STANDALONE_TOOLCHAIN_NAME = $STANDALONE_TOOLCHAIN_NAME"
echo "STANDALONE_TOOLCHAIN_FLAGS = $STANDALONE_TOOLCHAIN_FLAGS"

echo "STANDALONE_TOOLCHAIN_ARCH = $STANDALONE_TOOLCHAIN_ARCH"
echo "STANDALONE_TOOLCHAIN_CLANG = $STANDALONE_TOOLCHAIN_CLANG"
echo "ANDROID_PLATFORM = $ANDROID_PLATFORM"

${ANDROID_NDK}/build/tools/make-standalone-toolchain.sh \
${STANDALONE_TOOLCHAIN_FLAGS} \
--platform=${ANDROID_PLATFORM} \
--toolchain=${STANDALONE_TOOLCHAIN_NAME} \
--force

echo ""
echo "--------------------"
echo "${RED}[*] check openssl env${NC}"
echo "--------------------"

export PATH=${TOOLCHAIN_PATH}/bin:$PATH
export ANDROID_NDK_HOME=${TOOLCHAIN_PATH}
export PATH=${ANDROID_NDK_HOME}/bin:$PATH

# with openssl standard options:
CFG_FLAGS="$CFG_FLAGS zlib-dynamic"
CFG_FLAGS="$CFG_FLAGS no-shared"
CFG_FLAGS="$CFG_FLAGS --prefix=$OUTPUT_PATH"
CFG_FLAGS="$PLATFORM_CFG_FLAGS $CFG_FLAGS"

echo "PATH = $PATH"
echo ""
echo "CFLAGS = $CFLAGS"
echo "EXTRA_CFLAGS = $EXTRA_CFLAGS"
echo ""
echo "DEP_LIBS = $DEP_LIBS"
echo "EXTRA_LDFLAGS = $EXTRA_LDFLAGS"
echo ""
echo "CFG_FLAGS = $CFG_FLAGS"
echo ""

echo "--------------------"
echo "${RED}[*] configurate openssl${NC}"
echo "--------------------"

cd ${OPENSOURCE_PATH}

echo ""

echo "Enter Dir : ${OPENSOURCE_PATH}"
echo "CFG_FLAGS : ${CFG_FLAGS} "

./Configure ${CFG_FLAGS}
make clean
make SHLIB_VERSION_NUMBER=
make install

cp -r ${OUTPUT_PATH}/include ${SHARED_OUTPUT_PATH}/include
mkdir -p ${SHARED_OUTPUT_PATH}/lib
cp ${OUTPUT_PATH}/lib/libcrypto.a ${SHARED_OUTPUT_PATH}/lib/libcrypto.a
cp ${OUTPUT_PATH}/lib/libssl.a ${SHARED_OUTPUT_PATH}/lib/libssl.a
# cp ${OUTPUT_PATH}/lib/libcrypto.so ${SHARED_OUTPUT_PATH}/lib/libcrypto.so
# cp ${OUTPUT_PATH}/lib/libssl.so ${SHARED_OUTPUT_PATH}/lib/libssl.so

echo "SHARED_OUTPUT_PATH = ${SHARED_OUTPUT_PATH}"
echo "OUTPUT_SHARE_INCLUDE = ${SHARED_OUTPUT_PATH}/include"
echo "OUTPUT_SHARE_LIB = ${SHARED_OUTPUT_PATH}/lib"
echo ""
