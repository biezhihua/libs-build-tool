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

ANDROID_PLATFORM=android-21

BUILD_NAME=

BUILD_NAME_OPENSSL=

FFMPEG_SOURCE_PATH=

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

SO_SIMPLE_NAME=sffmpeg
SO_NAME=lib${SO_SIMPLE_NAME}.so

PRODUCT=product

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

    BUILD_NAME=ffmpeg-armv7a

    BUILD_NAME_OPENSSL=openssl-armv7a

    ANDROID_PLATFORM=android-21

    FFMPEG_SOURCE_PATH=${BUILD_ROOT}/${BUILD_NAME}

    CROSS_PREFIX_NAME=arm-linux-androideabi

    STANDALONE_TOOLCHAIN_NAME=arm-linux-android-${STANDALONE_TOOLCHAIN_CLANG}

    CFG_FLAGS="$CFG_FLAGS --arch=arm --cpu=cortex-a8"

    CFG_FLAGS="$CFG_FLAGS --enable-neon"

    CFG_FLAGS="$CFG_FLAGS --enable-thumb"

    EXTRA_CFLAGS="$EXTRA_CFLAGS -march=armv7-a -mcpu=cortex-a8 -mfpu=vfpv3-d16 -mfloat-abi=softfp -mthumb"

    EXTRA_LDFLAGS="$EXTRA_LDFLAGS -march=armv7-a -Wl,--fix-cortex-a8"

    ASSEMBLER_SUB_DIRS="arm"

elif [ "$ARCH" = "armv8a" ]; then
    
    BUILD_NAME=ffmpeg-armv8a

    BUILD_NAME_OPENSSL=openssl-armv8a

    ANDROID_PLATFORM=android-21

    FFMPEG_SOURCE_PATH=${BUILD_ROOT}/${BUILD_NAME}

    CROSS_PREFIX_NAME=aarch64-linux-android

    STANDALONE_TOOLCHAIN_NAME=aarch64-linux-android-${STANDALONE_TOOLCHAIN_CLANG}

    CFG_FLAGS="$CFG_FLAGS --arch=aarch64"

    EXTRA_CFLAGS="$EXTRA_CFLAGS -march=armv8-a"

    EXTRA_LDFLAGS="$EXTRA_LDFLAGS"

    ASSEMBLER_SUB_DIRS="aarch64 neon"

elif [ "$ARCH" = "x86" ]; then
    
    BUILD_NAME=ffmpeg-x86

    BUILD_NAME_OPENSSL=openssl-x86

    ANDROID_PLATFORM=android-21

    FFMPEG_SOURCE_PATH=${BUILD_ROOT}/${BUILD_NAME}

    CROSS_PREFIX_NAME=i686-linux-android

    STANDALONE_TOOLCHAIN_NAME=x86-linux-android-${STANDALONE_TOOLCHAIN_CLANG}

    CFG_FLAGS="$CFG_FLAGS --arch=x86 --cpu=i686"

    EXTRA_CFLAGS="$EXTRA_CFLAGS -march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32"

    EXTRA_LDFLAGS="$EXTRA_LDFLAGS"

    ASSEMBLER_SUB_DIRS="x86"

elif [ "$ARCH" = "x86_64" ]; then
    
    BUILD_NAME=ffmpeg-x86_64

    BUILD_NAME_OPENSSL=openssl-x86_64

    case "$NDK_REL" in
    18*|19*)
        ANDROID_PLATFORM=android-23
    ;;
    13*|14*|15*|16*|17*)
        ANDROID_PLATFORM=android-21
    ;;
    esac

    FFMPEG_SOURCE_PATH=${BUILD_ROOT}/${BUILD_NAME}

    CROSS_PREFIX_NAME=x86_64-linux-android

    STANDALONE_TOOLCHAIN_NAME=x86_64-linux-android-${STANDALONE_TOOLCHAIN_CLANG}

    CFG_FLAGS="$CFG_FLAGS  --arch=x86_64"

    EXTRA_CFLAGS="$EXTRA_CFLAGS -target x86_64-none-linux-androideabi -msse4.2 -mpopcnt -m64 -mtune=intel"

    # https://blog.csdn.net/cjf_iceking/article/details/25825569
    # 其中Wl表示将紧跟其后的参数，传递给连接器ld。Bsymbolic表示强制采用本地的全局变量定义，
    # 这样就不会出现动态链接库的全局变量定义被应用程序/动态链接库中的同名定义给覆盖了！
    EXTRA_LDFLAGS="$EXTRA_LDFLAGS -Wl,-Bsymbolic"

    ASSEMBLER_SUB_DIRS="x86"

