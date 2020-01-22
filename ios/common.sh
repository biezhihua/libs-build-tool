#!/bin/bash

set -e

check_ios_sdk_path() {
    if [[ -z ${SDK_PATH} ]]; then
        echo -e "(*) SDK_PATH not defined"
        exit 1
    fi
}

check_ios_target_sdk() {
    if [[ -z ${TARGET_SDK} ]]; then
        echo -e "(*) TARGET_SDK not defined"
        exit 1
    fi
}

check_ios_min_version() {
    if [[ -z ${IOS_MIN_VERSION} ]]; then
        echo -e "(*) IOS_MIN_VERSION not defined"
        exit 1
    fi
}

get_ios_sdk_veresion() {
    echo $(xcrun --sdk iphoneos --show-sdk-version)
}

get_ios_xcode() {
    echo $(xcode-select -p)
}

get_ios_arch_name() {
    case $1 in
    0) echo "armv7" ;;
    1) echo "armv7s" ;;
    2) echo "arm64" ;;
    3) echo "arm64e" ;;
    4) echo "i386" ;;
    5) echo "x86-64" ;;
    esac
}

get_ios_target_sdk() {
    echo "$(get_ios_target_arch)-apple-ios${IOS_MIN_VERSION}"
}

get_ios_target_arch() {
    case ${ARCH} in
    arm64 | arm64e)
        echo "aarch64"
        ;;
    x86-64)
        echo "x86_64"
        ;;
    *)
        echo "${ARCH}"
        ;;
    esac
}

get_ios_sdk_name() {
    case ${ARCH} in
    armv7 | armv7s | arm64 | arm64e)
        echo "iphoneos"
        ;;
    i386 | x86-64)
        echo "iphonesimulator"
        ;;
    esac
}

get_ios_sdk_simple_name() {
    case ${ARCH} in
    armv7 | armv7s | arm64 | arm64e)
        echo "OS"
        ;;
    i386 | x86-64)
        echo "Simulator"
        ;;
    esac
}

get_ios_sdk_path() {
    echo "$(xcrun --sdk $(get_ios_sdk_name) --show-sdk-path)"
}

get_ios_target_host() {
    echo "$(get_ios_target_arch)-ios-darwin"
}

get_ios_target_build_directory() {
    case ${ARCH} in
    x86-64)
        echo "ios-x86_64-apple-darwin"
        ;;
    *)
        echo "ios-${ARCH}-apple-darwin"
        ;;
    esac
}

get_ios_min_version_cflags() {
    case ${ARCH} in
    armv7 | armv7s | arm64 | arm64e)
        echo "-miphoneos-version-min=${IOS_MIN_VERSION}"
        ;;
    i386 | x86-64)
        echo "-mios-simulator-version-min=${IOS_MIN_VERSION}"
        ;;
    esac
}

get_ios_common_includes() {
    echo "-I${SDK_PATH}/usr/include"
}

get_ios_common_cflags() {
    case ${ARCH} in
    i386 | x86-64)
        echo "-fstrict-aliasing -DIOS -isysroot ${SDK_PATH}"
        ;;
    *)
        echo "-fstrict-aliasing -fembed-bitcode -DIOS -isysroot ${SDK_PATH}"
        ;;
    esac
}

get_ios_arch_specific_cflags() {
    case ${ARCH} in
    armv7)
        echo "-arch armv7 -target $(get_ios_target_host) -march=armv7 -mcpu=cortex-a8 -mfpu=neon -mfloat-abi=softfp"
        ;;
    armv7s)
        echo "-arch armv7s -target $(get_ios_target_host) -march=armv7s -mcpu=generic -mfpu=neon -mfloat-abi=softfp"
        ;;
    arm64)
        echo "-arch arm64 -target $(get_ios_target_host) -march=armv8-a+crc+crypto -mcpu=generic"
        ;;
    arm64e)
        echo "-arch arm64e -target $(get_ios_target_host) -march=armv8.3-a+crc+crypto -mcpu=generic"
        ;;
    i386)
        echo "-arch i386 -target $(get_ios_target_host) -march=i386 -mtune=intel -mssse3 -mfpmath=sse -m32"
        ;;
    x86-64)
        echo "-arch x86_64 -target $(get_ios_target_host) -march=x86-64 -msse4.2 -mpopcnt -m64 -mtune=intel"
        ;;
    esac
}

