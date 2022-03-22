# startup
### stan1
kubectl -n nats apply -f node1

### stan2
kubectl -n nats apply -f node2

### stan3
kubectl -n nats apply -f node3

### check pods
kubectl -n nats get pods

### check service
kubectl -n nats get service