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

FF_ARCH=$1
FF_BUILD_OPT=$2

echo "FF_ARCH=$FF_ARCH"
echo "FF_BUILD_OPT=$FF_BUILD_OPT"

# -z 字符串	字符串的长度为零则为真
if [[ -z "$FF_ARCH" ]]; then
    echo "You must specific an architecture 'arm, armv7a, x86, ...'."
    exit 1
fi

FF_BUILD_ROOT=`pwd`
FF_ANDROID_PLATFORM=android-21

FF_BUILD_NAME=
FF_FFMPEG_SOURCE_PATH=
FF_CROSS_PREFIX_NAME=
FF_DEP_OPENSSL_INC_PATH=
FF_DEP_OPENSSL_LIB_PATH=

FF_DEP_LIBSOXR_INC_PATH=
FF_DEP_LIBSOXR_LIB_PATH=

FF_CFG_FLAGS=

FF_EXTRA_CFLAGS=
FF_EXTRA_LDFLAGS=
FF_DEP_LIBS=

FF_LINK_MODULE_DIRS="compat libavcodec libavfilter libavformat libavutil libswresample libswscale"
FF_ASSEMBLER_SUB_DIRS=

FF_STANDALONE_TOOLCHAIN_FLAGS=
FF_STANDALONE_TOOLCHAIN_NAME=
FF_STANDALONE_TOOLCHAIN_STL=gnustl
FF_STANDALONE_TOOLCHAIN_ARCH=arm
FF_STANDALONE_TOOLCHAIN_CLANG=clang3.6

FF_SPLAYER_SO_SIMPLE_NAME=sffmpeg
FF_SPLAYER_SO_NAME=lib${FF_SPLAYER_SO_SIMPLE_NAME}.so

echo ""
echo "--------------------"
echo "${RED}[*] make NDK env${NC}"
echo "--------------------"

UNAME_S=$(uname -s)
UNAME_SM=$(uname -sm)

echo "BUILD PLATFORM = $UNAME_SM"
echo "ANDROID_NDK = $ANDROID_NDK"

if [[ -z "$ANDROID_NDK" ]]; then
    echo "You must define ANDROID_NDK before starting."
    echo "They must point to your NDK directories."
    echo ""
    exit 1
fi

NDK_REL=$(grep -o '^Pkg\.Revision.*=[0-9]*.*' ${ANDROID_NDK}/source.properties 2>/dev/null | sed 's/[[:space:]]*//g' | cut -d "=" -f 2)

case "$NDK_REL" in
    11*|12*|13*|14*|16*)
        if test -d ${ANDROID_NDK}/toolchains/arm-linux-androideabi-4.9
        then
            echo "NDK VERSION = r$NDK_REL"
        else
            echo "You need the NDKr10e or later"
            exit 1
        fi
    ;;
    *)
        echo "You need the NDKr10e or later"
        exit 1
    ;;
esac

echo ""
echo "--------------------"
echo "${RED}[*] make params${NC}"
echo "--------------------"

if [[ "$FF_ARCH" = "armv7a" ]]; then

    FF_BUILD_NAME=ffmpeg-armv7a

    FF_ANDROID_PLATFORM=android-21

    FF_FFMPEG_SOURCE_PATH=${FF_BUILD_ROOT}/${FF_BUILD_NAME}

    FF_CROSS_PREFIX_NAME=arm-linux-androideabi

    FF_STANDALONE_TOOLCHAIN_NAME=arm-linux-android-${FF_STANDALONE_TOOLCHAIN_CLANG}

    FF_CFG_FLAGS="$FF_CFG_FLAGS --arch=arm --cpu=cortex-a8"

    FF_CFG_FLAGS="$FF_CFG_FLAGS --enable-neon"

    FF_CFG_FLAGS="$FF_CFG_FLAGS --enable-thumb"

    FF_EXTRA_CFLAGS="$FF_EXTRA_CFLAGS -march=armv7-a -mcpu=cortex-a8 -mfpu=vfpv3-d16 -mfloat-abi=softfp -mthumb"

    FF_EXTRA_LDFLAGS="$FF_EXTRA_LDFLAGS -march=armv7-a -Wl,--fix-cortex-a8"

    FF_ASSEMBLER_SUB_DIRS="arm"