get_ios_size_optimization_cflags() {

    local ARCH_OPTIMIZATION=""
    case ${ARCH} in
    armv7 | armv7s | arm64 | arm64e)
        case $1 in
        x264 | x265)
            ARCH_OPTIMIZATION="-Oz -Wno-ignored-optimization-argument"
            ;;
        ffmpeg)
            ARCH_OPTIMIZATION="-Oz -Wno-ignored-optimization-argument"
            ;;
        *)
            ARCH_OPTIMIZATION="-Oz -Wno-ignored-optimization-argument"
            ;;
        esac
        ;;
    i386 | x86-64)
        case $1 in
        x264 | ffmpeg)
            ARCH_OPTIMIZATION="-O2 -Wno-ignored-optimization-argument"
            ;;
        x265)
            ARCH_OPTIMIZATION="-O2 -Wno-ignored-optimization-argument"
            ;;
        *)
            ARCH_OPTIMIZATION="-O2 -Wno-ignored-optimization-argument"
            ;;
        esac
        ;;
    esac

    echo "${ARCH_OPTIMIZATION}"
}

get_ios_size_optimization_asm_cflags() {

    local ARCH_OPTIMIZATION=""
    case $1 in
    jpeg | ffmpeg)
        case ${ARCH} in
        armv7 | armv7s | arm64 | arm64e)
            ARCH_OPTIMIZATION="-Oz"
            ;;
        i386 | x86-64)
            ARCH_OPTIMIZATION="-O2"
            ;;
        esac
        ;;
    *)
        ARCH_OPTIMIZATION=$(get_ios_size_optimization_cflags $1)
        ;;
    esac

    echo "${ARCH_OPTIMIZATION}"
}

get_ios_app_specific_cflags() {

    local APP_FLAGS=""
    case $1 in
    fontconfig)
        case ${ARCH} in
        armv7 | armv7s | arm64 | arm64e)
            APP_FLAGS="-std=c99 -Wno-unused-function -D__IPHONE_OS_MIN_REQUIRED -D__IPHONE_VERSION_MIN_REQUIRED=30000"
            ;;
        *)
            APP_FLAGS="-std=c99 -Wno-unused-function"
            ;;
        esac
        ;;
    ffmpeg)
        APP_FLAGS="-Wno-unused-function -Wno-deprecated-declarations"
        ;;
    jpeg)
        APP_FLAGS="-Wno-nullability-completeness"
        ;;
    kvazaar)
        APP_FLAGS="-std=gnu99 -Wno-unused-function"
        ;;
    leptonica)
        APP_FLAGS="-std=c99 -Wno-unused-function -DOS_IOS"
        ;;
    libwebp | xvidcore)
        APP_FLAGS="-fno-common -DPIC"
        ;;
    mobile-ffmpeg)
        APP_FLAGS="-std=c99 -Wno-unused-function -Wall -Wno-deprecated-declarations -Wno-pointer-sign -Wno-switch -Wno-unused-result -Wno-unused-variable -DPIC -fobjc-arc"
        ;;
    sdl2)
        APP_FLAGS="-DPIC -Wno-unused-function -D__IPHONEOS__"
        ;;
    shine)
        APP_FLAGS="-Wno-unused-function"
        ;;
    soxr | snappy)
        APP_FLAGS="-std=gnu99 -Wno-unused-function -DPIC"
        ;;
    openssl | openh264 | x265)
        APP_FLAGS="-Wno-unused-function"
        ;;
    *)
        APP_FLAGS="-std=c99 -Wno-unused-function"
        ;;
    esac

    echo "${APP_FLAGS}"
}

