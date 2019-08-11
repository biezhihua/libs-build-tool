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

SSL_ARCH=$1
SSL_BUILD_OPT=$2
SSL_REAL_OUTPUT_PATH=$3

echo "SSL_ARCH=$SSL_ARCH"
echo "SSL_BUILD_OPT=$SSL_BUILD_OPT"
echo "SSL_REAL_OUTPUT_PATH=$SSL_REAL_OUTPUT_PATH"

# -z 字符串	字符串的长度为零则为真
if [ -z "$SSL_ARCH" ]; then
    echo "You must specific an architecture 'armv8a, armv7a, x86, ...'."
    exit 1
fi

SSL_BUILD_ROOT=`pwd`/android

SSL_ANDROID_PLATFORM=android-21

SSL_BUILD_NAME=
SSL_OPENSSL_SOURCE_PATH=
SSL_CROSS_PREFIX_NAME=

SSL_CFG_FLAGS=

SSL_EXTRA_CFLAGS=
SSL_EXTRA_LDFLAGS=
SSL_DEP_LIBS=

SSL_LINK_MODULE_DIRS="compat libavcodec libavfilter libavformat libavutil libswresample libswscale"
SSL_ASSEMBLER_SUB_DIRS=

SSL_STANDALONE_TOOLCHAIN_FLAGS=
SSL_STANDALONE_TOOLCHAIN_NAME=
SSL_STANDALONE_TOOLCHAIN_ARCH=arm
SSL_STANDALONE_TOOLCHAIN_CLANG=clang3.6

SSL_PLATFORM_CFG_FLAGS=

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

if [ "$SSL_ARCH" = "armv7a" ]; then
    
    SSL_BUILD_NAME=openssl-armv7a
    
    SSL_ANDROID_PLATFORM=android-21
    
    SSL_OPENSSL_SOURCE_PATH=${SSL_BUILD_ROOT}/${SSL_BUILD_NAME}
    
    SSL_CROSS_PREFIX_NAME=arm-linux-androideabi
    
    SSL_STANDALONE_TOOLCHAIN_NAME=arm-linux-android-${SSL_STANDALONE_TOOLCHAIN_CLANG}
    
    SSL_PLATFORM_CFG_FLAGS="android-arm"
    
    elif [ "$SSL_ARCH" = "armv8a" ]; then
    SSL_BUILD_NAME=openssl-armv8a
    
    SSL_ANDROID_PLATFORM=android-21
    
    SSL_OPENSSL_SOURCE_PATH=${SSL_BUILD_ROOT}/${SSL_BUILD_NAME}
    
    SSL_CROSS_PREFIX_NAME=aarch64-linux-android
    
    SSL_STANDALONE_TOOLCHAIN_NAME=aarch64-linux-android-${SSL_STANDALONE_TOOLCHAIN_CLANG}
    
    SSL_PLATFORM_CFG_FLAGS="android-arm64"
    
    elif [ "$SSL_ARCH" = "x86" ]; then
    
    SSL_BUILD_NAME=openssl-x86
    
    SSL_ANDROID_PLATFORM=android-21
    
    SSL_OPENSSL_SOURCE_PATH=${SSL_BUILD_ROOT}/${SSL_BUILD_NAME}
    
    SSL_CROSS_PREFIX_NAME=i686-linux-android
    
    SSL_STANDALONE_TOOLCHAIN_NAME=x86-linux-android-${SSL_STANDALONE_TOOLCHAIN_CLANG}
    
    SSL_CFG_FLAGS="$SSL_CFG_FLAGS no-asm"
    
    SSL_PLATFORM_CFG_FLAGS="android-x86"
    
    elif [ "$SSL_ARCH" = "x86_64" ]; then
    
    SSL_BUILD_NAME=openssl-x86_64
    
    case "$NDK_REL" in
        18*|19*)
            SSL_ANDROID_PLATFORM=android-23
        ;;
        13*|14*|15*|16*|17*)
            SSL_ANDROID_PLATFORM=android-21
        ;;
    esac
    
    SSL_OPENSSL_SOURCE_PATH=${SSL_BUILD_ROOT}/${SSL_BUILD_NAME}
    
    SSL_CROSS_PREFIX_NAME=x86_64-linux-android
    
    SSL_STANDALONE_TOOLCHAIN_NAME=x86_64-linux-android-${SSL_STANDALONE_TOOLCHAIN_CLANG}
    
    SSL_PLATFORM_CFG_FLAGS="android-x86_64"
    
else
    echo "unknown architecture $SSL_ARCH";
    exit 1
fi

if [ ! -d ${SSL_OPENSSL_SOURCE_PATH} ]; then
    echo ""
    echo "!! ERROR"
    echo "!! Can not find Openssl directory for $SSL_BUILD_NAME"
    echo "!! Run 'sh init-android-openssl.sh' first"
    echo ""
    exit 1
fi

SSL_OUTPUT_PATH=${SSL_BUILD_ROOT}/build/${SSL_BUILD_NAME}/output
SSL_SHARED_OUTPUT_PATH=${SSL_BUILD_ROOT}/../build/${SSL_BUILD_NAME}
SSL_TOOLCHAIN_PATH=${SSL_BUILD_ROOT}/build/${SSL_BUILD_NAME}/toolchain
SSL_TOOLCHAIN_SYSROOT_PATH=${SSL_TOOLCHAIN_PATH}/sysroot

rm -rf ${SSL_BUILD_ROOT}/build/${SSL_BUILD_NAME}
rm -rf ${SSL_OUTPUT_PATH}
rm -rf ${SSL_SHARED_OUTPUT_PATH}
mkdir -p ${SSL_OUTPUT_PATH}
mkdir -p ${SSL_SHARED_OUTPUT_PATH}

