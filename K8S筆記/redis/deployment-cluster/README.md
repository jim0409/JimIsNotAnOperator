# create namespace
> kubectl create namespace redis

# startup
> kubectl -n redis apply -f .

# create cluster with replica 1
<!-- > kubectl -n redis exec -it redis-app-0 -- redis-cli --cluster create --cluster-replicas 1 \
$(kubectl get pods -l app=redis-cluster-app -o jsonpath='{range.items[*]}{.status.podIP}:6379 ' -n redis) -->

<!-- kubectl -n redis exec -it deploy/redis1 -- redis-cli -a yourpassword --cluster create --cluster-replicas 1 redis1:6379 redis2:6379 redis3:6379 redis4:6379 redis5:6379 redis6:6379 -->

<!-- > kubectl -n redis exec -it deploy/redis1 -- redis-cli -a yourpassword --cluster create --cluster-replicas 1 \ -->
> kubectl -n redis exec -it deploy/redis1 -- redis-cli --cluster create --cluster-replicas 1 \
$(kubectl get pods -l app=redis1 -o jsonpath='{range.items[*]}{.status.podIP}:6379 ' -n redis ) \
$(kubectl get pods -l app=redis2 -o jsonpath='{range.items[*]}{.status.podIP}:6379 ' -n redis ) \
$(kubectl get pods -l app=redis3 -o jsonpath='{range.items[*]}{.status.podIP}:6379 ' -n redis ) \
$(kubectl get pods -l app=redis4 -o jsonpath='{range.items[*]}{.status.podIP}:6379 ' -n redis ) \
$(kubectl get pods -l app=redis5 -o jsonpath='{range.items[*]}{.status.podIP}:6379 ' -n redis ) \
$(kubectl get pods -l app=redis6 -o jsonpath='{range.items[*]}{.status.podIP}:6379 ' -n redis ) 


# check with bash
kubectl -n redis exec -it deploy/redis1 -- bash


# check
> kubectl -n redis get pods 

# teardown
> kubectl -n redis delete -f .

# refer:
- https://www.tpisoftware.com/tpu/articleDetails/2011
