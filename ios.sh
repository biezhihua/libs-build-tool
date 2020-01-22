#!/bin/bash

# 引入公共模块
. $(pwd)/common/common.sh
. ${BASEDIR}/ios/common.sh
. ${BASEDIR}/ios/main.sh

main() {

    export DEFAULT_IOS_ARCHS="armv7 armv7s arm64 arm64e i386 x86-64"
    export IOS_MIN_VERSION=12.1

    process_args $*

    check_ios_arch

    print_enabled_architectures
    
    print_enabled_libraries

    build_env

    build_lib
    
    exit 0
}

main $*
