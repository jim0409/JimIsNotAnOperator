# database
- 顯示目前操作的database
> db

- 檢視資料庫
> show dbs

- 切換資料庫
use ${your_databases}

# collections
- 檢視 collections
> show collections

- 顯示collections資料筆數
> db.${your_collection}.count()

# CRUD
# read
### find
1. db.${your_collection}.find(`query`)
2. db.${your_collection}.findOne(`query`)
(註: query為字串，如果不放任何字串，表示直接回傳資料，不進行篩選。)
```md
假設，db下具有products這個`collection`，且products具有欄位如下
> db.products.findOne()
{
	"_id": "ac7",
	"name": "AC7 Phone",
	"brand": "ACME",
	"type": "phone",
	"price": 320,
	"warranty_years": 1,
	"available": false
}

可以搭配query條件
> db.products.find({_id: "ac7"})

來找到所有對應該collections下`"_id"為"ac7"`的資料
```

### query operators
- $gte (大於等於)
> 找出`price`大於等於200的資料: `db.products.find({ price: {$gte:200}})`

- $gt (大於)
> 找出`price`大於100的資料: `db.products.find({ price: {$gt:100}})`


## ## ##
- $lte (小於等於)
> 找出`price`小於等於300的資料: `db.prodcuts.find({ price: {$lte:300}})`

- $lt (小於)
> 找出`price`小於50的資料: `db.products.find({ price: {$lt:50}})`


## ## ##
- $in (包含)
> 找出`type`中，含有`case字串`的資料: `db.products.find({ type: {$in:["case"]}})`

- $nin (不包含)
> 找出`type`中，不含有`case字串`的資料: `db.products.find({ type: {$nin:["case"]}})`


## ## ##
- $or (或)
> 價格低於`200` or 名稱為`AC3 Phone`的資料: `db.products.find({ $or:[{ price:{$lt:200}}, { name:"AC3 Phone} ]})`

- $not (否) 
> `price`不大於`200`的資料: `db.products.find({ price:{ $not:{$gt:200}}})`

# Projection(投影) ... db.products.find( query, projection )
> 找出`_id`為`ac3`的資料，但只顯示 _id, name, price等三個欄位: `db.products.find({_id: "ac3}, {name:1, price:1})`
```log
{ "_id": "ac3", "name": "AC3 Phone", "price": 200}
```

# Modifier(修飾符) ... db.products.find( query ).sort( FieldName: 1 or -1 )
> 使`price`排序(升序): `db.products.find( {}, {name:1, price:1}).sort({ price: 1})`

> 限制資料回傳筆數`7`筆: `db.products.find().limit(7)`

> 跳過前面`5`筆，在拿取後面`10`筆(拿6~10的資料): `db.products.find().skip(5).limit(10)`


# Not Notation
當回傳資料的Json內，該Json具有某些物件屬性時
e.g.
```
{
	x: { a:1, b:3},
	y: {
		j: 33,
		k: {aaa:3, bbb:"hello"}
	}
}
```
> 查找x為1的資料: db.test.find({"x.a":1})

> 查找 y.k.bbb 為 "hello"的資料: db.test.find({"y.k.bbb":"hello"})


# Cursor 變量
通過宣告變量簡化查詢。
```
> var cursor = db.test.find();
> cursor.hasNext()
true
> cursor.next()
{...}
```

對於宣告的變量做引用，延伸查詢條件

```
# 命名變數
> var cursor = db.test.find()

# 透過下變量條件，反覆篩選。撈出必要的資料
> while( cursor.hasNext() ) printjson( cursor.next() )
```


# refer:
官方解釋
- https://docs.mongodb.com/manual/reference/operator/query-comparison/

中文解釋
- http://dog0416.blogspot.com/2015/08/databasemongodb-1-crud-operation-1.html

當要做mongo中撈取空字串的資料時
- https://stackoverflow.com/questions/9694223/test-empty-string-in-mongodb-and-pymongo
