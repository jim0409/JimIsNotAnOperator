# 利用SSH Tunnel做跳板
- `SSH`參數說明:
1. -N: 不執行任何指令
2. -f: 在背景執行
3. -L: 將local port轉向
4. -R: 將remote port轉向
5. -D: socks proxy

# 建立SSH tunnel(forward)
```bash
# syntax: ssh -L local_port:remote_address:remote_port user@server.ipv4

# 經過 ssh://localhost:2323 的連線，會藉由 serverB 作為跳板，再連到 ptt.cc:22
[user@serverA]$ ssh -NfL 2323:ptt.cc:22 user@serverB

# 連線
[user@serverA]$ ssh -p 2323 user@localhost
```

# 建立SSH tunnel(reverse proxy)
<!-- 注意，開啟反向tunnel之後，等於區網開了一個洞，外面的人可以連近來，可能會造成安全風險!需謹慎使用 -->
若配合`rdesktop`之類的程式使用，甚至可以在桌面環境遠端遙控
```bash
# syntax: ssh -R remote_port:local_address:local_port user@server.ipv4

# 經過 serverB:8888 的連線，都會 tunnel 到 serverA:1234
[user@serverA]$ ssh -NfR 8888:localhost:1234 user@serverB

# 連線
[user@serverB]$ ssh -p 8888 user@localhost

# 遠端桌面
[user@serverB]$ rdesktop localhost:8888
```

# 建立 SOCKS proxy server
```bash
# syntax: ssh -D port user@host
[user@serverA]$ ssh -NfD 2323 user@serverB

# 讓Chrome 透過 proxy 連線(須先關閉所有運行中的Chrome)

# Linux/Windows
# 將以下設定加入啟動 Chrome 的"目標"(右鍵 > 內容)後面
--proxy-server="socks5://localhost:2323"

# macOS
# 在terminal內使用指令方式開啟Chrome
opens -a "Google Chrome" --args --proxy-server="socks5://localhost:2323"

# 啟動以後，瀏覽的所有網頁都會透過這台 proxy server
```

# 列出使用中的 ssh tunnel
> ps aux|grep ssh


# refer:
- https://blog.rex-tsou.com/2017/10/利用-ssh-tunnel-做跳板aka.-翻牆/