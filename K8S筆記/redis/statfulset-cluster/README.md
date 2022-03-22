# create namespace
> kubectl create namespace redis-cluster

# startup
> kubectl -n redis-cluster apply -f .

# create cluster with replica 1
> kubectl -n redis-cluster exec -it redis-app-0 -- redis-cli --cluster create --cluster-replicas 1 \
$(kubectl get pods -l app=redis-cluster-app -o jsonpath='{range.items[*]}{.status.podIP}:6379 ' -n redis-cluster )

# check
> kubectl -n redis-cluster get pods 

# teardown
> kubectl -n redis-cluster delete -f .

# refer:
- https://www.tpisoftware.com/tpu/articleDetails/2011