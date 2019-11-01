#!/usr/bin/env bash

source ../tools/colors.sh
set -e

# in: upstream
# in: branch
# in: local_repo
function pull_repository() {

    echo "--------------------"
    echo -e "${red}[*] pull ffmpeg=$upstream base branch=$branch ${nc}"
    echo "--------------------"

    current_path=`pwd`

    if [[ ! -d ${local_repo} ]]; then
        git clone ${upstream} ${local_repo}
    else
        cd ${local_repo}
        git fetch --all --tags
    fi

    cd ${current_path}

    echo ""
}

# in: name
# in: target_arch
# in: upstream
# in: branch
# in: local_repo
function pull_fork() {

    echo "--------------------"
    echo -e "${red}[*] pull ${name} fork ${name}-${target_arch} ${nc}"
    echo "--------------------"

    remote_repo=${upstream}
    local_workspace_path=./build/src/${name}-${target_arch}
    ref_repo=${local_repo}

    if [[ -d ${local_workspace_path} ]]; then
        rm -rf ${local_workspace_path}
    fi

    current_path=`pwd`

    if [[ ! -d ${local_workspace_path} ]]; then
        git clone --reference ${ref_repo} ${remote_repo} ${local_workspace_path}
        cd ${local_workspace_path}
        git repack -a
        cd ${current_path}
    else
        cd ${local_workspace_path}
        git fetch --all --tags
        cd ${current_path}
    fi

    cd ${local_workspace_path}

    git checkout -b build_tools ${branch}

    cd ${current_path}

    echo ""
}

# in: name
# in: arch_all
function echo_init_usage() {
    echo "Usage:"
    echo "  init-${name}.sh ${arch_all}"
    echo "  init-${name}.sh clean"
    exit 1
}

# in: target_arch
# in: arch_all
function init_repository() {
    case ${target_arch} in
        all)
            pull_repository
            for arch in ${arch_all}
            do
                target_arch="$arch"
                pull_fork
            done
        ;;
        armv7|armv7s|arm64|x86_64|i386|armv7a|armv8a|x86)
            pull_repository
            pull_fork
        ;;
        clean)
            for arch in ${arch_all}
            do
                if [[ -d build/${name}-${arch} ]]; then
                    rm -rf build/${name}-${arch}
                fi
            done
            echo "clean complete"
        ;;
        *)
            echo_init_usage
            exit 1
        ;;
    esac
}

# in: arch_all
# in: target_arch
function echo_arch() {
    echo "--------------------"
    echo -e "${red}[*] check arch ${nc}"
    echo "--------------------"
    echo "arch_all = ${arch_all}"
    echo "arch = ${target_arch}"
    echo ""
}

# in: name
# in: arch_all
function echo_compile_usage() {
    echo "Usage:"
    echo "  compile-${name}.sh ${arch_all}"
    echo "  compile-${name}.sh clean"
    exit 1
}

# in: target_arch
# in: arch_all
function check_env() {
    echo "--------------------"
    echo -e "${red}[*] check env ing ${nc}"
    echo "--------------------"

    echo "arch = ${target_arch}"

    if [[ -z "$target_arch" ]]; then
        echo "You must specific an architecture ${arch_all} ...."
        exit 1
    fi
    echo ""
}

function check_ndk() {
    if [[ -z "$ANDROID_NDK" ]]; then
        echo "You must define ANDROID_NDK before starting."
        echo "They must point to your NDK directories."
        echo ""
        exit 1
    fi

    ndk_rel=$(grep -o '^Pkg\.Revision.*=[0-9]*.*' ${ANDROID_NDK}/source.properties 2>/dev/null | sed 's/[[:space:]]*//g' | cut -d "=" -f 2)

    case "$ndk_rel" in
        13*|14*|15*|16*|17*|18*|19*|20*)
            if test -d ${ANDROID_NDK}/toolchains/arm-linux-androideabi-4.9
            then
                echo "ndk version = r$ndk_rel"
            else
                echo "You need the NDK r16b r17c 18b 19 20"
                echo "https://developer.android.com/ndk/downloads/"
                exit 1
            fi
        ;;
        *)
            echo "You need the NDK r16b r17c 18b 19 20"
            echo "https://developer.android.com/ndk/downloads/"
            exit 1
        ;;
    esac
}

