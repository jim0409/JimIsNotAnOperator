#!/bin/bash
## intro : install minikube on centos7
## refer: https://phoenixnap.com/kb/install-minikube-on-centos

# update and install epel-release
function pre-install {
	sudo yum update -y
	sudo yum -y install epel-release
}

function install-kvm {
	sudo yum -y install libvirt qemu-kvm virt-install virt-top libguestfs-tools bridge-utils
}

# start and enable the libvirtd service:
function start-libvirtd {
	sudo systemctl start libvirtd
	sudo systemctl enable libvirtd
}

function add-usr-to-libvirtd {
	sudo usermod -a -G libvirt $(whoami)
}
