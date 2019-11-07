#! /usr/bin/env bash

source ../tools/colors.sh
source ../tools/common.sh
set -e

function make_android_openssl_config_params() {

    echo "--------------------"
    echo -e "${red}[*] make config params ${nc}"
    echo "--------------------"

    android_standalone_toolchain_clang=clang3.6

    cfg_flags="$cfg_flags zlib-dynamic"
    cfg_flags="$cfg_flags no-shared"
    cfg_flags="$cfg_flags --prefix=$output_path"

    if [[ "$target_arch" = "armv7a" ]]; then

        android_platform_name=android-21

        android_standalone_toolchain_name=arm-linux-android-${android_standalone_toolchain_clang}

        cfg_flags="$cfg_flags android-arm"

    elif [[ "$target_arch" = "armv8a" ]]; then

        android_platform_name=android-21

        android_standalone_toolchain_name=aarch64-linux-android-${android_standalone_toolchain_clang}

        cfg_flags="$cfg_flags android-arm64"

    elif [[ "$target_arch" = "x86" ]]; then

        android_platform_name=android-21

        android_standalone_toolchain_name=x86-linux-android-${android_standalone_toolchain_clang}

        cfg_flags="$cfg_flags android-x86 no-asm"

    elif [[ "$target_arch" = "x86_64" ]]; then

        android_platform_name=android-21

        android_standalone_toolchain_name=x86_64-linux-android-${android_standalone_toolchain_clang}

        cfg_flags="$cfg_flags android-x86_64"

     case "$ndk_rel" in
        18*|19*)
            android_platform_name=android-23
        ;;
        13*|14*|15*|16*|17*)
            android_platform_name=android-21
        ;;
    esac

    else
        echo "unknown architecture $target_arch";
        exit 1
    fi

    echo "cfg_flags = $cfg_flags"
    echo ""
    echo "dep_libs = $ld_libs"
    echo ""
    echo "android_platform_name = $android_platform_name"
    echo ""
    echo "android_standalone_toolchain_name = $android_standalone_toolchain_name"
    echo ""
}

function compile() {
    check_env
    check_ndk
    make_env_params
    make_android_openssl_config_params
    make_android_toolchain
    make_openssl_product
}

target_arch=$1
arch_all="armv7a armv8a x86 x86_64"
name=openssl

function main() {
    case "$target_arch" in
        all)
            for arch in ${arch_all}
            do
                reset
                target_arch=${arch}
                echo_arch
                compile
            done
        ;;
        armv7a|armv8a|x86|x86_64)
            echo_arch
            compile
        ;;
        clean)
            for arch in ${arch_all}
            do
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