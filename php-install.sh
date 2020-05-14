#!/bin/bash

cd /soft

echo "请输入需要安装的 PHP 版本：(默认1)"

echo "1 ---- 7.1.33"
echo "2 ---- 7.2.24"
echo "3 ---- 7.3.11"

read phpversion

case $phpversion in
1)
    tarname='php-7.1.33.tar.gz'
    dirname='php-7.1.33'
    source='https://www.php.net/distributions/php-7.1.33.tar.gz'
    ;;
2)
    tarname='php-7.2.24.tar.gz'
    dirname='php-7.2.24'
    source='https://www.php.net/distributions/php-7.2.24.tar.gz'
    ;;
3)
    tarname='php-7.3.11.tar.gz'
    dirname='php-7.3.11'
    source='https://www.php.net/distributions/php-7.3.11.tar.gz'
    ;;
*)
    tarname='php-7.1.33.tar.gz'
    dirname='php-7.1.33'
    source='https://www.php.net/distributions/php-7.1.33.tar.gz'
    ;;
esac

if [ ! -f "/soft/$tarname" ]; then
    wget $source
fi

if [ ! -d "/soft/$dirname" ]; then
    tar -zxvf $tarname
else
    cd $dirname && make clean
fi

cd $dirname

uninstall() {
    if [ -d "/usr/local/php" ]; then
        rm -rf /usr/local/php
    fi
}

uninstall

install() {
    yum install gd-devel libxml2 libxml2-devel openssl openssl-devel bzip2 bzip2-devel libcurl libcurl-devel libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel gmp gmp-devel libmcrypt libmcrypt-devel readline readline-devel libxslt libxslt-devel -y
    yum install bzip2 bzip2-devel -y
    yum install libxml2 libxml2-devel -y
    yum install libcurl.x86_64 libcurl-devel.x86_64 -y
    yum install gmp-devel -y
    yum -y install readline-devel
    yum -y install libxslt-devel
    yum install -y epel-release
    yum install -y libmcrypt-devel
}

install

./configure \
    --prefix=/usr/local/php \
    --with-config-file-path=/usr/local/php/lib/etc \
    --enable-fpm \
    --with-fpm-user=nginx \
    --with-fpm-group=nginx \
    --enable-inline-optimization \
    --disable-debug \
    --disable-rpath \
    --enable-shared \
    --enable-soap \
    --with-libxml-dir \
    --with-xmlrpc \
    --with-openssl \
    --with-mcrypt \
    --with-mhash \
    --with-pcre-regex \
    --with-sqlite3 \
    --with-zlib \
    --enable-bcmath \
    --with-iconv \
    --with-bz2 \
    --enable-calendar \
    --with-curl \
    --with-cdb \
    --enable-dom \
    --enable-exif \
    --enable-fileinfo \
    --enable-filter \
    --with-pcre-dir \
    --enable-ftp \
    --with-gd \
    --with-openssl-dir \
    --with-jpeg-dir \
    --with-png-dir \
    --with-zlib-dir \
    --with-freetype-dir \
    --enable-gd-native-ttf \
    --enable-gd-jis-conv \
    --with-gettext \
    --with-gmp \
    --with-mhash \
    --enable-json \
    --enable-mbstring \
    --enable-mbregex \
    --enable-mbregex-backtrack \
    --with-libmbfl \
    --with-onig \
    --enable-pdo \
    --with-mysqli=mysqlnd \
    --with-pdo-mysql=mysqlnd \
    --with-zlib-dir \
    --with-pdo-sqlite \
    --with-readline \
    --enable-session \
    --enable-shmop \
    --enable-simplexml \
    --enable-sockets \
    --enable-sysvmsg \
    --enable-sysvsem \
    --enable-sysvshm \
    --enable-wddx \
    --with-libxml-dir \
    --with-xsl \
    --enable-zip \
    --enable-mysqlnd-compression-support \
    --with-pear \
    --enable-opcache

make -j4
make install

mkdir /usr/local/php/lib/etc

cp php.ini-development /usr/local/php/lib/etc/php.ini

echo "export PATH=$PATH:/usr/local/php/bin" >>/etc/profile
source /etc/profile

cp sapi/fpm/php-fpm.service /usr/lib/systemd/system/php-fpm.service

systemctl daemon-reload
systemctl enable php-fpm.service

cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf

cp /usr/local/php/etc/php-fpm.d/www.conf.default /usr/local/php/etc/php-fpm.d/www.conf

sed -i "s/listen\s=\s.*/listen=\/dev\/shm\/php-fcgi.sock/" /usr/local/php/etc/php-fpm.d/www.conf

sed -i "s/;listen\.mode=.*/listen\.mode=0666/" /usr/local/php/etc/php-fpm.d/www.conf

echo "PHP 安装完毕"