get_ios_cflags() {
    local ARCH_FLAGS=$(get_ios_arch_specific_cflags)
    local APP_FLAGS=$(get_ios_app_specific_cflags $1)
    local COMMON_FLAGS=$(get_ios_common_cflags)
    local OPTIMIZATION_FLAGS=$(get_ios_size_optimization_cflags $1)
    local MIN_VERSION_FLAGS=$(get_ios_min_version_cflags $1)
    local COMMON_INCLUDES=$(get_ios_common_includes)

    echo "${ARCH_FLAGS} ${APP_FLAGS} ${COMMON_FLAGS} ${OPTIMIZATION_FLAGS} ${MIN_VERSION_FLAGS} ${COMMON_INCLUDES}"
}

get_ios_asmflags() {
    local ARCH_FLAGS=$(get_ios_arch_specific_cflags)
    local APP_FLAGS=$(get_ios_app_specific_cflags $1)
    local COMMON_FLAGS=$(get_ios_common_cflags)
    local OPTIMIZATION_FLAGS=$(get_ios_size_optimization_asm_cflags $1)
    local MIN_VERSION_FLAGS=$(get_ios_min_version_cflags $1)
    local COMMON_INCLUDES=$(get_ios_common_includes)

    echo "${ARCH_FLAGS} ${APP_FLAGS} ${COMMON_FLAGS} ${OPTIMIZATION_FLAGS} ${MIN_VERSION_FLAGS} ${COMMON_INCLUDES}"
}

get_ios_cxxflags() {
    local COMMON_CFLAGS="$(get_ios_common_cflags $1) $(get_ios_common_includes $1) $(get_ios_arch_specific_cflags) $(get_ios_min_version_cflags $1)"
    local OPTIMIZATION_FLAGS="-Oz"

    local BITCODE_FLAGS=""
    case ${ARCH} in
    armv7 | armv7s | arm64 | arm64e)
        local BITCODE_FLAGS="-fembed-bitcode"
        ;;
    esac

    case $1 in
    x265)
        echo "-std=c++11 -fno-exceptions ${BITCODE_FLAGS} ${COMMON_CFLAGS}"
        ;;
    gnutls)
        echo "-std=c++11 -fno-rtti ${BITCODE_FLAGS} ${COMMON_CFLAGS} ${OPTIMIZATION_FLAGS}"
        ;;
    opencore-amr)
        echo "-fno-rtti ${BITCODE_FLAGS} ${COMMON_CFLAGS} ${OPTIMIZATION_FLAGS}"
        ;;
    libwebp | xvidcore)
        echo "-std=c++11 -fno-exceptions -fno-rtti ${BITCODE_FLAGS} -fno-common -DPIC ${COMMON_CFLAGS} ${OPTIMIZATION_FLAGS}"
        ;;
    libaom)
        echo "-std=c++11 -fno-exceptions ${BITCODE_FLAGS} ${COMMON_CFLAGS} ${OPTIMIZATION_FLAGS}"
        ;;
    *)
        echo "-std=c++11 -fno-exceptions -fno-rtti ${BITCODE_FLAGS} ${COMMON_CFLAGS} ${OPTIMIZATION_FLAGS}"
        ;;
    esac
}

get_ios_common_linked_libraries() {
    echo "-L${SDK_PATH}/usr/lib -lc++"
}

get_ios_common_ldflags() {
    echo "-isysroot ${SDK_PATH}"
}

get_ios_size_optimization_ldflags() {
    case ${ARCH} in
    armv7 | armv7s | arm64 | arm64e)
        case $1 in
        ffmpeg)
            echo "-Oz -dead_strip"
            ;;
        *)
            echo "-Oz -dead_strip"
            ;;
        esac
        ;;
    *)
        case $1 in
        ffmpeg)
            echo "-O2"
            ;;
        *)
            echo "-O2"
            ;;
        esac
        ;;
    esac
}

get_ios_arch_specific_ldflags() {
    case ${ARCH} in
    armv7)
        echo "-arch armv7 -march=armv7 -mfpu=neon -mfloat-abi=softfp -fembed-bitcode"
        ;;
    armv7s)
        echo "-arch armv7s -march=armv7s -mfpu=neon -mfloat-abi=softfp -fembed-bitcode"
        ;;
    arm64)
        echo "-arch arm64 -march=armv8-a+crc+crypto -fembed-bitcode"
        ;;
    arm64e)
        echo "-arch arm64e -march=armv8.3-a+crc+crypto -fembed-bitcode"
        ;;
    i386)
        echo "-arch i386 -march=i386"
        ;;
    x86-64)
        echo "-arch x86_64 -march=x86-64"
        ;;
    esac
}

