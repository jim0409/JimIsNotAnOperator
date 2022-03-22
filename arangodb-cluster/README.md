# 事前準備
1. 增加一個`arangodb`使用者
> adduser arangodb;passwd arangodb

2. 關閉訪火牆
> iptables -F

# 逐步執行指令
在此以內網ip: 192.168.51.188 為例
(備註: 因為arangodb執行時會以，這邊要使用`arangodb`使用者來操作，避免檔案無法覆蓋...)
> su arangodb

```shell
# 啟動agent
nohup sh agency1.sh &> agent1.log &
nohup sh agency2.sh &> agent2.log &
nohup sh agency3.sh &> agent3.log &

# 啟動coordinator
nohup sh coordinator1.sh &> cor1.log &
nohup sh coordinator2.sh &> cor2.log &
nohup sh coordinator3.sh &> cor3.log &

# 啟動
nohup sh db_server1.sh &> db1.log &
nohup sh db_server2.sh &> db2.log &
nohup sh db_server3.sh &> db3.log &
```

# 關閉所有的 arangodb 相關服務
> ps -ae f|grep arango|awk '{print $1}'|xargs kill -9


# 將 arangodb 裡面的服務備份下來
arangodb backup(dump)
> arangodump --output-directory "./dump" --overwrite true --server.database "Database"


# 將前面備份的 arangodb 資料還原到指定服務器(coordinator; 127.0.0.1:8529)上
arangodb restore (server.endpoint 指定固定的 server ip)
> arangorestore --server.endpoint http+tcp://127.0.0.1:8529 --server.database "Database" --input-directory dump


# error_handling
> FATAL unable to create database directory 'start': Failed to create directory [start] Permission denied

- https://github.com/arangodb/arangodb/issues/2473

# refer:
- https://www.arangodb.com/docs/stable/deployment-cluster-manual-start.html


# note with specific `Valid IP`
Note in particular that the endpoint descriptions given under 

`--cluster.my-address and --cluster.agency-endpoint must not use the IP address 0.0.0.0` 

because they must contain an actual address that can be routed to the corresponding server.

The `0.0.0.0` in --server.endpoint simply means that the server binds itself to all available network devices with all available IP addresses.
