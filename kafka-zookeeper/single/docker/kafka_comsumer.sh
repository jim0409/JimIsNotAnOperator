# add a comsumer for topic 'test'
docker exec -it container_kafka_1 ./opt/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test
