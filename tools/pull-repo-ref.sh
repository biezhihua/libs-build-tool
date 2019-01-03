#! /usr/bin/env bash

#
# 该脚本用于从本地库中克隆一个副本到其他位置
# 

# 远程库地址
REMOTE_REPO=$1
# 本地副本路径
LOCAL_WORKSPACE_PATH=$2
# 本地库路径
REF_REPO=$3

# http://www.runoob.com/linux/linux-shell-test.html
# -z 字符串	字符串的长度为零则为真
# -d 文件名	如果文件存在且为目录则为真
# 或( -o )

if [ -z $1 -o -z $2 -o -z $3 ]; then
    echo "invalid call pull-repo.sh '$1' '$2' '$3'"
elif [ ! -d $LOCAL_WORKSPACE_PATH ]; then
    # https://git-scm.com/docs/git-clone
    # git clone --reference git/linux.git git://git.kernel.org/pub/scm/.../linux.git my-linux
    git clone --reference $REF_REPO $REMOTE_REPO $LOCAL_WORKSPACE_PATH
    cd $LOCAL_WORKSPACE_PATH
    git repack -a
else
    cd $LOCAL_WORKSPACE_PATH
    git fetch --all --tags
    cd -
fi
