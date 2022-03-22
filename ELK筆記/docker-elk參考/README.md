# intro

fix version of elk with all 7.2.1 version

use `docker-compose up -d ` to have a quick start and 

cli ... `curl -XPOST http://127.0.0.1:4151/pub?topic=TopicName -d '{"msgkey": "msgValue"}'`

to send msg to nsq (message queue)

to check whether data flow into elastisearch

# quick start
1. docker-compose up -d
2. curl -XPOST http://127.0.0.1:4151/pub?topic=TopicName -d '{"msgkey": "msgValue"}'
3. curl localhsot:9200/


# refer:
- https://blog.csdn.net/lvyuan1234/article/details/78653324
- https://www.elastic.co/guide/en/logstash/current/plugins-inputs-kafka.html
- https://ops-coffee.cn/s/zLsLSqRrloM-8sFWNWcksg.html


# fucking import one!! with container kafka to logstash
- https://rmoff.net/2018/08/02/kafka-listeners-explained/