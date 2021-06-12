#!/bin/bash

set -e

# 获取AndroidNDK工具链路径
get_android_toolchain_path() {
    echo ${BASEDIR}/android/ndk-toolchain-$(get_android_target_host)
}

# 获取AndroidNDK工具链的可执行文件路径
get_android_toolchain_path_bin() {
    echo $(get_android_toolchain_path)/bin
}

# 获取AndroidNDK路径
get_android_ndk_path() {
    echo $ANDROID_NDK
}

# 交叉编译目标库
make_android_toolchain() {
    NDK_TOOLCHAIN_PROPS=$(get_android_toolchain_path)/source.properties
    NDK_FORCE_ARG=

    if [ "$(cat \"${NDK_TOOLCHAIN_PROPS}\" 2>/dev/null)" != "$(cat \"$(get_android_ndk_path)/source.properties\")" ]; then
        echo "NDK changed, making new toolchain"
        NDK_FORCE_ARG="--force"
    fi

    if [ ! -d $(get_android_toolchain_path) ]; then
        $(get_android_ndk_path)/build/tools/make_standalone_toolchain.py \
            --arch $(get_android_toolchain_arch) \
            --api $(get_android_api) \
            --stl libc++ \
            ${NDK_FORCE_ARG} \
            --install-dir $(get_android_toolchain_path)
    fi
    if [ ! -d $(get_android_toolchain_path) ]; then
        echo "make_standalone_toolchain.py failed"
        exit 1
    fi

    if [ ! -z "${NDK_FORCE_ARG}" ]; then
        cp "$(get_android_ndk_path)/source.properties" "$(get_android_toolchain_path)"
    fi
}

# 检查API
check_android_api() {
    if [[ -z ${API} ]]; then
        echo -e "(*) API not defined"
        exit 1
    fi
}

# 检查ANDROID_HOME
check_android_home() {
    echo "INFO: ${ANDROID_HOME}"
    if [[ -z ${ANDROID_HOME} ]]; then
        echo "ANDROID_HOME not defined"
        exit 1
    fi
    if [[ ! -d ${ANDROID_HOME} ]]; then
        echo "ANDROID_HOME not exist"
        exit 1
    fi
}

# 检查ANDROID_NDK_ROOT
check_android_ndk_root() {
    echo "INFO: ${ANDROID_NDK}"
    if [[ -z ${ANDROID_NDK} ]]; then
        echo "ANDROID_NDK not defined"
        exit 1
    fi
    if [[ ! -d ${ANDROID_NDK} ]]; then
        echo "ANDROID_NDK not exist"
        exit 1
    fi
}

# 获取API
get_android_api() {
    echo $API
}

# 获取NDK版本
get_android_ndk_version() {
    echo $(grep -Eo Revision.* ${ANDROID_NDK}/source.properties | sed 's/Revision//g;s/=//g;s/ //g')
}

# 根据目标架构获取NDK的编译HOST
get_android_target_host() {
    case ${ARCH} in
    armeabi-v7a | armeabi-v7a-neon)
        echo "arm-linux-androideabi"
        ;;
    arm64-v8a)
        echo "aarch64-linux-android"
        ;;
    x86)
        echo "i686-linux-android"
        ;;
    x86_64)
        echo "x86_64-linux-android"
        ;;
    esac
}

# 根据目标架构获取NDK-CLANG的编译HOST
get_android_clang_target_host() {
    case ${ARCH} in
    armeabi-v7a | armeabi-v7a-neon)
        echo "armv7a-linux-androideabi${API}"
        ;;
    arm64-v8a)
        echo "aarch64-linux-android${API}"
        ;;
    x86)
        echo "i686-linux-android${API}"
        ;;
    x86_64)
        echo "x86_64-linux-android${API}"
        ;;
    esac
}

get_android_toolchain() {

    HOST_OS=$(uname -s)

    case ${HOST_OS} in
    Darwin)
        HOST_OS=darwin
        ;;
    Linux)
        HOST_OS=linux
        ;;
    FreeBsd)
        HOST_OS=freebsd
        ;;
    CYGWIN* | *_NT-*)
        HOST_OS=cygwin
        ;;
    esac

    HOST_ARCH=$(uname -m)
    case ${HOST_ARCH} in
    i?86)
        HOST_ARCH=x86
        ;;
    x86_64 | amd64)
        HOST_ARCH=x86_64
        ;;
    esac

    echo "${HOST_OS}-${HOST_ARCH}"
}

get_android_cmake_target_processor() {
    case ${ARCH} in
    armeabi-v7a | armeabi-v7a-neon)
        echo "arm"
        ;;
    arm64-v8a)
        echo "aarch64"
        ;;
    x86)
        echo "x86"
        ;;
    x86_64)
        echo "x86_64"
        ;;
    esac
}

