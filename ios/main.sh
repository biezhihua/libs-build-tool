#!/bin/bash

set -e

. ${BASEDIR}/common/common.sh
. ${BASEDIR}/ios/common.sh
. ${CONTRIB}/init.sh

display_help() {
    COMMAND=$(echo $0 | sed -e 's/\.\///g')

    echo -e "\n'"$COMMAND"' builds some lib for iOS platform. By default six architectures (armv7, armv7s, arm64, arm64e, i386 and x86-64) are built \
without any external libraries enabled. Options can be used to disable ABIs and/or enable external libraries. "
    echo ""

    echo -e "Usage: ./"$COMMAND" [OPTION]..."
    echo ""

    echo -e "Specify environment variables as VARIABLE=VALUE to override default build options."
    echo ""

    echo -e "Options:"

    echo -e "  -h, --help\t\t\tdisplay this help and exit"
    echo -e "  -v, --version\t\t\tdisplay version information and exit"
    echo -e "  -c, --clean\t\t\tclean build and prebuilt and exit"
    echo -e "  -cb, --clean build\t\tclean build and exit"
    echo -e "  -cp, --clean prebuil\t\tclean prebuilt and exit"

    # echo ""
    # echo -e "Licensing options:"

    # echo -e "  --enable-gpl\t\t\tallow use of GPL libraries, resulting libs will be licensed under GPLv3.0 [no]\n"

    echo -e "Platforms:"

    echo -e "  --arch-all\t\t\tdo build armv7, armv7s, arm64, arm64e, i386 and x86_64 platform [yes]"
    echo -e "  --arch-armv7\t\t\tdo build armv7 platform [yes]"
    echo -e "  --arch-armv7s\t\t\tdo build armv7s platform [yes]"
    echo -e "  --arch-arm64\t\t\tdo build arm64 platform [yes]"
    echo -e "  --arch-arm64e\t\t\tdo build arm64e platform [yes]"
    echo -e "  --arch-i386\t\t\tdo build i386 platform [yes]\n"
    echo -e "  --arch-x86-64\t\t\tdo build x86-64 platform [yes]\n"

    echo -e "Libraries:"

    echo -e "  --enable-libname\t\tbuild with libname libraries"
    echo ""
    echo -e "  \t\t\t\tsupport libs : $(get_all_pkgs)"
    echo ""
    echo -e "  \t\t\t\tnote: openssl library must be compiled independently"
    echo ""

    echo -e "FFmpeg Configs:"
    echo -e "  --ffmpeg-config-lite\t\tbuild ffmpeg with lite config"
    echo -e "  --ffmpeg-config-mp4\t\tbuild ffmpeg with mp4 config"
    echo -e "  --ffmpeg-config-mp3\t\tbuild ffmpeg with mp3 config"
    echo -e "  --ffmpeg-config-min\t\tbuild ffmpeg with min config"
    echo ""

    echo -e "GPL libraries:"
    echo -e "  --lib-x264\t\t\tbuild with x264 [no]"
    echo -e "  --lib-x265\t\t\tbuild with x265 [no]"
    echo ""

    # echo -e "Advanced options:"
    # echo ""

    echo -e "Autohr:"
    echo -e "  name\t\t\t\tbiezhihua"
    echo -e "  email\t\t\t\tbiezhihua@gmail.com"
    echo ""
}

display_version() {
    COMMAND=$(echo $0 | sed -e 's/\.\///g')
    echo -e "INFO: display_version"
}

print_unknown_option() {
    echo -e "INFO: Unknown option \"$1\".\nSee $0 --help for available options."
    exit 1
}

print_unknown_library() {
    echo -e "INFO: Unknown library \"$1\".\nSee $0 --help for available libraries."
    exit 1
}

print_unknown_platform() {
    echo -e "INFO: Unknown platform \"$1\".\nSee $0 --help for available platforms."
    exit 1
}

print_enabled_architectures() {
    echo -e "INFO: Architectures: $ENABLED_ARCHS"
    echo ""
}

print_enabled_libraries() {
    echo -e "INFO: Libraries: $ENABLE_LIBRARYS"
    echo ""
}

clean() {
    echo -e "INFO: Clean build and prebuilt files and directories "
    clean_build
    clean_prebuilt
}

clean_build() {
    echo -e "INFO: Clean build files and directories "
    echo ""
    rm -rf $BASEDIR/contrib/contrib-*
}

