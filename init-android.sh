#! /usr/bin/env bash

RED='\033[0;31m'
Green='\033[0;33m'
NC='\033[0m' # No Color

FFMPEG_UPSTREAM=https://github.com/FFmpeg/FFmpeg.git
FFMPEG_VERSION=4.1
FFMPEG_BRANCH=origin/release/$FFMPEG_VERSION
FFMPEG_LOCAL_REPO=repository/ffmpeg-$FFMPEG_VERSION

# http://www.runoob.com/linux/linux-comm-set.html
# set指令能设置所使用shell的执行方式，可依照不同的需求来做设置
# -e 　若指令传回值不等于0，则立即退出shell。

set -e

git --version

echo "--------------------"
echo -e "${RED}[*] pull ffmpeg ($FFMPEG_UPSTREAM) base branch $FFMPEG_BRANCH ${NC}"
echo "--------------------"

# if [ -d repository/ffmpeg-${FFMPEG_VERSION} ]; then
#     rm -rf ./repository/ffmpeg-$FFMPEG_VERSION
# fi 

sh tools/pull-repo-base.sh $FFMPEG_UPSTREAM $FFMPEG_LOCAL_REPO

function pull_fork()
{
    echo ""
    echo "--------------------"
    echo -e "${RED}[*] pull ffmpeg fork ffmpeg-$1 ${NC}"
    echo "--------------------"
    
    if [[ -d android/ffmpeg-$1 ]]; then
        rm -rf android/ffmpeg-$1
    fi

    sh tools/pull-repo-ref.sh $FFMPEG_UPSTREAM android/ffmpeg-$1 ${FFMPEG_LOCAL_REPO}
    cd android/ffmpeg-$1
    git checkout -b build_tools ${FFMPEG_BRANCH}
    cd -
}

pull_fork "armv7a"
# pull_fork "armv8a"
# pull_fork "x86"
# pull_fork "x86_64"

echo "--------------------"
echo -e "${RED}[*] Finish pull ffmpeg ${NC}"
echo "--------------------"