# intro

- Q: 什麼是 Lock(鎖)?
> A: Lock 的主要目的是避免資料發生錯誤，把不應該進行動作的指令排除在外，並讓應該進行動作的指令能夠順利完成。

- Q: 什麼是Table Lock (表單鎖定)? 什麼是Row Lock (紀錄鎖定)?
> A: 表單鎖定就是將整個資料表鎖定，讓其他連線無法讀取及異動，直到資料處理完畢為止。紀錄鎖定就是將指定的紀錄鎖定，讓其他連線無法讀取及異動，直到資料處理完畢為止。

- Q: `InnoDB`與`MyISAM`的鎖(Lock)有何差別?
> A: `MyISAM` 沒有交易功能 (Transaction)，若要避免多個連線交互執行 SQL 指令，造成資料錯亂，只好使用資料表鎖 (Table Lock) 的方式，InnoDB則可以使用Table Lock 與Row Lock。

- Q: MySQL不同版本的鎖定有何差別？
> A: MySQL不同版本的鎖定原理一樣，只是語法上有些差異。
```sql
例如 :
cker
MySQL 5.5 使用 Select ... lock in share mode;
MySQL 5.5 使用 Select ... for update;
MySQL 8.0 還可以使用 Select ... for share;
MySQL 8.0 還可以使用 Select ... for update NOWAIT;
```

# example
1. 顯示目前 mysql 版本資訊
```sql
SHOW VARIABLES LIKE "%version%";
```

### 2. 創建一個操作用的資料庫
```sql
CREATE DATABASE demo_table;
```

### 3. 使用`demo_table`資料庫
```sql
USE demo_table;
```

### 4. 創建表單
```sql
CREATE TABLE T (
	ID INT NOT NULL,
	F1 INT,
	PRIMARY KEY(ID)
);
```

### 5. 插入資料
```sql
INSERT INTO T (ID,F1) VALUES (1,2), (2,1), (3,2), (4,4);
```

### 6. 測試表單鎖(Table Lock)
- TABLE level LOCK for READ
```sql
LOCK TABLE T READ;
```	
1. 這是屬於表單鎖。自身連線只能針對該表單T讀取資料，不能寫入更改該表單T，也不能再去讀取其他表單。
2. 其他連線可以讀取該表單T，但是不能寫入更改該表單T，會進入等待，直到解除。
```sql
mysql> insert into T (ID, F1) values (1,1);
ERROR 1099 (HY000): Table 'T' was locked with a READ lock and can't be updated
```
3. 解除剛剛的鎖
```sql
UNLOCK TABLES;
```
- TABLE level LOCK for WRITE
1. 這是屬於表單鎖。自身連線可以針對該表單T讀取及寫入更改資料，但是不能操作其他表單。
2. 其他連線禁止對該表單T讀取及寫入更改資料，要寫入更改該表單T，會進入等待，直到解除。
3. 解除剛剛的鎖
```sql
UNLOCK TABLES;
```


