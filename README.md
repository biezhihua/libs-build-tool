
![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/biezhihua/FFmpegBuildTool)

[![Build Status](https://travis-ci.org/biezhihua/FFmpegBuildTool.svg?branch=master)](https://travis-ci.org/biezhihua/FFmpegBuildTool)

[![License](https://img.shields.io/badge/license-MIT-%23373737)](https://github.com/biezhihua/FFmpegBuildTool/blob/master/LICENSE)


# FFmpegBuildTool

A simple，fast FFmpeg build tool

# Build Platform

 * MacOS (Need install Python)
 * Ubuntu (Need install Python)

# Target Platform

 * Android
 * iOS 
 * MacOS
 * Ubuntu (Will Coming)
 * Windows (Will Coming)

# Android
## Features

 * FFmpeg: 4.1+
 * OpenSSL: 1.1.1+
 * Support NDK Version : **r13c** **r14b** **r15c** **r16b** **r17c** **r18b** **r19** **r20**
 * Support Arch : armv7a/armv8a/x86/x86_64
 * Support FFmpeg Separate compilation
 * Support OpenSSL Separate compilation

NDK Download : https://developer.android.com/ndk/downloads/revision_history

## Set up the necessary environment

```
# add these lines to your ~/.bash_profile or ~/.profile
export ANDROID_SDK=<your sdk path>
export ANDROID_NDK=<your ndk path>
```

# iOS

## Env

 * xcode

## Features

 * FFmpeg: 4.1+
 * OpenSSL: 1.1.1+
 * Support Arch : armv7/armv7s/arm64 i386 x86_64
 * Support FFmpeg Separate compilation
 * Support OpenSSL Separate compilation

# How use

 Android-OpenSSL: https://github.com/biezhihua/FFmpegBuildTool/blob/master/android/README_OPENSSL.md
 
 Android-FFmpeg: https://github.com/biezhihua/FFmpegBuildTool/blob/master/android/README_FFMPEG.md

 MacOS-FFmpeg: https://github.com/biezhihua/FFmpegBuildTool/blob/master/macos/README_FFMPEG.md
 
 iOS-FFmpeg: https://github.com/biezhihua/FFmpegBuildTool/blob/master/ios/README_FFMPEG.md

# Note

Part of the main structure from the IJKPlayer (https://github.com/bilibili/ijkplayer)
