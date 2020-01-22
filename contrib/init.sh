#! /bin/sh

. ${BASEDIR}/common/common.sh
. ${BASEDIR}/ios/common.sh

set -e

contrib_usage() {
	echo "Usage: $0 [--build=BUILD] [--host=HOST] [--prefix=PREFIX]"
	echo "  --build=BUILD    configure for building on BUILD"
	echo "  --host=HOST      cross-compile to build to run on HOST"
	echo "  --prefix=PREFIX  install files in PREFIX"
	echo "  --disable-FOO    configure to not build package FOO"
	echo "  --enable-FOO     configure to build package FOO"
	echo "  --disable-gpl    configure to not build viral GPL code"
	echo "  --disable-gnuv3  configure to not build version 3 (L)GPL code"
	echo "  --enable-ad-clauses configure to build packages with advertising clauses"
	echo "                   (USE AT YOUR OWN LEGAL RISKS)"
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
	if test -z "$SDKROOT"; then
		SDKROOT=$(get_ios_sdk_path)
		echo "INFO: SDKROOT not specified, assuming $SDKROOT"
		echo ""
	else
		SDKROOT="$SDKROOT"
	fi

	if [ ! -d "${SDKROOT}" ]; then
		echo "ERROR: *** ${SDKROOT} does not exist, please install required SDK, or set SDKROOT manually. ***"
		echo ""
		exit 1
	fi
	contrib_add_make "IOS_SDK=${SDKROOT}"
}

contrib_check_macosx_sdk() {
	if [ -z "${OSX_VERSION}" ]; then
		OSX_VERSION=$(xcrun --show-sdk-version)
		echo "INFO: OSX_VERSION not specified, assuming $OSX_VERSION"
		echo ""
	fi

	if test -z "$SDKROOT"; then
		SDKROOT=$(xcode-select -print-path)/Platforms/MacOSX.platform/Developer/SDKs/MacOSX$OSX_VERSION.sdk
		echo "INFO: SDKROOT not specified, assuming $SDKROOT"
		echo ""
	fi

	if [ ! -d "${SDKROOT}" ]; then
		SDKROOT_NOT_FOUND=$(xcode-select -print-path)/Platforms/MacOSX.platform/Developer/SDKs/MacOSX$OSX_VERSION.sdk
		SDKROOT=$(xcode-select -print-path)/SDKs/MacOSX$OSX_VERSION.sdk
		echo "INFO: SDKROOT not found at $SDKROOT_NOT_FOUND, trying $SDKROOT"
		echo ""
	fi

	if [ ! -d "${SDKROOT}" ]; then
		SDKROOT_NOT_FOUND="$SDKROOT"
		SDKROOT=$(xcrun --show-sdk-path)
		echo "INFO: SDKROOT not found at $SDKROOT_NOT_FOUND, trying $SDKROOT"
		echo ""
	fi

	if [ ! -d "${SDKROOT}" ]; then
		echo "ERROR: *** ${SDKROOT} does not exist, please install required SDK, or set SDKROOT manually. ***"
		echo ""
		exit 1
	fi

	contrib_add_make "MACOSX_SDK=${SDKROOT}"
	contrib_add_make "OSX_VERSION ?= ${OSX_VERSION}"
}

contrib_check_android_sdk() {

	if [ -z "${ANDROID_NDK}" ]; then
		echo "ERROR: You must set ANDROID_NDK environment variable"
		exit 1
	fi

	contrib_add_make "ANDROID_NDK := ${ANDROID_NDK}"

	if [ -z "${ANDROID_ABI}" ]; then
		echo "ERROR: You must set ANDROID_ABI environment variable"
		exit 1
	fi

	contrib_add_make "ANDROID_ABI := ${ANDROID_ABI}"

	if [ -z "${ANDROID_API}" ]; then
		echo "ERROR: You should set ANDROID_API environment variable (using default android-9)"
		ANDROID_API := android-9
	fi

	contrib_add_make "ANDROID_API := ${ANDROID_API}"

	case "${ANDROID_ABI}" in
	armeabi-v7a)
		contrib_add_make_enabled "HAVE_NEON"
		contrib_add_make_enabled "HAVE_ARMV7A"
		;;
	arm64-v8a)
		contrib_add_make_enabled "HAVE_NEON"
		contrib_add_make_enabled "HAVE_ARMV8A"
		;;
	armeabi)
		if [ -z "${NO_ARMV6}" ]; then
			contrib_add_make_enabled "HAVE_ARMV6"
		fi
		;;
	esac
}

contrib_check_tizen_sdk() {

	if [ -z "${TIZEN_SDK}" ]; then
		"ERROR: You must set TIZEN_SDK environment variable"
		exit 1
	fi

	contrib_add_make "TIZEN_SDK := ${TIZEN_SDK}"

	if [ -z "${TIZEN_ABI}" ]; then
		"ERROR: You must set TIZEN_ABI environment variable"
		exit 1
	fi

	contrib_add_make "TIZEN_ABI := ${TIZEN_ABI}"

	if [ ${TIZEN_ABI} = "armv7l" ]; then
		contrib_add_make_enabled "HAVE_NEON"
	fi

	if [ ${TIZEN_ABI} = "armv7l" ]; then
		contrib_add_make_enabled "HAVE_NEON"
		contrib_add_make_enabled "HAVE_ARMV7A"
	fi
}

BUILD=
HOST=
PREFIX=
PKGS_ENABLE=
PKGS_DISABLE=
GPL="1"
GNUV3="1"
AD_CLAUSES=
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
			exit 1
			;;
		--host=*)
			HOST="${1#--host=}"
			;;
		--prefix=*)
			PREFIX="${1#--prefix=}"
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
BUILD := $BUILD
HOST := $HOST
PKGS_DISABLE := $PKGS_DISABLE
PKGS_ENABLE := $PKGS_ENABLE
EOF
	echo ""

	test -z "$PREFIX" || contrib_add_make "PREFIX := $PREFIX"
	test -z "$GPL" || contrib_add_make_enabled "GPL"
	test -z "$GNUV3" || contrib_add_make_enabled "GNUV3"
	test -z "$AD_CLAUSES" || contrib_add_make_enabled "AD_CLAUSES"
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
	echo "    GPL $GPL"
	echo "    GGNUV3PL $GNUV3"
	echo "    AD_CLAUSES $AD_CLAUSES"
	echo "    ANDROID_ABI $ANDROID_ABI"
	echo "    ANDROID_API $ANDROID_API"
	echo ""

	mkdir -p ${CONTRIB_TARBALLS} || exit $?
}
