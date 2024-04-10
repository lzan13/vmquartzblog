# !/bin/bash
# -------------------------------------
# 自定义博客发布脚本，一键构建/上传站点
#
# Author: lzan13
# WebSite: https://melove.net
# -------------------------------------
init(){
    echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "┃ custom blog build publish sh script"
    echo "┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    set -e

    if [ $1 ]; then
        if [ $1 == "build" ]; then
            build
        fi
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
    tar -cvf blog.tar ./public/*
    echo "┃ build blog content finish"

    publish;
}

# 发布
publish(){
    echo "| remove server content..."
    ssh vmunt403a "rm -rf /www/wwwroot/melove.net/vmblog/*"
    echo "┃ remove vmunt403a blog.tar and build success"

    scp ./blog.tar vmunt403a:/www/wwwroot/melove.net/vmblog/blog.tar
    echo "┃ upload blog.tar to vmunt403a success"

    ssh vmunt403a "tar -xvf /www/wwwroot/melove.net/vmblog/blog.tar -C /www/wwwroot/melove.net/vmblog/"
    echo "┃ untar vmunt403a blog.tar success"
}


# 初始化
init;