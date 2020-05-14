#!/bin/bash

./user-add.sh nginx nginx
shellpwd=$(pwd)
install() {
    yum grouplist
    yum groupinstall "Development Tools"

    rpm -qa pcre pcre-devel
    yum install pcre pcre-devel -y
    rpm -qa pcre pcre-devel

    rpm -qa openssl openssl-devel
    yum install openssl openssl-devel -y
    rpm -qa openssl openssl-devel
    rpm -qa gd gd-devel
    yum install gd gd-devel -y
    rpm -qa gd gd-devel
}

uninstall() {
    if [ -d "/usr/local/nginx" ]; then
        rm -rf /usr/local/nginx
    fi
}

uninstall

install

if [ ! -d "/soft" ]; then
    mkdir /soft
fi

cd /soft

if ! [ -x "$(command -v wget)" ]; then
    yum install wget
fi

if [ ! -f "/soft/nginx-1.15.0.tar.gz" ]; then
    wget http://nginx.org/download/nginx-1.15.0.tar.gz

fi

tar -zxvf nginx-1.15.0.tar.gz

cd nginx-1.15.0

./configure \
    --prefix=/usr/local/nginx \
    --user=nginx \
    --group=nginx \
    --with-http_stub_status_module \
    --with-http_ssl_module \
    --with-http_sub_module \
    --with-http_realip_module \
    --with-http_image_filter_module \
    --with-pcre

make && make install

chown -R nginx:nginx /usr/local/nginx

if [ ! -f "/usr/bin/nginx" ]; then
    ln -s /usr/local/nginx/sbin/nginx /usr/bin/nginx
fi

if [ ! -f "/usr/lib/systemd/system/nginx.service" ]; then
    cp $shellpwd/nginx.service /usr/lib/systemd/system/nginx.service
fi

systemctl enable nginx.service

systemctl daemon-reload

echo "Nginx 安装完毕"
