#! /bin/sh

. ${BASEDIR}/common/common.sh

contrib_usage() {
	echo "Usage: $0 [--build=BUILD] [--host=HOST] [--prefix=PREFIX]"
	echo "  --build=BUILD    configure for building on BUILD"
	echo "  --host=HOST      cross-compile to build to run on HOST"
	echo "  --prefix=PREFIX  install files in PREFIX"
	echo "  --disable-FOO    configure to not build package FOO"
	echo "  --enable-FOO     configure to build package FOO"
	echo "  --disable-disc   configure to not build optical discs packages"
	echo "  --disable-net    configure to not build networking packages"
	echo "  --disable-sout   configure to not build stream output packages"
	echo "  --enable-small   optimize libraries for size with slight speed decrease [DANGEROUS]"
	echo "  --disable-gpl    configure to not build viral GPL code"
	echo "  --disable-gnuv3  configure to not build version 3 (L)GPL code"
	echo "  --enable-ad-clauses configure to build packages with advertising clauses"
	echo "                   (USE AT YOUR OWN LEGAL RISKS)"
	echo "  --disable-optim  disable optimization in libraries"
	echo "  --with-libname   build libname with for enable lib"
}

contrib_add_make() {
	while test -n "$1"; do
		echo "$1" >&3
		shift
	done
}

contrib_add_make_enabled() {
	while test -n "$1"; do
		contrib_add_make "$1 := 1"
		shift
	done
}

contrib_check_ios_sdk() {
	if test "$VLCSDKROOT"; then
		SDKROOT="$VLCSDKROOT"
	else
		if test -z "$SDKROOT"; then
			SDKROOT=$(xcode-select -print-path)/Platforms/iPhone${PLATFORM}.platform/Developer/SDKs/iPhone${PLATFORM}${SDK_VERSION}.sdk
			echo "INFO: SDKROOT not specified, assuming $SDKROOT"
		else
			SDKROOT="$SDKROOT"
		fi
	fi

	if [ ! -d "${SDKROOT}" ]; then
		echo "ERROR: *** ${SDKROOT} does not exist, please install required SDK, or set SDKROOT manually. ***"
		exit 1
	fi
	contrib_add_make "IOS_SDK=${SDKROOT}"
}

contrib_check_macosx_sdk() {
	if [ -z "${OSX_VERSION}" ]; then
		OSX_VERSION=$(xcrun --show-sdk-version)
		echo "INFO: OSX_VERSION not specified, assuming $OSX_VERSION"
	fi
	if test -z "$SDKROOT"; then
		SDKROOT=$(xcode-select -print-path)/Platforms/MacOSX.platform/Developer/SDKs/MacOSX$OSX_VERSION.sdk
		echo "INFO: SDKROOT not specified, assuming $SDKROOT"
	fi

	if [ ! -d "${SDKROOT}" ]; then
		SDKROOT_NOT_FOUND=$(xcode-select -print-path)/Platforms/MacOSX.platform/Developer/SDKs/MacOSX$OSX_VERSION.sdk
		SDKROOT=$(xcode-select -print-path)/SDKs/MacOSX$OSX_VERSION.sdk
		echo "INFO: SDKROOT not found at $SDKROOT_NOT_FOUND, trying $SDKROOT"
	fi
	if [ ! -d "${SDKROOT}" ]; then
		SDKROOT_NOT_FOUND="$SDKROOT"
		SDKROOT=$(xcrun --show-sdk-path)
		echo "INFO: SDKROOT not found at $SDKROOT_NOT_FOUND, trying $SDKROOT"
	fi

	if [ ! -d "${SDKROOT}" ]; then
		echo "ERROR: *** ${SDKROOT} does not exist, please install required SDK, or set SDKROOT manually. ***"
		exit 1
	fi

	contrib_add_make "MACOSX_SDK=${SDKROOT}"
	contrib_add_make "OSX_VERSION ?= ${OSX_VERSION}"
}