else
    echo "unknown architecture $ARCH";
    exit 1
fi

if [ ! -d ${FFMPEG_SOURCE_PATH} ]; then
    echo ""
    echo "!! ERROR"
    echo "!! Can not find FFmpeg directory for $BUILD_NAME"
    echo "!! Run 'sh init-android.sh' first"
    echo ""
    exit 1
fi

OUTPUT_PATH=${BUILD_ROOT}/build/${BUILD_NAME}/output
SHARED_OUTPUT_PATH=${BUILD_ROOT}/../${PRODUCT}/${BUILD_NAME}
TOOLCHAIN_PATH=${BUILD_ROOT}/build/${BUILD_NAME}/toolchain
TOOLCHAIN_SYSROOT_PATH=${TOOLCHAIN_PATH}/sysroot

OUTPUT_PATH_OPENSSL=${BUILD_ROOT}/build/${BUILD_NAME_OPENSSL}/output
TOOLCHAIN_PATH_OPENSSL=${BUILD_ROOT}/build/${BUILD_NAME_OPENSSL}/toolchain
TOOLCHAIN_SYSROOT_PATH_OPENSSL=${TOOLCHAIN_PATH_OPENSSL}/sysroot
DEP_OPENSSL_INC=${OUTPUT_PATH_OPENSSL}/include
DEP_OPENSSL_LIB=${OUTPUT_PATH_OPENSSL}/lib

rm -rf ${BUILD_ROOT}/build/${BUILD_NAME}
mkdir -p ${OUTPUT_PATH}
mkdir -p ${SHARED_OUTPUT_PATH}

echo "FFMPEG_SOURCE_PATH = $FFMPEG_SOURCE_PATH"
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
echo "OUTPUT_PATH_OPENSSL = $OUTPUT_PATH_OPENSSL"
echo "TOOLCHAIN_PATH_OPENSSL = $TOOLCHAIN_PATH_OPENSSL"
echo "TOOLCHAIN_SYSROOT_PATH_OPENSSL = $TOOLCHAIN_SYSROOT_PATH_OPENSSL"
echo "DEP_OPENSSL_INC = $DEP_OPENSSL_INC"
echo "DEP_OPENSSL_LIB = $DEP_OPENSSL_LIB"

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
echo "${RED}[*] check ffmpeg env${NC}"
echo "--------------------"

export PATH=${TOOLCHAIN_PATH}/bin:$PATH
export CLANG=${CROSS_PREFIX_NAME}-clang
export CXX=${CROSS_PREFIX_NAME}-clang++
export LD=${CROSS_PREFIX_NAME}-ld
export AR=${CROSS_PREFIX_NAME}-ar
export STRIP=${CROSS_PREFIX_NAME}-strip

# https://blog.csdn.net/m0_37170593/article/details/78892913
# example: --extra-cflags=-I/xxxx/include 
# example: --extra-ldflags=-L/usr/local/x264-x86/lib
# --extra-cflags=ECFLAGS   add ECFLAGS to CFLAGS []
# --extra-ldflags=ELDFLAGS add ELDFLAGS to LDFLAGS []
# -Wall 允许发出Gcc提供的所有有用的报警信息
# -O3Gcc 可以对代码进行优化，它通过编译选项“-On”来控制优化代码的生成，其中n是一个代表优化级别的整数。
# 对于不同版本的Gcc来讲，n的取值范围及其对应的优化效果可能并不完全相同，比较典型的范围是从0变化到2或3。
# -pipe                   Use pipes between commands, when possible# -pipe 使用管道
# -ffast-math             Allow aggressive, lossy floating-point optimizations
# -Werror	              把所有的告警信息转化为错误信息，并在告警发生时终止编译过程
# -Wa,<arg>               Pass the comma separated arguments in <arg> to the assembler
# -fPIC https://blog.csdn.net/a_ran/article/details/41943749
# -std=c99 https://blog.csdn.net/u012075739/article/details/26516007/
CFLAGS="-O3 -fPIC -Wall -pipe \
    -std=c99 \
    -ffast-math \
    -fstrict-aliasing -Werror=strict-aliasing \
    -Wa,--noexecstack \
    -DANDROID -DNDEBUG"

