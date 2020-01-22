#!/bin/bash

./ios.sh -cb && ./ios.sh --arch-all --enable-libdsm
./ios.sh -cb && ./ios.sh --arch-all --enable-openssl
./ios.sh -cb && ./ios.sh --arch-all --enable-ffmpeg

./android.sh -cb &&  ./android.sh --arch-all --enable-libdsm 
./android.sh -cb &&  ./android.sh --arch-all --enable-openssl
./android.sh -cb &&  ./android.sh --arch-all --enable-ffmpeg 