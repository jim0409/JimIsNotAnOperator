# MySQL資料庫的備份相關
1. 備份mysqldump
```shell
# 拉出指定db下的指定表格
->$: mysqldump -uroot -psecret $dumped_database $dumped_table > mysqltable.sql

# or
# 拉出指定db下的指定表格，表格的某一欄位需要符合情境
->$: mysqldump -uroot -psecret $dumped_database $dumped_table --where="created_time < '2019-10-01 00:00:00'" > mysqltable.sql
```

2. 還原dump出來的sql到其他DB
```shell
->$: mysqldump -uroot -psecret $dumped_database $dumped_table < mysqltable.sql
```

3. 驗證確認備份成功
```sql
SELECT * FROM $dumped_database.$dumped_table WHERE created_time < '2019-10-01 00:00:00';
```

4. 刪除msyql指定表的資料
```sql
mysql> DELETE FROM $dumped_database.$dumped_table WHERE created_at < '2019-10-01 00:00:00';
```

5. 確認刪除後record數有確實減少
```sql
SELECT * FROM $dumped_database.$dumped_table WHERE created_time < '2019-10-01 00:00:00';
```
