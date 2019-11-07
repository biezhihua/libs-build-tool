#! /usr/bin/env bash

source ../tools/colors.sh
source ../tools/common.sh
set -e

function make_ios_ffmpeg_config_params() {

    echo "--------------------"
    echo -e "${red}[*] make config params ${nc}"
    echo "--------------------"

    cfg_flags="$cfg_flags --prefix=$output_path"

    export COMMON_CFG_FLAGS=
    . ./config/module.sh

    # config
    cfg_flags="$cfg_flags ${COMMON_CFG_FLAGS}"

    #
    cfg_flags="$cfg_flags --enable-cross-compile"

    # Developer options (useful when working on FFmpeg itself):
    cfg_flags="$cfg_flags --disable-stripping"

    cfg_flags="$cfg_flags --arch=$target_arch"
    cfg_flags="$cfg_flags --target-os=darwin"

    cfg_flags="$cfg_flags --enable-optimizations"
    cfg_flags="$cfg_flags --disable-debug"
    cfg_flags="$cfg_flags --enable-small"

    # 动态库 Shared libraries are .so (or in Windows .dll, or in OS X .dylib) files.
    # 静态库 Static libraries are .a (or in Windows .lib) files.
    # https://stackoverflow.com/questions/2649334/difference-between-static-and-shared-libraries
    # https://blog.csdn.net/foooooods/article/details/80259395
    cfg_flags="$cfg_flags --enable-static"
    cfg_flags="$cfg_flags --disable-shared"

    if [[ "$target_arch" == "i386" ]]; then

        xcrun_platform_name="iPhoneSimulator"

        xcrun_osversion="-mios-simulator-version-min=8.0"

        cfg_flags="$cfg_flags --disable-asm"
        cfg_flags="$cfg_flags --disable-mmx"
        cfg_flags="$cfg_flags --assert-level=2"

    elif [[ "$target_arch" == "x86_64" ]]; then

        xcrun_platform_name="iPhoneSimulator"

        xcrun_osversion="-mios-simulator-version-min=8.0"

        cfg_flags="$cfg_flags --disable-asm"
        cfg_flags="$cfg_flags --disable-mmx"
        cfg_flags="$cfg_flags --assert-level=2"

    elif [[ "$target_arch" == "arm64" ]]; then

        xcrun_platform_name="iPhoneOS"

        xcrun_osversion="-miphoneos-version-min=8.0"

        xcode_bitcode="-fembed-bitcode"

        gaspp_export="GASPP_FIX_XCODE5=1"

        cfg_flags="$cfg_flags --enable-pic"
        cfg_flags="$cfg_flags --enable-neon"

    elif [[ "$target_arch" == "armv7" ]]; then

        xcrun_platform_name="iPhoneOS"

        xcrun_osversion="-miphoneos-version-min=8.0"

        xcode_bitcode="-fembed-bitcode"

        cfg_flags="$cfg_flags --enable-pic"
        cfg_flags="$cfg_flags --enable-neon"

    elif [[ "$target_arch" == "armv7s" ]]; then

        xcrun_platform_name="iPhoneOS"

        xcrun_osversion="-miphoneos-version-min=8.0"

        xcode_bitcode="-fembed-bitcode"

        cfg_cpu="$cfg_cpu --cpu=swift"

        cfg_flags="$cfg_flags --enable-pic"
        cfg_flags="$cfg_flags --enable-neon"

    else
        echo "unknown architecture $target_arch"
        exit 1
    fi

    c_flags="$c_flags -arch $target_arch"
    c_flags="$c_flags $xcrun_osversion"
    c_flags="$c_flags $xcode_bitcode"
    ld_flags="$ld_flags"
    ld_libs="$c_flags"
    cfg_cpu="$cfg_cpu"

    echo "cfg_flags = $cfg_flags"
    echo ""
    echo "dep_libs = $ld_libs"
    echo ""
    echo "ld_flags = $ld_flags"
    echo ""
    echo "cfg_cpu = $cfg_cpu"
    echo ""
    echo "xcrun_platform_name = $xcrun_platform_name"
    echo ""
    echo "xcrun_osversion = $xcrun_osversion"
    echo ""
    echo "xcode_bitcode = $xcode_bitcode"
    echo ""
}

