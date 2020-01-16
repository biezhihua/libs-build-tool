#!/bin/bash

. ${BASEDIR}/common/common.sh
. ${BASEDIR}/android/common.sh

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

    echo ""
    echo -e "Licensing options:"

    echo -e "  --enable-gpl\t\t\tallow use of GPL libraries, resulting libs will be licensed under GPLv3.0 [no]\n"

    echo -e "Platforms:"

    echo -e "  --arch-all\t\t\tdo build armeabi-v7a, armeabi-v7a-neon, arm64-v8a, x86 and x86_64 platform [yes]"
    echo -e "  --arch-armeabi-v7a\t\tdo build armeabi-v7a platform [yes]"
    echo -e "  --arch-armeabi-v7a-neon\tdo build armeabi-v7a-neon platform [yes]"
    echo -e "  --arch-arm64-v8a\t\tdo build arm64-v8a platform [yes]"
    echo -e "  --arch-x86\t\t\tdo build x86 platform [yes]"
    echo -e "  --arch-x86-64\t\t\tdo build x86-64 platform [yes]\n"

    echo -e "Libraries:"

    echo -e "  --lib-libname\t\t\tbuild with libname libraries"
    echo ""
    echo -e "  \t\t\t\tsupport libs : $(get_all_pkgs)"
    echo ""
    echo -e "  \t\t\t\tnote: Openssl library must be compiled independently"
    echo ""

    echo -e "With Libraries:"

    echo -e "  --with-openssl\t\tbuild with openssl for ffmpeg"
    echo ""

    echo -e "GPL libraries:"
    echo -e "  --lib-x264\t\t\tbuild with x264 [no]"
    echo -e "  --lib-x265\t\t\tbuild with x265 [no]"
    echo ""

    echo -e "Advanced options:"
    echo ""

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
print_with_libraries() {
    echo -e "INFO: With Libraries: $WITH_LIBRARYS"
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

        --with-*)
            export WITH_LIBRARYS="$WITH_LIBRARYS $1"
            ;;

        --lib-*)
            ENABLED_LIBRARY=$(echo $1 | sed -e 's/^--[A-Za-z]*-//g')
            if [[ -n $ENABLE_LIBRARYS && $ENABLE_LIBRARYS =~ "openssl" ]]; then
                echo -e "ERROR: openssl only alone build"
                exit 0
            fi
            export ENABLE_LIBRARYS="$ENABLED_LIBRARY ${ENABLE_LIBRARYS}"
            export ENABLED_LIBRARYS="${ENABLED_LIBRARYS} --enable-$ENABLED_LIBRARY"
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

    case $ENABLE_LIBRARYS in
    "openssl ")
        ONLY_OPENSSL="ONLY_OPENSSL"
        ;;
    esac
}

build() {

    set_toolchain_params

    ../bootstrap --prefix=$BASEDIR/prebuilt/$(get_target_host) --arch-name=$(get_android_arch_name) --api=$(get_api) --host=$(get_target_host) $ENABLED_LIBRARYS $WITH_LIBRARYS

    # Some libraries have arm assembly which won't build in thumb mode
    # We append -marm to the CFLAGS of these libs to disable thumb mode
    [ $(get_target_host) = "armeabi-v7a" ] && echo "NOTHUMB := -marm" >>config.mak

    echo "EXTRA_CFLAGS=${CFLAGS}" >>config.mak
    echo "EXTRA_CXXFLAGS=${CXXFLAGS}" >>config.mak
    echo "EXTRA_LDFLAGS=${LDFLAGS}" >>config.mak
    echo "CC=${CC}" >>config.mak
    echo "CXX=${CXX}" >>config.mak
    echo "AR=${AR}" >>config.mak
    echo "RANLIB=${RANLIB}" >>config.mak
    echo "LD=${LD}" >>config.mak
    echo "MAKE_FLAGS=$(get_make_flags)" >>config.mak
}

build_openssl() {

    echo -e "INFO: Build openssl"
    echo ""

    export PATH=$(get_toolchain_path)/bin:$PATH

    ../bootstrap --prefix=$BASEDIR/prebuilt/$(get_target_host) --arch-name=$(get_android_arch_name) --api=$(get_api) --host=$(get_target_host) $ENABLED_LIBRARYS $WITH_LIBRARYS

    echo "MAKE_FLAGS=$(get_make_flags)" >>config.mak
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

        echo -e "INFO: --------------------------------------------------------"
        echo ""
        echo -e "INFO: Building ${ARCH} platform on API level ${API}"
        echo ""
        echo -e "INFO: Starting new build for ${ARCH} on API level ${API} "
        echo ""

        export ARCH=$run_arch
        export TOOLCHAIN=$(get_toolchain)
        export TOOLCHAIN_PATH=$(get_toolchain_path)
        export TOOLCHAIN_ARCH=$(get_toolchain_arch)

        echo -e "INFO: NDK_PATH $(get_ndk_path)"
        echo ""
        echo -e "INFO: ARCH $ARCH"
        echo ""
        echo -e "INFO: TOOLCHAIN $TOOLCHAIN"
        echo ""
        echo -e "INFO: TOOLCHAIN_PATH $TOOLCHAIN_PATH"
        echo ""
        echo -e "INFO: TOOLCHAIN_ARCH $TOOLCHAIN_ARCH"
        echo ""

        check_ndk_root

        check_android_home

        check_arch

        check_basedir

        check_api

        echo -e "INFO: Building the contribs"
        echo ""

        mkdir -p $CONTRIB/contrib-android-$(get_target_host)
        mkdir -p $BASEDIR/prebuilt/$(get_target_host)/lib/pkgconfig

        cd $CONTRIB/contrib-android-$(get_target_host)

        make_toolchain

        if [[ -n $ONLY_OPENSSL ]]; then
            build_openssl
        else
            build
        fi

        make $(get_make_flags) fetch

        make list

        make $(get_make_flags)

        echo -e "INFO: Completed build for ${ARCH} on API level ${API} "

        if [[ -n $ONLY_OPENSSL ]]; then
            clean_build
        fi

    done

    export API=${ORIGINAL_API}

}

build_env() {
    export PATH="$BASEDIR/env_tools/build/bin:$PATH"
    echo -e "INFO: Building env_tools"
    echo ""

    . ${BASEDIR}/env_tools/init.sh

    init_env_tools

    TMP_PWD=$(pwd)
    cd $BASEDIR/env_tools

    make $(get_make_flags)

    make $(get_make_flags) .gas || make $(get_make_flags) .buildgas

    cd $TMP_PWD
}
