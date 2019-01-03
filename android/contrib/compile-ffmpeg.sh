#! /usr/bin/env bash

RED='\033[0;31m'
Green='\033[0;33m'
NC='\033[0m' # No Color

UNI_BUILD_ROOT=`pwd`

FF_TARGET=$1
FF_TARGET_EXTRA=$2

# -e 若指令传回值不等于0，则立即退出shell。
#set -e
# 执行指令后，会先显示该指令及所下的参数。
# set +x

FF_ACT_ARCHS_ALL="armv7a armv8a x86 x86_64"

echo_archs() {
    echo "--------------------"
    echo -e "${RED}[*] check archs${NC}"
    echo "--------------------"
    echo "FF_ALL_ARCHS = $FF_ACT_ARCHS_ALL"
    echo "FF_ACT_ARCHS = $*"
    echo ""
}

echo_usage() {
    echo "Usage:"
    echo "  compile-ffmpeg.sh armv7a|armv8a|x86|x86_64"
    echo "  compile-ffmpeg.sh all"
    echo "  compile-ffmpeg.sh clean"
    echo "  compile-ffmpeg.sh check"
    exit 1
}

echo_nextstep_help() {
    echo "--------------------"
    echo -e "${RED}[*] Finished${NC}"
    echo "--------------------"
}

case "$FF_TARGET" in
    "")
        echo_archs armv7a
        sh tools/do-compile-ffmpeg.sh armv7a
    ;;
    armv7a|armv8a|x86|x86_64)
        echo_archs $FF_TARGET $FF_TARGET_EXTRA
        sh tools/do-compile-ffmpeg.sh $FF_TARGET $FF_TARGET_EXTRA
        echo_nextstep_help
    ;;
    all)
        echo "prepare all"
        echo_archs $FF_ACT_ARCHS_ALL
        for ARCH in $FF_ACT_ARCHS_ALL
        do
            echo "$ARCH $FF_TARGET_EXTRA"
            sh ./tools/do-compile-ffmpeg.sh $ARCH $FF_TARGET_EXTRA
        done
        echo_nextstep_help
    ;;
    clean)
        echo "prepare clean"
        echo_archs FF_ACT_ARCHS_ALL
        for ARCH in $FF_ACT_ARCHS_ALL
        do
            if [ -d ffmpeg-$ARCH ]; then
                cd ffmpeg-$ARCH && git clean -xdf && cd -
            fi
        done
        rm -rf ./build/ffmpeg-*
    ;;
    check)
        echo_archs FF_ACT_ARCHS_ALL
    ;;
    *)
        echo_usage
        exit 1
    ;;
esac
