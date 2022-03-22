#!/bin/bash

# https://mkyong.com/nginx/nginx-modsecurity-and-owasp-crs/

# Prerequisite Packages 
apt update

apt install -y apt-utils autoconf automake build-essential git \
			libcurl4-openssl-dev libgeoip-dev liblmdb-dev libpcre++-dev \
			libtool libxml2-dev libyajl-dev pkgconf wget zlib1g-dev

apt update

# Download and Compile ModSecurity 3.0