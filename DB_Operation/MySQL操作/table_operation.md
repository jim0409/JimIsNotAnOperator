# CREATE 指令
## CREATE TABLE: 在某個database下創建新的表格，以及定義該表格下需要的欄位資料型態。
- CREATE TABLE `{TableName}` (`{Col1Name}` `{Col1Type}`, `{Col2Name}` `{Col2Type}`, ... )
```sql
CREATE TABLE `JimTable` (
    `first_col` VARCHAR(50),
    `second_col` VARCHAR(25)
);
```
<!-- ### 透過 Describe 來確認建立的資料是否正確
```sql
Describe `JimTable`;
```
> 執行結果
```log
mysql> describe JimTable;
+------------+-------------+------+-----+---------+-------+
| Field      | Type        | Null | Key | Default | Extra |
+------------+-------------+------+-----+---------+-------+
| first_col  | varchar(50) | YES  |     | NULL    |       |
| second_col | varchar(25) | YES  |     | NULL    |       |
+------------+-------------+------+-----+---------+-------+
3 rows in set (0.00 sec)
``` 
> Refer: https://kknews.cc/zh-tw/code/4mmpo9g.html

### 注入一些假資料供後面查詢使用
INSERT INTO `JimTable` (`first_col`, `second_col`)
VALUES ("key", "value");
-->


## DROP TABLE: 清除掉某個表格
```sql
DROP TABLE `JimTable`;
```

## CREATE VIEW: 鑑於某個表格創建一個view方便觀察及管控表；註此處的AS不是ALIAS的AS
- CREATE VIEW `{ViewName}` AS `{SQL-SELECT Syntax}` FROM `{TableName}`
```sql
CREATE VIEW `VJimTable` AS SELECT * FROM `JimTable`;
```

## DROP VIEW
```sql
DROP VIEW `VJimTable`;
```

## CREATE TABLE ... PRIMARY ...: 創造含有`PRIMARY KEY`的表格
- CREATE TABLE `{TableName}` ( `{Col1Name}` `{Col1Type}`, `{Col2Name}` `{Col2Type}`, ..., PRIMARY KEY (`{PKColName}`) )
```sql
CREATE TABLE `PKJimTable` (
    `id` INT,
    `last_name` VARCHAR(30),
    `first_name` VARCHAR(30),
    PRIMARY KEY(`id`)
);
```

## CREATE TABLE ... FOREIGN KEY ... REFERENCES ...: 創造含有`FOREIGN KEY`的表格`REFERENCES`到另一張表
- 前置作業: 需要具備一個可以被`REFERENCES`的table，此處飲用之前的`PKJimTable`
- 創建一個含有外鍵表格
```sql
CREATE TABLE `RefJimTable` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `date` TIMESTAMP,
    `usr_id` INT ,
    `age` INT,
    FOREIGN KEY (`usr_id`) REFERENCES `PKJimTable` (`id`)
);
```

# ALTER 指令
## ADD THE COLUMN()
- 在一個既有的表格中，增加一個欄位
```sql
ALTER TABLE `JimTable`
ADD COLUMN `third_col` VARCHAR(8);

-- VARCHAR可以換為其他的資料格式，8代表資料VARCHAR資料大小為 8 bytes
-- (*) 一個英文字母 1 bytes
```

## ADD EXTRA KEY PROPERTIE(s)
- 在一個既有的增加一個索引
```sql
ALTER TABLE `JimTable`
ADD INDEX `third_col_index`(`third_col`);

-- third_col 為期望作index的key
-- third_col_index 為查詢時，期望看到的名稱
```

<!-- 
### SHOW INDEX
- 顯示一個已存的Index
SHOW INDEX FROM `JimTable`;
```sql
mysql> SHOW INDEX FROM `JimTable`;
+----------+------------+-----------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| Table    | Non_unique | Key_name        | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment | Visible | Expression |
+----------+------------+-----------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| JimTable |          1 | third_col_index |            1 | third_col   | A         |           0 |     NULL |   NULL | YES  | BTREE      |         |               | YES     | NULL       |
| JimTable |          1 | first_col_index |            1 | first_col   | A         |           0 |     NULL |   NULL | YES  | BTREE      |         |               | YES     | NULL       |
+----------+------------+-----------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
2 rows in set (0.01 sec)
```
> Refer: https://dev.mysql.com/doc/refman/8.0/en/show-index.html
-->


## DROP THE INDEX
- 將一個表格中的index刪除
```sql
ALTER TABLE `JimTable`
DROP INDEX `third_col_index`;

-- third_col_index 將`third_col_index`這個`index`刪除
```


## DROP THE COLUMN(s)
- 在一個既有的表格中，刪除一個既有的欄位
```sql
ALTER TABLE `JimTable`
DROP COLUMN `third_col`;

-- third_col 將欄位third_col刪除
```


# EXTEND
#### FOREIGN
- (如果表內沒有`FOREIGN KEY`)使用`ALTER`指令幫表格增加`FOREIGN KEY`
```sql
ALTER TABLE `RefJimTable`
ADD FOREIGN KEY (`usr_id`) REFERENCES `PKJimTable` (`id`)

-- user_id 要賦予新的屬性的表欄位
-- PKJimTable 主表
-- id 主表下被參照的欄位名稱
```

## UPDATE CONSTANT
- 假設`table1`有一個`foreign key`名稱為`fk_table2_id`伴隨`constraint name: fk_name`
- `table2`參照表`table1`
```
talbe1 [ fk_table2_id ] --> table2 [t2]
```
1. 取原本的舊的`CONSTRAINT`
```sql
ALTER TABLE `table1` 
DROP FOREIGN KEY `fk_name`;
```
2. 增加新的`CONSTRAINT`
```sql
ALTER TABLE `table1`  
ADD CONSTRAINT `fk_name` 
FOREIGN KEY (`fk_table2_id`) REFERENCES `table2` (`t2`) ON DELETE CASCADE;
```

## CREATE A COMPOSITE INDEX
```sql
ALTER TABLE `JimTable`
ADD UNIQUE INDEX `composite_index`(
         `first_col`, 
         `second_col`
);
```

## SELECT (display) with REPLACE
- 以值取代表內某欄的值
```sql
SELECT REPLACE (first_col, 'key', 'key2')
FROM `JimTable`;

-- 將撈出的所有first_col的'key'值，都改以'key2'顯示
```


## TRUNCATE TABLE
- 清除表內資料，但不改變表結構
```sql
TRUNCATE TABLE `JimTable`;
```