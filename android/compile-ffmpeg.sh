#! /usr/bin/env bash

source ../tools/colors.sh
source ../tools/common.sh
set -e

function make_android_ffmpeg_config_params() {

    echo "--------------------"
    echo -e "${red}[*] make config params ${nc}"
    echo "--------------------"

    android_standalone_toolchain_clang=clang3.6

    if [[ "$target_arch" == "armv7a" ]]; then

        android_platform_name=android-21

        android_standalone_toolchain_cross_prefix_name=arm-linux-androideabi

        android_standalone_toolchain_name=arm-linux-android-${android_standalone_toolchain_clang}

        cfg_flags="$cfg_flags --arch=arm --cpu=cortex-a8"

        cfg_flags="$cfg_flags --enable-neon"

        cfg_flags="$cfg_flags --enable-thumb"

        c_flags="$c_flags -march=armv7-a -mcpu=cortex-a8 -mfpu=vfpv3-d16 -mfloat-abi=softfp -mthumb"

        ld_flags="$ld_flags -march=armv7-a -Wl,--fix-cortex-a8"

        assembler_sub_dirs="arm"

    elif [[ "$target_arch" == "armv8a" ]]; then

        android_platform_name=android-21

        android_standalone_toolchain_cross_prefix_name=aarch64-linux-android

        android_standalone_toolchain_name=aarch64-linux-android-${android_standalone_toolchain_clang}

        cfg_flags="$cfg_flags --arch=aarch64"

        c_flags="$c_flags -march=armv8-a"

        assembler_sub_dirs="aarch64 neon"

    elif [[ "$target_arch" == "x86" ]]; then

        android_platform_name=android-21

        android_standalone_toolchain_cross_prefix_name=i686-linux-android

        android_standalone_toolchain_name=x86-linux-android-${android_standalone_toolchain_clang}

        cfg_flags="$cfg_flags --arch=x86 --cpu=i686"

        c_flags="$c_flags -march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32"

        assembler_sub_dirs="x86"

    elif [[ "$target_arch" == "x86_64" ]]; then

        android_platform_name=android-21

        android_standalone_toolchain_cross_prefix_name=x86_64-linux-android

        android_standalone_toolchain_name=x86_64-linux-android-${android_standalone_toolchain_clang}

        cfg_flags="$cfg_flags --arch=x86_64"

        c_flags="$c_flags -target x86_64-none-linux-androideabi -msse4.2 -mpopcnt -m64 -mtune=intel"

        # https://blog.csdn.net/cjf_iceking/article/details/25825569
        # 其中Wl表示将紧跟其后的参数，传递给连接器ld。Bsymbolic表示强制采用本地的全局变量定义，
        # 这样就不会出现动态链接库的全局变量定义被应用程序/动态链接库中的同名定义给覆盖了！
        ld_flags="$ld_flags -Wl,-Bsymbolic"

        assembler_sub_dirs="x86"

        case "$ndk_rel" in
        18* | 19* | 20*)
            android_platform_name=android-23
            ;;
        13* | 14* | 15* | 16* | 17*)
            android_platform_name=android-21
            ;;
        esac

    else
        echo "unknown architecture $target_arch"
        exit 1
    fi

    export PATH=${toolchain_path}/bin:$PATH
    export CLANG=${android_standalone_toolchain_cross_prefix_name}-clang
    export CXX=${android_standalone_toolchain_cross_prefix_name}-clang++
    export LD=${android_standalone_toolchain_cross_prefix_name}-ld
    export AR=${android_standalone_toolchain_cross_prefix_name}-ar
    export STRIP=${android_standalone_toolchain_cross_prefix_name}-strip

    c_flags="$c_flags -O3 -fPIC -Wall -pipe \
        -std=c99 \
        -ffast-math \
        -fstrict-aliasing -Werror=strict-aliasing \
        -Wa,--noexecstack \
        -DANDROID -DNDEBUG"

    # config
    export COMMON_CFG_FLAGS=
    . ./config/module.sh
    cfg_flags="${COMMON_CFG_FLAGS} ${cfg_flags}"

    # with ffmpeg standard options:
    cfg_flags="$cfg_flags --prefix=$output_path"
    cfg_flags="$cfg_flags --sysroot=$toolchain_path/sysroot"
    cfg_flags="$cfg_flags --cc=clang --host-cflags= --host-ldflags="

    # with ffmpeg Advanced options (experts only):
    cfg_flags="$cfg_flags --cross-prefix=$toolchain_path/bin/${android_standalone_toolchain_cross_prefix_name}-"
    cfg_flags="$cfg_flags --enable-cross-compile"
    cfg_flags="$cfg_flags --target-os=android"
    cfg_flags="$cfg_flags --enable-pic"

    # 动态库 Shared libraries are .so (or in Windows .dll, or in OS X .dylib) files.
    # 静态库 Static libraries are .a (or in Windows .lib) files.
    # https://stackoverflow.com/questions/2649334/difference-between-static-and-shared-libraries
    # https://blog.csdn.net/foooooods/article/details/80259395
    cfg_flags="$cfg_flags --enable-static"
    cfg_flags="$cfg_flags --disable-shared"

    # with debug
    cfg_flags="$cfg_flags --enable-optimizations"
    cfg_flags="$cfg_flags --disable-debug"
    cfg_flags="$cfg_flags --enable-small"

    # with asm
    if [[ "$target_arch" == "x86" ]]; then
        cfg_flags="$cfg_flags --disable-asm"
    else
        cfg_flags="$cfg_flags --enable-asm"
        cfg_flags="$cfg_flags --enable-inline-asm"
    fi

    # with openssl
    if [[ -f "${output_path_depend}/lib/libssl.a" ]]; then
        export pkg_config_path=${output_path_depend}/lib/pkgconfig
        cfg_flags="$cfg_flags --enable-protocol=https"
        cfg_flags="$cfg_flags --enable-openssl"
        cfg_flags="$cfg_flags --pkg-config=pkg-config"
        c_flags="$c_flags -I${output_path_depend}/include"
        DEP_LIBS="$DEP_LIBS -L${output_path_depend}/lib -lssl -lcrypto"
    fi

    echo "c_flags = $c_flags"
    echo ""
    echo "cfg_flags = $cfg_flags"
    echo ""
    echo "dep_libs = $ld_libs"
    echo ""
    echo "android_platform_name = $android_platform_name"
    echo ""
    echo "android_standalone_toolchain_name = $android_standalone_toolchain_name"
    echo ""
    echo "android_standalone_toolchain_cross_prefix_name = $android_standalone_toolchain_cross_prefix_name"
    echo ""
    echo "PATH = $PATH"
    echo "CLANG = $CLANG"
    echo "CXX = $CXX"
    echo "LD = $LD"
    echo "AR = $AR"
    echo "STRIP = $STRIP"
}