clean_prebuilt() {
    echo -e "INFO: Clean pre built files and directories "
    rm -rf $BASEDIR/prebuilt/*
}

process_args() {

    if [[ $# -eq 0 ]]; then
        display_help
        exit 0
    fi

    while [ ! $# -eq 0 ]; do
        case $1 in
        -h | --help)
            display_help
            exit 0
            ;;

        -v | --version)
            display_version
            exit 0
            ;;

        --enable-*)
            ENABLED_LIBRARY=$(echo $1 | sed -e 's/^--[A-Za-z]*-//g')
            if [[ -n $ENABLE_LIBRARYS && $ENABLE_LIBRARYS =~ "openssl" ]]; then
                echo -e "ERROR: openssl only alone build"
                exit 0
            fi
            export ENABLE_LIBRARYS="$ENABLED_LIBRARY ${ENABLE_LIBRARYS}"
            export ENABLED_LIBRARYS="${ENABLED_LIBRARYS} --enable-$ENABLED_LIBRARY"
            ;;

        --ffmpeg-config-*)
            FFMPEG_CONFIG=$(echo $1 | sed -e 's/^--[A-Za-z]*-//g')
            ;;

        --arch-all)
            export ENABLED_ARCHS="armv7 armv7s arm64 arm64e i386 x86-64"
            ;;

        --arch-*)
            ENABLED_ARCH=$(echo $1 | sed -e 's/^--[A-Za-z]*-//g')
            export ENABLED_ARCHS="${ENABLED_ARCHS} $ENABLED_ARCH"
            ;;

        -c | --clean)
            clean
            exit 0
            ;;

        -cb | --clean-build)
            clean_build
            exit 0
            ;;
        -cp | --clean-prebuilt)
            clean_prebuilt
            exit 0
            ;;
        *)
            print_unknown_option
            exit 0
            ;;

        esac

        shift
    done
}

check_ios_arch() {
    # DISABLE 32-bit architectures on newer IOS versions
    if [[ $(get_ios_sdk_veresion) == 11* ]] || [[ $(get_ios_sdk_veresion) == 12* ]] || [[ $(get_ios_sdk_veresion) == 13* ]]; then
        if [[ $ENABLED_ARCHS =~ "armv7" ]]; then
            echo -e "ERROR: Disabled armv7 architecture which is not supported on SDK $(get_ios_sdk_veresion)"
            exit 0
        fi
        if [[ $ENABLED_ARCHS =~ "armv7s" ]]; then
            echo -e "ERROR: Disabled armv7s architecture which is not supported on SDK $(get_ios_sdk_veresion)"
            exit 0
        fi
        if [[ $ENABLED_ARCHS =~ "i386" ]]; then
            echo -e "ERROR: Disabled i386 architecture which is not supported on SDK $(get_ios_sdk_veresion)"
            exit 0
        fi
    fi
}

build() {

    set_ios_toolchain_params $(get_first_library)

    BUILDFORIOS="1"

    init_contrib --prefix=${PREBUILT}/$(get_ios_target_build_directory) --host=$(get_ios_target_host) $ENABLED_LIBRARYS

    echo "EXTRA_CFLAGS := ${CFLAGS}" >>${CONTRIBE_ARCH_BUILD}/config.mak
    echo "EXTRA_CXXFLAGS := ${CXXFLAGS}" >>${CONTRIBE_ARCH_BUILD}/config.mak
    echo "EXTRA_LDFLAGS := ${LDFLAGS}" >>${CONTRIBE_ARCH_BUILD}/config.mak
    echo "CC := ${CC}" >>${CONTRIBE_ARCH_BUILD}/config.mak
    echo "CXX := ${CXX}" >>${CONTRIBE_ARCH_BUILD}/config.mak
    echo "AR := ${AR}" >>${CONTRIBE_ARCH_BUILD}/config.mak
    echo "RANLIB := ${RANLIB}" >>${CONTRIBE_ARCH_BUILD}/config.mak
    echo "LD := ${LD}" >>${CONTRIBE_ARCH_BUILD}/config.mak
    echo "AS := ${AS}" >>${CONTRIBE_ARCH_BUILD}/config.mak
    echo "MAKE_FLAGS := $(get_make_flags)" >>${CONTRIBE_ARCH_BUILD}/config.mak
    echo "PREBUILT := ${PREBUILT}/$(get_ios_target_build_directory)" >>${CONTRIBE_ARCH_BUILD}/config.mak
    echo "FFMPEG_CONFIG := ${FFMPEG_CONFIG}" >>${CONTRIBE_ARCH_BUILD}/config.mak

    echo -e "INFO: config.mak"
    cat -n ${CONTRIBE_ARCH_BUILD}/config.mak
    echo ""
}

build_lib() {

    CURRENT_PWD=$(pwd)

    for run_arch in $ENABLED_ARCHS; do

        cd $CURRENT_PWD

        export ARCH=$run_arch
        export TARGET_SDK=$(get_ios_target_sdk)
        export SDK_PATH=$(get_ios_sdk_path)
        export SDK_NAME=$(get_ios_sdk_name)
        export LIPO="$(xcrun --sdk $(get_ios_sdk_name) -f lipo)"

        echo -e "INFO: --------------------------------------------------------"
        echo ""
        echo -e "INFO: Building ${ARCH} platform"
        echo ""

        echo -e "INFO: ARCH $ARCH"
        echo ""
        echo -e "INFO: TARGET_SDK $TARGET_SDK"
        echo ""
        echo -e "INFO: SDK_PATH $SDK_PATH"
        echo ""
        echo -e "INFO: SDK_NAME $SDK_NAME"
        echo ""
        echo -e "INFO: LIPO $LIPO"
        echo ""

        check_ios_sdk_path

        check_ios_target_sdk

        check_ios_arch

        check_basedir

        check_ios_min_version

        echo -e "INFO: Building the contribs"
        echo ""

        CONTRIBE_ARCH_BUILD=$CONTRIB/contrib-ios-$(get_ios_target_host)

        mkdir -p $CONTRIBE_ARCH_BUILD
        mkdir -p $CONTRIBE_ARCH_BUILD/lib/pkgconfig

        build

        cd $CONTRIBE_ARCH_BUILD

        make $(get_make_flags) fetch

        make list

        make $(get_make_flags)

        echo -e "INFO: Completed build for ${ARCH}"

    done
}
