# intro

1. 
```sql
SELECT DISTINC
FROM STORE_INFO
```

2. 
```sql
SELECT *
FROM "TABLE"
WHERE "FILTER"
```

3. 
```sql
SELECT *
FROM "TABLE"
WHERE "COND1"
AND|OR "COND2"
```

4. 
```sql
SELECT *
FROM "TABLE"
WHERE store_name
IN ("str1", "str2")
```

### 萬用字元
```sql
'ABC%': ABCD, ABC
'%ABC': 123ABC, FABC
'%AN%': XXANX
'_AN%': BANN, CANN
```


5. (萬用)
```sql
SELECT *
FROM "TABLE"
WHERE store_name
LIKE '%AN%'
```

6. 
```sql
SELECT *
FROM "TABLE"
WHERE "COND"
ORDER BY "COL"
```

### 計算符號
```sql
AVG(平均)
COUNT(計數)
MAX(最大)
MIN(最小)
SUM(總和)
```

7. 
```sql
SELECT *
AVG("COL")
FROM "TABLE"
```


8. (聚合)
```sql
SELECT *
FROM "TABLE"
GROUP BY "COL"
```

# JOIN
```sql
LEFT JOIN
OUT JOIN
INNER JOIN
```

9. 
```sql
SELECT a.*, b.*
FROM "TABLE1" AS a,
     "TABLE2" AS b
WHERE a.id=b.id
```

10. 
```sql
SELECT *
AVG("COL")
FROM "TABLE"
```

11. (Natural Join)
```sql
SELECT a.*, b.*
FROM "TABLE1" AS a,
NATURAL JOIN "TABLE2" AS b
```

12. 
```sql
SELECT *
AVG("COL")
FROM "TABLE"
```


# LEFT_JOIN, RIGHT_JOIN
> 這兩個其實是相同的，left join就是顯示左邊表格所有資料，如果沒有記顯示null；right則是相反

13. 
```sql
SELECT a.*, b.*
FROM "TABLE1" AS a
LEFT JOIN "TABLE2" AS b
ON a.id=b.id
```

# FULL_OUTER_JOIN
> 這個可以利用SQL UNION處理掉，這只是聯集(Left&Right Cross Join)，相同於`INNER JOIN`in MySQL

14. 
```sql
SELECT * FROM t1
LEFT JOIN (t2, t3, t4)
ON (t2.a=1 AND
    t3.b=t1.b AND
    t4.c=t1.c)
```

15. 
```sql
SELECT * FROM t1
LEFT JOIN (
    t2 CROSS JOIN t3
       CROSS JOIN t4
    )
ON (t2.a=t1 AND t3.b=t4.b
    AND t4.c=t1.c)
```

# 範例
學號 | 姓名 | 系碼
--
s001 | jim | 001
s002 | joe | 001
s003 | ian | 002
s004 | tim | 002


# keywords convert:
- RelationModel ; Access
- Relation ; Table
- Tuple ; Row/Record
- Attribute ; Col/Field
- Cordinality ; Number Of Record
- Primary Key ; Unique Identifier
- Domain ; Pool Legal Values


# 概要
1. Table: 由行與列組成的二維表格
2. Column: 欄(每一個屬性)
3. Row: 列 or Record(每一筆紀錄)
4. PrimaryKey(PK): unique col, 具唯一性，不可為NULL
5. ForeignKey(FK): 建立資料表之間的關係，其外鍵內含值表需要與另一個Table的PK相同

# 關聯性(Relationship)
在資料表關聯透過`FK`來參考另一`table`的`PK`，如果具有相同`Col`就可以參考

```
Attribute(col)
    | (符合唯一性)
    v
Super Key
    | (符合錊小性)
    v
Candidate Key
    | (任意規則)
    |---------------|
    v               v (未被選為PK)
PrimaryKey      AlternativeKey
```

# RDB 的三種類型
1. 一對一的關聯(1:1)
2. 一對多的關聯(1:M)
3. 多對多的關聯(N:M)

甲`table`只能對一筆
乙`table`
--
甲`table`的一筆資料對
乙`table`的多筆資料
--
甲`table`的多筆資料
乙`table`的多筆資料
--

### 範例
> 1:1
```
[學生table]

學號 | name | sex
--
001 | jim | male
002 | amy | female

[成績table]

學號 | English | Math
--
001 | 10 | 15
002 | 12 | 13
```
> 1:M
```
老師ID | name | domain
--
01 | Jim | Math
02 | Ian | ComputerScience

subject | sub_name | 老師ID
--
01 | python | 02
02 | algebra | 01
03 | golang | 02
04 | calculous | 01
```
> N:M (三張表)
```
studentID | name | subjectID
--
01 | Amy | 001
02 | Tim | 002


[Class Table]
StudentID | SubjectID
--
01 | 001
02 | 002


[Class Schedule]
SubjectID | Sub_Name | TeacherID
--
001 | math | Jim
002 | python | Ian
003 | Algebra | Jim
004 | golang | Ian
```

# UPDATE ... <SQL-627>
16. 
```sql
UPDATE "TABLE"
SET "COL"=...
IF(`col_cond`, `true_action`, `false_action`)
```
- example
```sql
UPDATE salary
SET sex=(IF(sex='f', 'm', 'f'));


id | name | sex | salary
--
1 | A | m | 100
2 | B | f | 200
3 | C | m | 100
4 | D | f | 250
```