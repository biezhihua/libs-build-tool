#!/bin/bash

set -e

# 引入公共模块
. $(pwd)/common/common.sh
. ${BASEDIR}/android/common.sh
. ${BASEDIR}/android/main.sh

main() {

    export API=16

    process_args $*

    check_android_ndk_root

    check_android_home

    print_enabled_architectures

    print_enabled_libraries

    build_env

    build_lib

    exit 0
}

main $*
