#!/bin/bash

shellpwd=$(pwd)
cd /soft

uninstall() {
    if [ -d "/usr/local/redis" ]; then
        rm -rf /usr/local/redis
    fi
}

uninstall

if [ -d "/soft/redis-4.0.0" ]; then
    rm -rf redis-4.0.0
else
    wget http://download.redis.io/releases/redis-4.0.0.tar.gz
fi

tar -zxvf redis-4.0.0.tar.gz

cd redis-4.0.0

yum install gcc gcc-c++

make PREFIX=/usr/local/redis install

mkdir /usr/local/redis/etc
cp redis.conf /usr/local/redis/etc/redis.conf

cp $shellpwd/redis.service /etc/rc.d/init.d/redis

chmod +x /etc/rc.d/init.d/redis

sed -i 's/daemonize\sno/daemonize yes' /usr/local/redis/etc/redis.conf

chkconfig --add redis

systemctl daemon-reload

systemctl start redis

systemctl status redis

/sbin/chkconfig redis on
