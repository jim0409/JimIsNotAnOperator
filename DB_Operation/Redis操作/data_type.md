# intro
Redis (REmote Dictionary Server)，字典式資料庫

可以透過啟動的docker-compose進行演練... http://127.0.0.1:8081

# 基本操作
1. 進入redis-cli: redis-cli
2. 設定key value及查詢
    ```sh
    # 列出所有的key
    redis 127.0.0.1:6379> keys *
    (empty list or set)

    # 設定key os 及value linux
    redis 127.0.0.1:6379> set os linux
    OK

    # 拿取key os 的value
    redis 127.0.0.1:6379> get os
    "linux"

    # 顯示目前所有的key
    redis 127.0.0.1:6379> keys *
    1) "os"

    # 以select切換到不同的資料庫，預設是使用0
    redis 127.0.0.1:6379> select 1
    OK

    #此時redis會變成[1]
    redis 127.0.0.1:6379[1]> keys *
    (empty list or set)

    # select 切換回原本的資料庫
    redis 127.0.0.1:6379[1]> select 0
    OK

    # 刪除指定的 key os
    redis 127.0.0.1:6379> del os
    (integer) 1

    # 確認已經沒有key os
    redis 127.0.0.1:6379> keys *
    (empty list or set)

    ```

# 常用的基本資料型態
基本來說，redis的資料以`redis['key']='value'`存在於資料庫中

而`'value'`的資料型態可以是: Strings(integers), Lists, Hashes, Sets, Sorted Sets

分別支持這些資料型態的操作為

### Strings(Intgers)
假設每點閱文章一次就累加次數
```sh
# 設定一個計數器表示hit，player為twtw ... 會得到一個初始值 1
redis 127.0.0.1:6379> incr hit:player:twtw
(integer) 1

# 也可以用 incrby 指定一次累加多少
redis 127.0.0.1:6379> incrby hit:player:twtw 5
(integer) 6

# 用 decr 及相對應的 decrby 做遞減
redis 127.0.0.1:6379> decr hit:player:twtw
(integer) 5

redis 127.0.0.1:6379> decrby hit:player:twtw 2
(integer) 3

#查詢某key的值
redis 127.0.0.1:6379> get hit:player:twtw
"3"

#key不存在則為nil或-1
redis 127.0.0.1:6379> get hit:player:none
(nil)
```

### Lists
有順序的列表，假設給twtw訊息一個編號，最新的排在最前面

```sh
redis 127.0.0.1:6379> lpush msg:twtw 100
(integer) 1

redis 127.0.0.1:6379> lpush msg:twtw 55
(integer) 2

redis 127.0.0.1:6379> lpush msg:twtw 33
(integer) 3

redis 127.0.0.1:6379> lpush msg:twtw 44
(integer) 4

redis 127.0.0.1:6379> lpush msg:twtw 22
(integer) 2

#列出所有訊息編號：
redis 127.0.0.1:6379> lrange msg:twtw 0 -1
1) "22"
2) "44"
3) "33"
4) "55"
5) "100"

#如果只保留前三個訊息
redis 127.0.0.1:6379> ltrim msg:twtw 0 2
1) "22"
2) "44"
3) "33"

redis 127.0.0.1:6379> lrange msg:twtw 0 -1
1) "100"
2) "55"
3) "33"

#若要刪掉倒數第一個55的訊息
redis 127.0.0.1:6379> lrem msg:twtw -1 55
(integer) 1

redis 127.0.0.1:6379> lrange msg:twtw 0 -1
1) "22"
2) "44"
3) "33"
4) "100"

#從左邊pop出第一個
redis 127.0.0.1:6379> lpop msg:twtw
"22"

redis 127.0.0.1:6379> lrange msg:twtw 0 -1
1) "44"
2) "33"
3) "100"

```

### Hashes
```sh
#同時設好幾個key value用hmset
redis 127.0.0.1:6379> hmset h_multiple_set:twtw firstKey 123 subject "This is the subject value"
OK


#一次抓所有的值
redis 127.0.0.1:6379> hgetall h_multiple_set:twtw
{
  "subject": "This is the subject value",
  "firstKey": "123 "
}

#一次只加一個key value用 hset
redis 127.0.0.1:6379> hset h_multiple_set:twtw another_subject "This is another subject value"
(integer) 1

# 刪除指定hash下的某個值
redis 127.0.0.1:6379> hdel h_multiple_set:twtw another_subject
(integer) 1

#一次抓一個key值
redis 127.0.0.1:6379> hget h_multiple_set:twtw another_subject
"This is another subject value"

```


### Sets
沒有分序列的集合，不同於有序列的陣列，元素也不會有重覆。

- SADD 將元素推進集合。

- SMEMBERS 列出該集合所有元素。

- SISMEMBER 查某元素是否屬該集合。

- SINTER 列出兩集合的交集的元素。

- SUNION 列出兩集合聯集的元素。

- SPOP 隨機移出集合裡的一元素。

