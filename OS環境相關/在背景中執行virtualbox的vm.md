# intro
假設有一台vm名稱叫做ubuntu

- 使用virtualbox的內建指令，直接運行vm
> VBoxManage startvm ubuntu --type headless

- 使用virtualbox的內建指令獲取正在運行中的vm
> VBoxManage list runningvms

- 使用virtualbox的內建指令獲取正在運行中的vm資訊
> VBoxManage showvminfo ubuntu

<!-- - 使用virtualbox的內建指令獲取該vm的ip
> VBoxManage guestproperty enumerate ubuntu -->

- 使用virtualbox的內建指令關閉正在運行中的vm
> VBoxManage controlvm ubuntu poweroff


# refer:
- https://superuser.com/questions/135498/run-virtualbox-in-background-without-a-window
- https://serverfault.com/questions/128685/how-can-i-get-the-bridged-ip-address-of-a-virtualbox-vm-running-in-headless-mode


# extend-refer:
在mac上安裝virtualbox
> `brew cask install virtualbox`

# 使用virtualbox: nat-network
- https://ephrain.net/virtualbox-%E7%94%A8-nat-network-%E8%AE%93%E5%A4%9A%E5%80%8B-vm-%E5%8F%AF%E4%BA%92%E9%80%A3%EF%BC%8C%E4%B9%9F%E5%8F%AF%E9%80%A3%E8%87%B3-internet/

# 更換virtualbox複製出來的vm的ip
- case 1. (在clone的時候點選 `generate new mac for all network adpater` ... 目前官方有bug... 即便clone出來mac不同仍舊會吃到同一個ip)
- case 2. (在clone的時候點選 `Include mac address ...` ... 必須要手動修改mac address以及重新去dhcp換ip)
### 因為IP是`MAC`地址透過`arp`協議去獲取的，所以首要任務為更換mac address
1. vm - settings
2. network -> advance -> renew mac address
3. start vm
4. sudo ip address flush scope global dynamic
5. sudo dhclient -v

... 目前只有手動下指令讓dhcp去改 ... 實屬麻煩 ... 那樣倒不如直接重裝一個VM?
(或者放棄使用本機的local-network改用bridge?)

### 官方文件
- https://pubs.vmware.com/workstation-11/index.jsp?topic=%2Fcom.vmware.ws.using.doc%2FGUID-5C55C285-79B0-404F-95A5-87F64C41E3DC.html

### 修改圖示
- https://superuser.com/questions/655670/two-virtualbox-vms-running-in-parallel-assigned-same-ip

### 在ubuntu-18.04讓dhcp做重新取ip的動作
- https://forums.virtualbox.org/viewtopic.php?f=6&t=91687#p466910

### configure network devices with virtualbox after cloning/copying for RAC setup
- https://www.hhutzler.de/blog/configure_network_devices/

### ubuntu & centos 在網卡設定不同路徑... (網路一堆教學錯誤文件...拿centos當作預設路徑都不講清楚os的...)
> ubuntu: /etc/network/interface
http://guguclock.blogspot.com/2012/12/centos-ubuntu.html

### 重新初始化dhcp-server
- https://unix.stackexchange.com/a/405584