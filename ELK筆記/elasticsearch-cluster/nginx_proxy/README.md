# nginx would be the proxy for es-master cluster
### nginx.conf
```nginx.conf
http {
	...
	access_log  syslog:server=unix:/dev/log  main;
	error_log  syslog:server=unix:/dev/log
	...
}
```

### default.conf
```default.conf
server 10.140.0.216:9200 max_fails=3 fail_timeout=30s;
server 10.140.0.217:9200 max_fails=3 fail_timeout=30s;
server 10.140.0.218:9200 max_fails=3 fail_timeout=30s;
```

### avoid `too many open files` error
1. 調整系統最大連線數 /etc/security/limits.conf
```conf limits.conf
...
* soft nofile 655360
* hard nofile 655360

# End of file
```

2. 調整nginx.conf
```conf nginx.conf
worker_processes 2;
worker_rlimit_nofile 10240;
events{
	# worker_connections 10240;
}
```


# nginx check health mechanism
### Passive Health Checks
1. 在nginx內部，實現請求時，會透過(Round Robin)輪詢訪問可用服務
2. 獲取可用服務(tcp syn)後會嘗試建立連線
3. 若連線失敗，會將失敗數`fails`加1，並記錄檢查的時間`checked`
4. 如果獲取服務發現`fails >= max_fails`且`now - checked <= fail_timeout`，則認為該服務不可用
5. 如果不滿足上面條件，nginx會重新嘗試連線
6. 服務回復正常時重置`fails=0`


# refer
### nginx-passive check health:
- https://docs.nginx.com/nginx/admin-guide/load-balancer/http-health-check/#passive-health-checks

### explanation for passive check health
- http://lotabout.me/2019/QQA-How-does-nginx-health-check-work/

### nginx log to journald
- https://stackoverflow.com/questions/28394084/nginx-log-to-stderr


### some issue between journald input in Filebeat
- https://github.com/elastic/beats/issues/7955

### replace nginx connection with nofile limits
- https://blog.longwin.com.tw/2011/05/nginx-worker-many-file-fix-2011/
