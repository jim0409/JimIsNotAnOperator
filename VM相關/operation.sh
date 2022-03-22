#!/bin/bash

# pre-required
# 1. ready for vm template (or pre-installation script)
# 2. sent ssh-key into vm
# 3. define the demo used spec

function clone_vm {
	local VM_SOURCE=$1
	local VM_NAME=$2
	VBoxManage clonevm $VM_SOURCE --mode=machine --name $VM_NAME  --register
}

function modified_vm {
	local VM_NAME=$1
	local VM_CPU=$2
	local VM_MEM=$3
	VBoxManage modifyvm $VM_NAME --cpus $VM_CPU --memory $VM_MEM
}

function delete_vm {
	local VM_NAME=$1
	VBoxManage unregistervm $VM_NAME --delete
}

function start_vm {
	local VM_NAME=$1
	VBoxManage startvm $VM_NAME --type headless
}

function retrive_vm_ip {
	local VM_NAME=$1
	local MAC=`VBoxManage showvminfo $VM_NAME|grep MAC|awk '{print $4}'|tr -d ','`
	local key="${MAC:0:2}:${MAC:2:2}:${MAC:4:2}:${MAC:6:2}:${MAC:8:2}:${MAC:10:2}"
	local IP=`sudo nmap -sn -PE -n 192.168.1.0/24|grep -rn2 $key|head -1|awk '{print $6}'`
	vm_ip=$IP
}

function benchmark {
    local vm_name=$1
    local cpu=$2
    local mem=$3

	local vm_ip=""

	# clone vm
	clone_vm "template-vm" $vm_name
    # modified_vm
    modified_vm $vm_name $cpu $mem
	# start vm
	start_vm $vm_name
	# 
	# TODO : declare a buffer until `vm on` rewrite it with loop ... condition ...
	echo "wait for booting"
	sleep 20
	# retrive vm ip
	retrive_vm_ip $vm_name
	# benchmark vm, easy to replace with any benchmark cli, e.g. > ab -c10 -n10 http://$vm_ip/
	jmeter -n -t demo.jmx -Jurl=$vm_ip
	# shutdown vm
	ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@$vm_ip poweroff
	# TODO : declare a buffer until `vm off`, rewrite it with loop ... condition ...
	echo "wait for shutdown"
	sleep 10
	# delete vm
	delete_vm $vm_name
}

function main {
    benchmark "demo-vm" 1 2048 # > /tmp/vm1.report &
    # benchmark "demo-vm2" 1 4096 > /tmp/vm2.report
}

main