# out:xcrun_developer
function check_ios_mac_host() {

    echo "--------------------"
    echo -e "${red}[*] check host ${nc}"
    echo "--------------------"

    xcrun_developer=`xcode-select -print-path`

    if [[ ! -d "$xcrun_developer" ]]; then
      echo "xcode path is not set correctly $xcrun_developer does not exist (most likely because of xcode > 4.3)"
      echo "run"
      echo "sudo xcode-select -switch <xcode path>"
      echo "for default installation:"
      echo "sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer"
      exit 1
    fi

    case ${xcrun_developer} in
         *\ * )
               echo "Your Xcode path contains whitespaces, which is not supported."
               exit 1
              ;;
    esac

    echo "xcrun_developer=$xcrun_developer"
    echo ""
}

# in:  target_arch
# in:  xcrun_platform_name
# in:  xcrun_osversion
# out: xcrun_sdk
# out: xcrun_sdk_platform_path
# out: xcrun_sdk_path
# out: xcrun_cc
# out: CROSS_TOP
# out: CROSS_SDK
# out: BUILD_TOOL
# out: CC
function make_ios_or_mac_toolchain() {
    echo "--------------------"
    echo -e "${red}[*] make toolchain [构建工具链] ${nc}"
    echo "--------------------"

    # echo "iPhoneOS" | tr '[:upper:]' '[:lower:]'
    # iphoneos
    xcrun_sdk=`echo ${xcrun_platform_name} | tr '[:upper:]' '[:lower:]'`

    # xcrun --sdk iphoneos --show-sdk-platform-path
    # /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform
    xcrun_sdk_platform_path=`xcrun -sdk ${xcrun_sdk} --show-sdk-platform-path`

    # xcrun --sdk iphoneos --show-sdk-path
    # /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS13.0.sdk
    xcrun_sdk_path=`xcrun -sdk ${xcrun_sdk} --show-sdk-path`

    # xcrun --sdk iphoneos clang
    xcrun_cc="xcrun -sdk ${xcrun_sdk} clang"

    export CROSS_TOP="$xcrun_sdk_platform_path/Developer"
    export CROSS_SDK=`echo ${xcrun_sdk_path/#$CROSS_TOP\/SDKs\//}`
    export BUILD_TOOL="$xcrun_developer"
    export CC="$xcrun_cc -arch $target_arch $xcrun_osversion"

    echo "xcrun_sdk = $xcrun_sdk"
    echo ""
    echo "xcrun_sdk_platform_path = $xcrun_sdk_platform_path"
    echo ""
    echo "xcrun_sdk_path = $xcrun_sdk_path"
    echo ""
    echo "xcrun_cc = xcrun --sdk ${xcrun_sdk} clang"
    echo ""
    echo "CROSS_TOP = $CROSS_TOP"
    echo ""
    echo "CROSS_SDK = $CROSS_SDK"
    echo ""
    echo "BUILD_TOOL = $BUILD_TOOL"
    echo ""
    echo "CC = $CC"
    echo ""
}

# in:  target_arch
# in:  name
# in:  build_root
# out: build_name
# out: build_
# out: source_path
# out: output_path
# out: product_path
function make_env_params() {

    echo "--------------------"
    echo -e "${red}[*] make env params ${nc}"
    echo "--------------------"

    build_root=`pwd`/build
    build_name=${name}-${target_arch}
    source_path=${build_root}/src/${build_name}
    output_path=${build_root}/output/${build_name}
    product_path=${build_root}/product/${build_name}
    toolchain_path=${build_root}/toolchain/${build_name}

    build_name_depend=${name_depend}-${target_arch}
    source_path_depend=${build_root}/src/${build_name_depend}
    output_path_depend=${build_root}/output/${build_name_depend}
    product_path_depend=${build_root}/product/${build_name_depend}
    toolchain_path_depend=${build_root}/toolchain/${build_name_depend}

    export PATH=${toolchain_path}/bin:$PATH
    export ANDROID_NDK_HOME=${toolchain_path}
    export PATH=${ANDROID_NDK_HOME}/bin:$PATH

    if [[ ! -d ${output_path} ]]; then
         mkdir -p ${output_path}
    fi

    if [[ ! -d ${product_path} ]]; then
         mkdir -p ${product_path}
    fi

    if [[ ! -d ${output_path_depend} ]]; then
         mkdir -p ${output_path_depend}
    fi

    if [[ ! -d ${product_path_depend} ]]; then
         mkdir -p ${product_path_depend}
    fi

    echo "build_root = $build_root"
    echo ""
    echo "build_name = $build_name"
    echo ""
    echo "source_path = $source_path"
    echo ""
    echo "output_path = $output_path"
    echo ""
    echo "product_path = $product_path"
    echo ""
    echo "toolchain_path = $toolchain_path"
    echo ""
    echo "build_name_depend = $build_name_depend"
    echo ""
    echo "source_path_depend = $source_path_depend"
    echo ""
    echo "output_path_depend = $output_path_depend"
    echo ""
    echo "product_path_depend = $product_path_depend"
    echo ""
    echo "toolchain_path_depend = $toolchain_path_depend"
    echo ""
}

