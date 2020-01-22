#!/bin/bash

# ./ios.sh -cb && ./ios.sh --arch-arm64 --enable-libdsm
./ios.sh -cb && ./ios.sh --arch-arm64 --enable-openssl
./ios.sh -cb && ./ios.sh --arch-arm64 --enable-ffmpeg

./android.sh -cb &&  ./android.sh --enable-libdsm --arch-armeabi-v7a
./android.sh -cb &&  ./android.sh --enable-openssl --arch-armeabi-v7a
./android.sh -cb &&  ./android.sh --enable-ffmpeg --arch-armeabi-v7a