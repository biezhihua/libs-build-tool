#!/bin/bash

. ${BASEDIR}/common/common.sh
. ${BASEDIR}/android/common.sh
. ${CONTRIB}/init.sh

display_help() {
    COMMAND=$(echo $0 | sed -e 's/\.\///g')

    echo -e "\n'"$COMMAND"' builds some lib for Android platform. By default five Android ABIs (armeabi-v7a, armeabi-v7a-neon, arm64-v8a, x86 and x86_64) are built \
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

    echo -e "  --arch-all\t\t\tdo build armeabi-v7a, armeabi-v7a-neon, arm64-v8a, x86 and x86_64 platform [yes]"
    echo -e "  --arch-armeabi-v7a\t\tdo build armeabi-v7a platform [yes]"
    echo -e "  --arch-armeabi-v7a-neon\tdo build armeabi-v7a-neon platform [yes]"
    echo -e "  --arch-arm64-v8a\t\tdo build arm64-v8a platform [yes]"
    echo -e "  --arch-x86\t\t\tdo build x86 platform [yes]"
    echo -e "  --arch-x86-64\t\t\tdo build x86-64 platform [yes]\n"

    echo -e "Libraries:"

    echo -e "  --enable-libname\t\t\tbuild with libname libraries"
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
    rm -rf $BASEDIR/android/ndk-*
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
            export ENABLE_LIBRARYS="$ENABLED_LIBRARY ${ENABLE_LIBRARYS}"
            export ENABLED_LIBRARYS="${ENABLED_LIBRARYS} --enable-$ENABLED_LIBRARY"
            ;;

        --ffmpeg-config-*)
            FFMPEG_CONFIG=$(echo $1 | sed -e 's/^--[A-Za-z]*-//g')
            ;;

        --arch-all)
            export ENABLED_ARCHS="armeabi-v7a arm64-v8a x86 x86_64"
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

build() {

    set_android_toolchain_params

    init_contrib --prefix=${PREBUILT}/$(get_android_target_host) --arch-name=$(get_android_arch_name) --api=$(get_android_api) --host=$(get_android_target_host) $ENABLED_LIBRARYS

    # Some libraries have arm assembly which won't build in thumb mode
    # We append -marm to the CFLAGS of these libs to disable thumb mode
    [ $(get_android_target_host) = "armeabi-v7a" ] && echo "NOTHUMB := -marm" >>${CONTRIBE_ARCH_BUILD}/config.mak

    echo "EXTRA_CFLAGS=${CFLAGS}" >>${CONTRIBE_ARCH_BUILD}/config.mak
    echo "EXTRA_CXXFLAGS=${CXXFLAGS}" >>${CONTRIBE_ARCH_BUILD}/config.mak
    echo "EXTRA_LDFLAGS=${LDFLAGS}" >>${CONTRIBE_ARCH_BUILD}/config.mak
    echo "CC=${CC}" >>${CONTRIBE_ARCH_BUILD}/config.mak
    echo "CXX=${CXX}" >>${CONTRIBE_ARCH_BUILD}/config.mak
    echo "AR=${AR}" >>${CONTRIBE_ARCH_BUILD}/config.mak
    echo "RANLIB=${RANLIB}" >>${CONTRIBE_ARCH_BUILD}/config.mak
    echo "LD=${LD}" >>${CONTRIBE_ARCH_BUILD}/config.mak
    echo "MAKE_FLAGS=$(get_make_flags)" >>${CONTRIBE_ARCH_BUILD}/config.mak
    echo "PREBUILT=${PREBUILT}/$(get_android_target_host)" >>${CONTRIBE_ARCH_BUILD}/config.mak
    echo "FFMPEG_CONFIG=${FFMPEG_CONFIG}" >>${CONTRIBE_ARCH_BUILD}/config.mak

    echo -e "INFO: config.mak"
    cat -n ${CONTRIBE_ARCH_BUILD}/config.mak
    echo ""
}

build_openssl() {

    echo -e "INFO: Build openssl"
    echo ""

    export PATH=$(get_android_toolchain_path)/bin:$PATH

    init_contrib --prefix=${PREBUILT}/$(get_android_target_host) --arch-name=$(get_android_arch_name) --api=$(get_android_api) --host=$(get_android_target_host) $ENABLED_LIBRARYS

    echo "MAKE_FLAGS=$(get_android_make_flags)" >>${CONTRIBE_ARCH_BUILD}/config.mak

    echo -e "INFO: config.mak"
    cat -n ${CONTRIBE_ARCH_BUILD}/config.mak
    echo ""
}

build_lib() {

    export ORIGINAL_API=${API}

    CURRENT_PWD=$(pwd)

    for run_arch in $ENABLED_ARCHS; do

        cd $CURRENT_PWD

        if [[ ${run_arch} -eq "arm64-v8a" || ${run_arch} -eq "x86_64" && ${API} < 21 ]]; then
            # 64 bit ABIs supported after API 21
            export API=21
        else
            export API=${ORIGINAL_API}
        fi

        export ARCH=$run_arch
        export TOOLCHAIN=$(get_android_toolchain)
        export TOOLCHAIN_PATH=$(get_android_toolchain_path)
        export TOOLCHAIN_ARCH=$(get_android_toolchain_arch)

        echo -e "INFO: --------------------------------------------------------"
        echo ""
        echo -e "INFO: Building ${ARCH} platform on API level ${API}"
        echo ""
        echo -e "INFO: Starting new build for ${ARCH} on API level ${API} "
        echo ""

        echo -e "INFO: NDK_PATH $(get_android_ndk_path)"
        echo ""
        echo -e "INFO: ARCH $ARCH"
        echo ""
        echo -e "INFO: TOOLCHAIN $TOOLCHAIN"
        echo ""
        echo -e "INFO: TOOLCHAIN_PATH $TOOLCHAIN_PATH"
        echo ""
        echo -e "INFO: TOOLCHAIN_ARCH $TOOLCHAIN_ARCH"
        echo ""

        check_android_ndk_root

        check_android_home

        check_android_arch

        check_basedir

        check_android_api

        echo -e "INFO: Building the contribs"
        echo ""

        CONTRIBE_ARCH_BUILD=$CONTRIB/contrib-android-$(get_android_target_host)

        mkdir -p $CONTRIBE_ARCH_BUILD
        mkdir -p $CONTRIBE_ARCH_BUILD/lib/pkgconfig

        make_android_toolchain

        if [[ $(get_first_library) = "openssl" ]]; then
            build_openssl
        else
            build
        fi

        cd $CONTRIBE_ARCH_BUILD

        make $(get_make_flags) fetch

        make list

        make $(get_make_flags)

        echo -e "INFO: Completed build for ${ARCH} on API level ${API} "
        echo ""
        if [[ $(get_first_library) = "openssl" ]]; then
            clean_build
        fi

    done

    export API=${ORIGINAL_API}

}
