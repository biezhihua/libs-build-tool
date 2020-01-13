#! /bin/sh
if [[ "$1" = "armeabi-v7a" ]]; then
	echo "android-arm"
elif [[ "$1" = "arm64-v8a" ]]; then
	echo "android-arm64"
elif [[ "$1" = "x86" ]]; then
	echo "android-x86 no-asm"
elif [[ "$1" = "x86_64" ]]; then
	echo "android-x86_64"
else
	echo "none"
fi