# with ffmpeg standard options:
CFG_FLAGS="$CFG_FLAGS --prefix=$OUTPUT_PATH"
CFG_FLAGS="$CFG_FLAGS --sysroot=$TOOLCHAIN_SYSROOT_PATH"
CFG_FLAGS="$CFG_FLAGS --cc=clang --host-cflags= --host-ldflags="

# with ffmpeg Advanced options (experts only):
CFG_FLAGS="$CFG_FLAGS --cross-prefix=${TOOLCHAIN_PATH}/bin/${CROSS_PREFIX_NAME}-"
CFG_FLAGS="$CFG_FLAGS --enable-cross-compile"
CFG_FLAGS="$CFG_FLAGS --target-os=android"
CFG_FLAGS="$CFG_FLAGS --enable-pic"

if [ "$ARCH" = "x86" ]; then
    CFG_FLAGS="$CFG_FLAGS --disable-asm"
else
    CFG_FLAGS="$CFG_FLAGS --enable-asm"
    CFG_FLAGS="$CFG_FLAGS --enable-inline-asm"
fi

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

# with ffmpeg config module
export COMMON_CFG_FLAGS=
. ${BUILD_ROOT}/../config/module.sh


# with openssl
if [ -f "${DEP_OPENSSL_LIB}/libssl.a" ]; then
    export PKG_CONFIG_PATH=${DEP_OPENSSL_LIB}/pkgconfig
    echo "PKG_CONFIG_PATH = ${PKG_CONFIG_PATH}"
    CFG_FLAGS="$CFG_FLAGS --enable-protocol=https"
    CFG_FLAGS="$CFG_FLAGS --enable-openssl"
    CFG_FLAGS="$CFG_FLAGS --pkg-config=pkg-config"
    CFLAGS="$CFLAGS -I${DEP_OPENSSL_INC}"
    DEP_LIBS="$DEP_LIBS -L${DEP_OPENSSL_LIB} -lssl -lcrypto"
fi

CFG_FLAGS="$CFG_FLAGS $COMMON_CFG_FLAGS"

echo "PATH = $PATH"
echo "CLANG = $CLANG"
echo "LD = $LD"
echo "AR = $AR"
echo "STRIP = $STRIP"
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
echo "${RED}[*] configurate ffmpeg${NC}"
echo "--------------------"

cd ${FFMPEG_SOURCE_PATH}

# path configure openssl
git add -A
git stash
patch -p0 ./configure ${BUILD_ROOT}/patch/configure-patch.patch

# http://www.runoob.com/linux/linux-comm-which.html
# which指令会在环境变量$PATH设置的目录里查找符合条件的文件。
# which $CC
# which ${CLANG}
./configure ${CFG_FLAGS} \
    --extra-cflags="$CFLAGS $EXTRA_CFLAGS" \
    --extra-ldflags="$DEP_LIBS $EXTRA_LDFLAGS" 

make clean

echo ""
echo "--------------------"
echo "${RED}[*] compile ffmpeg${NC}"
echo "--------------------"
echo "OUTPUT_PATH = $OUTPUT_PATH"

cp config.* ${OUTPUT_PATH}

make install -j8 > /dev/null

mkdir -p OUTPUT_PATH/include/libffmpeg
cp -f config.h OUTPUT_PATH/include/libffmpeg/config.h

echo "LIB_CONFIG = $OUTPUT_PATH/include/libffmpeg/config.h"
echo "FFmpeg install success"


echo ""
echo "--------------------"
echo "${RED}[*] link ffmpeg${NC}"
echo "--------------------"