function make_android_product() {
    echo "--------------------"
    echo -e "${red}[*] compile ${name} ${nc}"
    echo "--------------------"

    current_path=$(pwd)

    cd ${source_path}

    echo "current_directory = ${source_path}"

    git add -A
    git stash
    patch -p0 ./configure ${current_path}/patch/configure-patch.patch

    ./configure ${cfg_flags} \
        --extra-cflags="$c_flags" \
        --extra-ldflags="$ld_libs $ld_flags"

    make clean

    make install -j8

    cd ${current_path}

    echo "product_path = ${product_path}"
    echo ""
    echo "product_path_include = ${product_path}/include"
    echo ""
    echo "product_path_lib = ${product_path}/lib"
    echo ""
}

function make_android_product_so() {
    echo ""
    echo "--------------------"
    echo -e "${red}[*] link ffmpeg${nc}"
    echo "--------------------"

    current_path=$(pwd)

    cd ${source_path}

    link_c_obj_files=
    link_asm_obj_files=
    for module_dir in ${link_module_dirs}; do
        c_obj_files="$module_dir/*.o"
        if ls ${c_obj_files} 1>/dev/null 2>&1; then
            echo "link $module_dir/*.o"
            link_c_obj_files="$link_c_obj_files $c_obj_files"
        fi

        for asm_sub_dir in ${assembler_sub_dirs}; do
            asm_obj_files="$module_dir/$asm_sub_dir/*.o"
            if ls ${asm_obj_files} 1>/dev/null 2>&1; then
                echo "link $module_dir/$asm_sub_dir/*.o"
                link_asm_obj_files="$link_asm_obj_files $asm_obj_files"
            fi
        done
    done

    echo ""
    echo "link_c_obj_files = $link_c_obj_files"
    echo ""
    echo "link_asm_obj_files = $link_asm_obj_files"
    echo ""
    echo "product_so = $product_path/lib/$so_name"
    echo ""
    echo "use compiler: ${CLANG}"
    echo ""

    rm -rf ${product_path}
    mkdir -p ${product_path}/lib
    cp -r ${output_path}/include ${product_path}/include

    ${CLANG} -lm -lz -shared -Wl,--no-undefined -Wl,-z,noexecstack ${ld_flags} \
        -Wl,-soname,${so_name} \
        ${link_c_obj_files} \
        ${link_asm_obj_files} \
        ${ld_libs} \
        -o ${product_path}/lib/${so_name}

    #    mkdir -p ${product_path}/lib/pkgconfig
    #    cp ${output_path}/lib/pkgconfig/*.pc ${product_path}/lib/pkgconfig
    #
    #    for f in ${product_path}/lib/pkgconfig/*.pc; do
    #        # in case empty dir
    #        if [[ ! -f ${f} ]]; then
    #            continue
    #        fi
    #        f=${product_path}/lib/pkgconfig/`basename ${f}`
    #        echo "process share lib ${f}"
    #        # OSX sed doesn't have in-place(-i)
    #        mysedi ${f} 's/tools\/build\/'${build_name}'\/output/build\/'${build_name}'/g'
    #        mysedi ${f} 's/-lavcodec/-l'${so_simple_name}'/g'
    #        mysedi ${f} 's/-lavfilter/-l'${so_simple_name}'/g'
    #        mysedi ${f} 's/-lavformat/-l'${so_simple_name}'/g'
    #        mysedi ${f} 's/-lavutil/-l'${so_simple_name}'/g'
    #        mysedi ${f} 's/-lswresample/-l'${so_simple_name}'/g'
    #        mysedi ${f} 's/-lswscale/-l'${so_simple_name}'/g'
    #    done
}

function compile() {
    check_env
    check_ndk
    make_env_params
    make_android_ffmpeg_config_params
    make_android_toolchain
    make_android_product
    make_android_product_so
}

target_arch=$1
arch_all="armv7a armv8a x86 x86_64"
name=ffmpeg
name_depend=openssl
assembler_sub_dirs=
link_module_dirs="compat libavcodec libavfilter libavformat libavutil libswresample libswscale"
so_simple_name=sffmpeg
so_name=lib${so_simple_name}.so

function main() {
    case "$target_arch" in
    all)
        for arch in ${arch_all}; do
            reset
            target_arch=${arch}
            echo_arch
            compile
        done
        ;;
    armv7a | armv8a | x86 | x86_64)
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
