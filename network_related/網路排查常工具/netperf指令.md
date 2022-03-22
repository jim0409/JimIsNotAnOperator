# intro _ netperf (a network performance benchmark)

netperf 是一種網路性能的測量工具，主要針對基於`TCP`或`UDP`的傳輸

netperf 用於測試`批量數據傳輸(bulk data transfer)`模式和`請求/應答(request/response)`模式

具有四種工作模式: TCP_STREAM/ TCP_RR/ UDP_STREAM/ UDP_RR


# 基本參數
### 必填
- `-H (host)`: 指定遠端運行netserver的server IP地址
- `-l (testlen`: 指定測試的時間長度(秒)
- `-t (testname)`: 指定進行的測試類型(TCP_STREAM, UDP_STREAM, TCP_RR, TCP_CRR, UDP_RR)

### 選填
- `-s (size)`: 設置本地系統的socket發送與接收緩衝大小
- `-S (size)`: 設置遠端系統的socket發送與接受緩衝大小
- `-m (size)`: 設置本地系統發送測試分組的大小
- `-M (size)`: 設置遠端系統接受測試分組的大小
- `-D`: 對本地與遠端系統的socket設置TCP_NODELAY選項
- `-r (req, resp)`: 設置request和response分組的大小

# 實例
### 流動式通訊(Streaming)
##### 1. 測試TCP流式通訊時的網路帶寬
- TCP_STREAM
使用`-t TCP_STREAM`，測試netperf向Server發送批量的TCP數據分組，以確定數去傳輸過程中的吞吐量
> netperf -H 10.0.2.15 -t TCP_STREAM -l 10
```log (report)
root@ubuntu:/home/ubuntu# netperf -H 10.0.2.15 -t TCP_STREAM -l 10
MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 10.0.2.15 () port 0 AF_INET : demo
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

131072  16384  16384    10.01    5890.66
```
1. Recv Socket Size bytes: 遠端(Server)使用大小 131072 byte的socket接收緩衝
2. Send Socket Size bytes: 本地系統(Client)使用大小 16384 byte的socket發送緩衝
3. Send Message Size bytes: 向遠端系統發送的測試分組大小為16384 byte
4. Elapsed Time secs: 經歷測試的時間為 10.01 秒
5. Throughput: 測試結果表示`TCP`帶寬(吞吐量)為 5890.66 Mbits/秒


##### 2. 測試TCP流式通訊時的網路帶寬 _ 調整緩衝區分組的大小

通過修改可選填參數，可以驗證是否存在部分因素影響了連接的吞吐量

e.g. 如果懷疑路由器缺乏足夠的緩衝區空間，使得轉發大的分組時存在問題。

可以透過增加測試分組`(-m)`的大小，觀察吞吐量的變化
> netperf -H 10.0.2.15 -t TCP_STREAM -l 10 -- -m 2048
```log (report)
root@ubuntu:/home/ubuntu# netperf -H 10.0.2.15 -t TCP_STREAM -l 10 -- -m 2048
MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 10.0.2.15 () port 0 AF_INET : demo
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

131072  16384   2048    10.00     479.04
```

可以觀察到吞吐量有明顯的變化，可以說明緩衝區的大小確實會影響到帶寬大小。反之，如果沒有很大的變化，就代表緩衝區不會影響整個網路帶寬的表現。


##### 3. 測試UDP流式通訊時的網路帶寬

UDP_STREAM用來測試進行UDP批量傳出時的網路性能

特別需要注意的是，此時測試分組的大小不得大於socket的發送與接收緩衝大小，否則netperf會報錯
```log (error report)
root@ubuntu:/home/ubuntu# netperf -t UDP_STREAM -H 10.0.2.15 -l 10 -- -m 100000000
MIGRATED UDP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 10.0.2.15 () port 0 AF_INET : demo
send_data: data send error: errno 90
netperf: send_omni: send_data failed: Message too long
```

可以透過調整`-m`參數來限定測試分組的大小，或者增加socket的發送/接收緩衝大小。

> netperf -t UDP_STREAM -H 10.0.2.15 -l 10 -- -m 1024
```log (report)
root@ubuntu:/home/ubuntu# netperf -t UDP_STREAM -H 10.0.2.15 -l 10 -- -m 1024
MIGRATED UDP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 10.0.2.15 () port 0 AF_INET : demo
Socket  Message  Elapsed      Messages
Size    Size     Time         Okay Errors   Throughput
bytes   bytes    secs            #      #   10^6bits/sec

212992    1024   10.00      492775      0     403.67
212992           10.00      492201            403.20
```
第一行，顯示的是本地系統的發送統計，這裡的吞吐量表示netperf向本地socket發送分組的能力。(但是，UDP是不可靠的傳輸協議，發送數量不一定等同接受數量)
第二行，顯示遠端(Server)接受的情況，由於測試環境是在內網沒嚴重的掉包現象，但真實網路的掉包狀況可能更加嚴重


### 請求/應答(request/response)網路流量的性能


在client/server的架構中 request/response 模式是現今最為常見的模式之一

每次應答皆為一次交易(transaction)，交易中client向server發出小的查詢分組，server接收到請求，經處理後返回對應的結果數據

###### 1. TCP_RR __ tcp keep alive

TCP_RR 模式在測試 TCP request 和 response 的交際過程，但是他們發生在同一個 TCP 連接中，

這種模式常常出現在數據庫應用中。數據庫的client程序與server程序建立一個 TCP 連接以後，

就在這個連接中傳送數據庫的多次交易過程。

