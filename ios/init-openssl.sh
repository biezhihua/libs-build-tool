#! /usr/bin/env bash

source ../tools/colors.sh
source ../tools/common.sh
set -e

# 目标架构
target_arch=$1

# 库名称
name=openssl

# 库地址
upstream=https://github.com/openssl/openssl

# 库分支
branch=origin/OpenSSL_1_1_1-stable

# 本地库地址
local_repo=../repository/openssl

# 所有架构
arch_all="armv7 armv7s arm64 i386 x86_64"

init_repository
