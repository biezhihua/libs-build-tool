
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