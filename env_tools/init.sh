#!/bin/sh
# Copyright © 2011 Rafaël Carré
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston MA 02110-1301, USA.

check_version() {
    gotver=$2
    gotmajor=$(echo $gotver | cut -d. -f1)
    gotminor=$(echo $gotver | cut -d. -f2)
    gotmicro=$(echo $gotver | cut -d. -f3)
    [ -z "$gotmicro" ] && gotmicro=0
    needmajor=$(echo $3 | cut -d. -f1)
    needminor=$(echo $3 | cut -d. -f2)
    needmicro=$(echo $3 | cut -d. -f3)
    [ -z "$needmicro" ] && needmicro=0
    if [ "$needmajor" -gt "$gotmajor" \
        -o "$needmajor" -eq "$gotmajor" -a "$needminor" -gt "$gotminor" \
        -o "$needmajor" -eq "$gotmajor" -a "$needminor" -eq "$gotminor" -a "$needmicro" -gt "$gotmicro" ]; then
        echo "INFO: $1 too old"
        echo ""
        NEEDED="$NEEDED .$1"
    fi
}

check_tar() {
    if ! tar PcJ /dev/null >/dev/null 2>&1; then
        echo "INFO: tar doesn't support xz (J option)"
        echo ""
        NEEDED="$NEEDED .tar .xz"
    fi
}

check_sed() {
    tmp="$(pwd)/check_sed"
    trap "rm \"$tmp\" \"$tmp-e\" 2>/dev/null" EXIT
    echo "test file for GNU sed" >$tmp
    if ! sed -i -e 's/sed//' $tmp >/dev/null 2>&1; then
        echo "INFO: sed doesn't do in-place editing (-i option)"
        echo ""
        NEEDED="$NEEDED .sed"
    fi
}

check_nasm() {
    if ! nasm -v >/dev/null 2>&1; then
        echo "INFO: nasm not found"
        echo ""
        NEEDED="$NEEDED .nasm"
    else
        # found, need to check version ?
        [ -z "$1" ] && return # no
        gotver=$(nasm -v | cut -d ' ' -f 3)
        check_version nasm $gotver $1
    fi
}

check() {
    if ! $1 --version >/dev/null 2>&1 && ! $1 -version >/dev/null 2>&1; then
        echo "INFO: $1 not found"
        echo ""
        NEEDED="$NEEDED .$1"
    else
        # found, need to check version ?
        [ -z "$2" ] && return # no
        gotver=$($1 --version | head -1 | sed s/'.* '//)
        check_version $1 $gotver $2
    fi
}

init_env_tools() {
    export PATH="/usr/local/bin/:$PATH"
    export LC_ALL=
    NEEDED=
    ENV_TOOLS=${BASEDIR}/env_tools

    check autoconf 2.69
    check automake 1.15
    check m4 1.4.16
    check libtool 2.4
    check pkg-config
    check cmake 3.8.2
    check yasm
    check_tar
    check ragel
    check_sed
    check protoc 2.6.0
    check ant
    check xz
    check bison 3.0.0
    check flex
    check_nasm 2.13.02
    check meson 0.48.1
    check ninja

    if [[ -n "$NEEDED" ]]; then
        mkdir -p $ENV_TOOLS/build/bin
        echo "INFO: To-be-built packages: $(echo $NEEDED | sed 's/\.//g')"
        echo ""
    fi

    CPUS=
    case $(uname) in
    Linux | MINGW32* | MINGW64*)
        CPUS=$(getconf _NPROCESSORS_ONLN 2>&1)
        ;;
    Darwin | FreeBSD | NetBSD)
        CPUS=$(getconf NPROCESSORS_ONLN 2>&1)
        ;;
    OpenBSD)
        CPUS=$(sysctl -n hw.ncpu 2>&1)
        ;;
    SunOS)
        CPUS=$(psrinfo | wc -l 2>&1)
        ;;
    *)
        CPUS=1 # default
        ;;
    esac

    cat >$ENV_TOOLS/Makefile <<EOF
MAKEFLAGS += -j$CPUS
CMAKEFLAGS += --parallel=$CPUS
PREFIX=\$(abspath ./build)
CURRENT=\$(abspath ./)

all: $NEEDED
	@echo "INFO: You are ready to build libs"

include ./mak_tools/Makefile
EOF

    echo -e "INFO: Completed env tools build"
    echo ""
}
