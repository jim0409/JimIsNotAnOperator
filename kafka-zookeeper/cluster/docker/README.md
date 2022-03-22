# intro

start `kafka-cluster` via `docker-compose`

# step
1. Dockerfile for single node kafka
2. modify `/etc/hosts` to resolve kafka1、kafka2 and kafka3
```add an extra record in your /etc/hosts
127.0.0.1 kafka1 kafka2 kafka3
```
3. execute kafka consumer and producer for testing

# test for producer
# copy file from mine jimweng repo ... thirdparty/sarama_kafka/...
# for producer
> go run producer.go 127.0.0.1:9092 test

# for consumer
> go run consumer.go 127.0.0.1:9093 test test
