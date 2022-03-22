# intro
在centos7下安裝virtualbox

# steps
1. update
> sudo yum update

2. install vboxdrv kernel module
> sudo yum install –y patch gcc kernel-headers kernel-devel make perl wget

3. reboot
> sudo reboot

4. download virtualbox repository
> sudo wget https://download.virtualbox.org/virtualbox/6.1.16/VirtualBox-6.1-6.1.16_140961_el7-1.x86_64.rpm


# backlog:

need to fix ...

```
error: Failed dependencies:
	libSDL-1.2.so.0()(64bit) is needed by VirtualBox-6.1-6.1.16_140961_el7-1.x86_64
	libXt.so.6()(64bit) is needed by VirtualBox-6.1-6.1.16_140961_el7-1.x86_64
	libopus.so.0()(64bit) is needed by VirtualBox-6.1-6.1.16_140961_el7-1.x86_64
	libvpx.so.1()(64bit) is needed by VirtualBox-6.1-6.1.16_140961_el7-1.x86_64
```


# refer:
- 
