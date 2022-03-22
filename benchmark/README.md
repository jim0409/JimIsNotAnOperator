# intro
### setup test env
> docker run --rm --name nginx -p 80:80 -d nginx:1.13.7

### AB for get
script
```bash
concurrency=$1
totalnumber=$2
SOME_URL="127.0.0.1:80"
ab -c $concurrency -n $totalnumber http://$SOME_URL/
```

### AB for post
script
```bash
concurrency=$1
totalnumber=$2
SOME_URL="127.0.0.1:80"
ab -p post.json -T application/json -c $concurrency -n $totalnumber http://$SOME_URL/
```

post.json
```json
{
    "data": "just data",
    "params": "just parameters",
}
```


### check nginx access log (records ?= #request)
> docker logs nginx|wc -l


# refer:
- https://learn-jmeter.blogspot.com/2016/10/how-to-run-test-plan-for-specified.html
- https://blog.e-zest.com/how-to-run-jmeter-in-non-gui-mode/
