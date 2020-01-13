#!/bin/bash

export BASEDIR=$(pwd)
export CONTRIB=$(pwd)/contrib
export CONTRIB_SRC=$(pwd)/contrib/src
export CONTRIB_TARBALLS=$(pwd)/contrib/tarballs

# 引入公共模块
. ${BASEDIR}/common/common.sh
. ${BASEDIR}/android/common.sh
. ${BASEDIR}/android/main.sh

main() {

    export API=16

    process_args $*

    check_ndk_root

    check_android_home

    print_enabled_architectures

    print_enabled_libraries

    build_env

    # build_lib
}

main $*