get_android_target_build() {
    case ${ARCH} in
    armeabi-v7a)
        echo "arm"
        ;;
    armeabi-v7a-neon)
        if [[ ! -z ${MOBILE_LTS_BUILD} ]]; then
            echo "arm/neon"
        else
            echo "arm"
        fi
        ;;
    arm64-v8a)
        echo "arm64"
        ;;
    x86)
        echo "x86"
        ;;
    x86_64)
        echo "x86_64"
        ;;
    esac
}

get_android_toolchain_arch() {
    case ${ARCH} in
    armeabi-v7a | armeabi-v7a-neon)
        echo "arm"
        ;;
    arm64-v8a)
        echo "arm64"
        ;;
    x86)
        echo "x86"
        ;;
    x86_64)
        echo "x86_64"
        ;;
    esac
}

get_android_arch_name() {
    case ${ARCH} in
    armeabi-v7a | armeabi-v7a-none)
        echo "armeabi-v7a"
        ;;
    arm64-v8a)
        echo "arm64-v8a"
        ;;
    x86)
        echo "x86"
        ;;
    x86_64)
        echo "x86_64"
        ;;
    esac
}

get_android_arch() {
    case $1 in
    0 | 1)
        echo "armeabi-v7a"
        ;;
    2)
        echo "arm64-v8a"
        ;;
    3)
        echo "x86"
        ;;
    4)
        echo "x86_64"
        ;;
    esac
}

get_android_common_includes() {
    echo "-I$(get_android_toolchain_path)/sysroot/usr/include -I$(get_android_toolchain_path)/sysroot/usr/local/include"
}

get_android_common_cflags() {
    echo "-fno-integrated-as -fstrict-aliasing -fPIC -DANDROID -D__ANDROID__ -D__ANDROID_API__=${API}"
}

get_android_arch_specific_cflags() {
    case ${ARCH} in
    armeabi-v7a)
        echo "-march=armv7-a -mfpu=vfpv3-d16 -mfloat-abi=softfp "
        ;;
    armeabi-v7a-neon)
        echo "-march=armv7-a -mfpu=neon -mfloat-abi=softfp "
        ;;
    arm64-v8a)
        echo "-march=armv8-a "
        ;;
    x86)
        echo "-march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32 "
        ;;
    x86_64)
        echo "-march=x86-64 -msse4.2 -mpopcnt -m64 -mtune=intel "
        ;;
    esac
}

# 获取ANDROID编译优化标记
get_android_size_optimization_cflags() {
    if [[ -z ${NO_LINK_TIME_OPTIMIZATION} ]]; then
        local LINK_TIME_OPTIMIZATION_FLAGS="-flto"
    else
        local LINK_TIME_OPTIMIZATION_FLAGS=""
    fi

    local ARCH_OPTIMIZATION=""
    case ${ARCH} in
    armeabi-v7a | armeabi-v7a-neon)
        case $1 in
        ffmpeg)
            ARCH_OPTIMIZATION="${LINK_TIME_OPTIMIZATION_FLAGS} -O2 -ffunction-sections -fdata-sections"
            ;;
        *)
            ARCH_OPTIMIZATION="-Os -ffunction-sections -fdata-sections"
            ;;
        esac
        ;;
    arm64-v8a)
        case $1 in
        ffmpeg)
            ARCH_OPTIMIZATION="${LINK_TIME_OPTIMIZATION_FLAGS} -fuse-ld=gold -O2 -ffunction-sections -fdata-sections"
            ;;
        *)
            ARCH_OPTIMIZATION="-Os -ffunction-sections -fdata-sections"
            ;;
        esac
        ;;
    x86 | x86_64)
        case $1 in
        ffmpeg)
            ARCH_OPTIMIZATION="${LINK_TIME_OPTIMIZATION_FLAGS} -Os -ffunction-sections -fdata-sections"
            ;;
        *)
            ARCH_OPTIMIZATION="-Os -ffunction-sections -fdata-sections"
            ;;
        esac
        ;;
    esac

    local LIB_OPTIMIZATION=""

    echo "${ARCH_OPTIMIZATION} ${LIB_OPTIMIZATION}"
}

get_android_app_specific_cflags() {

    local APP_FLAGS=""
    case $1 in
    xvidcore)
        APP_FLAGS=""
        ;;
    ffmpeg)
        APP_FLAGS="-Wno-unused-function -DBIONIC_IOCTL_NO_SIGNEDNESS_OVERLOAD"
        ;;
    shine)
        APP_FLAGS="-Wno-unused-function"
        ;;
    soxr | snappy | libwebp)
        APP_FLAGS="-std=gnu99 -Wno-unused-function -DPIC"
        ;;
    kvazaar)
        APP_FLAGS="-std=gnu99 -Wno-unused-function"
        ;;
    *)
        APP_FLAGS="-std=c99 -Wno-unused-function"
        ;;
    esac

    echo "${APP_FLAGS}"
}

