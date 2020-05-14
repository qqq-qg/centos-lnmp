#!/bin/bash

echo "请选择要安装的程序：（默认 1）"

echo "1. 全部程序"

echo "2. Nginx"

echo "3. MySQL"

echo "4. PHP"

echo "5. Node"

echo "6. Redis"

read USER_INPUT

if [ ! -n "$USER_INPUT" ]; then
    userchoice='1'
else
    userchoice=$USER_INPUT
fi

if [[ $userchoice =~ [1-7] ]]; then
    userchoice=$userchoice
else
    userchoice='1'
fi

function ensureInstall() {
    echo "安装会卸载之前版本，是否确认？(y/n,默认否)"
    read USER_INPUT
    # if [ ! -n "$USER_INPUT" ]; then
    #     echo '取消安装'
    #     exit 0
    # fi

    if [ "$USER_INPUT" != "y" ]; then
        echo '取消安装'
        exit 0
    fi
}

case $userchoice in
1)
    echo "安装全部程序..."
    ensureInstall
#    ./nginx-install.sh
#    ./mysql-install.sh
#    ./php-install.sh
#    ./node-install.sh
#    ./redis-install.sh
    ;;
2)
    echo "安装Nginx..."
    ensureInstall
    ./nginx-install.sh
    ;;
3)
    echo "安装MySQL..."
    ensureInstall
#    ./mysql-install.sh
    ;;

4)
    echo "安装PHP..."
    ensureInstall
#    ./php-install.sh
    ;;

5)
    echo "安装Node..."
    ensureInstall
#    ./node-install.sh
    ;;

6)
    echo "安装Redis..."
    ensureInstall
#    ./redis-install.sh
    ;;
*)
    exit 1
    ;;
esac

echo '安装完成'
