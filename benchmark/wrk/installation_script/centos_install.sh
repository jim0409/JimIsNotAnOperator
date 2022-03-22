#!/bin/bash

# centos
sudo yum groupinstall -y 'Development Tools'
sudo yum install -y openssl-devel git 
git clone https://github.com/wg/wrk.git wrk
cd wrk
make
# move the executable to somewhere in your PATH
sudo cp wrk /usr/bin/
