#!/bin/bash

set -e

# 引入公共模块
. $(pwd)/common/common.sh

# 导入Android环境模块
. "${BASEDIR}"/android/common.sh
. "${BASEDIR}"/android/main.sh

main() {

  export API=16

  # 解析脚本参数
  # 初始化环境配置
  process_args $*

  # 检查前置条件 - NDK
  check_android_ndk_root

  # 检查前置条件 - ANDROID_HOME
  check_android_home

  # 打印可构建的架构
  print_enabled_architectures

  # 打印准备构建的库
  print_enabled_libraries

  # 构建编译环境
  build_env

  # 构建目标库
  build_lib

  # 退出脚本
  exit 0
}

main "$*"
