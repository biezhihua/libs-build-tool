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
FF_REAL_OUTPUT_PATH=$3

echo "FF_ARCH=$FF_ARCH"
echo "FF_BUILD_OPT=$FF_BUILD_OPT"
echo "FF_REAL_OUTPUT_PATH=$FF_REAL_OUTPUT_PATH"

if [ -z "$FF_ARCH" ]; then
    echo "You must specific an architecture 'x86_64, ...'."
    exit 1
fi

FF_BUILD_ROOT=`pwd`/mac

FF_BUILD_NAME=
FF_BUILD_NAME_OPENSSL=
FF_FFMPEG_SOURCE_PATH=

FF_CFG_FLAGS=

FF_EXTRA_CFLAGS=
FF_EXTRA_LDFLAGS=
FF_DEP_LIBS=

FF_LINK_MODULE_DIRS="compat libavcodec libavfilter libavformat libavutil libswresample libswscale"
FF_ASSEMBLER_SUB_DIRS=

FF_SPLAYER_SO_SIMPLE_NAME=sffmpeg
FF_SPLAYER_SO_NAME=lib${FF_SPLAYER_SO_SIMPLE_NAME}.so

echo ""
echo "--------------------"
echo "${RED}[*] make params${NC}"
echo "--------------------"

if [ "$FF_ARCH" = "x86_64" ]; then
    
    FF_BUILD_NAME=ffmpeg-x86_64

    FF_BUILD_NAME_OPENSSL=openssl-x86_64

    FF_FFMPEG_SOURCE_PATH=${FF_BUILD_ROOT}/${FF_BUILD_NAME}

    FF_CFG_FLAGS="$FF_CFG_FLAGS "

    FF_EXTRA_CFLAGS="$FF_EXTRA_CFLAGS "

    FF_EXTRA_LDFLAGS="$FF_EXTRA_LDFLAGS "

    FF_ASSEMBLER_SUB_DIRS="$FF_ASSEMBLER_SUB_DIRS "

else
    echo "unknown architecture $FF_ARCH";
    exit 1
fi

if [ ! -d ${FF_FFMPEG_SOURCE_PATH} ]; then
    echo ""
    echo "!! ERROR"
    echo "!! Can not find FFmpeg directory for $FF_BUILD_NAME"
    echo ""
    exit 1
fi

FF_OUTPUT_PATH=${FF_BUILD_ROOT}/build/${FF_BUILD_NAME}/output
FF_SHARED_OUTPUT_PATH=${FF_BUILD_ROOT}/../build/${FF_BUILD_NAME}

FF_OUTPUT_PATH_OPENSSL=${FF_BUILD_ROOT}/build/${FF_BUILD_NAME_OPENSSL}/output
FF_DEP_OPENSSL_INC=${FF_OUTPUT_PATH_OPENSSL}/include
FF_DEP_OPENSSL_LIB=${FF_OUTPUT_PATH_OPENSSL}/lib

rm -rf ${FF_BUILD_ROOT}/build/${FF_BUILD_NAME}
mkdir -p ${FF_OUTPUT_PATH}
mkdir -p ${FF_SHARED_OUTPUT_PATH}

echo "FF_FFMPEG_SOURCE_PATH = $FF_FFMPEG_SOURCE_PATH"
echo ""
echo "FF_BUILD_NAME = $FF_BUILD_NAME"
echo "FF_BUILD_NAME_OPENSSL = $FF_BUILD_NAME_OPENSSL"
echo "FF_BUILD_NAME_LIBSOXR = $FF_BUILD_NAME_LIBSOXR"
echo ""
echo "FF_CFG_FLAGS = $FF_CFG_FLAGS"
echo "FF_EXTRA_CFLAGS = $FF_EXTRA_CFLAGS"
echo "FF_EXTRA_LDFLAGS = $FF_EXTRA_LDFLAGS"
echo "FF_ASSEMBLER_SUB_DIRS = $FF_ASSEMBLER_SUB_DIRS"
echo ""
echo "FF_OUTPUT_PATH = $FF_OUTPUT_PATH"
echo ""
echo "FF_OUTPUT_PATH_OPENSSL = $FF_OUTPUT_PATH_OPENSSL"
echo "FF_DEP_OPENSSL_INC = $FF_DEP_OPENSSL_INC"
echo "FF_DEP_OPENSSL_LIB = $FF_DEP_OPENSSL_LIB"

echo ""
echo "--------------------"
echo "${RED}[*] check ffmpeg env${NC}"
echo "--------------------"

FF_CFLAGS=""

# with ffmpeg standard options:
FF_CFG_FLAGS="$FF_CFG_FLAGS --prefix=$FF_OUTPUT_PATH"
FF_CFG_FLAGS="$FF_CFG_FLAGS --cc=clang --host-cflags= --host-ldflags="

