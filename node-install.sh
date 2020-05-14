#!/bin/bash

cd /soft

uninstall() {
    if [ -d "/usr/local/node" ]; then
        rm -rf /usr/local/node
    fi
}

uninstall

if [ ! -f "/soft/node-v8.11.4-linux-x64.tar.gz" ]; then
    wget https://npm.taobao.org/mirrors/node/latest-v8.x/node-v8.11.4-linux-x64.tar.gz
fi
tar -zxvf node-v8.11.4-linux-x64.tar.gz
mv node-v8.11.4-linux-x64 /usr/local/node
ln -s /usr/local/node/bin/node /usr/bin/node
ln -s /usr/local/node/bin/npm /usr/bin/npm
ln -s /usr/local/node/bin/npx /usr/bin/npx
