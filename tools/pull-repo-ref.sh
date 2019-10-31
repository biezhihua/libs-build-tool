#! /usr/bin/env bash

#
# 该脚本用于从本地库中克隆一个副本到其他位置
# 

# 远程库地址
remote_repo=$1

# 本地副本路径
local_workspace_path=$2

# 本地库路径
ref_repo=$3

if [[ -z $1 || -z $2 || -z $3 ]]; then
    echo "invalid call pull-repo.sh '$1' '$2' '$3'"
elif [[ ! -d ${local_workspace_path} ]]; then
    git clone --reference ${ref_repo} ${remote_repo} ${local_workspace_path}
    cd ${local_workspace_path}
    git repack -a
else
    cd ${local_workspace_path}
    git fetch --all --tags
    cd -
fi
