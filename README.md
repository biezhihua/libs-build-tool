# FFmpegBuildTool (English)

Android FFmepg fully automatic build tool.

Help you quickly build your own FFmpeg static library.

# My Environment

* MacOS 10.14.2 
* NDK **r14b** **r15c** **r16b** **r17c** **r18b** **r19**
* Arch - armv7a/armv8a/x86/x86_64 (only support)

NDK Download URL：https://developer.android.com/ndk/downloads/revision_history

# Setup The Environment

```
# add these lines to your ~/.bash_profile or ~/.profile
export ANDROID_SDK=<your sdk path>
export ANDROID_NDK=<your ndk path>
```

# Init FFmpeg Configure Module

* If you prefer more codec/format
```
./init-config all 
```

* If you prefer less codec/format for smaller binary size
```
./init-config lite
```

* If you prefer less codec/format for smaller binary size   (include hevc function)
```
./init-config litehevc
```

* If you perfer min code/format for minimun binary size ( only include basic function)
```
./init-config min
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

----------------


# FFmpegBuildTool (中文)

Android下FFmpeg自动构建工具。

帮助你快速构建自己的FFmpeg静态库。

# 我的环境

* MacOS 10.14.2 
* NDK **r14b** **r15c** **r16b** **r17c** **r18b** **r19**
* 架构 - armv7a/armv8a/x86/x86_64 (目前仅支持这些）

NDK下载地址：https://developer.android.com/ndk/downloads/revision_history

# 设置环境

```
# 添加下面内容到你的 ~/.bash_profile or ~/.profile 文件中
export ANDROID_SDK=<your sdk path>
export ANDROID_NDK=<your ndk path>
```

# 初始化FFmpeg配置模块

* 如果你需要更多的编码和格式
```
./init-config all 
```

* 如果你需要更少的编码和格式，以减少库大小
```
./init-config lite
```

* 如果你需要更少的编码和格式，以减少库大小（包含HEVC功能）
```
./init-config litehevc
```

* 如果你需要最少的编码和格式，最小的库大小（仅支持支持功能）
```
./init-config min
```

# 编译库

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

# 查看产物

```
./build/ffmpeg-armv7a/

./build/ffmpeg-armv8a/

./build/ffmpeg-x86/

./build/ffmpeg-x86_64/
```