get_ios_ldflags() {
    local ARCH_FLAGS=$(get_ios_arch_specific_ldflags)
    local LINKED_LIBRARIES=$(get_ios_common_linked_libraries)
    local OPTIMIZATION_FLAGS="$(get_ios_size_optimization_ldflags $1)"
    local COMMON_FLAGS=$(get_ios_common_ldflags)

    case $1 in
    mobile-ffmpeg)
        case ${ARCH} in
        armv7 | armv7s | arm64 | arm64e)
            echo "${ARCH_FLAGS} ${LINKED_LIBRARIES} ${COMMON_FLAGS} -fembed-bitcode -Wc,-fembed-bitcode ${OPTIMIZATION_FLAGS}"
            ;;
        *)
            echo "${ARCH_FLAGS} ${LINKED_LIBRARIES} ${COMMON_FLAGS} ${OPTIMIZATION_FLAGS}"
            ;;
        esac
        ;;
    *)
        echo "${ARCH_FLAGS} ${LINKED_LIBRARIES} ${COMMON_FLAGS} ${OPTIMIZATION_FLAGS}"
        ;;
    esac
}

set_ios_toolchain_clang_paths() {
    TARGET_HOST=$(get_ios_target_host)

    export AR="$(xcrun --sdk $(get_ios_sdk_name) -f ar)"
    export CC="clang"
    export OBJC="$(xcrun --sdk $(get_ios_sdk_name) -f clang)"
    export CXX="clang++"

    LOCAL_ASMFLAGS="$(get_ios_asmflags $1)"
    LOCAL_GAS_PREPROCESSOR="gas-preprocessor.pl"

    case ${ARCH} in
    armv7 | armv7s)
        if [ "$1" == "x265" ]; then
            export AS="${LOCAL_GAS_PREPROCESSOR}"
            export AS_ARGUMENTS="-arch arm"
            export ASM_FLAGS="${LOCAL_ASMFLAGS}"
        else
            export AS="${LOCAL_GAS_PREPROCESSOR} -arch arm -- ${CC} ${LOCAL_ASMFLAGS}"
        fi
        ;;
    arm64 | arm64e)
        if [ "$1" == "x265" ]; then
            export AS="${LOCAL_GAS_PREPROCESSOR}"
            export AS_ARGUMENTS="-arch aarch64"
            export ASM_FLAGS="${LOCAL_ASMFLAGS}"
        else
            export AS="${LOCAL_GAS_PREPROCESSOR} -arch aarch64 -- ${CC} ${LOCAL_ASMFLAGS}"
        fi
        ;;
    *)
        export AS="${CC} ${LOCAL_ASMFLAGS}"
        ;;
    esac

    export LD="$(xcrun --sdk $(get_ios_sdk_name) -f ld)"
    export RANLIB="$(xcrun --sdk $(get_ios_sdk_name) -f ranlib)"
    export STRIP="$(xcrun --sdk $(get_ios_sdk_name) -f strip)"

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
    echo -e "INFO: AS $AS"
    echo ""
    echo -e "INFO: OBJC $OBJC"
    echo ""
}

set_ios_toolchain_params() {
    echo -e "INFO: Building params for ${ARCH} and for lib ${1}"
    echo ""

    set_ios_toolchain_clang_paths $1

    export CFLAGS=$(get_ios_cflags $1)
    export CXXFLAGS=$(get_ios_cxxflags $1)
    export LDFLAGS=$(get_ios_ldflags $1)

    echo -e "INFO: Target host $(get_ios_target_host)"
    echo ""
    echo -e "INFO: CFLAGS $CFLAGS"
    echo ""
    echo -e "INFO: CXXFLAGS $CXXFLAGS"
    echo ""
    echo -e "INFO: LDFLAGS $LDFLAGS"
    echo ""
}
