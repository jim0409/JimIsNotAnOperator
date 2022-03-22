# refer: 

### about mysql architecture
- https://lalitvc.files.wordpress.com/2018/05/mysql_architecture_guide.pdf
<!--  -->
### 參照的SQL指令教學網址
- https://www.1keydata.com/tw/sql/sql.html
### online SQL editor
- https://www.w3schools.com/sql/trysql.asp?filename=trysql_op_in
### 解釋mysql中key/primary key/unique key的意義及使用場景
- https://stackoverflow.com/questions/10908561/mysql-meaning-of-primary-key-unique-key-and-key-when-used-together-whil
<!--  -->

### 改變舊的 foreign key 參照行為
- https://stackoverflow.com/questions/3359329/how-to-change-the-foreign-key-referential-action-behavior?lq=1
### drop index
- https://www.w3schools.com/sql/sql_ref_drop_index.asp
### alter index
- https://stackoverflow.com/questions/5038040/mysql-make-an-existing-field-unique
- https://stackoverflow.com/questions/21777787/altering-existing-unique-constraint
### why index
- http://n.sfs.tw/content/index/10376 
### how to declare secondary or non-unique index
- https://stackoverflow.com/questions/23525790/how-to-declare-secondary-or-non-unique-index-in-mysql
### truncate table
- https://www.w3schools.com/sql/sql_unique.asp

<!--  -->
### 簡易dump及restore資料庫資料
- https://phoenixnap.com/kb/how-to-backup-restore-a-mysql-database
### 使用`condition`拉出指定情境下的資料
- https://idiallo.com/blog/mysql-dump-table-where
### 依據資料庫時間點進行資料還原
- https://dev.mysql.com/doc/mysql-backup-excerpt/5.5/en/point-in-time-recovery-times.html
```shell
->: mysqldump -uroot -psecret $dumped_database $dumped_table1 $dumped_table2 $dumped_tabl3 --where="created_time < '2019-10-01 00:00:00'" > mysqltable.sql
```
一次dump多個mysql的資料表
- https://dba.stackexchange.com/questions/9306/how-do-you-mysqldump-specific-tables

<!--  -->
### mysql 轉寫到 redis
- https://www.tutorialspoint.com/redis/redis_quick_guide.htm

