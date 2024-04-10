# !/bin/bash
# -------------------------------------
# 自定义博客发布脚本，一键构建/上传站点
#
# Author: lzan13
# WebSite: https://melove.net
# -------------------------------------
set -e

if [ $1 ]; then
    debug=$1
else
    debug="debug"
fi

init(){
    echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "┃ custom blog build publish sh script"
    echo "┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "┃ input args $1"
    if [ $debug == "build" ]; then
        build
    else
        debug
    fi

}

# 调试运行
debug(){
    echo "┃ build blog content..."
    # 构建内容
    yarn dev
    # 打包生成内容
    tar -cvf blog.tar ./public
    echo "┃ build blog content finish"

}

# 打包编译
build(){

    echo "| remove old build res!"
    rm -rf blog.tar

    echo "┃ build blog content..."
    # 构建内容
    yarn build
    # 打包生成内容
    tar -cvf ./blog.tar ./public/*
    echo "┃ build blog content finish"

    publish;

    rm -rf blog.tar
}

# 发布
publish(){
    echo "| remove server content..."
    ssh vmunt403a "rm -rf /www/wwwroot/vmblog/blog.tar /www/wwwroot/vmblog/public"
    echo "┃ remove vmunt403a blog.tar and build success"

    scp ./blog.tar vmunt403a:/www/wwwroot/vmblog/blog.tar
    echo "┃ upload blog.tar to vmunt403a success"

    ssh vmunt403a "tar -xvf /www/wwwroot/vmblog/blog.tar -C /www/wwwroot/vmblog/"
    ssh vmunt403a "chown -R root /www/wwwroot/vmblog/public"
    echo "┃ untar vmunt403a blog.tar success"
}


# 初始化
init;