#! /usr/bin/env bash

RED='\033[0;31m'
Green='\033[0;33m'
NC='\033[0m' # No Color

UNI_BUILD_ROOT=`pwd`

TARGET=$1
TARGET_EXTRA=$2

# -e 若指令传回值不等于0，则立即退出shell。
#set -e
# 执行指令后，会先显示该指令及所下的参数。
# set +x

ACT_ARCHS_ALL="x86_64"

echo_archs() {
    echo "--------------------"
    echo -e "${RED}[*] check archs${NC}"
    echo "--------------------"
    echo "ALL_ARCHS = $ACT_ARCHS_ALL"
    echo "ACT_ARCHS = $*"
    echo ""
}

echo_usage() {
    echo "Usage:"
    echo "  compile-mac-ffmpeg.sh x86_64"
    echo "  compile-mac-ffmpeg.sh all"
    echo "  compile-mac-ffmpeg.sh clean"
    exit 1
}

echo_nextstep_help() {
    echo "--------------------"
    echo -e "${RED}[*] Finished${NC}"
    echo "--------------------"
}

case "$TARGET" in
    ""|x86_64)
        echo_archs $TARGET $TARGET_EXTRA
        sh ./mac/do-compile-mac-ffmpeg.sh $TARGET $TARGET_EXTRA
        echo_nextstep_help
    ;;
    all)
        echo "prepare all"
        echo_archs $ACT_ARCHS_ALL
        for ARCH in $ACT_ARCHS_ALL
        do
            echo "$ARCH $TARGET_EXTRA"
            sh ./mac/do-compile-mac-ffmpeg.sh $ARCH $TARGET_EXTRA
        done
        echo_nextstep_help
    ;;
    clean)
        echo "prepare clean"
        echo_archs ACT_ARCHS_ALL
        for ARCH in $ACT_ARCHS_ALL
        do
            if [ -d ffmpeg-$ARCH ]; then
                cd ffmpeg-$ARCH && git clean -xdf && cd -
            fi
        done
        rm -rf ./mac/build/ffmpeg-*
        rm -rf ./build/ffmpeg-*
    ;;
    check)
        echo_archs ACT_ARCHS_ALL
    ;;
    *)
        echo_usage
        exit 1
    ;;
esac
