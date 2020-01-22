#!/bin/bash

./ios.sh -cb && ./ios.sh --arch-all --enable-libdsm
./ios.sh -cb && ./ios.sh --arch-all --enable-openssl
./ios.sh -cb && ./ios.sh --arch-all --enable-ffmpeg

./android.sh -cb &&  ./android.sh --enable-libdsm --arch-all
./android.sh -cb &&  ./android.sh --enable-openssl --arch-all
./android.sh -cb &&  ./android.sh --enable-ffmpeg --arch-all