elif [ "$FF_ARCH" = "armv8a" ]; then
    FF_BUILD_NAME=ffmpeg-armv8a

    FF_ANDROID_PLATFORM=android-21

    FF_FFMPEG_SOURCE_PATH=${FF_BUILD_ROOT}/${FF_BUILD_NAME}

    FF_CROSS_PREFIX_NAME=aarch64-linux-android

    FF_STANDALONE_TOOLCHAIN_NAME=aarch64-linux-android-${FF_STANDALONE_TOOLCHAIN_CLANG}

    FF_CFG_FLAGS="$FF_CFG_FLAGS --arch=aarch64"

    FF_EXTRA_CFLAGS="$FF_EXTRA_CFLAGS -march=armv8-a"

    FF_EXTRA_LDFLAGS="$FF_EXTRA_LDFLAGS"

    FF_ASSEMBLER_SUB_DIRS="aarch64 neon"

elif [ "$FF_ARCH" = "x86" ]; then
    
    FF_BUILD_NAME=ffmpeg-x86

    FF_ANDROID_PLATFORM=android-21

    FF_FFMPEG_SOURCE_PATH=${FF_BUILD_ROOT}/${FF_BUILD_NAME}

    FF_CROSS_PREFIX_NAME=i686-linux-android

    FF_STANDALONE_TOOLCHAIN_NAME=x86-linux-android-${FF_STANDALONE_TOOLCHAIN_CLANG}

    FF_CFG_FLAGS="$FF_CFG_FLAGS --arch=x86 --cpu=i686"

    FF_EXTRA_CFLAGS="$FF_EXTRA_CFLAGS -march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32"

    FF_EXTRA_LDFLAGS="$FF_EXTRA_LDFLAGS"

    FF_ASSEMBLER_SUB_DIRS="x86"

elif [ "$FF_ARCH" = "x86_64" ]; then
    
    FF_BUILD_NAME=ffmpeg-x86_64

    FF_ANDROID_PLATFORM=android-21

    FF_FFMPEG_SOURCE_PATH=${FF_BUILD_ROOT}/${FF_BUILD_NAME}

    FF_CROSS_PREFIX_NAME=x86_64-linux-android

    FF_STANDALONE_TOOLCHAIN_NAME=x86_64-linux-android-${FF_STANDALONE_TOOLCHAIN_CLANG}

    FF_CFG_FLAGS="$FF_CFG_FLAGS  --arch=x86_64"

    FF_EXTRA_CFLAGS="$FF_EXTRA_CFLAGS -target x86_64-none-linux-androideabi -msse4.2 -mpopcnt -m64 -mtune=intel"

    # https://blog.csdn.net/cjf_iceking/article/details/25825569
    # 其中Wl表示将紧跟其后的参数，传递给连接器ld。Bsymbolic表示强制采用本地的全局变量定义，
    # 这样就不会出现动态链接库的全局变量定义被应用程序/动态链接库中的同名定义给覆盖了！
    FF_EXTRA_LDFLAGS="$FF_EXTRA_LDFLAGS -Wl,-Bsymbolic"

    FF_ASSEMBLER_SUB_DIRS="x86"

else
    echo "unknown architecture $FF_ARCH";
    exit 1
fi

if [[ ! -d ${FF_FFMPEG_SOURCE_PATH} ]]; then
    echo ""
    echo "!! ERROR"
    echo "!! Can not find FFmpeg directory for $FF_BUILD_NAME"
    echo "!! Run 'sh init-android.sh' first"
    echo ""
    exit 1
fi

FF_OUTPUT_PATH=${FF_BUILD_ROOT}/build/${FF_BUILD_NAME}/output

FF_TOOLCHAIN_PATH=${FF_BUILD_ROOT}/build/${FF_BUILD_NAME}/toolchain

FF_TOOLCHAIN_SYSROOT_PATH=${FF_TOOLCHAIN_PATH}/sysroot

FF_DEP_OPENSSL_INC_PATH=${FF_BUILD_ROOT}/build/${FF_BUILD_NAME_OPENSSL}/output/include

FF_DEP_OPENSSL_LIB_PATH=${FF_BUILD_ROOT}/build/${FF_BUILD_NAME_OPENSSL}/output/lib

FF_DEP_LIBSOXR_INC_PATH=${FF_BUILD_ROOT}/build/${FF_BUILD_NAME_LIBSOXR}/output/include

FF_DEP_LIBSOXR_LIB_PATH=${FF_BUILD_ROOT}/build/${FF_BUILD_NAME_LIBSOXR}/output/lib

mkdir -p ${FF_OUTPUT_PATH}

