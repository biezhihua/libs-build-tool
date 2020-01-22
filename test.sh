#!/bin/bash

set -e

./android.sh -cb &&  ./android.sh --enable-libdsm --arch-armeabi-v7a
./android.sh -cb &&  ./android.sh --enable-openssl --arch-armeabi-v7a
./android.sh -cb &&  ./android.sh --enable-ffmpeg --arch-armeabi-v7a