#! /usr/bin/env bash

RED='\033[0;31m'
Green='\033[0;33m'
NC='\033[0m'

echo "--------------------"
echo "${RED}[*] check env ing $1 ${NC}"
echo "--------------------"

ARCH=$1

echo "ARCH[架构]=$ARCH"

if [ -z "$ARCH" ]; then
    echo "You must specific an architecture 'armv8a, armv7a, x86, ...'."
    exit 1
fi

BUILD_ROOT=`pwd`/tools

PRODUCT=product

ANDROID_PLATFORM_NAME=android-21

BUILD_NAME=

OPENSSL_SOURCE_PATH=

CROSS_PREFIX_NAME=

CFG_FLAGS=

DEP_LIBS=

STANDALONE_TOOLCHAIN_FLAGS=
STANDALONE_TOOLCHAIN_NAME=
STANDALONE_TOOLCHAIN_ARCH=arm
STANDALONE_TOOLCHAIN_CLANG=clang3.6

echo ""
echo "--------------------"
echo "${RED}[*] make NDK env${NC}"
echo "--------------------"

UNAME_S=$(uname -s)
UNAME_SM=$(uname -sm)

echo "BUILD PLATFORM[构建平台] = $UNAME_SM"
echo ""
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
echo "${RED}[*] make pre params [确定预参数] ${NC}"
echo "--------------------"

if [ "$ARCH" = "armv7a" ]; then
    
    BUILD_NAME=openssl-armv7a
    
    ANDROID_PLATFORM_NAME=android-21
    
    CROSS_PREFIX_NAME=arm-linux-androideabi
    
    STANDALONE_TOOLCHAIN_NAME=arm-linux-android-${STANDALONE_TOOLCHAIN_CLANG}
    
    CFG_FLAGS="$CFG_FLAGS android-arm"
    
    OPENSSL_SOURCE_PATH=${BUILD_ROOT}/${BUILD_NAME}
    
elif [ "$ARCH" = "armv8a" ]; then
    
    BUILD_NAME=openssl-armv8a
    
    ANDROID_PLATFORM_NAME=android-21
    
    CROSS_PREFIX_NAME=aarch64-linux-android
    
    STANDALONE_TOOLCHAIN_NAME=aarch64-linux-android-${STANDALONE_TOOLCHAIN_CLANG}
    
    CFG_FLAGS="$CFG_FLAGS android-arm64"
    
    OPENSSL_SOURCE_PATH=${BUILD_ROOT}/${BUILD_NAME}
    
elif [ "$ARCH" = "x86" ]; then
    
    BUILD_NAME=openssl-x86
    
    ANDROID_PLATFORM_NAME=android-21
    
    CROSS_PREFIX_NAME=i686-linux-android
    
    STANDALONE_TOOLCHAIN_NAME=x86-linux-android-${STANDALONE_TOOLCHAIN_CLANG}
    
    CFG_FLAGS="$CFG_FLAGS android-x86 no-asm"
    
    OPENSSL_SOURCE_PATH=${BUILD_ROOT}/${BUILD_NAME}
    
elif [ "$ARCH" = "x86_64" ]; then
    
    BUILD_NAME=openssl-x86_64
    
    case "$NDK_REL" in
        18*|19*)
            ANDROID_PLATFORM_NAME=android-23
        ;;
        13*|14*|15*|16*|17*)
            ANDROID_PLATFORM_NAME=android-21
        ;;
    esac
    
    CROSS_PREFIX_NAME=x86_64-linux-android
    
    STANDALONE_TOOLCHAIN_NAME=x86_64-linux-android-${STANDALONE_TOOLCHAIN_CLANG}
    
    CFG_FLAGS="$CFG_FLAGS android-x86_64"
    
    OPENSSL_SOURCE_PATH=${BUILD_ROOT}/${BUILD_NAME}
    
else
    echo "unknown architecture $ARCH";
    exit 1
fi

if [ ! -d ${OPENSSL_SOURCE_PATH} ]; then
    echo ""
    echo "!! ERROR"
    echo "!! Can not find Openssl directory for $BUILD_NAME"
    echo "!! Run 'sh init-android-openssl.sh' first"
    echo ""
    exit 1
fi

