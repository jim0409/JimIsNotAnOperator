# 考慮將MySQL的資料轉換到Redis
演示用MySQL轉換資料到Redis
```
table -> hset
```

# SETUP
設定一個MySQL環境，並且透過該環境來模擬轉換
0. 使用docker-compose啟動`MySQL`以及`Redis`環境
> docker-compose up -d

1. 創建一個表格
```sql
CREATE TABLE events_all_time (
  id int(11) unsigned NOT NULL AUTO_INCREMENT,
  action varchar(255) NOT NULL,
  count int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (id),
  UNIQUE KEY uniq_action (action)
);
```


2. 插入幾筆數據
```sql
insert into events_all_time (action) values ("simle");
insert into events_all_time (action) values ("cry");
insert into events_all_time (action, count) values ("angry", 1);
insert into events_all_time (action, count) values ("laugh", 1);
```

2. 創建一個
```sql
-- events_to_redis.sql

SELECT CONCAT(
  "*4\r\n",
  '$', LENGTH(redis_cmd), '\r\n',
  redis_cmd, '\r\n',
  '$', LENGTH(redis_key), '\r\n',
  redis_key, '\r\n',
  '$', LENGTH(hkey), '\r\n',
  hkey, '\r\n',
  '$', LENGTH(hval), '\r\n',
  hval, '\r'
)
FROM (
  SELECT
  'HSET' as redis_cmd,
  'events_all_time' AS redis_key,
  action AS hkey,
  count AS hval
  FROM events_all_time
) AS t
```

3. 執行 `mysql` 及 `redis-cli` 指令
> mysql stats_db --skip-column-names --raw < events_to_redis.sql | redis-cli -h 127.0.0.1 -p 6379 -a "yourpassword" --pipe

