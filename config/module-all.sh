#! /usr/bin/env bash

#--------------------
# Standard options:
export COMMON_FF_CFG_FLAGS=
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --prefix=PREFIX"

# Licensing options:
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-gpl"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-version3"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-nonfree"

# Configuration options:
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-static" # do not build static libraries [no]
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-shared" #  build shared libraries [no]
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-small" # optimize for size instead of speed
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-runtime-cpudetect" # detecting CPU capabilities at runtime (smaller binary)
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-gray" # full grayscale support (slower color)
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-swscale-alpha" # disable alpha channel support in swscale

# Program options:
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-programs" # do not build command line programs
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-ffmpeg"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-ffplay"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-ffprobe"

# Documentation options:
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-doc"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-htmlpages"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-manpages"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-podpages"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-txtpages"

# Component options:
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-avdevice" # disable libavdevice build
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-avcodec" # libavcodec build
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-avformat" # libavformat build
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-avutil" # libavutil build
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-swresample" # libavformat build
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-swscale" # libswscale build
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-postproc"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-avfilter"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-avresample"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-pthreads"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-w32threads"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-os2threads"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-network"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-dct"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-dwt"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-lsp"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-lzo"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-mdct"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-rdft"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-fft"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-faan"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-pixelutils"

# Hardware accelerators:
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-amf"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-audiotoolbox"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-cuda-sdk" nofree
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-cuvid"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-d3d11va"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-dxva2"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-ffnvcodec"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-libdrm"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-libmfx"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-libnpp" nofree
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-mmal"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-nvdec"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-nvenc"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-omx"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-omx-rpi"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-rkmpp"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-v4l2-m2m"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-vaapi"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-vdpau"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-videotoolbox"

# Individual component options:
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-everything"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-encoders"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-decoders"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-hwaccels"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-muxers"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-demuxers"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-parsers"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-bsfs"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-protocols"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-devices"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-filters"

# External library support:
# Using any of the following switches will allow FFmpeg to link to the
# corresponding external library. All the components depending on that library
# will become enabled, if all their other dependencies are met and they are not
# explicitly disabled. E.g. --enable-libwavpack will enable linking to
# libwavpack and allow the libwavpack encoder to be built, unless it is
# specifically disabled with --disable-encoder=libwavpack.

# Note that only the system libraries are auto-detected. All the other external
# libraries must be explicitly enabled.

# Also note that the following help text describes the purpose of the libraries
# themselves, not all their features will necessarily be usable by FFmpeg.
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-iconv"
# ...

export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=async"

# Advanced options (experts only):
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --cross-prefix=${FF_CROSS_PREFIX}-"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-cross-compile"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --sysroot=PATH"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --sysinclude=PATH"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --target-os=TAGET_OS"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --target-exec=CMD"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --target-path=DIR"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --toolchain=NAME"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --nm=NM"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --ar=AR"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --as=AS"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --yasmexe=EXE"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --cc=CC"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --cxx=CXX"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --dep-cc=DEPCC"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --ld=LD"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --host-cc=HOSTCC"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --host-cflags=HCFLAGS"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --host-cppflags=HCPPFLAGS"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --host-ld=HOSTLD"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --host-ldflags=HLDFLAGS"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --host-os=OS"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --extra-cflags=ECFLAGS"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --extra-cxxflags=ECFLAGS"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --extra-ldflags=ELDFLAGS"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --extra-libs=ELIBS"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --extra-version=STRING"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --optflags=OPTFLAGS"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --build-suffix=SUFFIX"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --malloc-prefix=PREFIX"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --progs-suffix=SUFFIX"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --arch=ARCH"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --cpu=CPU"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-pic" # build position-independent code
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-thumb"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-symver"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-hardcoded-tables"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-safe-bitstream-reader"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-lto"

# Optimization options (experts only):
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-asm"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-altivec"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-vsx"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-power8"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-amd3dnow"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-amd3dnowext"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-mmx"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-mmxext"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-sse"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-sse2"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-sse3"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-ssse3"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-sse4"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-sse42"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-avx"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-avx2"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-avx512"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-xop"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-fma3"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-fma4"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-aesni"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-armv5te"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-armv6"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-armv6t2"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-vfp"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-neon"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-inline-asm"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-x86asm"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-mipsdsp"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-mipsdspr2"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-msa"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-mmi"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-mips32r2"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-mipsfpu"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-fast-unaligned"

# Developer options (useful when working on FFmpeg itself):
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-debug"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-debug=LEVEL"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-optimizations"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-extra-warnings"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-stripping"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --assert-level=level"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-memory-poisoning"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --valgrind=VALGRIND"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-ftrapv"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --samples=PATH"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-neon-clobber-test"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-xmm-clobber-test"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-random"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-random"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-random=LIST"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-random=LIST"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --random-seed=VALUE"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-valgrind-backtrace"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --libfuzzer=PATH"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --ignore-tests=TESTS"
# export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-linux-perf"