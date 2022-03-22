# intro
記錄一些常見的 nginx 設定檔，以及記錄一些使用(方法)場景

# nginx cfg archi
1. worker_processes 8;
> nginx 的進程數(worker數)

2. worker_cpu_affinity auto;(or 00000001 00000010 ...)
> 指派nginx worker位於指定cpu上

3. worker_rlimit_nofile 102400;
> 指定nginx的每一個worker打開最多文件描述符數目,`(ulimit -n)/$workers`

4. use epool;
> 使用linux kernal epool

5. keepalive_timeout 60;
> keepalive 超時時間 ... (*What condition should use?)

6. client_header_buffer_size 4k;
> client端請求header的緩衝區大小 ... (*What condition should use?)

7. open_file_cache make=102400 inactive=20s;
> 將打開文件指定緩存，默認不啟用。max為指定緩存數量，inactive指多久沒請求後刪除緩存

8. open_file_cache_valid 30s;
> 多長時間檢查一次緩存的有效信息

9. open_file_cache_min_uses 1;
> open_file_cache指令中的inactive參數時間內文件的最少使用次數

10. net.ipv4.tcp_max_tw_buckets = 6000;
> timewait 的數量，默認是 180000

11. net.ipv4.ip_local_port_range = 1024 65000;
> 允許系統打開的端口範圍

12. net.ipv4.tcp_tw_recycle = 1;
> 啟用timewait快速回收 ... (*Adv/disAdv)

13. net.ipv4.tcp_tw_reuse = 1;
> 開啟重用。允許將TIME-WAI sockets重新用於新的TCP連接 ... (*反向代理後面可以復用連線)

14. net.ipv4.tcp_syncookies = 1;
> 開啟SYN Cookies，當出現SYN等待隊列溢出時，啟用cookies來處理

15. net.core.somaxconn = 262144;
> (web應用中listen函數的backlog)默認為128，nginx(NGX_LISTEN_BACKLOG)默認為511 ... (*What is backlog)

16. net.core.netdev_max_backlog = 262144;
> 每個網路接口接收數據包的速率比內核處理這些包的速率快時，允許送到隊列的數據包的最大數目

17. net.ipv4.tcp_max_orphans = 262144;
> 系統中最多有多少個TCP套接字，不被關聯到任何一個用戶文件上。如果超過這個數字，孤兒連接將即刻被復用並打印出警告信息。這個限制僅僅是為了防止簡單的DoS攻擊；增加預設值，也會增加內存消耗

18. net.ipv4.tcp_max_syn_backlog = 262144;
> 紀錄哪些尚未收到客戶端確認信息的連接請求的最大值；對於128M內存的系統而言，缺省值是1024。

19. net.ipv4.tcp_timestamps = 0;
> 時間戳，可以避免序列號的捲繞

20. net.ipv4.tcp_synack_retries = 1;
> 三向握手中的第二次



# refer:
### 中文解說
- https://reurl.cc/Z7O7pa

### github 資源
- https://gist.github.com/jim0409/8ae83c46eede6d5590b052b88cbd9d07

### 
