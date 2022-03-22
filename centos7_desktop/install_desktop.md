# intro
在centos7上安裝桌面

# steps
1. 安裝`GNOME Desktop`以及`Graphical Administration Tools`
> yum groupinstall "GNOME Desktop" "Graphical Administration Tools" -y

2. 設定系統預設圖像顯示
> systemctl set-default graphical.target

3. 重新啟動
> reboot



# refer:
- https://xyz.cinc.biz/2015/11/centos7-install-gui.html
