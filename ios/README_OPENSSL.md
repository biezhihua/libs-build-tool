# Arch

https://stackoverflow.com/questions/21422447/what-iphone-devices-will-run-on-armv7s-and-arm64
https://docs.elementscompiler.com/Platforms/Cocoa/CpuArchitectures/

arm64:  iPhone6s | iphone6s plus｜iPhone6｜ iPhone6 plus｜iPhone5S | iPad Air｜ iPad mini2(iPad mini with Retina Display)
armv7s: iPhone5｜iPhone5C｜iPad4(iPad with Retina Display)
armv7:  iPhone4｜iPhone4S｜iPad｜iPad2｜iPad3(The New iPad)｜iPad mini｜iPod Touch 3G｜iPod Touch4

i386:   intel 32
x86_64: x86架构的64位处理器

模拟器32位处理器测试需要i386架构，
模拟器64位处理器测试需要x86_64架构，
真机32位处理器需要armv7,或者armv7s架构，
真机64位处理器需要arm64架构。

# Init Repository 初始化库 

```
./init-openssl.sh armv7a | all
```

# Clean Repository Cache 清理库缓存

```
./init-openssl.sh clean
```

# Build Library 构建库

```
./compile-openssl.sh armv7a | all
```

# Check Output 查看输出结果

```
open ./product
```



