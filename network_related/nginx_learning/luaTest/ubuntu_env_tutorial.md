# 流程

0. refer :
- https://github.com/luarocks/luarocks/wiki/Installation-instructions-for-Unix

1. install lua

curl -R -O http://www.lua.org/ftp/lua-5.3.5.tar.gz
tar zxf lua-5.3.5.tar.gz
cd lua-5.3.5
make linux test


2. install luarocks

wget https://luarocks.org/releases/luarocks-3.3.1.tar.gz
tar zxpf luarocks-3.3.1.tar.gz
cd luarocks-3.3.1
./configure && make && sudo make install
sudo luarocks install luasocket
lua


3. configure openresty Makfile

> ./configure --prefix=/home/ubuntu/openresty --with-pcre-jit --with-ipv6 --without-http_redis2_module --with-http_iconv_module --with-http_postgres_module -j8

4. install openresty via `make install`

> make install

# pre-request
```bash
sudo apt-get install -y \
 unzip \
 libpcre3-dev \
 libssl-dev \
 perl \
 make \
 build-essential \
 curl \
 libpq-dev \
 zlib1g-dev
```