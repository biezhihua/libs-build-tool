#! /usr/bin/env bash

#--------------------
# Standard options:
export COMMON_CFG_FLAGS=

# Licensing options:
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-gpl"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-nonfree"

# Configuration options:
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-runtime-cpudetect"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-gray"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-swscale-alpha"

# Program options:
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-programs"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-ffmpeg"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-ffplay"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-ffprobe"

# Documentation options:
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-doc"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-htmlpages"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-manpages"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-podpages"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-txtpages"

# Component options:
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-avdevice"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-avcodec"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-avformat"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-avutil"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-swresample"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-swscale"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-postproc"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-avfilter"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-avresample"
# enable-network error:
# libavformat/udp.c:290:28: error: member reference base type '__be32' (aka 'unsigned int') is not a structure or union
#         mreqs.imr_multiaddr.s_addr = ((struct sockaddr_in *)addr)->sin_addr.s_addr;
#         ~~~~~~~~~~~~~~~~~~~^~~~~~~
# libavformat/udp.c:292:32: error: assigning to '__be32' (aka 'unsigned int') from incompatible type 'struct in_addr'
#             mreqs.imr_interface= ((struct sockaddr_in *)local_addr)->sin_addr;
#                                ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# libavformat/udp.c:294:32: error: member reference base type '__be32' (aka 'unsigned int') is not a structure or union
#             mreqs.imr_interface.s_addr= INADDR_ANY;
#             ~~~~~~~~~~~~~~~~~~~^~~~~~~
# libavformat/udp.c:295:29: error: member reference base type '__be32' (aka 'unsigned int') is not a structure or union
#         mreqs.imr_sourceaddr.s_addr = ((struct sockaddr_in *)&sources[i])->sin_addr.s_addr;
#         ~~~~~~~~~~~~~~~~~~~~^~~~~~~
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-network"

# Hardware accelerators:
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-dxva2"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-vaapi"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-vdpau"

# Individual component options:
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-encoders"

# ./configure --list-decoders
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-decoders"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-decoder=aac"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-decoder=aac_latm"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-decoder=flv"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-decoder=h263"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-decoder=h263i"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-decoder=h263p"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-decoder=h264"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-decoder=mp3*"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-decoder=vp6"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-decoder=vp6a"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-decoder=vp6f"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-decoder=hevc"

export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-hwaccels"

# ./configure --list-muxers
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-muxers"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-muxer=mpegts"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-muxer=mp4"

# ./configure --list-demuxers
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-demuxers"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-demuxer=aac"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-demuxer=concat"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-demuxer=data"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-demuxer=flv"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-demuxer=hls"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-demuxer=latm"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-demuxer=live_flv"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-demuxer=loas"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-demuxer=m4v"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-demuxer=mov"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-demuxer=mp3"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-demuxer=mpegps"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-demuxer=mpegts"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-demuxer=mpegvideo"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-demuxer=hevc"

# ./configure --list-parsers
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-parsers"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-parser=aac"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-parser=aac_latm"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-parser=h263"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-parser=h264"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-parser=hevc"

# ./configure --list-bsf
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-bsfs"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-bsf=mjpeg2jpeg"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-bsf=mjpeg2jpeg"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-bsf=mjpega_dump_header"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-bsf=mov2textsub"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-bsf=text2movsub"

# ./configure --list-protocols
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-protocols"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-protocol=async"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-protocol=bluray"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-protocol=ffrtmpcrypt"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-protocol=ffrtmphttp"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-protocol=gopher"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-protocol=librtmp*"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-protocol=libssh"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-protocol=mmsh"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-protocol=mmst"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-protocol=rtmp*"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-protocol=rtmp"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-protocol=rtmpt"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-protocol=rtp"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-protocol=sctp"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-protocol=srtp"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-protocol=unix"

#
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-devices"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-filters"

# External library support:
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-iconv"
# ...

# Advanced options (experts only):

# Optimization options (experts only):

# Developer options (useful when working on FFmpeg itself):

# BUG FIX
# https://github.com/Bilibili/ijkplayer/issues/4093
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-linux-perf"