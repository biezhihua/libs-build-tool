#! /usr/bin/env bash

source ../tools/colors.sh
source ../tools/common.sh
set -e

function echo_usage() {
    echo "Usage:"
    echo "  init-config.sh default|lite|min|litehevc|mp3|mp4"
    echo "  init-config.sh clean"
    exit 1
}

target=$1

function main() {

    echo "--------------------"
    echo -e "${red}[*] config ffmpeg module ${nc}"
    echo "--------------------"

    if [[ -f 'config/module.sh' ]]; then
        rm ./config/module.sh
    fi

    case "$target" in
    min)
        cp config/module-min.sh config/module.sh
        cat config/module.sh
        echo "config complete"
        ;;
    mp3)
        cp config/module-mp3.sh config/module.sh
        cat config/module.sh
        echo "config complete"
        ;;
    mp4)
        cp config/module-mp4.sh config/module.sh
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
}

main
