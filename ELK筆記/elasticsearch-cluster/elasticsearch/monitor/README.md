# intro
記錄相關的監控紀錄

# top 監控整體資源
> top (-->1 & m)
觀察在壓測時，cpu以及記憶體的整體變化。

# iotop 監控是否有寫入瓶頸點
> iotop -p $es_pid
觀察再壓測時，是否有io瓶頸

# 影響因子
1. /etc/security/limits.conf
```conf limits.conf
...
* soft nofile 655360
* hard nofile 655360

# End of file
```
調整連線數限制，避免錯誤`too many open file`

2. ulimit -u
打開socket限制，避免壓測時受到影響

# refer:
### 使用ionice命令獲取、設置I/O調度類別和優先級
- https://blog.51cto.com/john88wang/1553812

### 避免Too many open files情況
- https://blog.longwin.com.tw/2011/05/nginx-worker-many-file-fix-2011/

