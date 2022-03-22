#!/bin/bash

yum groupinstall -y 'Development Tools'
yum install -y openssl openssl-devel git wget

# install wrk

cd /
git clone https://github.com/wg/wrk.git wrk
cd wrk; make;  cp wrk /usr/bin

# install luajit

cd /
git clone https://luajit.org/git/luajit-2.0.git
cd luajit-2.0; make && make install

# install luarocks

cd /
wget https://luarocks.org/releases/luarocks-3.3.1.tar.gz
tar zxf luarocks-3.3.1.tar.gz; cd luarocks-3.3.1; ./configure --with-lua-include=/luajit-2.0/src --lua-suffix=jit; make && make install


# install some popular pkgs
# luarocks install jwt
# luarocks install luasocket
# luarocks install lunajson