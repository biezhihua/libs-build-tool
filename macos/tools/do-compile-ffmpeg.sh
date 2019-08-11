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

if [ -z "$ARCH" ]; then
    echo "You must specific an architecture 'x86_64, ...'."
    exit 1
fi

BUILD_ROOT=`pwd`/tools

BUILD_NAME=
BUILD_NAME_OPENSSL=
FFMPEG_SOURCE_PATH=

CFG_FLAGS=

EXTRA_CFLAGS=
EXTRA_LDFLAGS=
DEP_LIBS=

LINK_MODULE_DIRS="compat libavcodec libavfilter libavformat libavutil libswresample libswscale"
ASSEMBLER_SUB_DIRS=

SPLAYER_SO_SIMPLE_NAME=sffmpeg
SPLAYER_SO_NAME=lib${SPLAYER_SO_SIMPLE_NAME}.so

echo ""
echo "--------------------"
echo "${RED}[*] make params${NC}"
echo "--------------------"

if [ "$ARCH" = "x86_64" ]; then
    
    BUILD_NAME=ffmpeg-x86_64

    BUILD_NAME_OPENSSL=openssl-x86_64

    FFMPEG_SOURCE_PATH=${BUILD_ROOT}/${BUILD_NAME}

    CFG_FLAGS="$CFG_FLAGS "

    EXTRA_CFLAGS="$EXTRA_CFLAGS "

    EXTRA_LDFLAGS="$EXTRA_LDFLAGS "

    ASSEMBLER_SUB_DIRS="$ASSEMBLER_SUB_DIRS "

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

OUTPUT_PATH=${BUILD_ROOT}/build/${BUILD_NAME}/output
SHARED_OUTPUT_PATH=${BUILD_ROOT}/../build/${BUILD_NAME}

OUTPUT_PATH_OPENSSL=${BUILD_ROOT}/build/${BUILD_NAME_OPENSSL}/output
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
echo ""
echo "CFG_FLAGS = $CFG_FLAGS"
echo "EXTRA_CFLAGS = $EXTRA_CFLAGS"
echo "EXTRA_LDFLAGS = $EXTRA_LDFLAGS"
echo "ASSEMBLER_SUB_DIRS = $ASSEMBLER_SUB_DIRS"
echo ""
echo "OUTPUT_PATH = $OUTPUT_PATH"
echo ""
echo "OUTPUT_PATH_OPENSSL = $OUTPUT_PATH_OPENSSL"
echo "DEP_OPENSSL_INC = $DEP_OPENSSL_INC"
echo "DEP_OPENSSL_LIB = $DEP_OPENSSL_LIB"

echo ""
echo "--------------------"
echo "${RED}[*] check ffmpeg env${NC}"
echo "--------------------"

CFLAGS=""

# with ffmpeg standard options:
CFG_FLAGS="$CFG_FLAGS --prefix=$OUTPUT_PATH"
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

make install > /dev/null

mkdir -p OUTPUT_PATH/include/libffmpeg
cp -f config.h OUTPUT_PATH/include/libffmpeg/config.h

echo "LIB_CONFIG = $OUTPUT_PATH/include/libffmpeg/config.h"
echo "FFmpeg install success"


exit 0

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
echo "SPLAYER_SO = $OUTPUT_PATH/$SPLAYER_SO_NAME"
echo "ANDROID_PLATFORM = $ANDROID_PLATFORM"
echo "TOOLCHAIN_SYSROOT = $TOOLCHAIN_SYSROOT_PATH"
echo "Use Compiler: ${CLANG}"
echo ""

${CLANG} -lm -lz -shared -Wl,--no-undefined -Wl,-z,noexecstack ${EXTRA_LDFLAGS} \
    -Wl,-soname,$SPLAYER_SO_NAME \
    ${LINK_C_OBJ_FILES} \
    ${LINK_ASM_OBJ_FILES} \
    ${DEP_LIBS} \
    -o ${OUTPUT_PATH}/$SPLAYER_SO_NAME 

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
cp ${OUTPUT_PATH}/${SPLAYER_SO_NAME} ${SHARED_OUTPUT_PATH}/lib/${SPLAYER_SO_NAME}
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
    mysedi ${f} 's/android\/build\/'${BUILD_NAME}'\/output/build\/'${BUILD_NAME}'/g'
    mysedi ${f} 's/-lavcodec/-l'${SPLAYER_SO_SIMPLE_NAME}'/g'
    mysedi ${f} 's/-lavfilter/-l'${SPLAYER_SO_SIMPLE_NAME}'/g'
    mysedi ${f} 's/-lavformat/-l'${SPLAYER_SO_SIMPLE_NAME}'/g'
    mysedi ${f} 's/-lavutil/-l'${SPLAYER_SO_SIMPLE_NAME}'/g'
    mysedi ${f} 's/-lswresample/-l'${SPLAYER_SO_SIMPLE_NAME}'/g'
    mysedi ${f} 's/-lswscale/-l'${SPLAYER_SO_SIMPLE_NAME}'/g'
done

echo ""
