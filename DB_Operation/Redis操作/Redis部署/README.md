# intro
### quick run customerize redis config
> docker run --rm --name myredis -v $PWD/7001:/usr/local/etc/ redis:5.0.3-alpine3.9 redis-server /usr/local/etc/redis.conf


### docker-compose up
> docker-compose up -d


# cli to create cluster
- create cluster with pre auth `yourpassword`
> echo "yes"| redis-cli -a yourpassword --cluster create 172.29.0.1:7001 172.29.0.1:7002 172.29.0.1:7003 172.29.0.1:7004 172.29.0.1:7005 172.29.0.1:7006 --cluster-replicas 1

- create cluster without pre auth ...
> echo "yes"| redis-cli --cluster create 172.29.0.1:7001 172.29.0.1:7002 172.29.0.1:7003 172.29.0.1:7004 172.29.0.1:7005 172.29.0.1:7006 --cluster-replicas 1


...or...


use `build_cluster.sh` script to create ...
*interactive is needed


# some error handling include
1. `daemonize` is forbidden in cluster 
2. `auth` is required ...


# refer:
reids docker hub
- https://hub.docker.com/_/redis/

how to setup cluster with config
- https://blog.yowko.com/create-redis-cluster/

handle failover
- https://codertw.com/%E7%A8%8B%E5%BC%8F%E8%AA%9E%E8%A8%80/36835/

official doc
- https://redis.io/topics/cluster-tutorial

require pass
- https://blog.csdn.net/lxpbs8851/article/details/8136126

some knowledge about docker-compose
- https://yeasy.gitbooks.io/docker_practice/compose/compose_file.html
	- stdin_open: true ---- allow external input from terminal
	- tty: true --- simulate a TeleTYpewriter from outside