echo "FF_FFMPEG_SOURCE_PATH = $FF_FFMPEG_SOURCE_PATH"
echo ""
echo "FF_BUILD_NAME = $FF_BUILD_NAME"
echo "FF_BUILD_NAME_OPENSSL = $FF_BUILD_NAME_OPENSSL"
echo "FF_BUILD_NAME_LIBSOXR = $FF_BUILD_NAME_LIBSOXR"
echo "FF_CROSS_PREFIX_NAME = $FF_CROSS_PREFIX_NAME"
echo "FF_STANDALONE_TOOLCHAIN_NAME = $FF_STANDALONE_TOOLCHAIN_NAME"
echo ""
echo "FF_CFG_FLAGS = $FF_CFG_FLAGS"
echo "FF_EXTRA_CFLAGS = $FF_EXTRA_CFLAGS"
echo "FF_EXTRA_LDFLAGS = $FF_EXTRA_LDFLAGS"
echo "FF_ASSEMBLER_SUB_DIRS = $FF_ASSEMBLER_SUB_DIRS"
echo ""
echo "FF_OUTPUT_PATH = $FF_OUTPUT_PATH"
echo "FF_TOOLCHAIN_PATH = $FF_TOOLCHAIN_PATH"
echo "FF_TOOLCHAIN_SYSROOT_PATH = $FF_TOOLCHAIN_SYSROOT_PATH"
echo "FF_DEP_OPENSSL_INC_PATH = $FF_DEP_OPENSSL_INC_PATH"
echo "FF_DEP_OPENSSL_LIB_PATH = $FF_DEP_OPENSSL_LIB_PATH"
echo "FF_DEP_LIBSOXR_INC_PATH = $FF_DEP_LIBSOXR_INC_PATH"
echo "FF_DEP_LIBSOXR_LIB_PATH = $FF_DEP_LIBSOXR_LIB_PATH"


echo ""
echo "--------------------"
echo "${RED}[*] make NDK standalone toolchain${NC}"
echo "--------------------"

FF_STANDALONE_TOOLCHAIN_FLAGS="$FF_STANDALONE_TOOLCHAIN_FLAGS --install-dir=$FF_TOOLCHAIN_PATH"

echo "FF_STANDALONE_TOOLCHAIN_NAME = $FF_STANDALONE_TOOLCHAIN_NAME"
echo "FF_STANDALONE_TOOLCHAIN_FLAGS = $FF_STANDALONE_TOOLCHAIN_FLAGS"
echo "FF_STANDALONE_TOOLCHAIN_STL = $FF_STANDALONE_TOOLCHAIN_STL"
echo "FF_STANDALONE_TOOLCHAIN_ARCH = $FF_STANDALONE_TOOLCHAIN_ARCH"
echo "FF_STANDALONE_TOOLCHAIN_CLANG = $FF_STANDALONE_TOOLCHAIN_CLANG"
echo "FF_ANDROID_PLATFORM = $FF_ANDROID_PLATFORM"

FF_TOOLCHAIN_TOUCH="$FF_TOOLCHAIN_PATH/touch"
if [[ ! -f "$FF_TOOLCHAIN_TOUCH" ]]; then

    ${ANDROID_NDK}/build/tools/make-standalone-toolchain.sh \
        ${FF_STANDALONE_TOOLCHAIN_FLAGS} \
        --platform=${FF_ANDROID_PLATFORM} \
        --toolchain=${FF_STANDALONE_TOOLCHAIN_NAME} 

    touch ${FF_TOOLCHAIN_TOUCH}
fi


echo ""
echo "--------------------"
echo "${RED}[*] check ffmpeg env${NC}"
echo "--------------------"

export PATH=${FF_TOOLCHAIN_PATH}/bin:$PATH
export CLANG=${FF_CROSS_PREFIX_NAME}-clang
export CXX=${FF_CROSS_PREFIX_NAME}-clang++
export LD=${FF_CROSS_PREFIX_NAME}-ld
export AR=${FF_CROSS_PREFIX_NAME}-ar
export STRIP=${FF_CROSS_PREFIX_NAME}-strip

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
FF_CFLAGS="-O3 -fPIC -Wall -pipe \
    -std=c99 \
    -ffast-math \
    -fstrict-aliasing -Werror=strict-aliasing \
    -Wno-psabi -Wa,--noexecstack \
    -DANDROID -DNDEBUG"

# with ffmpeg openssl
# if [[ -f "${FF_DEP_OPENSSL_LIB_PATH}/libssl.a" ]]; then
#     echo "OpenSSL detected"
#     FF_CFG_FLAGS="$FF_CFG_FLAGS --enable-nonfree"
#     FF_CFG_FLAGS="$FF_CFG_FLAGS --enable-openssl"

