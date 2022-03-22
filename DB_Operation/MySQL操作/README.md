# INTRO
紀錄工作上常用的SQL指令

<!-- architecture of mysql -->
@import "architmate.md"

# 常用指令
1. SELECT : 選表欄用
2. AS : 將database宣告為某一變數方便後面做有效宣告
3. FROM : 表示使用哪個database
```sql
SELECT a.OrderID,sum(a.OrderID)
FROM Orders a;
```

4. where : 用於下判斷式，特別是搭配{in, between, and, or}
```sql
SELECT *
FROM OrderDetails
WHERE OrderID > 10500 OR (ProductID > 70 AND Quantity > 10);
```

5. order by (desc): 將顯示出來的結果做排序，desc表示反排序。
6. like : 可以配合特殊字元'%'用篩選欄位資料
```sql
SELECT *
FROM OrderDetails WHERE OrderID LIKE '%50';
```
<!-- # 額外的SELECT語法 -->
7. REPLACE : 以值取代表內某欄的值。
```sql
SELECT REPLACE (ProductName, 'Chais', 'Jim')
FROM Products;
```
8. JOIN(概念) : 通常用於宣稱alias後把兩張表以結合的形式做呈現
```sql
SELECT * FROM OrderDetails
AS a1, Orders AS a2 WHERE a1.OrderID = a2.OrderID;
```
9. GROUP BY : 同類分群;可以額外多加上計算，像是sum/average/
```sql
SELECT OrderID,sum(Quantity)
FROM OrderDetails GROUP BY OrderID;
```
10. HAVING : 類似shell的'|'，通常是在對於sql執行的結果做進一步判斷用。
```sql
SELECT OrderID,sum(Quantity)
FROM OrderDetails GROUP BY OrderID HAVING sum(Quantity) > 100;
```

# 關聯名詞
記錄一些在敘述表格常用的名詞解釋，關聯式資料模型 SQL Server/Access

| 常用名詞| 對應名詞|
|---|---|
| 關聯(Releation)| 表格(Table)|
| 值組(Tuple)| 橫列(Row) or 紀錄(Record)|
| 屬性(Attribute) |直欄(Column) or 欄位(Field)|
| 基數(Cardinality)| 紀錄個數(number of Record)|
| 主鍵(Primary Key| 唯一識別(unique identifier)|
| 定義域(Domain)| 合法值群(pool legal values)|

e.g.
| 學號| 姓名| 系碼|
|---|---|---|
| b1| Jim| m1|
| b2| Ian| m2|
| b3| Tom| m1|

學號，姓名以及系碼為三個屬性名稱，各欄位下的數值為屬性質。
此外，學號就是主鍵(Primary Key)，其下面的{ b1, b2, b3}就是值組

-- select * from Orders;
-- SELECT * FROM [OrderDetails]
-- select a.OrderID from OrderDetails a;
-- select a.OrderID from OrderDetails as a;
-- select * from OrderDetails as a1, Orders as a2 where a1.OrderID = a2.OrderID;
-- select * from Products as a1, Shippers as a2, Suppliers as a3 where a1.SupplierID = a3.SupplierID and a2.ShipperName in ("Speedy Express");

<!-- advance operation for table -->
@import "table_operation.md"

# 套用上面的表操作SQL語法於[數據庫](https://www.w3schools.com/sql/trysql.asp?filename=trysql_op_in)
1. DELETE FROM : 根據條件刪除表的部分值
```sql
DELETE FROM OrderDetails AS a
WHERE a.OrderDetailID in (1,2);
```
2. UPDATE : 修改表格中的某欄位的值; 備註：不能使用alias -- (X) update OrderDetails as a set a.Quantity=100 where a.Quantity=5;
```sql
UPDATE OrderDetails
SET Quantity=100
WHERE Quantity=5;
```
3. ALTER TABLE : 新增/更換/刪除 指令表格的'欄位'
- 新增表格欄位'Gender char(1)' 
```sql
ALTER TABLE `Orders`
ADD `Gender char(1)`;
```
- 更換`Gender char(1)`資料型態
```sql
ALTER TABLE `Orders`
CHANGE `Gender` integer; -- 網頁版有問題無法正常執行
```
- 刪除指令欄位`Gender char(1)`
```sql
ALTER DROP `Orders` COLUMN `Gender`; -- 網頁版有問題無法正常執行
```
4. DROP TABLE : 直接刪除整張表格
```sql
DROP TABLE `Orders`;
```
5. INSERT INTO : 將資料塞入表中，資料型態需要符合依照該表對應欄位的資料型態
```sql
INSERT INTO `Orders` (`OrderID`, `CustomerID`, `EmployeeID`, `OrderDate`, `ShipperID`)
VALUES (10247, 900, 100, 'Jan-10-1999', 999);
```

# 表聯集指令
1. 使用UNION將兩句SQL指令串接起來;(備註:UNION要大寫)
```sql
SELECT `OrderID`
FROM `Orders` UNION SELECT `OrderID`
FROM `OrderDetails`;
```

2. UNION ALL，不篩選掉重複資料。將所有SQL指令的結果全部顯示出來。
```sql
SELECT `OrderID`
FROM `Orders` 
UNION ALL SELECT `OrderID` 
FROM `OrderDetails`;
```

# SQL腳本
1. `sql-case`: 用case來做sql-script。
```sql
SELECT CASE("col_name")
WHEN "criterion1" THEN "result1"
WHEN "criterion2" THEN "result2"
...
ELSE "result_else"
END
FROM "table_name";
```

# 關於一些名詞解釋的差異`PRIMARY KEY`&`UNIQUE KEY`&`KEY`
- Meaning of "PRIMARY KEY","UNIQUE KEY" and "KEY" when used together while creating a table
example as below;
```sql
CREATE TABLE IF NOT EXISTS `tmp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `tag` int(1) NOT NULL DEFAULT '0',
  `description` varchar(255),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uid` (`uid`),
  KEY `name` (`name`),
  KEY `tag` (`tag`)
) ENGINE=InnoDB AUTO_INCREMENT=1 ;
```

1. key: 一般的索引，就像書籤一樣
2. unique_key: 用來增加索引速度，對於所有的unique_key來說，欄位下的所有值都是唯一的
3. primary_key: 特需情境下的`unique_key`，通常是用來表示該筆record的`Uuid`

<!-- use mysql migrate to redis as example -->
@import "migrate_to_redis.md"
<!-- mysql-command and backup -->
@import "backup.md"
<!-- refer ... -->
@import "refer.md"