# 获取ANDROID的C编译器的选项
get_android_cflags() {

    local ARCH_FLAGS=$(get_android_arch_specific_cflags)

    local APP_FLAGS=$(get_android_app_specific_cflags $1)

    local COMMON_FLAGS=$(get_android_common_cflags)

    if [[ -z ${DEBUG} ]]; then
        local OPTIMIZATION_FLAGS=$(get_android_size_optimization_cflags $1)
    else
        local OPTIMIZATION_FLAGS="${DEBUG}"
    fi

    local COMMON_INCLUDES=$(get_android_common_includes)

    echo "${ARCH_FLAGS} ${APP_FLAGS} ${COMMON_FLAGS} ${OPTIMIZATION_FLAGS} ${COMMON_INCLUDES}"
}

# 获取ANDROID的C++编译器选项
get_android_cxxflags() {
    if [[ -z ${NO_LINK_TIME_OPTIMIZATION} ]]; then
        local LINK_TIME_OPTIMIZATION_FLAGS="-flto"
    else
        local LINK_TIME_OPTIMIZATION_FLAGS=""
    fi

    if [[ -z ${DEBUG} ]]; then
        local OPTIMIZATION_FLAGS="-Os -ffunction-sections -fdata-sections"
    else
        local OPTIMIZATION_FLAGS="${DEBUG}"
    fi

    case $1 in
    gnutls)
        echo "-std=c++11 -fno-rtti ${OPTIMIZATION_FLAGS}"
        ;;
    ffmpeg)
        if [[ -z ${DEBUG} ]]; then
            echo "-std=c++11 -fno-exceptions -fno-rtti ${LINK_TIME_OPTIMIZATION_FLAGS} -O2 -ffunction-sections -fdata-sections"
        else
            echo "-std=c++11 -fno-exceptions -fno-rtti ${DEBUG}"
        fi
        ;;
    opencore-amr)
        echo "${OPTIMIZATION_FLAGS}"
        ;;
    x265)
        echo "-std=c++11 -fno-exceptions ${OPTIMIZATION_FLAGS}"
        ;;
    *)
        echo "-std=c++11 -fno-exceptions -fno-rtti ${OPTIMIZATION_FLAGS}"
        ;;
    esac
}

# 获取ANDROIDNDK的公共库链接标记
get_android_common_linked_libraries() {
    local COMMON_LIBRARY_PATHS="-L$(get_android_toolchain_path)/$(get_android_target_host)/lib -L$(get_android_toolchain_path)/sysroot/usr/lib -L$(get_android_toolchain_path)/lib"

    case $1 in
    ffmpeg)
        if [[ -z ${MOBILE_LTS_BUILD} ]]; then
            echo "-lc -lm -ldl -llog -lcamera2ndk -lmediandk ${COMMON_LIBRARY_PATHS}"
        else
            echo "-lc -lm -ldl -llog ${COMMON_LIBRARY_PATHS}"
        fi
        ;;
    libvpx)
        echo "-lc -lm ${COMMON_LIBRARY_PATHS}"
        ;;
    tesseract | x265)
        echo "-lc -lm -ldl -llog -lc++_shared ${COMMON_LIBRARY_PATHS}"
        ;;
    *)
        echo "-lc -lm -ldl -llog ${COMMON_LIBRARY_PATHS}"
        ;;
    esac
}

get_android_size_optimization_ldflags() {
    if [[ -z ${NO_LINK_TIME_OPTIMIZATION} ]]; then
        local LINK_TIME_OPTIMIZATION_FLAGS="-flto"
    else
        local LINK_TIME_OPTIMIZATION_FLAGS=""
    fi

    case ${ARCH} in
    arm64-v8a)
        case $1 in
        ffmpeg)
            echo "-Wl,--gc-sections ${LINK_TIME_OPTIMIZATION_FLAGS} -fuse-ld=gold -O2 -ffunction-sections -fdata-sections -finline-functions"
            ;;
        *)
            echo "-Wl,--gc-sections -Os -ffunction-sections -fdata-sections"
            ;;
        esac
        ;;
    *)
        case $1 in
        ffmpeg)
            echo "-Wl,--gc-sections,--icf=safe ${LINK_TIME_OPTIMIZATION_FLAGS} -O2 -ffunction-sections -fdata-sections -finline-functions"
            ;;
        *)
            echo "-Wl,--gc-sections,--icf=safe -Os -ffunction-sections -fdata-sections"
            ;;
        esac
        ;;
    esac
}

