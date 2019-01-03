#! /usr/bin/env bash

FFMPEG_UPSTREAM=https://github.com/FFmpeg/FFmpeg.git
FFMPEG_BRANCH=origin/release/4.1
FFMPEG_LOCAL_REPO=repository/ffmpeg

# http://www.runoob.com/linux/linux-comm-set.html
# set指令能设置所使用shell的执行方式，可依照不同的需求来做设置
# -e 　若指令传回值不等于0，则立即退出shell。

set -e

git --version

echo "== pull ffmpeg ($FFMPEG_UPSTREAM) base repository $FFMPEG_BRANCH =="

sh tools/pull-repo-base.sh $FFMPEG_UPSTREAM $FFMPEG_LOCAL_REPO

function pull_fork()
{
    echo "== pull ffmpeg fork $1 =="
    if [[ -d android/contrib/ffmpeg-$1 ]]; then
        rm -rf android/contrib/ffmpeg-$1
    fi

    sh tools/pull-repo-ref.sh $FFMPEG_UPSTREAM android/contrib/ffmpeg-$1 ${FFMPEG_LOCAL_REPO}
    cd android/contrib/ffmpeg-$1
    git checkout -b splayer ${FFMPEG_BRANCH}
    cd -
}

pull_fork "armv7a"
pull_fork "armv8a"
pull_fork "x86"
pull_fork "x86_64"

./init-config.sh