contrib_check_android_sdk() {

	[ -z "${ANDROID_NDK}" ] && echo "ERROR: You must set ANDROID_NDK environment variable" && exit 1

	contrib_add_make "ANDROID_NDK := ${ANDROID_NDK}"

	[ -z "${ANDROID_ABI}" ] && echo "ERROR: You must set ANDROID_ABI environment variable" && exit 1

	contrib_add_make "ANDROID_ABI := ${ANDROID_ABI}"

	[ -z "${ANDROID_API}" ] && echo "ERROR: You should set ANDROID_API environment variable (using default android-9)" && ANDROID_API := android-9

	contrib_add_make "ANDROID_API := ${ANDROID_API}"

	[ ${ANDROID_ABI} = "armeabi-v7a" ] && contrib_add_make_enabled "HAVE_NEON"
	[ ${ANDROID_ABI} = "armeabi-v7a" ] && contrib_add_make_enabled "HAVE_ARMV7A"
	[ ${ANDROID_ABI} = "arm64-v8a" ] && contrib_add_make_enabled "HAVE_NEON"
	[ ${ANDROID_ABI} = "arm64-v8a" ] && contrib_add_make_enabled "HAVE_ARMV8A"
	[ ${ANDROID_ABI} = "armeabi" -a -z "${NO_ARMV6}" ] && contrib_add_make_enabled "HAVE_ARMV6"
}

contrib_check_tizen_sdk() {

	[ -z "${TIZEN_SDK}" ] && echo "ERROR: You must set TIZEN_SDK environment variable" && exit 1

	contrib_add_make "TIZEN_SDK := ${TIZEN_SDK}"

	[ -z "${TIZEN_ABI}" ] && echo "ERROR: You must set TIZEN_ABI environment variable" && exit 1

	contrib_add_make "TIZEN_ABI := ${TIZEN_ABI}"

	[ ${TIZEN_ABI} = "armv7l" ] && contrib_add_make_enabled "HAVE_NEON"
	[ ${TIZEN_ABI} = "armv7l" ] && contrib_add_make_enabled "HAVE_ARMV7A"
}

BUILD=
HOST=
PREFIX=
PKGS_ENABLE=
PKGS_DISABLE=
BUILD_OPENSSL="0"
BUILD_ENCODERS="1"
BUILD_NETWORK="1"
BUILD_DISCS="1"
GPL="1"
GNUV3="1"
AD_CLAUSES=
WITH_OPTIMIZATION="1"
ANDROID_ABI=
ANDROID_API=

