#! /usr/bin/env bash

source ../tools/colors.sh
source ../tools/common.sh
set -e

function make_ios_openssl_config_params() {

    echo "--------------------"
    echo -e "${red}[*] make config params ${nc}"
    echo "--------------------"

    if [[ "$target_arch" = "i386" ]]; then

        xcrun_platform_name="iPhoneSimulator"

        xcrun_osversion="-mios-simulator-version-min=8.0"

        cfg_flags="$cfg_flags darwin-i386-cc"

    elif [[ "$target_arch" = "x86_64" ]]; then

        xcrun_platform_name="iPhoneSimulator"

        xcrun_osversion="-mios-simulator-version-min=8.0"

        cfg_flags="$cfg_flags darwin64-x86_64-cc"

    elif [[ "$target_arch" = "arm64" ]]; then

        xcrun_platform_name="iPhoneOS"

        xcrun_osversion="-miphoneos-version-min=8.0"

        xcode_bitcode="-fembed-bitcode"

        gaspp_export="GASPP_FIX_XCODE5=1"

        cfg_flags="$cfg_flags iphoneos-cross"

    elif [[ "$target_arch" = "armv7" ]]; then

        xcrun_platform_name="iPhoneOS"

        xcrun_osversion="-miphoneos-version-min=8.0"

        xcode_bitcode="-fembed-bitcode"

        cfg_flags="$cfg_flags iphoneos-cross"

    elif [[ "$target_arch" = "armv7s" ]]; then

        xcrun_platform_name="iPhoneOS"

        xcrun_osversion="-miphoneos-version-min=8.0"

        xcode_bitcode="-fembed-bitcode"

        cfg_flags="$cfg_flags iphoneos-cross"

    else
        echo "unknown architecture $target_arch";
        exit 1
    fi


    cfg_flags="$cfg_flags --prefix=$output_path"

    echo "cfg_flags = $cfg_flags"
    echo ""
    echo "dep_libs = $dep_libs"
    echo ""
    echo "xcrun_platform_name = $xcrun_platform_name"
    echo ""
    echo "xcrun_osversion = $xcrun_osversion"
    echo ""
    echo "xcode_bitcode = $xcode_bitcode"
    echo ""
}

function make_ios_openssl_product() {
    echo "--------------------"
    echo -e "${red}[*] compile openssl ${nc}"
    echo "--------------------"

    current_path=`pwd`

    cd ${source_path}

    echo "current_directory = ${source_path}"

    ./Configure ${cfg_flags}

    make clean
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

function compile() {
    check_env
    check_ios_mac_host
    make_env_params
    make_ios_openssl_config_params
    make_ios_or_mac_toolchain
    make_ios_openssl_product
}

target_arch=$1
arch_all="armv7 armv7s arm64"
name=openssl
build_root=`pwd`/build

function main() {
    case "$target_arch" in
        armv7|armv7s|arm64)
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
            rm -rf ./build/src/${name}-*
            rm -rf ./build/output/${name}-*
            rm -rf ./build/product/${name}-*
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