function make_ios_ffmpeg_product() {
    echo "--------------------"
    echo -e "${red}[*] compile openssl ${nc}"
    echo "--------------------"

    current_path=$(pwd)
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
    mkdir -p ${product_path}/include/libffmpeg
    cp -f config.h ${product_path}/include/libffmpeg/config.h

    cd ${current_path}

    echo "product_path = ${product_path}"
    echo ""
    echo "product_path_include = ${product_path}/include"
    echo ""
    echo "product_path_lib = ${product_path}/lib"
    echo ""
}

function make_arch_merge() {
    echo "--------------------"
    echo -e "${red}[*] merge arch ${nc}"
    echo "--------------------"

    merge_root=${build_root}/product/${name}

    echo "merge_root = ${merge_root}"
    echo ""

    if [[ ! -d ${merge_root} ]]; then
        mkdir ${merge_root}
    fi

    for lib in ${merge_libs}; do
        file="$lib.a"
        merge_output=${merge_root}/lib/${file}

        if [[ ! -d ${merge_root}/lib ]]; then
            mkdir ${merge_root}/lib
        fi

        merge_src=

        echo "merge_output = ${merge_output}"
        echo ""

        for arch in ${arch_all}; do
            merge_name=${name}-${arch}
            merge_product_path=${build_root}/product/${merge_name}
            src=${merge_product_path}/lib/${file}
            if [[ -f ${src} ]]; then
                merge_src="$merge_src ${src}"

                echo "merge_name = ${merge_name}"
                echo "merge_product_path = ${merge_product_path}"
                echo ""
            fi
        done

        echo "merge_src = ${merge_src}"
        echo ""

        xcrun lipo -create ${merge_src} -output ${merge_output}
        xcrun lipo -info ${merge_output}
    done

    echo ""

    any_arch=
    for arch in ${arch_all}
    do
        merge_name=${name}-${arch}
        merge_product_path=${build_root}/product/${merge_name}
        merge_arch_inc_dir="${merge_product_path}/include"

        echo "merge_name = ${merge_name}"
        echo "merge_product_path = ${merge_product_path}"
        echo "merge_arch_inc_dir = ${merge_arch_inc_dir}"
        echo ""

        if [[ -d "$merge_arch_inc_dir" ]]; then
            if [[ -z "$any_arch" ]]; then
                any_arch=${arch}
                cp -R "$merge_arch_inc_dir" "${merge_root}"
            fi

            merge_inc_dir="${merge_root}/include"

            mkdir -p "$merge_inc_dir/libavutil/$arch"

            cp -f "$merge_arch_inc_dir/libavutil/avconfig.h"  "$merge_inc_dir/libavutil/$arch/avconfig.h"

            cp -f tools/avconfig.h                      "$merge_inc_dir/libavutil/avconfig.h"

            cp -f "$merge_arch_inc_dir/libavutil/ffversion.h" "$merge_inc_dir/libavutil/$arch/ffversion.h"

            cp -f tools/ffversion.h                     "$merge_inc_dir/libavutil/ffversion.h"

            mkdir -p "$merge_inc_dir/libffmpeg/$arch"

            cp -f "$merge_arch_inc_dir/libffmpeg/config.h"    "$merge_inc_dir/libffmpeg/$arch/config.h"

            cp -f tools/config.h                        "$merge_inc_dir/libffmpeg/config.h"
        fi
    done
}

function compile() {
    check_env
    check_ios_mac_host
    make_env_params
    make_ios_ffmpeg_config_params
    make_ios_or_mac_toolchain
    make_ios_ffmpeg_product
    make_arch_merge
}

target_arch=$1
arch_all="armv7 armv7s arm64 i386 x86_64"
name=ffmpeg
merge_libs="libavcodec libavfilter libavformat libavutil libswscale libswresample"

function main() {
    current_path=$(pwd)
    case "$target_arch" in
    all)
        for arch in ${arch_all}; do
            reset
            target_arch=${arch}
            echo_arch
            compile
        done
        ;;
    armv7 | armv7s | arm64 | i386 | x86_64)
        echo_arch
        compile
        ;;
    clean)
        for arch in ${arch_all}; do
            if [[ -d ${name}-${arch} ]]; then
                cd ${name}-${arch} && git clean -xdf && cd -
            fi
        done
        rm -rf ./build/output/**
        rm -rf ./build/product/**
        rm -rf ./build/toolchain/**
        echo "clean complete"
        ;;
    check)
        echo_arch
        ;;
    *)
        echo_compile_usage
        exit 1
        ;;
    esac
}

main
