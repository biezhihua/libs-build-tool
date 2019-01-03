# FFmpegBuildTool

Android FFmepg fully automatic build tool.

Help you quickly build your own FFmpeg static library.

# My Environment

* MacOS 10.14.2 
* NDK android-ndk-r16b (only support)

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