LINK_C_OBJ_FILES=
LINK_ASM_OBJ_FILES=
for MODULE_DIR in ${LINK_MODULE_DIRS}
do
    C_OBJ_FILES="$MODULE_DIR/*.o"
    if ls ${C_OBJ_FILES} 1> /dev/null 2>&1; then
        echo "link $MODULE_DIR/*.o"
        LINK_C_OBJ_FILES="$LINK_C_OBJ_FILES $C_OBJ_FILES"
    fi

    for ASM_SUB_DIR in ${ASSEMBLER_SUB_DIRS}
    do
        ASM_OBJ_FILES="$MODULE_DIR/$ASM_SUB_DIR/*.o"
        if ls ${ASM_OBJ_FILES} 1> /dev/null 2>&1; then
            echo "link $MODULE_DIR/$ASM_SUB_DIR/*.o"
            LINK_ASM_OBJ_FILES="$LINK_ASM_OBJ_FILES $ASM_OBJ_FILES"
        fi
    done
done

echo ""
echo "LINK_C_OBJ_FILES = $LINK_C_OBJ_FILES"
echo "LINK_ASM_OBJ_FILES = $LINK_ASM_OBJ_FILES"
echo "DEP_LIBS = $DEP_LIBS"
echo "SPLAYER_SO = $OUTPUT_PATH/$SO_NAME"
echo "ANDROID_PLATFORM = $ANDROID_PLATFORM"
echo "TOOLCHAIN_SYSROOT = $TOOLCHAIN_SYSROOT_PATH"
echo "Use Compiler: ${CLANG}"
echo ""

${CLANG} -lm -lz -shared -Wl,--no-undefined -Wl,-z,noexecstack ${EXTRA_LDFLAGS} \
    -Wl,-soname,$SO_NAME \
    ${LINK_C_OBJ_FILES} \
    ${LINK_ASM_OBJ_FILES} \
    ${DEP_LIBS} \
    -o ${OUTPUT_PATH}/$SO_NAME 

echo ""
echo "--------------------"
echo "${RED}[*] create files for shared ffmpeg ${NC}"
echo "--------------------"
echo ""

mysedi() {
    f=$1
    exp=$2
    n=`basename $f`
    cp $f /tmp/$n
    # http://www.runoob.com/linux/linux-comm-sed.html
    # sed可依照script的指令，来处理、编辑文本文件。
    sed $exp /tmp/$n > $f
    rm /tmp/$n
    # echo "${f}    ${exp}    ${n}"
}

rm -rf ${SHARED_OUTPUT_PATH}
mkdir -p ${SHARED_OUTPUT_PATH}/lib/pkgconfig
cp -r ${OUTPUT_PATH}/include ${SHARED_OUTPUT_PATH}/include
cp ${OUTPUT_PATH}/${SO_NAME} ${SHARED_OUTPUT_PATH}/lib/${SO_NAME}
cp ${OUTPUT_PATH}/lib/pkgconfig/*.pc ${SHARED_OUTPUT_PATH}/lib/pkgconfig

echo "OUTPUT_SHARE = ${SHARED_OUTPUT_PATH}"
echo "OUTPUT_SHARE_INCLUDE = ${SHARED_OUTPUT_PATH}/include"
echo "OUTPUT_SHARE_LIB = ${SHARED_OUTPUT_PATH}/lib"
echo ""

for f in ${SHARED_OUTPUT_PATH}/lib/pkgconfig/*.pc; do
    # in case empty dir
    if [ ! -f ${f} ]; then
        continue
    fi
    f=${SHARED_OUTPUT_PATH}/lib/pkgconfig/`basename ${f}`
    echo "process share lib ${f}"
    # OSX sed doesn't have in-place(-i)
    mysedi ${f} 's/tools\/build\/'${BUILD_NAME}'\/output/build\/'${BUILD_NAME}'/g'
    mysedi ${f} 's/-lavcodec/-l'${SO_SIMPLE_NAME}'/g'
    mysedi ${f} 's/-lavfilter/-l'${SO_SIMPLE_NAME}'/g'
    mysedi ${f} 's/-lavformat/-l'${SO_SIMPLE_NAME}'/g'
    mysedi ${f} 's/-lavutil/-l'${SO_SIMPLE_NAME}'/g'
    mysedi ${f} 's/-lswresample/-l'${SO_SIMPLE_NAME}'/g'
    mysedi ${f} 's/-lswscale/-l'${SO_SIMPLE_NAME}'/g'
done

echo ""