OPENSSL_OUTPUT_PATH=${BUILD_ROOT}/build/${BUILD_NAME}/output
SHARED_OUTPUT_PATH=${BUILD_ROOT}/../${PRODUCT}/${BUILD_NAME}
TOOLCHAIN_PATH=${BUILD_ROOT}/build/${BUILD_NAME}/toolchain
TOOLCHAIN_SYSROOT_PATH=${TOOLCHAIN_PATH}/sysroot

rm -rf ${BUILD_ROOT}/build/${BUILD_NAME}
rm -rf ${OPENSSL_OUTPUT_PATH}
rm -rf ${SHARED_OUTPUT_PATH}
mkdir -p ${OPENSSL_OUTPUT_PATH}
mkdir -p ${SHARED_OUTPUT_PATH}


echo "BUILD_NAME[构建名称] = $BUILD_NAME"
echo ""
echo "CROSS_PREFIX_NAME = $CROSS_PREFIX_NAME"
echo ""
echo "TOOLCHAIN_PATH[工具链] = $TOOLCHAIN_PATH"
echo ""
echo "TOOLCHAIN_SYSROOT_PATH[工具链Root] = $TOOLCHAIN_SYSROOT_PATH"
echo ""
echo "OPENSSL_SOURCE_PATH[源码目录] = $OPENSSL_SOURCE_PATH"
echo ""
echo "OPENSSL_OUTPUT_PATH[编译输出目录] = $OPENSSL_OUTPUT_PATH"

echo ""
echo "--------------------"
echo "${RED}[*] make NDK standalone toolchain [构建NDK独立工具链] ${NC}"
echo "--------------------"

STANDALONE_TOOLCHAIN_FLAGS="$STANDALONE_TOOLCHAIN_FLAGS --install-dir=$TOOLCHAIN_PATH"

echo "STANDALONE_TOOLCHAIN_NAME = $STANDALONE_TOOLCHAIN_NAME"
echo ""
echo "STANDALONE_TOOLCHAIN_FLAGS = $STANDALONE_TOOLCHAIN_FLAGS"
echo ""
echo "STANDALONE_TOOLCHAIN_ARCH = $STANDALONE_TOOLCHAIN_ARCH"
echo ""
echo "STANDALONE_TOOLCHAIN_CLANG = $STANDALONE_TOOLCHAIN_CLANG"
echo ""
echo "ANDROID_PLATFORM_NAME = $ANDROID_PLATFORM_NAME"
echo ""

${ANDROID_NDK}/build/tools/make-standalone-toolchain.sh \
${STANDALONE_TOOLCHAIN_FLAGS} \
--platform=${ANDROID_PLATFORM_NAME} \
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
CFG_FLAGS="$CFG_FLAGS --prefix=$OPENSSL_OUTPUT_PATH"

echo "PATH[环境变量] = $PATH"
echo ""
echo "CFG_FLAGS[编译参数] = $CFG_FLAGS"
echo ""
echo "DEP_LIBS[链接器依赖库] = $DEP_LIBS"
echo ""

echo "--------------------"
echo "${RED}[*] compile openssl [编译Openssl] ${NC}"
echo "--------------------"

cd ${OPENSSL_SOURCE_PATH}

echo ""
echo "Enter Dir : ${OPENSSL_SOURCE_PATH}"

./Configure --help

./Configure ${CFG_FLAGS}

make clean
make SHLIB_VERSION_NUMBER=
make install

cp -r ${OPENSSL_OUTPUT_PATH}/include ${SHARED_OUTPUT_PATH}/include
mkdir -p ${SHARED_OUTPUT_PATH}/lib
cp ${OPENSSL_OUTPUT_PATH}/lib/libcrypto.a ${SHARED_OUTPUT_PATH}/lib/libcrypto.a
cp ${OPENSSL_OUTPUT_PATH}/lib/libssl.a ${SHARED_OUTPUT_PATH}/lib/libssl.a

echo ""
echo "SHARED_OUTPUT_PATH = ${SHARED_OUTPUT_PATH}"
echo ""
echo "SHARED_OUTPUT_PATH_INCLUDE = ${SHARED_OUTPUT_PATH}/include"
echo ""
echo "SHARED_OUTPUT_PATH_LIB = ${SHARED_OUTPUT_PATH}/lib"
echo ""
