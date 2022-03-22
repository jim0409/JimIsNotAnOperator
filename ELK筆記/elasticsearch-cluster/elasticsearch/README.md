# create three VM in NAT with ip ...
創造es cluster時，需要在定義一些參數。以下例子以三個master nodes為例

- host1: 10.140.0.216
- host2: 10.140.0.217
- host3: 10.140.0.218


```yaml (elasticsearch.yml)
...

# 服務發現
discovery.seed_hosts: 
- 10.140.0.216
- 10.140.0.217
- 10.140.0.218

cluster.initial_master_nodes: 
- Elasticsearch_M1
- Elasticsearch_M2
- Elasticsearch_M3

...
```
# modify elasticsarch systemd config
> vi /usr/lib/systemd/system/elasticsearch.service
```conf elasticsearch.service
...
[Service]
Type=notify
RuntimeDirectory=elasticsearch
PrivateTmp=true
Environment=ES_HOME=/usr/share/elasticsearch  <--- 要改
Environment=ES_PATH_CONF=/etc/elasticsearch   <--- 要改
Environment=PID_DIR=/var/run/elasticsearch    <--- 要改
Environment=ES_SD_NOTIFY=true
EnvironmentFile=-/etc/sysconfig/elasticsearch <--- 要改

WorkingDirectory=/usr/share/elasticsearch     <--- 要改

User=elasticsearch
Group=elasticsearch

ExecStart=/usr/share/elasticsearch/bin/systemd-entrypoint -p ${PID_DIR}/elasticsearch.pid --quiet
...
```

# refer:
### config es cluster
- https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-discovery-bootstrap-cluster.html

### introduction for elasticsearch and simple query syntax
- https://buildingvts.com/elasticsearch-architectural-overview-a35d3910e515

