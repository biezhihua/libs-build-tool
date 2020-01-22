#!/bin/bash

set -e

export BASEDIR=$(pwd)
export CONTRIB=$(pwd)/contrib
export CONTRIB_SRC=$(pwd)/contrib/src
export CONTRIB_TARBALLS=$(pwd)/contrib/tarballs
export PREBUILT=$(pwd)/prebuilt

export FFMPEG_CONFIG=min

get_all_pkgs() {
    local ALL_PKGS=""
    for filepath in $CONTRIB_SRC/*; do
        if [[ -d $filepath && -d ${filepath}/rules ]]; then
            name=${filepath##*/}
            ALL_PKGS="$ALL_PKGS $name"
        fi
    done
    echo $ALL_PKGS
}

get_make_flags() {
    echo -j$(get_cpu_count)
}

get_cpu_count() {
    if [ "$(uname)" == "Darwin" ]; then
        echo $(sysctl -n hw.physicalcpu)
    else
        echo $(nproc)
    fi
}

prepare_inline_sed() {
    if [ "$(uname)" == "Darwin" ]; then
        export SED_INLINE="sed -i .tmp"
    else
        export SED_INLINE="sed -i"
    fi
}

check_basedir() {
    if [[ -z ${BASEDIR} ]]; then
        echo -e "(*) BASEDIR not defined"
        exit 1
    fi
}

check_arch() {
    if [[ -z ${ARCH} ]]; then
        echo -e "(*) ARCH not defined"
        exit 1
    fi
}

build_env() {
    export PATH="$BASEDIR/env_tools/build/bin:$PATH"
    echo -e "INFO: Building env_tools"
    echo ""

    . ${BASEDIR}/env_tools/init.sh

    init_env_tools

    TMP_PWD=$(pwd)
    cd $BASEDIR/env_tools

    echo "INFO: Help Info"
    echo ""

    make $(get_make_flags)

    make $(get_make_flags) .gas || make $(get_make_flags) .buildgas

    cd $TMP_PWD
}

get_first_library() {
    for libname in $ENABLE_LIBRARYS; do
        echo $libname
        return
    done
    echo ""
}
