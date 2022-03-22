# zookeeper and kafka:動物園保管者對與卡夫卡
- kafka擔當生產者(producer)跟消費者(consumer)作為
- zookeeper是一個管控kafka topic的管理者
- kafka集群與zookeeper皆為有狀態的服務

# 使用docker-compose
- `docker-compose up -d`快速開啟一個kafka_zookeeper的集群
- 使用`sh kafka_producer.sh`執行kafka container裡面的kafka來對topic:`test`製造一些log
- 使用`sh kafka_consumer.sh`執行kafka container裡面的kafka來對topic:`test`收取一些log

# refer:
- https://github.com/wurstmeister/kafka-docker
- https://kafka.apache.org/documentation/


# extend-refer: 使用 jmap 驗證 kafka 是否有記憶體洩漏的問題
- https://stackoverflow.com/questions/25715067/jmap-command-not-found
- https://stackoverflow.com/questions/1751130/calling-jmx-mbean-method-from-a-shell-script
