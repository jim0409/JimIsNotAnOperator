# 摘要

紀錄如何架設elasticsearch(7.9) cluster

# 角色介紹
1. master node: 主要用於元數據(metadata)的處理，比如索引的新增、刪除、分片分配
2. data node: 節點上保存了數據分片。負責數據相關操作。比如分片的CRUD，以及搜索和整合操作。(比較消耗CPU、內存和I/O資源)
3. client node: 節點道路由請求的作用，實際上可以看作附載均衡器


# 配備限制
1. centos7
2. 2c8g
3. 開防火牆9200/9300

# 配置
- master:
[master node1 config yaml](./elasticsearch_master1.yml)
[master node2 config yaml](./elasticsearch_master2.yml)

- slave: 
[data node1 config yaml](./elasticsearch_node1.yml)
[data node2 config yaml](./elasticsearch_node2.yml)

# 檢查
> curl 'http://127.0.0.1:9200/_cat/health?v'
```log

```


# [進階] 配置解釋
1. cluster.name : 叢集名稱，同一叢集的節點配置需一致。
2. node.name : 節點名稱
	path.data : 
	path.logs : 


3. discovery.seed_hosts: 服務註冊處，提供給data-node以及master-node註冊服務處
4. cluster.initial_master_nodes: 叢集下的master節點初始化註冊處




# refer:
### download elasticsearch
- https://www.elastic.co/downloads/elasticsearch

### data-node-trouble-shooting (data node 一開始為master，後來改寫設定檔有問題)
- https://my.oschina.net/yyqz/blog/3102035/print
> rm -rf /var/lib/elasticsearch/node