# in: source_path
# in: cfg_flags
# in: xcrun_cc
# in: cfg_cpu
# in: ld_flags
# in: dep_libs
# in: output_path
function make_ios_or_mac_ffmpeg_product() {
    echo "--------------------"
    echo -e "${red}[*] compile openssl ${nc}"
    echo "--------------------"

    current_path=`pwd`
    cd ${source_path}

    echo "current_directory = ${source_path}"

    ./configure \
        ${cfg_flags} \
        --cc="$xcrun_cc" \
        ${cfg_cpu} \
        --extra-cflags="$c_flags" \
        --extra-cxxflags="$c_flags" \
        --extra-ldflags="$ld_flags $ld_libs"

    make clean
    make install -j8

    cp -r ${output_path}/include ${product_path}/include
    mkdir -p ${product_path}/lib
    cp -r ${output_path}/lib/* ${product_path}/lib/

    cd ${current_path}

    echo "product_path = ${product_path}"
    echo ""
    echo "product_path_include = ${product_path}/include"
    echo ""
    echo "product_path_lib = ${product_path}/lib"
    echo ""
}

# 构建OpenSSL产物
function make_openssl_product() {
    echo "--------------------"
    echo -e "${red}[*] compile openssl ${nc}"
    echo "--------------------"

    current_path=`pwd`

    cd ${source_path}

    echo "current_directory = ${source_path}"

    ./Configure ${cfg_flags}

    make clean
    make SHLIB_VERSION_NUMBER=
    make install

    cp -r ${output_path}/include ${product_path}/include
    mkdir -p ${product_path}/lib
    cp ${output_path}/lib/libcrypto.a ${product_path}/lib/libcrypto.a
    cp ${output_path}/lib/libssl.a ${product_path}/lib/libssl.a

    cd ${current_path}

    echo "product_path = ${product_path}"
    echo ""
    echo "product_path_include = ${product_path}/include"
    echo ""
    echo "product_path_lib = ${product_path}/lib"
    echo ""
}

# 构建AndroidNDK工具链
function make_android_toolchain() {
    android_standalone_toolchain_flags="$android_standalone_toolchain_flags --install-dir=$toolchain_path"
    ${ANDROID_NDK}/build/tools/make-standalone-toolchain.sh \
        ${android_standalone_toolchain_flags} \
        --platform=${android_platform_name} \
        --toolchain=${android_standalone_toolchain_name} \
        --force
}

function mysedi() {
    f=$1
    exp=$2
    n=`basename $f`
    cp $f /tmp/$n
    # http://www.runoob.com/linux/linux-comm-sed.html
    # sed可依照script的指令，来处理、编辑文本文件。
    sed $exp /tmp/$n > $f
    rm /tmp/$n
    # echo "${f}    ${exp}    ${n}"
}

# 目标架构
# eg: arm64
target_arch=

# 所有支持架构
arch_all=

# 库地址
upstream=

# 库分支
branch=

# 本地库地址
local_repo=

# 库名称
# eg: ffmpeg/openssl
name=

# 库名称
# eg: openssl
name_depend=

# 构建根路径
# eg: */build/
build_root=

# 构建名称
build_name=
source_path=
output_path=
product_path=
toolchain_path=

# 构建依赖项名称
build_name_depend=
source_path_depend=
output_path_depend=
product_path_depend=
toolchain_path_depend=

# 构建配置
cfg_flags=
cfg_cpu=

# c构建配置
c_flags=

# ld构建配置
ld_flags=

# 构建依赖
ld_libs=

## iOS
##

# iOS SDK
# eg: iphoneos
xcrun_sdk=

# iOS SDK 平台路径
# eg: /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform
xcrun_sdk_platform_path=

# iOS 平台名称
# eg: "iPhoneOS"
xcrun_platform_name=

# iOS SDK 路径
# eg: /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS13.0.sdk
xcrun_sdk_path=

# iOS SDK CC 编译
# eg: xcrun --sdk iphoneos clang
xcrun_cc=

# iOS SDK 支持最低版本
# eg: xcrun_osversion="-miphoneos-version-min=7.0"
xcrun_osversion=

# Android
# eg: 20.0.5594570
ndk_rel=

# android平台名称
# eg: android-21
android_platform_name=

# Android独立工具链clang
# eg: clang3.6
android_standalone_toolchain_clang=

android_standalone_toolchain_cross_prefix_name=

# Android独立工具链名称
# eg:
android_standalone_toolchain_name=

# Android独立工具链编译标记
android_standalone_toolchain_flags=