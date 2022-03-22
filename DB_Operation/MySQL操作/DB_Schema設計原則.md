# intro
因應資料量龐大，許多 Schema 在設計時，必須考量到 DB 資源的使用，以達到最有效的利用。
```sql
CREATE TABLE mainartist_raw (
  id bigint(20) NOT NULL AUTO_INCREMENT,
  territory_code char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  language_code char(4) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  script_code char(4) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  title_text varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'artist role name',
  status bigint(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  created_at int(10) NOT NULL,
  updated_at int(10) DEFAULT NULL,
  PRIMARY KEY (id),
  KEY btree__title_text (title_text)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED
```

# 流水號設計
MySQL 中常用的整數數字型態有 `tinyint`、`smallint`、`int`、`bigint`

- tinyint(1 byte): -128 到 127
- smallint(2 bytes): -2^15 (-32768) 到 2^15-1 (32767)
- int(4 bytes): -2^31 (-2147483648) 到 2^31-1 (2147483647)
- bigint(8 bytes): -2^63 (-9223372036854775808) 到 2^63-1 (9223372036854775807)

不同的型態存在資料庫的容量大小會不同，因此在`設計上需要先估算此張表寫入的資料量大小，再決定使用什麼型態，而不是一昧的使用最大型態`
以紀錄`album`來說，可能就需要用到`bigint`，但如果只是紀錄某種`type`，也許`tinyint`就已足夠

> 以範例來說，status 可以改成: 
```sql
status tinyint(4) DEFAULT 0
-- Notice：如果只是流水號，一定不會用到負數，可以利用 unsigned 屬性增加流水號的正數區間。
```

# 字串的設計
字串儲存使用的是`char`或`varchar`的型態，兩者差異是`char 使用固定長度空間來儲存`，如果字串長度不足，還是會自動存滿;
而`varchar 可以允許可變長度的字串`，存入字串後會再使用 1 byte 來標識字串的長度。
<!-- 
char: 固定
varchar: 變動(vary)
 -->
```sql
存入字串	Char(5)	Varchar(5)
'te'	5 bytes	3 bytes
'tes'	5 bytes	4 bytes
'kkbox'	5 bytes	6 bytes

-- 名字相關不確定長度的資訊，可以使用 varchar ，並預估可能需要的長度：
-- title_text varchar(200) NOT NULL COMMENT 'artist role name',
-- 確定長度的字串，例如 script_code 就可以使用 char 來存

-- Notice：VARCHAR 超過 255 的話, 標識字串長度需要用到 2 bytes。
-- Notice：儲存大小會根據編碼決定，utf8 編碼要 * 3，utf8mb4 要 * 4。
```

# COLLATE 設定不要寫在 column
CREATE TABLE 時就應該設定 COLLATE=utf8mb4_unicode_ci，不需要再針對 column 做 COLLATE 的設定。
> 主要原因是當未來 DBA 需要協助調整 COLLATE 設定時，還要再進 column 改一次，會增加調整的成本。
<!-- Notice：除非欄位有特殊編碼需求，不然統一都設定在 Table。 -->


# DEFAULT ''
除了 Laravel ORM Model 會使用到的 updated_at 可以 DEFAULT NULL 之外，其他欄位如果非必填，建議都是以預設空字串或 0 為主。
```sql
language_code char(4) DEFAULT '',
status tinyint(4) DEFAULT 0,
```
> 原因是 InnoDB 會把需要的空間畫進去 data page (16K) 裡面，但是`Null 只是一個 flag`，當 NULL 被寫入值的時候，需要把整筆記錄搬一個新的位置，會造成 Data fragmentation。


# 建立索引（Index）
MySQL 中，索引都是以`B+Tree`的方式儲存，這種結構可以在查詢時針對鍵值快速找出資料
因此，如果 Table 中會被拿來當搜尋依據的特定欄位，都需要加上索引（Index）

### 提升索引（Index）效率的資料型態：

1. 小：能用 varchar(5) 就不要用 varchar(255)
2. 簡單：Int > Char > Varchar > Text
3. 盡量不用 NULL

- 根據`B+Tree`的原理，索引`Index`設計的長度也會影響搜尋的速度及建立的空間大小
> 如果遇到字串需要設定索引（Index），必須思考多少長度的索引（Index）範圍可以含蓋到最多資料。
<!-- e.g. 以 mainartist_raw 的 title_text (其實就是 artist_name) 為例，取前 20 個字就可以涵蓋到大部份的名字。 -->

# DBA 的測試資料
```sql
mysql> SELECT count(distinct(title_text)) AS n_unique, count(distinct(LEFT(title_text, 100))) AS n100,
    -> count(distinct(LEFT(title_text, 20))) AS n20, count(distinct(LEFT(title_text, 15))) AS n15,
    -> count(distinct(LEFT(title_text, 12))) AS n12, count(distinct(LEFT(title_text, 10))) AS n10,
    -> count(distinct(LEFT(title_text, 5))) AS n5 FROM song_meta_name_raw;
+----------+----------+----------+----------+---------+---------+---------+
| n_unique | n100     | n20      | n15      | n12     | n10     | n5      |
+----------+----------+----------+----------+---------+---------+---------+
| 16699739 | 16684589 | 13906368 | 11993071 | 9727458 | 7555408 | 1476038 |
+----------+----------+----------+----------+---------+---------+---------+
1 row in set (27 min 1.61 sec)
```
根據上面測試資料顯示，title_text 的索引（Index）設在 20 是一個在效益上相對平衡的數字，根據範例 title_text 可以修改成：
```sql
KEY btree__title_text (title_text(20))
```


# refer:
- https://blog.johnsonlu.org/mysql-db-schema-%e8%a8%ad%e8%a8%88%e5%8e%9f%e5%89%87/
