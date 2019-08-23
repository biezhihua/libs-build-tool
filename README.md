
# FFmpegBuildTool

A simple，fast FFmpeg build tool

# Build Platform

 * MacOS (Need install Python)
 * Ubuntu (Need install Python)

# Target Platform

 * Android
 * MacOS
 * Ubuntu (Will Coming)
 * Windows (Will Coming)
 * iOS (Will Coming)

# Features

 * FFmpeg: 4.1+
 * OpenSSL: 1.1.1+
 * Support NDK Version : **r13c** **r14b** **r15c** **r16b** **r17c** **r18b** **r19** **r20**
 * Support Arch : armv7a/armv8a/x86/x86_64
 * Support FFmpeg Separate compilation
 * Support OpenSSL Separate compilation

NDK Download : https://developer.android.com/ndk/downloads/revision_history


# Set up the necessary environment

```
# add these lines to your ~/.bash_profile or ~/.profile
export ANDROID_SDK=<your sdk path>
export ANDROID_NDK=<your ndk path>
```

# How use

 Android-OpenSSL: https://github.com/biezhihua/FFmpegBuildTool/blob/master/android/README_OPENSSL.md
 
 Android-FFmpeg: https://github.com/biezhihua/FFmpegBuildTool/blob/master/android/README_FFMPEG.md

 MacOS-FFmpeg: https://github.com/biezhihua/FFmpegBuildTool/blob/master/macos/README_FFMPEG.md

# Note

Part of the main structure from the IJKPlayer (https://github.com/bilibili/ijkplayer)


----------------

# FFmpegBuildTool

一款简洁、快速的全平台FFmpeg编译构建工具。

# 支持构建平台

 * MacOS(需要安装Python)
 * Ubuntu(需要安装Python)

# 支持目标平台

 * Android
 * MacOS
 * Ubuntu (即将到来)
 * Windows (即将到来)
 * iOS (即将到来)

# 特性

 * FFmpeg: 4.1+
 * OpenSSL: 1.1.1+
 * 支持的NDK版本: **r13c** **r14b** **r15c** **r16b** **r17c** **r18b** **r19** **r20**
 * 支持的架构: armv7a/armv8a/x86/x86_64
 * 支持FFmpeg独立编译
 * 支持OpenSSL独立编译
 * 支持FFmpeg*OpenSSL联合编译

NDK 下载 : https://developer.android.com/ndk/downloads/revision_history


# 设置必要的环境

```
# add these lines to your ~/.bash_profile or ~/.profile
export ANDROID_SDK=<your sdk path>
export ANDROID_NDK=<your ndk path>
```

# 如何使用

 Android-OpenSSL: https://github.com/biezhihua/FFmpegBuildTool/blob/master/android/README_OPENSSL.md
 
 Android-FFmpeg: https://github.com/biezhihua/FFmpegBuildTool/blob/master/android/README_FFMPEG.md

 MacOS-FFmpeg: https://github.com/biezhihua/FFmpegBuildTool/blob/master/macos/README_FFMPEG.md

# 注意

部分主体结构借鉴自IJKPlayer (https://github.com/bilibili/ijkplayer)

# 引用

 * https://stackoverflow.com/questions/2649334/difference-between-static-and-shared-libraries
