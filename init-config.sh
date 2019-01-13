#! /usr/bin/env bash

RED='\033[0;31m'
Green='\033[0;33m'
NC='\033[0m' # No Color

FF_TARGET=$1

echo "--------------------"
echo -e "${RED}[*] config ffmpeg module ${NC}"
echo "--------------------"

# http://www.runoob.com/linux/linux-shell-test.html
# -f 文件名	如果文件存在且为普通文件则为真

if [ -f 'config/module.sh' ]; then
    rm ./config/module.sh
fi 

echo_usage() {
    echo "Usage:"
    echo "  init-config.sh default|lite|min|litehevc"
    echo "  init-config.sh clean"
    exit 1
}

case "$FF_TARGET" in
    # all)
    #     cp config/module-all.sh config/module.sh
    #     cat config/module.sh
    #     echo "config complete"
    # ;;
    min)
        cp config/module-min.sh config/module.sh
        cat config/module.sh
        echo "config complete"
    ;;
    default)
        cp config/module-default.sh config/module.sh
        cat config/module.sh
        echo "config complete"
    ;;
    lite)
        cp config/module-lite.sh config/module.sh
        cat config/module.sh
        echo "config complete"
    ;;
    litehevc)
        cp config/module-lite-hevc.sh config/module.sh
        cat config/module.sh
        echo "config complete"
    ;;
    clean)
        rm -rf config/module.sh
        echo "clean complete"
    ;;
    *)
        echo_usage
        exit 1
    ;;
esac

echo "--------------------"
echo -e "${RED}[*] Finish config ffmpeg module ${NC}"
echo "--------------------"