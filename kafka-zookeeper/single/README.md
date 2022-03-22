# 部署kafka & zookeeper
原先是使用docker-compose進行部署...

但是production通常都使用vm，所以還是需要具備能部署實體化kafka的能力，來解決一些container內部nat的問題

# refer:
- https://kafka.apache.org/documentation/#introduction