可以透過`-r`參數來改變 request 和 response 分組的大小來進行測試

> netperf -t TCP_RR -H 10.0.2.15 -- -r 32,1024 / netperf -t TCP_RR -H 10.0.2.15 -- -r 10240,40960
```log (report)
root@ubuntu:/home/ubuntu# netperf -t TCP_RR -H 10.0.2.15 -- -r 32,1024
MIGRATED TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 10.0.2.15 () port 0 AF_INET : demo : first burst 0
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate
bytes  Bytes  bytes    bytes   secs.    per sec

16384  131072 32       1024    10.00    6537.30
16384  131072

root@ubuntu:/home/ubuntu# netperf -t TCP_RR -H 10.0.2.15 -- -r 10240,40960
MIGRATED TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 10.0.2.15 () port 0 AF_INET : demo : first burst 0
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate
bytes  Bytes  bytes    bytes   secs.    per sec

16384  131072 10240    40960   10.00    3854.15
16384  131072
```

從上述結果可以看到，增加 request/response分組的大小會導致交易率明顯的下降
(ps: 目前還未考慮到交易過程中的應用程序處理延遲，引此實際交易比率會更低)



###### 2. TCP_CRR __ tcp (HTTP)

與TCP_RR不同，TCP_CRR為每次交易建立一個新的TCP連接。最常用的協議為HTTP

每次HTTP交易是在一條單獨的TCP連接中進行。因此，需要不停地建立新的TCP連接，並且在交易結束後拆除TCP連接(交易率一定會受到很大的影響)

> netperf -t TCP_CRR -H 10.0.2.15
```log (report)
root@ubuntu:/home/ubuntu# netperf -t TCP_CRR -H 10.0.2.15
MIGRATED TCP Connect/Request/Response TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 10.0.2.15 () port 0 AF_INET : demo
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate
bytes  Bytes  bytes    bytes   secs.    per sec

16384  131072 1        1       10.00    2564.22
16384  131072
```

即便只有用 1 byte，也可以發現交易率明顯降低了


##### 3. UDP_RR

UDP_RR模式使用UDP分組進行 request/response的交易程序。由於UDP沒有TCP連接所帶來的負擔，所以相對交易率會比較高

> netperf -t UDP_RR -H 10.0.2.15
```log (report)
root@ubuntu:/home/ubuntu# netperf -t UDP_RR -H 10.0.2.15
MIGRATED UDP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 10.0.2.15 () port 0 AF_INET : demo : first burst 0
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate
bytes  Bytes  bytes    bytes   secs.    per sec

212992 212992 1        1       10.00    6732.07
212992 212992
```

notes: 這裡使用virtualbox的nat做測試，所以看起來交易率沒有差很多。實際網路狀況可能會影響更多。



# refer:
- https://www.twblogs.net/a/5b8dd8af2b71771883410481
- https://kknews.cc/zh-tw/code/mgbny6p.html

### netperf --help
```
➜  ~ netperf --help
netperf: illegal option -- -

Usage: netperf [global options] -- [test options]

Global options:
    -a send,recv      Set the local send,recv buffer alignment
    -A send,recv      Set the remote send,recv buffer alignment
    -B brandstr       Specify a string to be emitted with brief output
    -c [cpu_rate]     Report local CPU usage
    -C [cpu_rate]     Report remote CPU usage
    -d                Increase debugging output
    -D time,[units] * Display interim results at least every time interval
                      using units as the initial guess for units per second
                      A negative value for time will make heavy use of the
                      system's timestamping functionality
    -f G|M|K|g|m|k    Set the output units
    -F lfill[,rfill]* Pre-fill buffers with data from specified file
    -h                Display this text
    -H name|ip,fam *  Specify the target machine and/or local ip and family
    -i max,min        Specify the max and min number of iterations (15,1)
    -I lvl[,intvl]    Specify confidence level (95 or 99) (99)
                      and confidence interval in percentage (10)
    -j                Keep additional timing statistics
    -l testlen        Specify test duration (>0 secs) (<0 bytes|trans)
    -L name|ip,fam *  Specify the local ip|name and address family
    -o send,recv      Set the local send,recv buffer offsets
    -O send,recv      Set the remote send,recv buffer offset
    -n numcpu         Set the number of processors for CPU util
    -N                Establish no control connection, do 'send' side only
    -p port,lport*    Specify netserver port number and/or local port
    -P 0|1            Don't/Do display test headers
    -r                Allow confidence to be hit on result only
    -s seconds        Wait seconds between test setup and test start
    -S                Set SO_KEEPALIVE on the data connection
    -t testname       Specify test to perform
    -T lcpu,rcpu      Request netperf/netserver be bound to local/remote cpu
    -v verbosity      Specify the verbosity level
    -W send,recv      Set the number of send,recv buffers
    -v level          Set the verbosity level (default 1, min 0)
    -V                Display the netperf version and exit
    -y local,remote   Set the socket priority
    -Y local,remote   Set the IP_TOS. Use hexadecimal.
    -Z passphrase     Set and pass to netserver a passphrase

For those options taking two parms, at least one must be specified;
specifying one value without a comma will set both parms to that
value, specifying a value with a leading comma will set just the second
parm, a value with a trailing comma will set just the first. To set
each parm to unique values, specify both and separate them with a
comma.

* For these options taking two parms, specifying one value with no comma
will only set the first parms and will leave the second at the default
value. To set the second value it must be preceded with a comma or be a
comma-separated pair. This is to retain previous netperf behaviour.
```