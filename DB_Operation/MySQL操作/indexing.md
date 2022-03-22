# intro
MySQL使用索引來加速搜尋

# 自動目錄
- 把常用索引得值設成"索引鍵"加速搜尋
- 建立組合索引鍵

# 把常用索引得值設成"索引鍵"加速搜尋
只要是常常用到搜索條件的欄位，就應該把它設成索引鍵，有無設定的速度差可能會好幾倍。

例如把`type`欄位設成索引鍵

ALTER TABLE `attribute` ADD INDEX ( `type` )

爾後搜尋條件有限制type時，搜尋速度會大幅提升。

SELECT * FROM `attribute` WHERE `type`='xxxx';

建議：主鍵索引欄位最好是數字型態，千萬不要用其他的型態，以免傷了效能。

要刪除索引用drop：
ALTER TABLE `attribute` DROP INDEX `type`

查看索引，可以用三種方法：
SHOW {INDEX | INDEXES | KEYS} from `attribute`;

也可以直接查看資料庫的索引
SHOW {INDEX | INDEXES | KEYS} from `dbname`;

# 建立組合索引鍵
上面說的範例是單欄位索引，可以建立多欄位的索引，多欄位的索引使用上比較不一樣。

例如把`type`和`tid`欄位設成索引鍵，給他一個名稱叫combo。
ALTER TABLE `attribute` ADD INDEX `combo` ( `type` , `tid` )
接下來搜尋時就要強調用combo這個索引。
SELECT * FROM attribute use INDEX (combo)   WHERE type=1 AND tid=2

如果有多個索引重覆欄位不同，有時可能會要指定不使用某個索引，可用IGNORE
SELECT * FROM attribute ignore INDEX (combo)   WHERE type=1 AND tid=2

# 討論
以上面為例，如果設兩個單鍵索引 type 和 tid，再設一個索組合引combo( `type` , `tid` ) ，單鍵索引和多鍵索引哪個比較快？

當然是多鍵索引快，不然就用單鍵索引代替就好，何必再用組合索引呢？官網有提到[1]：

1. Mysql 自動會使用索引，不需要特別指定使用哪一個索引，除非你指定。例如你同時有 col1 和 col2 的單欄索引：
   SELECT * FROM table WHERE col1=1 AND col2=2
  上面這個查詢會自動使用最左邊的(col1)當索引，除非你指定col2當關鍵索引。
   SELECT * FROM table use INDEX( col2 ) WHERE col1=1 AND col2=2

2. 如果你有多欄索引查詢單欄資料，多欄索引中最左邊的欄位一定要出現在條件中，才會使用索引，例如三欄組合索引(col1, col2, col3)：

以下兩個查詢會用到索引
SELECT * FROM tbl_name WHERE col1=val1;
SELECT * FROM tbl_name WHERE col1=val1 AND col2=val2;

以下兩個查詢不會用到索引，請注意條件中 col2並非索引的第一個欄位
SELECT * FROM tbl_name WHERE col2=val2;
SELECT * FROM tbl_name WHERE col2=val2 AND col3=val3;

3. 如果同時有col1, col2, (col1,col2) 三個索引，在查詢時會使用哪一個當索引[2]？
這是一個好問題，答案是Mysql會採用索引優化演算(Index Merge optimization)[2]大部分時候(col1,col2)會優先使用，端看你的條件而定。



# refer:
- http://n.sfs.tw/content/index/10376