- SREM 從集合移出一個或多個元素。

```sh
# 
redis 127.0.0.1:6379> sadd i5:type:tech twtw
(integer) 1

# 
redis 127.0.0.1:6379> sadd i5:type:tech chiounan
(integer) 1

# 
redis 127.0.0.1:6379> smembers i5:type:tech
1) "chiounan"
2) "twtw"

# 
redis 127.0.0.1:6379> sadd i5:type:life chiounan
(integer) 1

# 
redis 127.0.0.1:6379> sinter i5:type:tech i5:type:life
1) "chiounan"

# 
redis 127.0.0.1:6379> SISMEMBER i5:type:tech twtw
(integer) 1

# 
redis 127.0.0.1:6379> SISMEMBER i5:type:life twtw
(integer) 0

# 
redis 127.0.0.1:6379> SUNION i5:type:life i5:type:tech
1) "chiounan"
2) "twtw"

# 
redis 127.0.0.1:6379> SPOP i5:type:tech
"chiounan"

# 
redis 127.0.0.1:6379> SREM i5:type:tech twtw
(integer) 1
```

### Sorted Sets
同樣是集合，但元素是再加上數值，而可依每元素的數值做排序。

```sh
redis 127.0.0.1:6379> ZADD i5:scores 7515 seanamph
(integer) 1

redis 127.0.0.1:6379> ZADD i5:scores 12033 chiounan
(integer) 1

redis 127.0.0.1:6379> ZADD i5:scores 9977 markshu
(integer) 1

redis 127.0.0.1:6379> ZADD i5:scores 9694 thc
(integer) 1

redis 127.0.0.1:6379> ZADD i5:scores 26040 sunallen
(integer) 1

#升冪排序
redis 127.0.0.1:6379> ZRANGE i5:scores 0 -1
1) "seanamph"
2) "thc"
3) "markshu"
4) "chiounan"
5) "sunallen"

#降冪排序
redis 127.0.0.1:6379> ZREVRANGE i5:scores 0 -1
1) "sunallen"
2) "chiounan"
3) "markshu"
4) "thc"
5) "seanamph"

#加上 WITHSCORES 列出每元素的分數
redis 127.0.0.1:6379> ZREVRANGE i5:scores 0 -1 WITHSCORES
 1) "sunallen"
 2) "26040"
 3) "chiounan"
 4) "12033"
 5) "markshu"
 6) "9977"
 7) "thc"
 8) "9694"
 9) "seanamph"
10) "7515"

#算出分數 5000 ~ 10000 的元素個數
redis 127.0.0.1:6379> ZCOUNT i5:scores 5000 10000
(integer) 3

#列出分數 5000 ~ 10000 的元素
redis 127.0.0.1:6379> ZRANGEBYSCORE i5:scores 5000 10000
1) "seanamph"
2) "thc"
3) "markshu"

#增加某元素的分數
redis 127.0.0.1:6379> ZINCRBY i5:scores 1 thc
"9695"

#列出某元素的分數
redis 127.0.0.1:6379> ZSCORE i5:scores thc
"9695"
```

### 有時效的key
透過 expire 的指令，可設定某key在幾秒後 key 被刪除。

TTL 可看key剩多少秒將被刪除。

PERSIST 可取消掉倒數刪除的作用，而讓該key沒有expire的屬性。

```sh
# 
redis 127.0.0.1:6379> set gone:after:3mins "2012-10-21 15:57:06 +0800"
OK

# 
redis 127.0.0.1:6379> ttl gone:after:3mins
(integer) -1

# 
redis 127.0.0.1:6379> expire gone:after:3mins 180
(integer) 1

# 
redis 127.0.0.1:6379> ttl gone:after:3mins
(integer) 176

# 
redis 127.0.0.1:6379> ttl gone:after:3mins
(integer) 173

# 
redis 127.0.0.1:6379> PERSIST gone:after:3mins
(integer) 1

# 
redis 127.0.0.1:6379> ttl gone:after:3mins
(integer) -1
```
也可指定某個時間expire，時間指定需用unix timestamp格式，例如：2012-10-21 16:18:44 +0800 換算成 1350807518

```sh
# 
redis 127.0.0.1:6379> set gone:latter hi
OK

# 
redis 127.0.0.1:6379> TTL gone:latter
(integer) -1

# 
redis 127.0.0.1:6379> EXPIREAT gone:latter 1350807518
(integer) 1

# 
redis 127.0.0.1:6379> TTL gone:latter
(integer) 268
```

也可再設key的同時也設key的有效時間：

```sh
# 
redis 127.0.0.1:6379> SETEX gone:60sec 60 "gone after 60 secs"
OK

# 
redis 127.0.0.1:6379> get gone:60sec
"gone after 60 secs"

# 
redis 127.0.0.1:6379> ttl gone:60sec
(integer) 53
```


# refer:
- https://redis.io/topics/data-types
- https://ithelp.ithome.com.tw/articles/10105731