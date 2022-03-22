# intro _ iperf

`iperf`是一個網路性能測試工具。iperf可以測試最大TCP和UDP帶寬性能，具有多種參數和UDP特性

可以根據需要調整，可以報告帶寬、延遲抖動和數據包丟失

# iperf 
### client端 與 server端 共用選項

- `-u(-udp)`: 使用UDP方式而不是TCP方式
- `-p(-port)`: 設置端口，與服務器端的監聽端口一致，默認是使用5001端口
- `-l(-len)`: 設置讀寫緩衝區的長度。TCP方式默認為8KB，UDP方式默認為1470字節
- `-w(-window)`: 設置套接字緩衝區為指定大小。
    - 對於TCP方式，此設置為TCP窗口大小。
    - 對於UDP方式，此設置為接受UDP數據包的緩衝區大小，限制可以接受數據包的最大值
- `-m(-print_miss)`: 輸出TCP MSS值(通過TCP_MAXSEG支持)。MSS值一般比MTU值小40字節


### Server端 專用選項

- `-s(-server)`: 啟用Iperf服務器模式
- `-c(-client host)`: 如果Iperf運行在服務器模式，並且使用-c參數指定一個主機，那麼Iperf將只接受指定主機的連接。(註: 此參數不能工作於UDP模式)
- `-P(-parallel)`: 服務器關閉之前保持的連線數。默認是0，表示永遠接受連接


### Client端 專用選項

- `-c(-client host)`: 運行Iperf的客戶端模式，連接到指定的Iperf服務器端
- `-b(-bandwidth)`: UDP模式使用的帶寬，必須配合`-u`參數，默認值是 1 Mbit/sec
- `-d(-dualtest)`: 運行雙測模式。這將使服務器端反向連接到客戶端，使用`-L`參數中指定的端口(或默認使用客戶端連接到服務器的端口)
    。這些在操作的同時就立即完成。如果需要一個交互的測試，可以使用`-r`參數
- `-r(-tradeoff)`: 交互測試模式。當客戶端到服務器端的測試結束時，服務器端通過`-l`選指定的端口(或默認為客戶端連接到服務器端的端口)
    ，反向連接至客戶端。當客戶端連接終止時，反向連接隨即開始。如果需要
- `-L(-listenport)`: 將指定服務端反向連接到客戶端時使用的端口。默認使用客戶端連接至服務端的端口
- `-t(-time)`: 設置傳輸的總時間。Iperf在指定的時間內，重複的發送指定長度的數據包。(默認是10秒鐘)
- `-P(-parallel)`: 線程數。指定客戶端與服務端之間使用的線程數。默認是 1 線程。需要客戶端與服務器端徒繩使用此參數


### 實例

帶寬測試通常採用`UDP模式`，因為能測試出`極限帶寬`、`延遲抖動`及`丟包率`。

再進行測試時，首先以`鏈路理論帶寬`作為數據發送速率進行測試，

```
e.g. 從客戶端到服務器之間的鏈路的理論帶寬為 100Mbps，先用`-b 100M`進行測試，然後根據測試結果
     (包含實際帶寬，延遲抖動和丟包率)，再以實際帶寬做為數據發送速率進行測試，會發現延遲抖動和丟包率比第一次好很多
    ，重複測試幾次，就能得出穩定的實際帶寬。
```

### UDP 模式

Server端
> iperf -u -s


Client端
- 在udp模式下，以100Mbps為數據發送速率，客戶端到服務器端(10.0.2.15)上傳帶寬測試，測試時間為10s
> iperf -u -c 10.0.2.15 -b 100M -t 10

```log (report)
root@ubuntu:/home/ubuntu# iperf -u -c 10.0.2.15 -b 100M -t 10
------------------------------------------------------------
Client connecting to 10.0.2.15, UDP port 5001
Sending 1470 byte datagrams, IPG target: 112.15 us (kalman adjust)
UDP buffer size:  208 KByte (default)
------------------------------------------------------------
[  3] local 10.0.2.4 port 56897 connected with 10.0.2.15 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec   125 MBytes   105 Mbits/sec
[  3] Sent 89165 datagrams
[  3] Server Report:
[  3]  0.0-10.0 sec   125 MBytes   105 Mbits/sec   0.000 ms   27/89165 (0%)
```


- 客戶端以5Mbps為數據發送速率，同時向服務器端發起30個連接線程
> iperf -u -c 10.0.2.15 -b 5M -P 30 -t 60


- 客戶端以100M為數據發送速率，進行上下行帶寬測試`-L`參數指定本端`雙測`監聽的端口(30000)
> iperf -u -c 10.0.2.15 -b 100M -d -t 10 -L 30000


```log (report)
root@ubuntu:/home/ubuntu# iperf -u -c 10.0.2.15 -b 100M -d -t 10 -L 30000
------------------------------------------------------------
Client connecting to 10.0.2.15, UDP port 5001
Sending 1470 byte datagrams, IPG target: 112.15 us (kalman adjust)
UDP buffer size:  208 KByte (default)
------------------------------------------------------------
------------------------------------------------------------
Server listening on UDP port 30000
Receiving 1470 byte datagrams
UDP buffer size:  208 KByte (default)
------------------------------------------------------------
[  3] local 10.0.2.4 port 53395 connected with 10.0.2.15 port 5001 (peer 2.0.10-alpha)
[  4] local 10.0.2.4 port 30000 connected with 10.0.2.15 port 33833
[ ID] Interval       Transfer     Bandwidth        Jitter   Lost/Total Datagrams
[  4]  0.0-10.0 sec   125 MBytes   105 Mbits/sec   0.019 ms    0/89165 (0%)
[  3]  0.0-10.0 sec   125 MBytes   105 Mbits/sec
[  3] Sent 89163 datagrams
[  3] Server Report:
[  3]  0.0-10.0 sec   125 MBytes   105 Mbits/sec   0.000 ms    0/89163 (0%)
[  3] 0.00-10.00 sec  1 datagrams received out-of-order
```


