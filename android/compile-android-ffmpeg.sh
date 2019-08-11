#! /usr/bin/env bash

RED='\033[0;31m'
Green='\033[0;33m'
NC='\033[0m'

UNI_BUILD_ROOT=`pwd`

TARGET=$1
TARGET_EXTRA=$2

ACT_ARCHS_ALL="armv7a armv8a x86 x86_64"

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
    echo "  compile-android-ffmpeg.sh armv7a|armv8a|x86|x86_64"
    echo "  compile-android-ffmpeg.sh all"
    echo "  compile-android-ffmpeg.sh clean"
    exit 1
}

echo_nextstep_help() {
    echo "--------------------"
    echo -e "${RED}[*] Finished${NC}"
    echo "--------------------"
}

case "$TARGET" in
    "")
        echo_archs armv7a
        sh ./tools/do-compile-android-ffmpeg.sh armv7a
    ;;
    armv7a|armv8a|x86|x86_64)
        echo_archs $TARGET $TARGET_EXTRA
        sh ./tools/do-compile-android-ffmpeg.sh $TARGET $TARGET_EXTRA
        echo_nextstep_help
    ;;
    all)
        echo "prepare all"
        echo_archs $ACT_ARCHS_ALL
        for ARCH in $ACT_ARCHS_ALL
        do
            echo "$ARCH $TARGET_EXTRA"
            sh ./tools/do-compile-android-ffmpeg.sh $ARCH $TARGET_EXTRA
        done
        echo_nextstep_help
    ;;
    clean)
        echo "prepare clean"
        echo_archs ACT_ARCHS_ALL
        for ARCH in $ACT_ARCHS_ALL
        do
            if [ -d ./tools/ffmpeg-$ARCH ]; then
                cd ./tools/ffmpeg-$ARCH && git clean -xdf && cd -
            fi
        done
        rm -rf ./tools/build/ffmpeg-*
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
