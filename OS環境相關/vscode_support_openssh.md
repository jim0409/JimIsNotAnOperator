# intro
使用vscode連線到遠端VM進行編輯

1. 安裝vscode插件`OpenSSH`
2. 編輯預設的.sshconfig: `vi .ssh/config`
```
Host ubuntu-vm
  Hostname 127.0.0.1
  User ubuntu
  Port 1111
```
3. 點選vscode左邊的icon連線。會自動打開

# 推薦
mac安裝virtualbox，連線到virtualbox內部的ubuntu或centos作業

# refer:
- https://www.footmark.info/software/editor/vscode-remote-ssh-linux-folder/

# refer_連接到virtualbox_vm:
> in short: 把ssh port轉發到其他port e.g. 1111
```
Network -> Adapter 1(by default have attached to as NAT) -> Advanced -> Port Forwarding Add a new entry (click on + to add)
with Host Port: 1111, Guest Port: 22, and leave host IP and guest IP blank
```
- https://unix.stackexchange.com/questions/231138/ssh-into-virtualbox-on-mac

```
or ...
更改 network[adapter] -> Attached to `Bridged Adapter`
```