### TCP 模式

Server端
> iperf -s

Client端
- 在tcp模式下，客戶端到服務器10.0.2.15上傳帶寬測試，測試時間為10s
> iperf -c 10.0.2.15 -t 10

```log (report)
root@ubuntu:/home/ubuntu# iperf -c 10.0.2.15 -t 10
------------------------------------------------------------
Client connecting to 10.0.2.15, TCP port 5001
TCP window size: 85.0 KByte (default)
------------------------------------------------------------
[  3] local 10.0.2.4 port 43864 connected with 10.0.2.15 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec  6.37 GBytes  5.47 Gbits/sec
```


- 進行上下帶寬測試
> iperf -c 10.0.2.15 -d -t 10

```log (report)
root@ubuntu:/home/ubuntu# iperf -c 10.0.2.15 -d -t 10
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size:  128 KByte (default)
------------------------------------------------------------
------------------------------------------------------------
Client connecting to 10.0.2.15, TCP port 5001
TCP window size: 1.56 MByte (default)
------------------------------------------------------------
[  3] local 10.0.2.4 port 43866 connected with 10.0.2.15 port 5001
[  5] local 10.0.2.4 port 5001 connected with 10.0.2.15 port 48450
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec  5.27 GBytes  4.53 Gbits/sec
Segmentation fault (core dumped)
```


- 測試單線程tcp (-i: 設置帶寬報告的時間間隔(s), -t: 測試時長(s), -w: 設置tcp窗口大小，一般可以不用設置，默認即可)
    - server端:
        > iperf -s -p 12345 -i 1 -t 10 -m -y
    - client端:
        > iperf -c 10.0.2.15 -p 12345 -i 1 -t 10 -w 20K

```log (report)
root@ubuntu:/home/ubuntu# iperf -c 10.0.2.15 -p 12345 -i 1 -t 10 -w 20K
------------------------------------------------------------
Client connecting to 10.0.2.15, TCP port 12345
TCP window size: 40.0 KByte (WARNING: requested 20.0 KByte)
------------------------------------------------------------
[  3] local 10.0.2.4 port 51484 connected with 10.0.2.15 port 12345
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0- 1.0 sec   278 MBytes  2.33 Gbits/sec
[  3]  1.0- 2.0 sec   278 MBytes  2.33 Gbits/sec
[  3]  2.0- 3.0 sec   278 MBytes  2.34 Gbits/sec
[  3]  3.0- 4.0 sec   279 MBytes  2.34 Gbits/sec
[  3]  4.0- 5.0 sec   278 MBytes  2.33 Gbits/sec
[  3]  5.0- 6.0 sec   278 MBytes  2.33 Gbits/sec
[  3]  6.0- 7.0 sec   278 MBytes  2.33 Gbits/sec
[  3]  7.0- 8.0 sec   278 MBytes  2.34 Gbits/sec
[  3]  8.0- 9.0 sec   278 MBytes  2.34 Gbits/sec
[  3]  9.0-10.0 sec   277 MBytes  2.32 Gbits/sec
[  3]  0.0-10.0 sec  2.72 GBytes  2.33 Gbits/sec
```


- 測試多線程tcp
    - server端:
        > iperf -s -P 5 -p 23456
    - client端:
        > iperf -c 10.0.2.15 -p 23456 -P 5 -t 10

``` log (report)
root@ubuntu:/home/ubuntu# iperf -c 10.0.2.15 -p 23456 -P 5 -t 10
------------------------------------------------------------
Client connecting to 10.0.2.15, TCP port 23456
TCP window size: 85.0 KByte (default)
------------------------------------------------------------
[  3] local 10.0.2.4 port 35736 connected with 10.0.2.15 port 23456
[  4] local 10.0.2.4 port 35738 connected with 10.0.2.15 port 23456
[  5] local 10.0.2.4 port 35740 connected with 10.0.2.15 port 23456
[  6] local 10.0.2.4 port 35742 connected with 10.0.2.15 port 23456
[  7] local 10.0.2.4 port 35744 connected with 10.0.2.15 port 23456
[ ID] Interval       Transfer     Bandwidth
[  5]  0.0-10.0 sec  1.17 GBytes  1.01 Gbits/sec
[  3]  0.0-10.0 sec  1.12 GBytes   963 Mbits/sec
[  7]  0.0-10.0 sec  1.17 GBytes  1.00 Gbits/sec
[  4]  0.0-10.0 sec  1.19 GBytes  1.02 Gbits/sec
[  6]  0.0-10.0 sec  1.17 GBytes  1.00 Gbits/sec
[SUM]  0.0-10.0 sec  5.81 GBytes  4.98 Gbits/sec
```

### 備註:

發完包後，可以通過`ifconfig ethX`和`ethtool -S ethX`查看對應收發包情況，確定發包數、包長及是否丟包等。