#! /usr/bin/env bash

#--------------------
# Standard options:
export COMMON_CFG_FLAGS=

export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --disable-all"

export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-avcodec"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-avformat"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-avutil"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-swresample"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-swscale"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-avfilter"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-network"

export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-decoder=mp3"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-parser=aac"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-muxer=mp3"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-demuxer=mp3"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-protocol=http"
export COMMON_CFG_FLAGS="$COMMON_CFG_FLAGS --enable-protocol=https"



