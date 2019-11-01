#! /usr/bin/env bash

source ../tools/colors.sh
source ../tools/common.sh
set -e

# 目标架构
target_arch=$1

# 库名称
name=ffmpeg

# 库地址
upstream=https://github.com/FFmpeg/FFmpeg.git

# 库分支
branch=origin/release/4.2

# 本地库地址
local_repo=../repository/ffmpeg

# 所有架构
arch_all="armv7a armv8a x86 x86_64"

init_repository