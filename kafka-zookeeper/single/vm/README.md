# pre require
### java
> yum update -y; yum install -y java-1.8.0-openjdk

# quick start
### workdri=$PWD

- download
> wget http://ftp.tc.edu.tw/pub/Apache/kafka/2.4.1/kafka_2.12-2.4.1.tgz; tar -xzf kafka_2.12-2.4.1.tgz; cd kafka_2.12-2.4.1

- start server
    - zookeeper
    > bin/zookeeper-server-start.sh config/zookeeper.properties

    - kafka
    > bin/kafka-server-start.sh config/server.properties

- replicate kafka config for multi-brokers
> cp config/server.properties config/server-1.properties 

# refer:
- https://kafka.apache.org/documentation/#gettingStarted
- https://oranwind.org/-big-data-apache-kafka-an-zhuang-jiao-xue/
- https://codertw.com/%E7%A8%8B%E5%BC%8F%E8%AA%9E%E8%A8%80/14062/