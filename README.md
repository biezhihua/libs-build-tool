# FFmpegBuildTool (English)

Android FFmepg fully automatic build tool.

Help you quickly build your own FFmpeg static library.


# Support OS Platform
  
 * MacOS (Need Install Python)
 * Ubuntu (Need Install Ptyhon)

# Feature

* FFmpeg 4.1
* OpenSSL 1.1.1B
* Support NDK **r13c** **r14b** **r15c** **r16b** **r17c** **r18b** **r19**
* Support Arch - armv7a/armv8a/x86/x86_64

NDK Download：https://developer.android.com/ndk/downloads/revision_history

# Setup The Environment

```
# add these lines to your ~/.bash_profile or ~/.profile
export ANDROID_SDK=<your sdk path>
export ANDROID_NDK=<your ndk path>
```

# Init OpenSSL Repository Setting

```
./init-android-openssl all (armv7a armv8a x86 x86_64)
```

# Compile OpenSSL Library

```
./compile-android-openssl all (armv7a armv8a x86 x86_64)
```

# Check OpenSSL Product

```

./build/openssl-armv7a/

./build/openssl-armv8a/

./build/openssl-x86/

./build/openssl-x86_64/
```

# Init FFmpeg Repository Setting

```
./init-android-ffmpeg all (armv7a armv8a x86 x86_64)
```

# Init FFmpeg Configure Module

* If you prefer more codec/format
```
./init-config-ffmpeg all 
```

* If you prefer less codec/format for smaller binary size
```
./init-config-ffmpeg lite
```

* If you prefer less codec/format for smaller binary size   (include hevc function)
```
./init-config-ffmpeg litehevc
```

* If you perfer min code/format for minimun binary size ( only include basic function)
```
./init-config-ffmpeg min
```

# Compile Android FFmpeg Library

* Clone repository
```
git clone https://github.com/biezhihua/FFmpegBuildTool
cd FFmpegBuildTool
```

* Build All Arch
```
./compile-android-ffmpeg.sh all
```

* Build Single Arch
```
./compile-android-ffmpeg.sh armv7a
```

# Check Build Product

```
./build/ffmpeg-armv7a/

./build/ffmpeg-armv8a/

./build/ffmpeg-x86/

./build/ffmpeg-x86_64/
```

# Note

Part of the main structure from the IJKPlayer (https://github.com/bilibili/ijkplayer)

----------------

# 前言

有问题请在Gihub上提ISSUE，邮件问题恕不能一一回复。

# FFmpegBuildTool (中文)

Android下FFmpeg自动构建工具。

帮助你快速构建自己的FFmpeg静态库。

# 支持平台
  
 * MacOS (请提前安装Python)
 * Ubuntu (请提前安装Ptyhon)

# 特性

* FFmpeg 4.1
* OpenSSL 1.1.1B
* 支持 NDK **r13c** **r14b** **r15c** **r16b** **r17c** **r18b** **r19**
* 支持 架构 - armv7a/armv8a/x86/x86_64 (目前仅支持这些）

NDK下载地址：https://developer.android.com/ndk/downloads/revision_history

# 设置环境

```
# 添加下面内容到你的 ~/.bash_profile or ~/.profile 文件中
export ANDROID_SDK=<your sdk path>
export ANDROID_NDK=<your ndk path>
```

# 初始化OpenSSL仓库设置

```
./init-android-openssl all (armv7a armv8a x86 x86_64)
```

# 编译OpenSSL库

```
./compile-android-openssl all (armv7a armv8a x86 x86_64)
```

# 查看OpenSSL产物

```

./build/openssl-armv7a/

./build/openssl-armv8a/

./build/openssl-x86/

./build/openssl-x86_64/
```


# 初始化FFmpeg仓库设置

```
./init-android-ffmpeg all (armv7a armv8a x86 x86_64)
```

# 初始化FFmpeg配置模块

* 如果你需要更多的编码和格式
```
./init-config-ffmpeg all 
```

* 如果你需要更少的编码和格式，以减少库大小
```
./init-config-ffmpeg lite
```

* 如果你需要更少的编码和格式，以减少库大小（包含HEVC功能）
```
./init-config-ffmpeg litehevc
```

* 如果你需要最少的编码和格式，最小的库大小（仅支持支持功能）
```
./init-config-ffmpeg min
```

# 编译FFmpeg库

* 克隆项目
```
git clone https://github.com/biezhihua/FFmpegBuildTool
cd FFmpegBuildTool
```

* 构建所有架构
```
./compile-android-ffmpeg.sh all
```

* 构建单一架构
```
./compile-android-ffmpeg.sh armv7a
```

# 查看FFmpeg产物

```
./build/ffmpeg-armv7a/

./build/ffmpeg-armv8a/

./build/ffmpeg-x86/

./build/ffmpeg-x86_64/

```

# 注意

部分主体结构借鉴自IJKPlayer (https://github.com/bilibili/ijkplayer)



