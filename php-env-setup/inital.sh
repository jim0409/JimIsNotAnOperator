#!/bin/bash

yum install -y epel-release nginx
yum -y install wget gcc gcc-c++ autoconf libjpeg-turbo-static libjpeg-turbo-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel pcre pcre-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel krb5-libs krb5-devel libidn libidn-devel openssl openssl-devel openldap openldap-devel nss-pam-ldapd openldap-clients openldap-servers bison lrzsz libmcrypt libmcrypt-devel mcrypt mhash ImageMagick ImageMagick-devel libmemcached libmemcached-devel

cd /tmp
wget http://cn2.php.net/distributions/php-5.6.37.tar.gz

tar zxf php-5.6.37.tar.gz
cd /tmp/php-5.6.37

./configure --prefix=/usr/local/php \
  --with-config-file-path=/usr/local/php/etc \
  --with-bz2 \
  --with-curl \
  --enable-ftp \
  --enable-sockets \
  --disable-ipv6 \
  --with-gd \
  --with-jpeg-dir=/usr/local \
  --with-png-dir=/usr/local \
  --with-freetype-dir=/usr/local \
  --enable-gd-native-ttf \
  --with-iconv-dir=/usr/local \
  --enable-mbstring \
  --enable-calendar \
  --with-gettext \
  --with-ldap \
  --with-libxml-dir=/usr/local \
  --with-zlib \
  --with-pdo-mysql=mysqlnd \
  --with-mysqli=mysqlnd \
  --with-mysql=mysqlnd \
  --enable-dom \
  --enable-xml \
  --enable-fpm \
  --with-libdir=lib64 \
  --enable-bcmath \
  --with-mysqli

make && make install

# install mcrypt
cd /tmp/php-5.6.37/ext/mcrypt

/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config
make && make install


# install igbinary
cd /tmp

wget https://pecl.php.net/get/igbinary-2.0.1.tgz
tar zxf igbinary-2.0.1.tgz

cd /tmp/igbinary-2.0.1
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config
make && make install


# install phpredis
cd /tmp

wget http://pecl.php.net/get/redis-2.2.7.tgz
tar zxf redis-2.2.7.tgz

cd /tmp/redis-2.2.7
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config
make && make install


# install zip
cd /tmp
wget https://pecl.php.net/get/zip-1.12.5.tgz
tar zxf zip-1.12.5.tgz

cd /tmp/zip-1.12.5
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config
make && make install
