#! /usr/bin/env bash

#--------------------
# Standard options:
export COMMON_FF_CFG_FLAGS=

export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-all"

export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-avcodec"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-avformat"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-avutil"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-swresample"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-swscale"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-avfilter"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-network"

export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-decoder=mp3"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-decoder=aac"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-decoder=h264"

export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-parser=aac"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-parser=h264"

export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-muxer=mp3"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-muxer=mp4"

export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=aac"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=concat"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=data"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=flv"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=hls"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=mov"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=mp3"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=mpegps"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=mpegts"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=mpegvideo"

export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=http"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=https"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=file"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=hls"
export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=concat"

export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-bsf=h264_mp4toannexb"



