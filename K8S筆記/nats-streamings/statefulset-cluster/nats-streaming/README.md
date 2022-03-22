# starup
> kubectl --namespace=nats apply nats -f . 

# check
> kubectl --namespace=nats get pods
> kubectl --namespace=nats get service

# teardown
> kubectl --namespace=nats delete -f . 