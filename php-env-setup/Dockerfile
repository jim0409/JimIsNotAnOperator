FROM centos:7

# install nginx, php & php-fpm
WORKDIR /tmp

RUN yum install -y epel-release
RUN yum install -y nginx

RUN yum -y install wget gcc gcc-c++ autoconf libjpeg-turbo-static libjpeg-turbo-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel pcre pcre-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel krb5-libs krb5-devel libidn libidn-devel openssl openssl-devel openldap openldap-devel nss-pam-ldapd openldap-clients openldap-servers bison lrzsz libmcrypt libmcrypt-devel mcrypt mhash ImageMagick ImageMagick-devel libmemcached libmemcached-devel
RUN wget http://cn2.php.net/distributions/php-5.6.37.tar.gz
RUN tar zxf php-5.6.37.tar.gz

WORKDIR /tmp/php-5.6.37

RUN ./configure --prefix=/usr/local/php \
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


RUN make && make install

# ENV PHP_PATH=/usr/local/php/bin
# ENV PHP_FPM=/usr/local/php/sbin
# ENV PATH=$PHP_FPM:$PHP_PATH:$PATH


# install mcrypt
WORKDIR /tmp/php-5.6.37/ext/mcrypt
RUN /usr/local/php/bin/phpize
RUN ./configure --with-php-config=/usr/local/php/bin/php-config
RUN make && make install

# install igbinary
WORKDIR /tmp

RUN wget https://pecl.php.net/get/igbinary-2.0.1.tgz
RUN tar zxf igbinary-2.0.1.tgz

WORKDIR /tmp/igbinary-2.0.1
RUN /usr/local/php/bin/phpize
RUN ./configure --with-php-config=/usr/local/php/bin/php-config
RUN make && make install

# install phpredis
WORKDIR /tmp
RUN  wget http://pecl.php.net/get/redis-2.2.7.tgz
RUN tar zxf redis-2.2.7.tgz

WORKDIR /tmp/redis-2.2.7
RUN /usr/local/php/bin/phpize
RUN ./configure --with-php-config=/usr/local/php/bin/php-config
RUN make && make install

# replace config files
RUN rm /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx/nginx.conf

COPY php.ini /usr/local/php/etc/php.ini
COPY php-fpm.conf /usr/local/php/etc/php-fpm.conf

# COPY php code
COPY php /usr/share/nginx/php

COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

# change path back to php
WORKDIR /usr/share/nginx/php

CMD ["/entrypoint.sh"]