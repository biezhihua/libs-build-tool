#! /usr/bin/env bash

# 
# 该脚本用于从远程库克隆代码到本地
# 

# 远程库地址
remote_repo=$1

# 本地文件夹地址
local_workspace_path=$2

if [[ -z ${remote_repo} || -z ${local_workspace_path} ]]; then
    echo "invalid call pull-repo.sh '$remote_repo' '$local_workspace_path'"
elif [[ ! -d ${local_workspace_path} ]]; then
    git clone ${remote_repo} ${local_workspace_path}
else
    cd ${local_workspace_path}
    git fetch --all --tags
    cd --
fi
