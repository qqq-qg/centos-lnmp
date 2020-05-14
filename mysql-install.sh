#!/bin/bash

./user-add.sh mysql mysql
shellpwd=$(pwd)
uninstall() {
    if [ -d "/usr/local/mysql" ]; then
        rm -rf /usr/local/mysql
    fi

    if [ -d "/data/mysql" ]; then
        rm -rf /data/mysql
    fi

    if [ -f "/etc/my.cnf" ]; then
        rm /etc/my.cnf
    fi
}

uninstall

cd /soft

if [ ! -f "/soft/mysql-5.7.22-linux-glibc2.12-x86_64.tar.gz" ]; then
    wget https://dev.mysql.com/get/archives/mysql-5.7/mysql-5.7.22-linux-glibc2.12-x86_64.tar.gz
fi

tar -zxvf mysql-5.7.22-linux-glibc2.12-x86_64.tar.gz

mv mysql-5.7.22-linux-glibc2.12-x86_64 /usr/local/mysql

chown -R mysql.mysql /usr/local/mysql

echo "export PATH=$PATH:/usr/local/mysql/bin" >>/etc/profile
source /etc/profile

mkdir -p /data/mysql/{data,binlogs,log,etc,run}
ln -s /data/mysql/data /usr/local/mysql/data
ln -s /data/mysql/binlogs /usr/local/mysql/binlogs
ln -s /data/mysql/log /usr/local/mysql/log
ln -s /data/mysql/etc /usr/local/mysql/etc
ln -s /data/mysql/run /usr/local/mysql/run
chown -R mysql.mysql /data/mysql/
chown -R mysql.mysql /usr/local/mysql/{data,binlogs,log,etc,run}

cp $shellpwd/my.cnf /usr/local/mysql/etc/my.cnf

yum install -y libaio

mysqld --initialize --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data

temporaryPassword=$(grep 'temporary password' /usr/local/mysql/log/mysql_error.log)

if [ ! -f "/usr/lib/systemd/system/mysqld.service" ]; then
    cp $shellpwd/mysqld.service /usr/lib/systemd/system/mysqld.service
fi

systemctl daemon-reload
systemctl enable mysqld.service
systemctl start mysqld.service

echo "MySQL 安装完毕"
echo "数据库临时密码："
echo $temporaryPassword
