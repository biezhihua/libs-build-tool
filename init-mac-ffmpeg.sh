#! /usr/bin/env bash

RED='\033[0;31m'
Green='\033[0;33m'
NC='\033[0m' # No Color

TARGET=$1

UPSTREAM=https://github.com/FFmpeg/FFmpeg.git
VERSION=4.1
BRANCH=origin/release/$VERSION
LOCAL_REPO=repository/ffmpeg-$VERSION

# http://www.runoob.com/linux/linux-comm-set.html
# set指令能设置所使用shell的执行方式，可依照不同的需求来做设置
# -e 　若指令传回值不等于0，则立即退出shell。

set -e

git --version

function pull_repository()
{
    echo "--------------------"
    echo -e "${RED}[*] pull ffmpeg ($UPSTREAM) base branch $BRANCH ${NC}"
    echo "--------------------"
    
    sh tools/pull-repo-base.sh $UPSTREAM $LOCAL_REPO
}

function pull_fork()
{
    echo ""
    echo "--------------------"
    echo -e "${RED}[*] pull ffmpeg fork ffmpeg-$1 ${NC}"
    echo "--------------------"
    
    if [[ -d mac/ffmpeg-$1 ]]; then
        rm -rf mac/ffmpeg-$1
    fi
    
    sh tools/pull-repo-ref.sh $UPSTREAM mac/ffmpeg-$1 ${LOCAL_REPO}
    cd mac/ffmpeg-$1
    git checkout -b build_tools ${BRANCH}
    cd -
}

echo_usage() {
    echo "Usage:"
    echo "  init-mac-ffmpeg.sh x86_64"
    echo "  init-mac-ffmpeg.sh clean"
    exit 1
}

case "$TARGET" in
    all)
        pull_repository
        pull_fork "x86_64"
        echo "init complete"
    ;;
    x86_64)
        pull_repository
        pull_fork "x86_64"
        echo "init complete"
    ;;
    clean)
        ACT_ARCHS_ALL="x86_64"
        for ARCH in $ACT_ARCHS_ALL
        do
            if [[ -d mac/ffmpeg-$ARCH ]]; then
                echo "rm mac/ffmpeg-$ARCH"
                rm -rf mac/ffmpeg-$ARCH
            fi
        done
        echo "clean complete"
    ;;
    *)
        echo_usage
        exit 1
    ;;
esac

echo "--------------------"
echo -e "${RED}[*] Finish pull ffmpeg ${NC}"
echo "--------------------"