#     FF_CFLAGS="$FF_CFLAGS -I${FF_DEP_OPENSSL_INC_PATH}"
#     FF_DEP_LIBS="$FF_DEP_LIBS -L${FF_DEP_OPENSSL_LIB_PATH} -lssl -lcrypto"
# fi
# if [[ -f "${FF_DEP_LIBSOXR_LIB_PATH}/libsoxr.a" ]]; then
#     echo "libsoxr detected"
#     FF_CFG_FLAGS="$FF_CFG_FLAGS --enable-libsoxr"

#     FF_CFLAGS="$FF_CFLAGS -I${FF_DEP_LIBSOXR_INC_PATH}"
#     FF_DEP_LIBS="$FF_DEP_LIBS -L${FF_DEP_LIBSOXR_LIB_PATH} -lsoxr"
# fi

# with ffmpeg standard options:
FF_CFG_FLAGS="$FF_CFG_FLAGS --prefix=$FF_OUTPUT_PATH"
FF_CFG_FLAGS="$FF_CFG_FLAGS --sysroot=$FF_TOOLCHAIN_SYSROOT_PATH"
FF_CFG_FLAGS="$FF_CFG_FLAGS --cc=clang --host-cflags= --host-ldflags="

# with ffmpeg Advanced options (experts only):
FF_CFG_FLAGS="$FF_CFG_FLAGS --cross-prefix=${FF_TOOLCHAIN_PATH}/bin/${FF_CROSS_PREFIX_NAME}-"
FF_CFG_FLAGS="$FF_CFG_FLAGS --enable-cross-compile"
FF_CFG_FLAGS="$FF_CFG_FLAGS --target-os=linux"
FF_CFG_FLAGS="$FF_CFG_FLAGS --enable-pic"

if [[ "$FF_ARCH" = "x86" ]]; then
    FF_CFG_FLAGS="$FF_CFG_FLAGS --disable-asm"
else
    FF_CFG_FLAGS="$FF_CFG_FLAGS --enable-asm"
    FF_CFG_FLAGS="$FF_CFG_FLAGS --enable-inline-asm"
fi

case "$FF_BUILD_OPT" in
    debug)
        FF_CFG_FLAGS="$FF_CFG_FLAGS --disable-optimizations"
        FF_CFG_FLAGS="$FF_CFG_FLAGS --enable-debug"
        FF_CFG_FLAGS="$FF_CFG_FLAGS --disable-small"
    ;;
    *)
        FF_CFG_FLAGS="$FF_CFG_FLAGS --enable-optimizations"
        FF_CFG_FLAGS="$FF_CFG_FLAGS --enable-debug"
        FF_CFG_FLAGS="$FF_CFG_FLAGS --enable-small"
    ;;
esac

# with ffmpeg config module
export COMMON_FF_CFG_FLAGS=
. ${FF_BUILD_ROOT}/../../config/module.sh

FF_CFG_FLAGS="$FF_CFG_FLAGS $COMMON_FF_CFG_FLAGS"

echo "PATH = $PATH"
echo "CLANG = $CLANG"
echo "LD = $LD"
echo "AR = $AR"
echo "STRIP = $STRIP"
echo ""
echo "FF_CFLAGS = $FF_CFLAGS"
echo "FF_EXTRA_CFLAGS = $FF_EXTRA_CFLAGS"
echo ""
echo "FF_DEP_LIBS = $FF_DEP_LIBS"
echo "FF_EXTRA_LDFLAGS = $FF_EXTRA_LDFLAGS"
echo ""
echo "FF_CFG_FLAGS = $FF_CFG_FLAGS"
echo ""

echo "--------------------"
echo "${RED}[*] configurate ffmpeg${NC}"
echo "--------------------"

cd ${FF_FFMPEG_SOURCE_PATH}

# http://www.runoob.com/linux/linux-comm-which.html
# which指令会在环境变量$PATH设置的目录里查找符合条件的文件。
# which $CC
# which ${CLANG}
if [ -f "./config.h" ]; then
    echo 'Reuse configure'
else
    ./configure ${FF_CFG_FLAGS} \
        --extra-cflags="$FF_CFLAGS $FF_EXTRA_CFLAGS" \
        --extra-ldflags="$FF_DEP_LIBS $FF_EXTRA_LDFLAGS" 
    
    make clean
fi

echo ""
echo "--------------------"
echo "${RED}[*] compile ffmpeg${NC}"
echo "--------------------"
echo "FF_OUTPUT_PATH = $FF_OUTPUT_PATH"

cp config.* ${FF_OUTPUT_PATH}

make install > /dev/null

mkdir -p FF_OUTPUT_PATH/include/libffmpeg
cp -f config.h FF_OUTPUT_PATH/include/libffmpeg/config.h

