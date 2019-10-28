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
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-avcodec"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-avformat"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-avutil"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-swresample"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-swscale"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-avfilter"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-network"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-avresample"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-avdevice"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-postproc"

# Hardware accelerators:
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-d3d11va"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-dxva2"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-vaapi"

export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-vdpau"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-videotoolbox"

# Individual component options:
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-encoders"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-encoder=png"

# ./configure --list-decoders
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-decoders"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-decoder=aac"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-decoder=ac3"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-decoder=aac_latm"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-decoder=flv"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-decoder=h264"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-decoder=mp3*"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-decoder=vp6f"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-decoder=flac"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-decoder=vp8"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-decoder=vp9"

export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-hwaccels"

# ./configure --list-muxers
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-muxers"

# ./configure --list-demuxers
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-demuxers"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-demuxer=aac"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-demuxer=concat"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-demuxer=data"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-demuxer=flv"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-demuxer=hls"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-demuxer=live_flv"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-demuxer=mov"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-demuxer=mp3"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-demuxer=mpegps"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-demuxer=mpegts"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-demuxer=mpegvideo"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-demuxer=flac"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-demuxer=webm_dash_manifest"

# ./configure --list-parsers
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-parsers"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-parser=aac"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-parser=aac_latm"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-parser=h264"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-parser=flac"

# ./configure --list-bsf
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-bsfs"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-bsf=chomp"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-bsf=dca_core"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-bsf=dump_extradata"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-bsf=hevc_mp4toannexb"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-bsf=imx_dump_header"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-bsf=mjpeg2jpeg"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-bsf=mjpega_dump_header"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-bsf=mov2textsub"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-bsf=mp3_header_decompress"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-bsf=mpeg4_unpack_bframes"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-bsf=noise"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-bsf=remove_extradata"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-bsf=text2movsub"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-bsf=vp9_superframe"

# ./configure --list-protocols
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-protocols"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-protocol=async"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-protocol=bluray"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-protocol=concat"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-protocol=crypto"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-protocol=ffrtmpcrypt"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-protocol=gopher"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-protocol=icecast"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-protocol=librtmp*"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-protocol=libssh"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-protocol=md5"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-protocol=mmsh"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-protocol=mmst"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-protocol=rtmp*"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-protocol=rtp"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-protocol=sctp"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-protocol=srtp"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-protocol=subfile"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-protocol=unix"

#
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-devices"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-filters"

# External library support:
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-iconv"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-audiotoolbox"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-videotoolbox"

# Developer options (useful when working on FFmpeg itself):
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-linux-perf"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-bzlib"

