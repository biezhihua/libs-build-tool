
# FFmpegBuildTool

一款简洁、快速的FFmpeg编译构建工具。

# 支持构建平台

 * MacOS(需要安装Python)
 * Ubuntu(需要安装Python)

# 特性

 * FFmpeg: 4.1+
 * OpenSSL: 1.1.1+
 * 支持的NDK版本: **r13c** **r14b** **r15c** **r16b** **r17c** **r18b** **r19**
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

 Android-OpenSSL: https://github.com/biezhihua/FFmpegBuildTool/blob/master/android/OPENSSL_README.md
 
 Android-FFmpeg: https://github.com/biezhihua/FFmpegBuildTool/blob/master/android/FFMPEG_README.md

# 注意

部分主体结构借鉴自IJKPlayer (https://github.com/bilibili/ijkplayer)

# 引用

 * https://stackoverflow.com/questions/2649334/difference-between-static-and-shared-libraries

# 预编译库下载