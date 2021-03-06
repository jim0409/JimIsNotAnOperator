# intro
kafka 部署相關


# mq 的使用時機 與 不適合使用時機
## 不適合使用時機
1. 上游請求關注被調用的下游請求
2. 即時性
3. 孝媳可靠性和重複性互為矛盾，消息不丟不重難以同時保證
4. 系統複雜化
> 不適合的問題不具備則是適合


## 典型 mq 使用場景
### 1. 數據驅動的任務依賴
```
什麼是任務依賴，舉個例子，互聯網公司經常在凌晨進行一些數據統計任務，這些任務之間有一定的依賴關係，比如
1. task3 需要使用 task2 的輸出作為輸入
2. task2 需要使用 task1 的輸出作為輸入
這樣的話， task1, task2, task3 之間就有任務依賴關係，必須 task1 先執行，在執行 task2 再執行 task3
```

- [傳統] 對於這類需求，最常見的實現方式是。使用 cron 人工排執行時間表:
1. task1 t1 execute
2. task2 t2 execute
3. task3 t3 execute

- 缺點:
1. 如果有一個任務執行時間超過了預留 buffer ，將會得到錯誤結果。因為後續任務不清楚前面任務是否成功，此時任務就得要重跑，甚至調整
2. 總任務的執行時間很長，預留 buffer 難以估計，如果前置任務提前完成。後續任務也不會提前開始
3. 如果一個任務被多個任務依賴，這個任務將會成為關鍵路徑，不好調整。調整容易出錯
4. 如果一個任務的執行時間有變動，前後任務的執行時間也會受到調整

- [優化方案] 採用 MQ 解耦
1. task1 執行後發送訊息到 mq 表示開始，並於執行完畢後發送 `task1 done`
2. task2 訂閱 `task1 done` 消息。當收到消息後開始執行，且於執行結束後發送 `task2 done` 消息
3. task3 同理

- 採用 MQ 優點
1. 不需要預留 buffer，上游任務執行完，下游任務總會在第一時間被執行
2. 依賴多個任務，被多個任務依賴都很好處理。只需要訂閱相關消息即可
3. 有任務執行時間變化，下游任務都不需要調整執行時間
> 需要特別說明的是，MQ只用來傳遞上游任務執行完成的消息，並不用於傳遞真正的輸入輸出數據


### 2. 數據驅動的任務依賴
```
上游需要關注執行結果時要用"調用"，上游不關注執行結果時，就可以使用MQ了。舉個例子
58同城的很多下游需要關注"用戶發佈帖子"這事件，比如招聘用戶發佈帖子後，招聘業務要獎勵58豆，
房產用戶發佈帖子後，房產業務要送2個置頂，二手用戶發佈帖子後，二手業務要修改用戶統計數據。
         上游
       /  |  \
  下游1 下游2 下游3
```

- [傳統] 對於這類需求，常見的實現方式是，使用調用關係：
帖子發佈服務執行完成之後，調用下游招聘業務、房產業務、二手業務來完成消息的通知，但事實上，這個通知是否正常正確的執行，帖子發佈服務根本不關注。

- 缺點:
1. 帖子發佈流程的執行時間增加了
2. 下游服務當機，可能導致帖子發佈服務受影響，上下游邏輯+物理依賴嚴重
3. 每當增加一個需要知道"帖子發佈成功"信息的下游，修改代碼的是帖子發佈服務; 這一點是最噁心的，屬於架構設計中典型的依賴倒轉

```
         上游
	  |
	 MQ
       /  |  \
  下游1 下游2 下游3
```

- [優化方案] 採用 MQ 解耦
1. 帖子發佈成功後，向MQ發一個消息
2. 哪個下游關注"帖子發佈成功"的消息，主動去MQ訂閱
	- 採用 MQ 的優點是:
	1. 上游執行時間短
	2. 上下游邏輯+物理解耦，除了與MQ有物理連接，模塊之間都不相互依賴
	3. 新增一個下游消息關注方，上游不需要修改任何代碼



### 3. 上游關注執行結果，但執行時間很長
有時候上游需要關注執行結果，但執行結果時間很長(典型的是調用離線處理，或者跨公網調用)，也經常使用回調官網+MQ來解耦。舉個例子
```
微信支付，跨公網調用微信的接口，執行時間會比較長，但調用方又非常關注執行結果
 上游 <-- 調用/ 調用成功 --> WeChat
  ^                         |
  |                         |
  |                         | 回復結果
訂閱結果                     |
  |                         |
  |                         v
  MQ <---統一回復 --- http-gateway (統一關網)
```
一般採用"回調官網+MQ"方案來解耦：
1. 調用方直接跨公網調用微信接口
2. 微信返回調用成功，此時並不代表返回成功
3. 微信執行完成後，回調統一關網
4. 關網將返回結果通知MQ
5. 請求方收到結果通知

> 這裡需要注意的是，不應該由回調關網來通知結果，如果是這樣的話，每次新增調用方，回調關網都需要修改代碼，仍然會反向依賴，使用`回調官網+MQ`的方案，新增任何對微信支付的調用，都不需要修改代碼


# 總結:
MQ 是一個互聯網架構中常見的解耦利器

- 什麼時候不使用MQ?
1. 上游實時關注執行結果

- 什麼時候使用MQ?
1. 數據驅動的任務依賴
2. 上游不關心多下游執行結果
3. 異步返回執行時間長



# refer:
- https://kafka.apache.org/documentation/#introduction