echo "FF_LIB_CONFIG = $FF_OUTPUT_PATH/include/libffmpeg/config.h"
echo "FFmpeg install success"


echo ""
echo "--------------------"
echo "${RED}[*] link ffmpeg${NC}"
echo "--------------------"

FF_LINK_C_OBJ_FILES=
FF_LINK_ASM_OBJ_FILES=
for MODULE_DIR in ${FF_LINK_MODULE_DIRS}
do
    C_OBJ_FILES="$MODULE_DIR/*.o"
    if ls ${C_OBJ_FILES} 1> /dev/null 2>&1; then
        echo "link $MODULE_DIR/*.o"
        FF_LINK_C_OBJ_FILES="$FF_LINK_C_OBJ_FILES $C_OBJ_FILES"
    fi

    for ASM_SUB_DIR in ${FF_ASSEMBLER_SUB_DIRS}
    do
        ASM_OBJ_FILES="$MODULE_DIR/$ASM_SUB_DIR/*.o"
        if ls ${ASM_OBJ_FILES} 1> /dev/null 2>&1; then
            echo "link $MODULE_DIR/$ASM_SUB_DIR/*.o"
            FF_LINK_ASM_OBJ_FILES="$FF_LINK_ASM_OBJ_FILES $ASM_OBJ_FILES"
        fi
    done
done

echo ""
echo "FF_LINK_C_OBJ_FILES = $FF_LINK_C_OBJ_FILES"
echo "FF_LINK_ASM_OBJ_FILES = $FF_LINK_ASM_OBJ_FILES"
echo "FF_DEP_LIBS = $FF_DEP_LIBS"
echo "FF_SPLAYER_SO = $FF_OUTPUT_PATH/$FF_SPLAYER_SO_NAME"
echo "FF_ANDROID_PLATFORM = $FF_ANDROID_PLATFORM"
echo "FF_TOOLCHAIN_SYSROOT = $FF_TOOLCHAIN_SYSROOT_PATH"
echo "Use Compiler: ${CLANG}"
echo ""

${CLANG} -lm -lz -shared -Wl,--no-undefined -Wl,-z,noexecstack ${FF_EXTRA_LDFLAGS} \
    -Wl,-soname,$FF_SPLAYER_SO_NAME \
    ${FF_LINK_C_OBJ_FILES} \
    ${FF_LINK_ASM_OBJ_FILES} \
    -o ${FF_OUTPUT_PATH}/$FF_SPLAYER_SO_NAME 

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

echo ""
echo "--------------------"
echo "${RED}[*] create files for shared ffmpeg${NC}"
echo "--------------------"
echo ""

rm -rf ${FF_OUTPUT_PATH}/shared
mkdir -p ${FF_OUTPUT_PATH}/shared/lib/pkgconfig
ln -s ${FF_OUTPUT_PATH}/include ${FF_OUTPUT_PATH}/shared/include
ln -s ${FF_OUTPUT_PATH}/${FF_SPLAYER_SO_NAME} ${FF_OUTPUT_PATH}/shared/lib/${FF_SPLAYER_SO_NAME}
cp ${FF_OUTPUT_PATH}/lib/pkgconfig/*.pc ${FF_OUTPUT_PATH}/shared/lib/pkgconfig

echo "FF_OUTPUT_SHARE = ${FF_OUTPUT_PATH}/shared"
echo "FF_OUTPUT_SHARE_INCLUDE = ${FF_OUTPUT_PATH}/shared/include"
echo "FF_OUTPUT_SHARE_LIB = ${FF_OUTPUT_PATH}/shared/lib"
echo ""

for f in ${FF_OUTPUT_PATH}/lib/pkgconfig/*.pc; do
    # in case empty dir
    if [[ ! -f ${f} ]]; then
        continue
    fi
    cp ${f} ${FF_OUTPUT_PATH}/shared/lib/pkgconfig
    f=${FF_OUTPUT_PATH}/shared/lib/pkgconfig/`basename ${f}`
    echo "process share lib${f}"
    # OSX sed doesn't have in-place(-i)
    mysedi ${f} 's/\/output/\/output\/shared/g'
    mysedi ${f} 's/-lavcodec/-lsffmpeg/g'
    mysedi ${f} 's/-lavfilter/-lsffmpeg/g'
    mysedi ${f} 's/-lavformat/-lsffmpeg/g'
    mysedi ${f} 's/-lavutil/-lsffmpeg/g'
    mysedi ${f} 's/-lswresample/-lsffmpeg/g'
    mysedi ${f} 's/-lswscale/-lsffmpeg/g'
done

echo ""