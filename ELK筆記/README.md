# 記錄學習ELK的筆記

# DevTools常用的指定

1. 查詢index-pattern
GET _cat/indices
> refer :https://www.elastic.co/guide/en/kibana/current/tutorial-define-index.html
2. 

# 參考文章
1. https://github.com/deviantony/docker-elk

# 使用standalone的模式啟用elk系統來收集日誌
1. kibana

2. logstash

3. elastic-search

# 後記:
chown -R 1001 esdata
```
# docker-compose.yml
...yml
  elasticsearch:
    image: elasticsearch:7.6.2
    container_name: elasticsearch
    volumes:
      - ./elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml
      - /esdata:/usr/share/elasticsearch/data
    ports:
      - "9200:9200"
      - "9300:9300"
    environment:
      ES_JAVA_OPTS: "-Xmx256m -Xms256m"
      ELASTIC_PASSWORD: changeme
      discovery.type: single-node
...
```