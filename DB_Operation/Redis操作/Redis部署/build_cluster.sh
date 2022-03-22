#!/bin/bash
REDIS_CLUSTER_IP=`docker network ls|grep 'redis-cluster'|awk '{print $1}'|xargs docker network inspect|grep Gateway|awk '{print $2}'|tr -d '"'`

# # password less
# docker exec -it redis1 redis-cli -c -p 7001 --cluster create $REDIS_CLUSTER_IP:7001 $REDIS_CLUSTER_IP:7002 $REDIS_CLUSTER_IP:7003 $REDIS_CLUSTER_IP:7004 $REDIS_CLUSTER_IP:7005 $REDIS_CLUSTER_IP:7006 --cluster-replicas 1
docker exec -it redis1 sh -c "echo 'yes' | redis-cli -c -p 7001 --cluster create $REDIS_CLUSTER_IP:7001 $REDIS_CLUSTER_IP:7002 $REDIS_CLUSTER_IP:7003 $REDIS_CLUSTER_IP:7004 $REDIS_CLUSTER_IP:7005 $REDIS_CLUSTER_IP:7006 --cluster-replicas 1"


# for k8s ...
# C_IP1=`dig redis-cluster-0.redis-cluster.dev-pds.svc.cluster.local +short`
# C_IP2=`dig redis-cluster-1.redis-cluster.dev-pds.svc.cluster.local +short`
# C_IP3=`dig redis-cluster-2.redis-cluster.dev-pds.svc.cluster.local +short`
# C_IP4=`dig redis-cluster-3.redis-cluster.dev-pds.svc.cluster.local +short`
# C_IP5=`dig redis-cluster-4.redis-cluster.dev-pds.svc.cluster.local +short`
# C_IP6=`dig redis-cluster-5.redis-cluster.dev-pds.svc.cluster.local +short`

# echo "echo 'yes' | redis-cli -c -p 6379 --cluster create $C_IP1:6379 $C_IP2:6379 $C_IP3:6379 $C_IP4:6379 $C_IP5:6379 $C_IP6:6379 --cluster-replicas 1"
