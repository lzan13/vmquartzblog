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
    echo "┃ author: lzan13"
    echo "┃ params doc:"
    echo "┃ arg1:main   branch"
    echo "┃ arg2:14     platform ip"
    echo "┃ arg3:0      clean flutter cache 0-no 1-yes"
    echo "┃ example：main 21 0"
    echo "┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    read -p "┃ input params: " arg1
    if [ ! -n "$arg1" ]; then
        arg1=dev
    fi
    

    echo "┃ input args $arg1"

    # 打包编译
    build;

}

# 打包编译
build(){
    echo "| remove old build res!"
    rm -rf blog.tar

    echo "┃ build blog content..."
    # 构建内容
    yarn build
    # 打包生成内容
    tar -cvf blog.tar ./public
    echo "┃ build blog content finish"

    if [ $arg1 == "release" ]; then
        upload
    fi
}

# 指定板子
upload(){
    ssh vmunt403a "rm -rf /www/wwwroot//Develop/24h.tar /home/orangepi/Develop/build/"
    echo "┃ remove vmunt403a blog.tar and build success"

    scp ./24h.tar pi$arg2:/home/orangepi/Develop/24h.tar
    echo "┃ upload 24h.tar to pi$arg2 success"

    ssh pi$arg2 "tar -xvf /home/orangepi/Develop/24h.tar -C /home/orangepi/Develop/"
    echo "┃ untar pi$arg2 24h.tar success"
}

# 上传全部
uploadAll(){
    arg2=19;
    upload;
    arg2=21;
    upload;
    arg2=103;
    upload;
    echo "┃ upload all platform success"
}

# 移除并从打包机子下载包到本机（目前打包机就是当前机子）
removeLocalTar(){
    rm 24h.tar
    echo "┃ remove 24h.tar success"

    scp weidian@10.211.55.4:/home/weidian/Develop/ccm_24h_flutter/24h.tar ~/Develop
    echo "┃ download 24h.tar success"
}

# 等待参数输入
init;