get_android_arch_specific_ldflags() {
    case ${ARCH} in
    armeabi-v7a)
        echo "-march=armv7-a -mfpu=vfpv3-d16 -mfloat-abi=softfp -Wl,--fix-cortex-a8"
        ;;
    armeabi-v7a-neon)
        echo "-march=armv7-a -mfpu=neon -mfloat-abi=softfp -Wl,--fix-cortex-a8"
        ;;
    arm64-v8a)
        echo "-march=armv8-a"
        ;;
    x86)
        echo "-march=i686"
        ;;
    x86_64)
        echo "-march=x86-64"
        ;;
    esac
}

# 获取ANDROID-NDK的优化参数
get_android_ldflags() {
    local ARCH_FLAGS=$(get_android_arch_specific_ldflags)
    if [[ -z ${DEBUG} ]]; then
        local OPTIMIZATION_FLAGS="$(get_android_size_optimization_ldflags $1)"
    else
        local OPTIMIZATION_FLAGS="${DEBUG}"
    fi
    local COMMON_LINKED_LIBS=$(get_android_common_linked_libraries $1)

    echo "${ARCH_FLAGS} ${OPTIMIZATION_FLAGS} ${COMMON_LINKED_LIBS} -Wl,--hash-style=both -Wl,--exclude-libs,libgcc.a -Wl,--exclude-libs,libunwind.a"
}

set_android_toolchain_clang_paths() {
    export PATH=$PATH:$(get_android_toolchain_path_bin)
    export AR=$(get_android_toolchain_path_bin)/$(get_android_target_host)-ar
    export CC=$(get_android_toolchain_path_bin)/$(get_android_target_host)-clang
    export CXX=$(get_android_toolchain_path_bin)/$(get_android_target_host)-clang++
    export LD=$(get_android_toolchain_path_bin)/$(get_android_target_host)-ld
    export RANLIB=$(get_android_toolchain_path_bin)/$(get_android_target_host)-ranlib
    export STRIP=$(get_android_toolchain_path_bin)/$(get_android_target_host)-strip

    if [ "$1" == "x264" ]; then
        export AS=${CC}
    else
        export AS=$(get_android_toolchain_path_bin)/$(get_android_target_host)-as
    fi

    case ${ARCH} in
    arm64-v8a)
        export ac_cv_c_bigendian=no
        ;;
    esac

    echo -e "INFO: PATH $PATH"
    echo ""
    echo -e "INFO: AR $AR"
    echo ""
    echo -e "INFO: CC $CC"
    echo ""
    echo -e "INFO: CXX $CXX"
    echo ""
    echo -e "INFO: LD $LD"
    echo ""
    echo -e "INFO: RANLIB $RANLIB"
    echo ""
    echo -e "INFO: STRIP $STRIP"
    echo ""
}

# 设置ANDROID-NDK工具链的参数
set_android_toolchain_params() {
    echo -e "INFO: Building toolchain params for ${ARCH}"
    echo ""

    set_android_toolchain_clang_paths $1

    # https://blog.csdn.net/aa804738534/article/details/99643960

    # CFLAGS、CXXFLAGS，这两个变量实际上涵盖了编译和汇编两个步骤。

    # CFLAGS： 指定头文件（.h文件）的路径，如：CFLAGS=-I/usr/include -I/path/include。
    # 同样地，安装一个包时会在安装路径下建立一个include目录，当安装过程中出现问题时，试着把以前安装的包的include目录加入到该变量中来。

    # LDFLAGS：gcc 等编译器会用到的一些优化参数，也可以在里面指定库文件的位置。
    # 用法：LDFLAGS=-L/usr/lib -L/path/to/your/lib。每安装一个包都几乎一定的会在安装目录里建立一个lib目录。

    # CFLAGS表示用于C编译器的选项
    export CFLAGS=$(get_android_cflags $1)

    # CXXFLAGS表示用于C++编译器的选项
    export CXXFLAGS=$(get_android_cxxflags $1)

    # LDFLAGS表示GCC等编译器会用到的一些优化参数，也可以在里面指定库文件的位置。
    export LDFLAGS=$(get_android_ldflags $1)

    echo -e "INFO: Target host $(get_android_target_host)"
    echo ""
    echo -e "INFO: CFLAGS $CFLAGS"
    echo ""
    echo -e "INFO: CXXFLAGS $CXXFLAGS"
    echo ""
    echo -e "INFO: LDFLAGS $LDFLAGS"
    echo ""
}