init_contrib() {

	while test -n "$1"; do

		echo "INFO: Init $1"
		echo ""

		case "$1" in
		--build=*)
			BUILD="${1#--build=}"
			;;
		--help | -h)
			contrib_usage
			exit 0
			;;
		--host=*)
			HOST="${1#--host=}"
			;;
		--prefix=*)
			PREFIX="${1#--prefix=}"
			;;
		--with-*)
			WITH="${1#--with=}"
			if [[ $WITH = "openssl" && -e ${PREBUILT}/$(get_target_host)/lib/libcrypto.a && -e ${PREBUILT}/$(get_target_host)/lib/libssl.a ]]; then
				BUILD_OPENSSL="1"
			fi
			;;
		--disable-disc)
			BUILD_DISCS=
			;;
		--disable-net)
			BUILD_NETWORK=
			;;
		--disable-sout)
			BUILD_ENCODERS=
			;;
		--disable-optim)
			WITH_OPTIMIZATION=
			;;
		--enable-small)
			ENABLE_SMALL=1
			;;
		--disable-gpl)
			GPL=
			;;
		--disable-gnuv3)
			GNUV3=
			;;
		--enable-ad-clauses)
			AD_CLAUSES=1
			;;
		--disable-*)
			PKGS_DISABLE="${PKGS_DISABLE} ${1#--disable-}"
			;;
		--enable-*)
			PKGS_ENABLE="${PKGS_ENABLE} ${1#--enable-}"
			;;
		--api=*)
			ANDROID_API=${1#--api=}
			;;
		--arch-name=*)
			ANDROID_ABI="${1#--arch-name=}"
			;;
		*)
			echo "INFO: Unrecognized options $1"
			contrib_usage
			exit 1
			;;
		esac
		shift
	done

	if test -n "$AD_CLAUSES" -a -n "$GPL" -a -z "$GNUV3"; then
		echo "ERROR: advertising clauses are not compatible with GPLv2!"
		exit 1
	fi

	if test -z "$BUILD"; then
		BUILD="$(${CC:-cc} -dumpmachine)"
		if test -z "$BUILD"; then
			echo "ERROR: Build no exist"
			exit 1
		fi
		echo "INFO: Guessing build system... $BUILD"
		echo ""
	fi

	if test -z "$HOST"; then
		HOST="$BUILD"
		echo "INFO: Guessing host system...  $HOST"
		echo ""
	fi

	if test -n "$GPL"; then
		if test -n "$GNUV3"; then
			LICENSE="GPL version 3"
		else
			LICENSE="GPL version 2"
		fi
	else
		if test -n "$GNUV3"; then
			LICENSE="Lesser GPL version 3"
		else
			LICENSE="Lesser GPL version 2.1"
		fi
	fi

	echo "INFO: Packages licensing... $LICENSE"
	echo ""

	if test "$PREFIX"; then
		# strip trailing slash
		PREFIX="${PREFIX%/}"
	fi

	# Prepare files
	echo "INFO: Creating configuration file... config.mak"
	exec 3>$CONTRIBE_ARCH_BUILD/config.mak || exit $?
	cat >&3 <<EOF
