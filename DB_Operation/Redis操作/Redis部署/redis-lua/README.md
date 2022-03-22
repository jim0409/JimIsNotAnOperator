# intro

使用lua來操作redis，
情境:
1.需要較好的效能
2.利用redis的ACID性質

# set key
<!-- > eval "redis.call('set', KEYS[1], ARGV[1])" 1 key:name value -->
> eval 'redis.call("set", KEYS[1], ARGV[1])' 1 key:name value

設定一個鍵`key:name`，對應值`value`

# get key
<!-- > eval "return redis.call('get', KEYS[1])" 1 key:name -->
> eval 'return redis.call("get", KEYS[1])' 1 key:name

拿取鍵`key:name`的值後回傳

# complex condition
assume there has two keys
- hkeys with type
hmset hkeys key:1 value:1 key:2 value:2 key:3 value:3 key:4 value:4 key:5 value:5 key:6 value:6
- order with type
zadd order 1 key:3 2 key:1 3 key:2

query order with `zrange` and return values within hkeys via `hmget` cli.
<!-- > eval "local order = redis.call('zrange', KEYS[1], 0, -1); return redis.call('hmget',KEYS[2],unpack(order));" 2 order hkeys -->
> eval 'local order = redis.call("zrange", KEYS[1], 0, -1); return redis.call("hmget",KEYS[2],unpack(order));' 2 order hkeys

# store script inside redis

1. store script
<!-- > script load "return redis.call('get', KEYS[1])" -->
> script load 'return redis.call("get", KEYS[1])'
```log
127.0.0.1:6379> script load "return redis.call('get', KEYS[1])"
"4e6d8fc8bb01276962cce5371fa795a7763657ae"
```

2. use pre-load script
> evalsha 4e6d8fc8bb01276962cce5371fa795a7763657ae 1 key:name
```log
127.0.0.1:6379> evalsha 4e6d8fc8bb01276962cce5371fa795a7763657ae 1 key:name
"value"
```

# advanced : change some json struct in redis
### why
1. 可能存儲一些物件(json)，但是不傾向時常去拿值後覆寫(影響效能)
2. 當存在redis上的物件資料偏大，頻繁的網路傳輸可能拖慢速度

# set some json in redis
> set obj '{"a":"foo", "b":"bar"}'

# modify obj with lua script
<!-- > eval "local obj = redis.call('get', KEYS[1]); local obj2 = string.gsub(obj,'(' .. ARGV[1] .. '\':)([^,}]+)', '%1' .. ARGV[2]); return redis.call('set',KEYS[1],obj2);" 1 obj b bar2 -->
> eval 'local obj = redis.call("get", KEYS[1]); local obj2 = string.gsub(obj,"(" .. ARGV[1] .. "\":)([^,}]+)", "%1" .. ARGV[2]); return redis.call("set",KEYS[1],obj2);' 1 obj b bar2
```lua
eval 'local obj = redis.call("get", KEYS[1]); local obj2 = string.gsub(obj,"(" .. ARGV[1] .. "\":)([^,}]+)", "%1" .. ARGV[2]); return redis.call("set",KEYS[1],obj2);' 1 obj b bar2
```

# script load to replace function
> script load 'local obj = redis.call("get",KEYS[1]); local obj2 = string.gsub(obj,"(" .. ARGV[1] .. "\":)([^,}]+)", "%1" .. ARGV[2]); return redis.call("set",KEYS[1],obj2);'
```log
127.0.0.1:6379> script load 'local obj = redis.call("get",KEYS[1]); local obj2 = string.gsub(obj,"(" .. ARGV[1] .. "\":)([^,}]+)", "%1" .. ARGV[2]); return redis.call("set",KEYS[1],obj2);'
"e0ce5eb4b53d5247e4b2bb52128043f6bdce9653"
```
> evalsha e0ce5eb4b53d5247e4b2bb52128043f6bdce9653 1 obj b bar3
```log
127.0.0.1:6379> get obj
"{\"a\":\"foo\", \"b\":bar3}"
```


# refer:
### redis lua script 簡易教學
- https://www.freecodecamp.org/news/a-quick-guide-to-redis-lua-scripting/

### redis lua script with golang
- https://studygolang.com/articles/18031