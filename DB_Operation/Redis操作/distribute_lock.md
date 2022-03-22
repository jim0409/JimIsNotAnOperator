# 使用Redis實現分佈式鎖

鎖是大部分實現分佈式系統所會遇到的問題之一，一但有競爭條件的出現。任何不驚保護的操作都可能帶來衍生的問題。目前有三種實現方式

1. 使用數據庫實現
2. 使用Redis緩存系統實現
3. 使用Zookeeper分布式協調系統實現

其中Redis是一個高可用分佈式，且支持持久化的一項

# SETNX介紹
使用 Redis 實現分佈式鎖的根本原理是 SETNX 指令
> SETNX key value

如果說key不存在，則設置key值為value；如果key已經存在，則不執行任何賦值的操作，並使用不同的返回值做表示


- 另外一種語意表達形式
> SET key value [expiration `EX seconds` ｜`PX millseconds`] [`NX`|`XX`｜

NX 僅在key不存在時執行賦值。透過 SET 語法可以額外增加 有效時間


# SETNX 實現分佈式鎖的方式
### (1) SETNX + Delete
```go
// 宣告一個 lock_a 並且賦予一個隨機值
SETNX lock_a random_value

... do something

// 將 lock_a 刪除
DELETE lock_a
```
此實現方式的問題在於，一但服務獲取鎖後，因為某種因素而死亡，則鎖會一直無法釋放。從而導致死鎖


### (2) SETNX + SETEX
```go
// 宣告一個 lock_a 並且賦予一個隨機值
SETNX locak_a random_value
SETEX lock_a 10 random_value

... do something


// 將 lock_a 刪除
DELETE lock_a
```
設置超時的方式解決了(1)死鎖的問題，但同時引入新的死鎖問題。如果 SETNX 之後 SETEX 之前服務死亡，會陷入死鎖

根本原因為 SETNX/ SETEX 為兩步驟，並非原子操作


### (3) SET NX PX
```go
// 設置一個 10s 過期後的 鎖
SET lock_a random_value NX PX 10000

... do something

// 將 lock_a 刪除
DELETE lock_a
```
通過 SET 的 NX/PX 選項，將設定鎖頭&設定超時合併成一個原子抄作，從而解決(1)&(2)的問題
(PX/ EX 差異在於在單位，)

但是此方案也有一個問題，如果鎖被錯誤地釋放(如超時)。或被錯誤的強佔，或因 redis 問題導致鎖丟失，無法很快感知到


### (4) SET Key RandomValue NX PX
基於方案(3)上，增加對value的檢查，只解除自己家的鎖。類似於CAS，不過式compare-and-delete。

以下以lua代碼做示範
```go
var random_valu = 123
SET lock_a random_value NX PX 10000

... do something

// 判斷是否刪除 Redis 鎖，或者另外再加一個鎖
checkRedisLockAndDo(123)


func checkRedisLockAndDo(value string) {
    if (GET lock_a) = value{
        DELETE lock_a
        return
    }else {
        SET lock_a random NX PX 10000
        
        ... do something

        checkRedisLockAndDo(value)
    }
}
// 原文中的 lua 寫法
// eval "if redis.call('get',KEYS[1]) == ARGV[1] then return redis.call('del',KEYS[1]) else return 0 end" 1 lock_a random_value
```
此方案更嚴謹，給使因為某些異常導致鎖被錯誤的搶佔，也能部分保證鎖的正確釋放，並且在釋放鎖時能檢測到鎖是否被錯誤搶佔、錯誤釋放，從而進行特殊處理


# 注意事項

### 超時時間
從上述描述可以看出，超時時間是一個比較重要的變量:
- 超時時間不能太短，否則在任務執行完成前就自動釋放了鎖，導致資源暴露在鎖保護之外
- 超時時間不能太長，否則會導致意外死鎖後長時間的等待。除非人為介入處理

建議是根據任務內容，合理衡量超時時間，將超時時間設置為任務內容的幾倍即可

如果實在無法確定而又要求比較嚴格，可以採用SETEX/Expire更新超時時間實現

### 重試

如果拿不到鎖，需要根據任務性質、業務形式進行輪詢等待。等待次數需要參考任務執行時間


### 與 Redis 業務 的比較

SETNX 使用更為靈活方便，Multi/Exec 的業務實現形式較為複雜。且部分 Redis 集群方案(如Codis)。不支持 Multi/Exec 業務




# refer:
- https://blog.didiyun.com/index.php/2019/01/14/redis-3/