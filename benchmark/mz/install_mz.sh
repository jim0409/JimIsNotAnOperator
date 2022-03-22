# below, declare our environment was setup in centos7 environment

#!/bin/bash

# download websocat
# wget https://github.com/vi/websocat/releases/download/v1.7.0/websocat_amd64-linux-static

# donwload mz
# https://superuser.com/questions/590808/yum-install-gcc-g-doesnt-work-anymore-in-centos-6-4
yum install -y cmake libpcap-devel libnet-devel libcli-devel gcc-c++

git clone https://github.com/uweber/mausezahn

cd mausezahn

# ... TODO: fix it...
cmake .
make
make install


# refer:
# - https://blog.csdn.net/glovej/article/details/79631359