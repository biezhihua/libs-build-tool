#!/bin/bash

set -e

# 创建根目录变量
export BASEDIR=$(pwd)

# 创建依赖库路径变量
export CONTRIB=$(pwd)/contrib

# 创建依赖库源代码路径变量
export CONTRIB_SRC=$(pwd)/contrib/src

# 创建依赖库
export CONTRIB_TARBALLS=$(pwd)/contrib/tarballs

# 创建编译产物路径比那辆
export PREBUILT=$(pwd)/prebuilt

# 创建默认的FFMPEG配置为MIN
export FFMPEG_CONFIG=min

# 获取所有支持的包
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

# 获取MAKE执行标记
get_make_flags() {
    echo -j$(get_cpu_count)
}

# 获取CPU核心数
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

# 构建编译环境
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
        echo "$libname"
        return
    done
    echo ""
}
