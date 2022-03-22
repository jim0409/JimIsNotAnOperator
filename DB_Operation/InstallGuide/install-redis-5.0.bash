#!/bin/bash

#######################################
swap=$(cat /etc/sysctl.conf | grep vm.overcommit_memory)
if [ -z "${swap}" ]; then
    echo "vm.overcommit_memory = 1" >>/etc/sysctl.conf
    sysctl -p >/dev/null
else
    sed -i "/vm.overcommit_memory/d" /etc/sysctl.conf
    echo "vm.overcommit_memory = 1" >>/etc/sysctl.conf
    sysctl -p >/dev/null
fi

echo "never" >/sys/kernel/mm/transparent_hugepage/enabled

#######################################

yum install -y -q -e 0 epel-release
yum install -y -q -e 0 https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install -y -q -e 0 https://repo.ius.io/ius-release-el7.rpm
yum install -y -q -e 0 redis5

#######################################
rm -f /usr/lib/systemd/system/redis.service
systemctl daemon-reload
# systemctl start redis_${dbPort}.service
# systemctl enable redis_${dbPort}.service