# This file was automatically generated.
# Any change will be overwritten if init_contrib is run again.
BUILD := $BUILD
HOST := $HOST
PKGS_DISABLE := $PKGS_DISABLE
PKGS_ENABLE := $PKGS_ENABLE
EOF
	echo ""

	test -z "$PREFIX" || contrib_add_make "PREFIX := $PREFIX"
	test -z "$BUILD_DISCS" || contrib_add_make_enabled "BUILD_DISCS"
	test -z "$BUILD_ENCODERS" || contrib_add_make_enabled "BUILD_ENCODERS"
	test -z "$BUILD_NETWORK" || contrib_add_make_enabled "BUILD_NETWORK"
	test -z "$BUILD_OPENSSL" || contrib_add_make "BUILD_OPENSSL := $BUILD_OPENSSL"
	test -z "$ENABLE_SMALL" || contrib_add_make_enabled "ENABLE_SMALL"
	test -z "$GPL" || contrib_add_make_enabled "GPL"
	test -z "$GNUV3" || contrib_add_make_enabled "GNUV3"
	test -z "$AD_CLAUSES" || contrib_add_make_enabled "AD_CLAUSES"
	test -z "$WITH_OPTIMIZATION" || contrib_add_make_enabled "WITH_OPTIMIZATION"
	test "$(uname -o 2>/dev/null)" != "Msys" || contrib_add_make "CMAKE_GENERATOR := -G \"MSYS Makefiles\""

	#
	# Checks
	#
	OS="${HOST#*-}" # strip architecture
	case "${OS}" in
	*-darwin*)
		if test -z "$BUILDFORIOS"; then
			contrib_check_macosx_sdk
			contrib_add_make_enabled "HAVE_MACOSX" "HAVE_DARWIN_OS" "HAVE_BSD"
		else
			contrib_check_ios_sdk
			contrib_add_make_enabled "HAVE_IOS" "HAVE_DARWIN_OS" "HAVE_BSD" "HAVE_FPU"

			case "${HOST}" in
			*armv7s*)
				contrib_add_make "PLATFORM_SHORT_ARCH := armv7s"
				contrib_add_make_enabled "HAVE_NEON" "HAVE_ARMV7A"
				;;
			*arm*)
				contrib_add_make "PLATFORM_SHORT_ARCH := armv7"
				contrib_add_make_enabled "HAVE_NEON" "HAVE_ARMV7A"
				;;
			*arm64* | *aarch64*)
				contrib_add_make "PLATFORM_SHORT_ARCH := arm64"
				;;
			*x86_64*)
				contrib_add_make "PLATFORM_SHORT_ARCH := x86_64"
				;;
			*86*)
				contrib_add_make "PLATFORM_SHORT_ARCH := i386"
				;;
			esac
		fi
		if test "$BUILDFORTVOS"; then
			contrib_add_make_enabled "HAVE_TVOS"
		fi
		;;
	*bsd*)
		contrib_add_make_enabled "HAVE_BSD"
		;;
	*android*)
		contrib_check_android_sdk
		contrib_add_make_enabled "HAVE_LINUX" "HAVE_ANDROID"
		case "${HOST}" in
		*arm*)
			contrib_add_make "PLATFORM_SHORT_ARCH := arm"
			;;
		*arm64* | *aarch64*)
			contrib_add_make "PLATFORM_SHORT_ARCH := arm64"
			;;
		*i686*)
			contrib_add_make "PLATFORM_SHORT_ARCH := x86"
			;;
		*x86_64*)
			contrib_add_make "PLATFORM_SHORT_ARCH := x86_64"
			;;
		*mipsel*)
			contrib_add_make "PLATFORM_SHORT_ARCH := mips"
			;;
		esac
		;;
	*linux*)
		if [ "$(${CC} -v 2>&1 | grep tizen)" ]; then
			contrib_check_tizen_sdk
			contrib_add_make_enabled "HAVE_TIZEN"
			case "${HOST}" in
			*arm*)
				contrib_add_make "PLATFORM_SHORT_ARCH := arm"
				;;
			*i386*)
				contrib_add_make "PLATFORM_SHORT_ARCH := x86"
				;;
			esac
		fi

		contrib_add_make_enabled "HAVE_LINUX"
		;;
	*mingw*)
		contrib_add_make_enabled "HAVE_WIN32"
		case "${HOST}" in
		*winphone* | *windowsphone*)
			contrib_add_make_enabled "HAVE_WINDOWSPHONE"
			;;
		esac
		case "${HOST}" in
		*winphone* | *windowsphone* | *winrt* | *uwp*)
			contrib_add_make_enabled "HAVE_WINSTORE"
			;;
		esac
		case "${HOST}" in
		amd64* | x86_64*)
			contrib_add_make_enabled "HAVE_WIN64"
			;;
		esac
		case "${HOST}" in
		armv7*)
			contrib_add_make_enabled "HAVE_ARMV7A"
			;;
		esac
		;;
	*solaris*)
		contrib_add_make_enabled "HAVE_SOLARIS"
		;;
	esac

	#
	# Results output
	#
	test -e ${CONTRIBE_ARCH_BUILD}/Makefile && unlink ${CONTRIBE_ARCH_BUILD}/Makefile
	ln -sf ${CONTRIB_SRC}/Makefile ${CONTRIBE_ARCH_BUILD}/Makefile || exit $?
	echo "INFO: Bootstrap completed."
	echo "    BUILD $BUILD"
	echo "    HOST $HOST"
	echo "    PREFIX $PREFIX"
	echo "    PKGS_ENABLE $PKGS_ENABLE"
	echo "    PKGS_DISABLE $PKGS_DISABLE"
	echo "    BUILD_OPENSSL $BUILD_OPENSSL"
	echo "    BUILD_ENCODERS $BUILD_ENCODERS"
	echo "    BUILD_NETWORK $BUILD_NETWORK"
	echo "    BUILD_DISCS $BUILD_DISCS"
	echo "    GPL $GPL"
	echo "    GGNUV3PL $GNUV3"
	echo "    AD_CLAUSES $AD_CLAUSES"
	echo "    WITH_OPTIMIZATION $WITH_OPTIMIZATION"
	echo "    ANDROID_ABI $ANDROID_ABI"
	echo "    ANDROID_API $ANDROID_API"
	echo ""

	mkdir -p ${CONTRIB_TARBALLS} || exit $?
}