echo "SSL_OPENSSL_SOURCE_PATH = $SSL_OPENSSL_SOURCE_PATH"
echo ""
echo "SSL_BUILD_NAME = $SSL_BUILD_NAME"
echo "SSL_BUILD_NAME_OPENSSL = $SSL_BUILD_NAME_OPENSSL"
echo "SSL_BUILD_NAME_LIBSOXR = $SSL_BUILD_NAME_LIBSOXR"
echo "SSL_CROSS_PREFIX_NAME = $SSL_CROSS_PREFIX_NAME"
echo "SSL_STANDALONE_TOOLCHAIN_NAME = $SSL_STANDALONE_TOOLCHAIN_NAME"
echo ""
echo "SSL_CFG_FLAGS = $SSL_CFG_FLAGS"
echo "SSL_EXTRA_CFLAGS = $SSL_EXTRA_CFLAGS"
echo "SSL_EXTRA_LDFLAGS = $SSL_EXTRA_LDFLAGS"
echo "SSL_ASSEMBLER_SUB_DIRS = $SSL_ASSEMBLER_SUB_DIRS"
echo ""
echo "SSL_OUTPUT_PATH = $SSL_OUTPUT_PATH"
echo "SSL_TOOLCHAIN_PATH = $SSL_TOOLCHAIN_PATH"
echo "SSL_TOOLCHAIN_SYSROOT_PATH = $SSL_TOOLCHAIN_SYSROOT_PATH"

echo ""
echo "--------------------"
echo "${RED}[*] make NDK standalone toolchain${NC}"
echo "--------------------"

SSL_STANDALONE_TOOLCHAIN_FLAGS="$SSL_STANDALONE_TOOLCHAIN_FLAGS --install-dir=$SSL_TOOLCHAIN_PATH"

echo "SSL_STANDALONE_TOOLCHAIN_NAME = $SSL_STANDALONE_TOOLCHAIN_NAME"
echo "SSL_STANDALONE_TOOLCHAIN_FLAGS = $SSL_STANDALONE_TOOLCHAIN_FLAGS"

echo "SSL_STANDALONE_TOOLCHAIN_ARCH = $SSL_STANDALONE_TOOLCHAIN_ARCH"
echo "SSL_STANDALONE_TOOLCHAIN_CLANG = $SSL_STANDALONE_TOOLCHAIN_CLANG"
echo "SSL_ANDROID_PLATFORM = $SSL_ANDROID_PLATFORM"

${ANDROID_NDK}/build/tools/make-standalone-toolchain.sh \
${SSL_STANDALONE_TOOLCHAIN_FLAGS} \
--platform=${SSL_ANDROID_PLATFORM} \
--toolchain=${SSL_STANDALONE_TOOLCHAIN_NAME} \
--force

echo ""
echo "--------------------"
echo "${RED}[*] check openssl env${NC}"
echo "--------------------"

export PATH=${SSL_TOOLCHAIN_PATH}/bin:$PATH
export ANDROID_NDK_HOME=${SSL_TOOLCHAIN_PATH}
export PATH=${ANDROID_NDK_HOME}/bin:$PATH

# with openssl standard options:
SSL_CFG_FLAGS="$SSL_CFG_FLAGS zlib-dynamic"
SSL_CFG_FLAGS="$SSL_CFG_FLAGS no-shared"
SSL_CFG_FLAGS="$SSL_CFG_FLAGS --prefix=$SSL_OUTPUT_PATH"
SSL_CFG_FLAGS="$SSL_PLATFORM_CFG_FLAGS $SSL_CFG_FLAGS"

echo "PATH = $PATH"
echo ""
echo "SSL_CFLAGS = $SSL_CFLAGS"
echo "SSL_EXTRA_CFLAGS = $SSL_EXTRA_CFLAGS"
echo ""
echo "SSL_DEP_LIBS = $SSL_DEP_LIBS"
echo "SSL_EXTRA_LDFLAGS = $SSL_EXTRA_LDFLAGS"
echo ""
echo "SSL_CFG_FLAGS = $SSL_CFG_FLAGS"
echo ""

echo "--------------------"
echo "${RED}[*] configurate openssl${NC}"
echo "--------------------"

cd ${SSL_OPENSSL_SOURCE_PATH}

echo ""

echo "Enter Dir : ${SSL_OPENSSL_SOURCE_PATH}"
echo "SSL_CFG_FLAGS : ${SSL_CFG_FLAGS} "

./Configure ${SSL_CFG_FLAGS}
make clean
make SHLIB_VERSION_NUMBER=
make install

cp -r ${SSL_OUTPUT_PATH}/include ${SSL_SHARED_OUTPUT_PATH}/include
mkdir -p ${SSL_SHARED_OUTPUT_PATH}/lib
cp ${SSL_OUTPUT_PATH}/lib/libcrypto.a ${SSL_SHARED_OUTPUT_PATH}/lib/libcrypto.a
cp ${SSL_OUTPUT_PATH}/lib/libssl.a ${SSL_SHARED_OUTPUT_PATH}/lib/libssl.a
# cp ${SSL_OUTPUT_PATH}/lib/libcrypto.so ${SSL_SHARED_OUTPUT_PATH}/lib/libcrypto.so
# cp ${SSL_OUTPUT_PATH}/lib/libssl.so ${SSL_SHARED_OUTPUT_PATH}/lib/libssl.so

echo "SSL_SHARED_OUTPUT_PATH = ${SSL_SHARED_OUTPUT_PATH}"
echo "SSL_OUTPUT_SHARE_INCLUDE = ${SSL_SHARED_OUTPUT_PATH}/include"
echo "SSL_OUTPUT_SHARE_LIB = ${SSL_SHARED_OUTPUT_PATH}/lib"
echo ""
