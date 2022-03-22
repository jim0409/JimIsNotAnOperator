#!/bin/bash

# close linux security
function setSelinux() {
    # close SeLinux
    setenforce 0
    sed -i "s/=enforcing/=disabled/g" /etc/selinux/config
}

function setSwap() {
    #  swap: vm.swappiness = 1
    swap=`cat /etc/sysctl.conf | grep vm.swappiness`
    if [ -z "${swap}" ];then
        echo "vm.swappiness = 1" >> /etc/sysctl.conf
        sysctl -p > /dev/null
    else
        sed -i "/vm.swappiness/d" /etc/sysctl.conf
        echo "vm.swappiness = 1" >> /etc/sysctl.conf
        sysctl -p > /dev/null
    fi
}

function setTool() {
    yum install -y lrzsz tree wget policycoreutils-python net-tools bash-completion vim htop iotop sysstat screen zip unzip jq
}



setSelinux
setSwap
setTool

