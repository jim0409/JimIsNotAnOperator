# intro
According to some customerize fire wall rule need to be elastic in nginx

here comes to have some work

# quick start
> docker-compose up -d

# modify ngixn.client:connection ${redis ip}
> docker exec -it redis hostname -i

# test with redis
### set data
> curl "http://127.0.0.1/setredis?name=abc3&email=abc3@163.com"
```log
1
```

### get data
> curl "http://127.0.0.1/getredis?name=abc3"
```log
abc3@163.com
```

# refer:
- https://lua.ren/topic/338/
- https://www.mtyun.com/library/how-to-use-openresty-redis-on-centos6