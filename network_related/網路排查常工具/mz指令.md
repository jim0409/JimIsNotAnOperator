# MZ _ Mausezahn

mz 是一個以 C 語言開發的快速產生流量的工具，可以透過這個工具來

1. 產生流量(比如高家的多點傳送網路)
2. 防火牆和IDS的穿透測試
3. 網路中的DoS攻擊
4. 用大量的ping和端口掃描搜索攻擊
5. 測試網路行為在奇怪的環境下(如壓力測試、畸形包)

# 參數

mz 網卡 -A(-a) 包的來源  -B(-b) 包的送往目的地 -t 包的協議類型 "(可以參照 mz -t 協議 help來輸入)" ... 各種參數

e.g. 送一個來源 10.0.2.4 的 tcp (data "test context") 封包給 10.0.2.15
> mz enp0s3 -A 10.0.2.4 -B 10.0.2.15 -t tcp "dp=5001, sp=1" -P "test context"
 
- *`-t (packet_type)`: 指令包(packet)的類型 (IP, UDP, TCP, ARP, BPDU, CDP, 部分的ICMP, RTP, DNS 和 SYSLOG)
- `-a (Src_MAC|keyword)`: 指定的源mac，預設為參照網卡的mac
- `-A (Src_IP)`: 指定的源IP，預設為參照網卡的IP
- *`-b (Dst_MAC|keyword)`: 目的地mac
- *`-B (Dst_IP)`: 目的地IP
- `-p (length)`: 指定未加工的幀指定長度(隨機字節數)
- `-P (ASCII Payload)`: 指定ASCII字符有效載荷
- `-r (delay rand time)`: 指定deplay的時間為隨機值
- `-f (filename)`: 從文件中讀取ASCII的有效載荷 
- `-F (filename)`: 從文件中讀取16進位數字的有效載荷
- `-S (Simulation)`: 模擬模式，東訊中不放任何數據。通常與`-v(verbose)`併用

# 自產包種類

透過`ip`這個協議，丟向指定的mac位置
> mz enp0s3 -t ip p=08:00:27:bb:a1:c7 -P "Hello World"
```log (report)
root@ubuntu:/home/ubuntu# tcpdump -i any host 10.0.2.15 -vvnnA
tcpdump: listening on any, link-type LINUX_SLL (Linux cooked), capture size 262144 bytes
21:24:25.241290 IP (tos 0x0, ttl 255, id 10616, offset 0, flags [none], proto Options (0), length 31)
    10.0.2.15 > 255.255.255.255:  ip-proto-0 11
E...)x.....X
.......Hello World...............
```

##### UDP
> mz enp0s3  -B 10.0.2.15 -t udp "dp=5001, sp=1" -P "Mausezahn is great"

##### TCP
> mz enp0s3 -B 10.0.2.15 -t tcp "dp=600, sp=1" -P "Mausezahn is great"


##### benchmark _ 

因為 mz 預設為只送一個封包，如果要做壓力或效能測試，需要調整參數`-c`來增加封包數(notes: `-c 0`表示封包會持續發送)

另外，可以透過`-A rand`來達到偽裝源IP

- `-c(count)`: 增加輸送的封包

> mz -c 10 -A rand -B 10.0.2.4 -T icmp "ping" -v

```log (report)
root@ubuntu:/home/ubuntu# mz -c 10 -A rand -B 10.0.2.4 -T icmp "ping" -v

Mausezahn 0.40 - (C) 2007-2010 by Herbert Haas - http://www.perihel.at/sec/mz/
Use at your own risk and responsibility!
-- Verbose mode --

 mz: device enp0s3 got assigned 10.0.2.15 and is a possible candidate.
 mz: device lo got assigned 127.0.0.1 (loopback)
 mz: device not given, will use enp0s3
 This system supports a high resolution clock.
  The clock resolution is 1 nanoseconds.
Mausezahn will send 10 frames...
 IP:  ver=4, len=28, tos=0, id=0, frag=0, ttl=255, proto=1, sum=0, SA=195.133.31.0, DA=10.0.2.4,
      payload=[see next layer]
 ICMP Echo Request (id=66 seq=1)


 IP:  ver=4, len=28, tos=0, id=0, frag=0, ttl=255, proto=1, sum=0, SA=191.224.244.0, DA=10.0.2.4,
      payload=[see next layer]
 ICMP Echo Request (id=66 seq=1)


 IP:  ver=4, len=28, tos=0, id=0, frag=0, ttl=255, proto=1, sum=0, SA=202.152.235.0, DA=10.0.2.4,
      payload=[see next layer]
 ICMP Echo Request (id=66 seq=1)

 ...
```


# refer:
### installation _ centos
- https://www.twblogs.net/a/5b88afa92b71775d1cddcd6f?lang=zh-cn
```shell
git clone https://github.com/uweber/mausezahn.git
yum install -y cmake libpcap-devel libnet-devel libcli-devel gcc-g++
cd mausezahn; cmake . && make && make install
```

# docker run mz ~
> docker run -it --rm  gophernet/mz -h