case "$FF_BUILD_OPT" in
    debug)
        FF_CFG_FLAGS="$FF_CFG_FLAGS --disable-optimizations"
        FF_CFG_FLAGS="$FF_CFG_FLAGS --enable-debug"
        FF_CFG_FLAGS="$FF_CFG_FLAGS --disable-small"
    ;;
    *)
        FF_CFG_FLAGS="$FF_CFG_FLAGS --enable-optimizations"
        FF_CFG_FLAGS="$FF_CFG_FLAGS --disable-debug"
        FF_CFG_FLAGS="$FF_CFG_FLAGS --enable-small"
    ;;
esac

# with ffmpeg config module
export COMMON_FF_CFG_FLAGS=
. ${FF_BUILD_ROOT}/../config/module.sh

# with openssl
if [ -f "${FF_DEP_OPENSSL_LIB}/libssl.a" ]; then
    export PKG_CONFIG_PATH=${FF_DEP_OPENSSL_LIB}/pkgconfig
    echo "PKG_CONFIG_PATH = ${PKG_CONFIG_PATH}"
    FF_CFG_FLAGS="$FF_CFG_FLAGS --enable-protocol=https"
    FF_CFG_FLAGS="$FF_CFG_FLAGS --enable-openssl"
    FF_CFG_FLAGS="$FF_CFG_FLAGS --pkg-config=pkg-config"
    FF_CFLAGS="$FF_CFLAGS -I${FF_DEP_OPENSSL_INC}"
    FF_DEP_LIBS="$FF_DEP_LIBS -L${FF_DEP_OPENSSL_LIB} -lssl -lcrypto"
fi

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

# path configure openssl
git add -A
git stash
patch -p0 ./configure ${FF_BUILD_ROOT}/patch/configure-patch.patch

# http://www.runoob.com/linux/linux-comm-which.html
# which指令会在环境变量$PATH设置的目录里查找符合条件的文件。
# which $CC
# which ${CLANG}
./configure ${FF_CFG_FLAGS} \
    --extra-cflags="$FF_CFLAGS $FF_EXTRA_CFLAGS" \
    --extra-ldflags="$FF_DEP_LIBS $FF_EXTRA_LDFLAGS" 

make clean

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


exit 0

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
    ${FF_DEP_LIBS} \
    -o ${FF_OUTPUT_PATH}/$FF_SPLAYER_SO_NAME 

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

rm -rf ${FF_SHARED_OUTPUT_PATH}
mkdir -p ${FF_SHARED_OUTPUT_PATH}/lib/pkgconfig
cp -r ${FF_OUTPUT_PATH}/include ${FF_SHARED_OUTPUT_PATH}/include
cp ${FF_OUTPUT_PATH}/${FF_SPLAYER_SO_NAME} ${FF_SHARED_OUTPUT_PATH}/lib/${FF_SPLAYER_SO_NAME}
cp ${FF_OUTPUT_PATH}/lib/pkgconfig/*.pc ${FF_SHARED_OUTPUT_PATH}/lib/pkgconfig

echo "FF_OUTPUT_SHARE = ${FF_SHARED_OUTPUT_PATH}"
echo "FF_OUTPUT_SHARE_INCLUDE = ${FF_SHARED_OUTPUT_PATH}/include"
echo "FF_OUTPUT_SHARE_LIB = ${FF_SHARED_OUTPUT_PATH}/lib"
echo ""

for f in ${FF_SHARED_OUTPUT_PATH}/lib/pkgconfig/*.pc; do
    # in case empty dir
    if [ ! -f ${f} ]; then
        continue
    fi
    f=${FF_SHARED_OUTPUT_PATH}/lib/pkgconfig/`basename ${f}`
    echo "process share lib ${f}"
    # OSX sed doesn't have in-place(-i)
    mysedi ${f} 's/android\/build\/'${FF_BUILD_NAME}'\/output/build\/'${FF_BUILD_NAME}'/g'
    mysedi ${f} 's/-lavcodec/-l'${FF_SPLAYER_SO_SIMPLE_NAME}'/g'
    mysedi ${f} 's/-lavfilter/-l'${FF_SPLAYER_SO_SIMPLE_NAME}'/g'
    mysedi ${f} 's/-lavformat/-l'${FF_SPLAYER_SO_SIMPLE_NAME}'/g'
    mysedi ${f} 's/-lavutil/-l'${FF_SPLAYER_SO_SIMPLE_NAME}'/g'
    mysedi ${f} 's/-lswresample/-l'${FF_SPLAYER_SO_SIMPLE_NAME}'/g'
    mysedi ${f} 's/-lswscale/-l'${FF_SPLAYER_SO_SIMPLE_NAME}'/g'
done

echo ""
