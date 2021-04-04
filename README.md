
# Introduction

[![Build Status](https://api.travis-ci.org/biezhihua/libs-build-tool.svg?branch=master)](https://travis-ci.org/biezhihua/libs-build-tool)

[![License](https://img.shields.io/badge/license-GPL-blue)](https://github.com/biezhihua/libs-build-tool/blob/master/LICENSE)

[![Version](https://img.shields.io/github/v/release/biezhihua/libs-build-tool)](https://github.com/biezhihua/libs-build-tool/releases)

Convenient and fast library building tools.

# Target Platform

* Support Android
* Support iOS

# Android Guide Start

## Prerequisite

* NDK-18: android-ndk-r18b
* MacOS

## Help

```
❯ ./android.sh -h

'android.sh' builds some lib for Android platform. By default five Android ABIs (armeabi-v7a, armeabi-v7a-neon, arm64-v8a, x86 and x86_64) are built without any external libraries enabled. Options can be used to disable ABIs and/or enable external libraries.

Usage: ./android.sh [OPTION]...

Specify environment variables as VARIABLE=VALUE to override default build options.

Options:
  -h, --help			display this help and exit
  -v, --version			display version information and exit
  -c, --clean			clean build and prebuilt and exit
  -cb, --clean build		clean build and exit
  -cp, --clean prebuil		clean prebuilt and exit
Platforms:
  --arch-all			do build armeabi-v7a, armeabi-v7a-neon, arm64-v8a, x86 and x86_64 platform [yes]
  --arch-armeabi-v7a		do build armeabi-v7a platform [yes]
  --arch-armeabi-v7a-neon	do build armeabi-v7a-neon platform [yes]
  --arch-arm64-v8a		do build arm64-v8a platform [yes]
  --arch-x86			do build x86 platform [yes]
  --arch-x86_64			do build x86_64 platform [yes]

Libraries:
  --enable-libname			build with libname libraries

  				support libs : ffmpeg gsm iconv lame libdsm libtasn1 openjpeg openssl zlib

  				note: openssl library must be compiled independently

FFmpeg Configs:
  --ffmpeg-config-lite		build ffmpeg with lite config
  --ffmpeg-config-mp4		build ffmpeg with mp4 config
  --ffmpeg-config-mp3		build ffmpeg with mp3 config
  --ffmpeg-config-min		build ffmpeg with min config

GPL libraries:
  --lib-x264			build with x264 [no]
  --lib-x265			build with x265 [no]

Autohr:
  name				biezhihua
  email				biezhihua@gmail.com
```

## Guide

```
./android.sh -h
```

## Build FFmpeg with min config

```
/android.sh --lib-ffmpeg --ffmpeg-config-min --arch-armeabi-v7a
```

## Build Openssl lib

```
./android.sh --lib-openssl --arch-armeabi-v7a
```

## Clean All

```
./android.sh --clean
```

# Statement

Some code logic is referenced from third-party open source libraries

* https://github.com/tanersener/mobile-ffmpeg
* https://code.videolan.org/videolan/vlc-android

# License

```

                    GNU GENERAL PUBLIC LICENSE
                       Version 3, 29 June 2007

 Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
 Everyone is permitted to copy and distribute verbatim copies
 of this license document, but changing it is not allowed.
```