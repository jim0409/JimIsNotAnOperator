# 延時消息
## 動機
很多時候，業務有"在一段時間之後，完成一個工作任務"的需求

例如: 滴滴打車訂單完成後，如果用戶一直不評價，48小時候會將自動評價評為5星

一般來說怎麼實現這類"48小時候自動評價為5星"需求呢?

- [傳統] 常見方案:

啟動一個 cron 定時任務，每小時跑一次，將完成時間超過48小時的訂單取出，置為5星，並把評價狀態置為已評價
假設訂單表的結構為: t_order( oid, finish_time, stars, status, ...) 更具體的，定食任務隔一個小時這麼做一次:

1. select oid from t_order where finish_time > 48 hours and status=0;
2. update t_order set stars=5 and staus=1 where oid in [...];

如果數據量很大，需要分頁查詢，分頁update，這將會是一個 for 循環

- 缺點:
1. 輪詢效率比較低
2. 每次掃庫，已經被執行過紀錄，仍然會被掃瞄(只是不會出現在結果集中)，有重複計算的嫌疑
3. 時效性不夠好，如果每小時輪詢一次，最差的情況下，時間誤差會達到1小時
4. 如果通過增加 cron 輪詢頻率來減少 `3.` 中的時間誤差，`1.`和`2.`中重複計算的問題會進一步凸顯

> 如何利用"延時消息"，對於每個任務只觸發一次，保證效率的同時保證實時性?

## 高校延時間消息設計與實現
- 高校延時消息，包含兩個重要的數據結構
1. 環型隊列，例如可以創建一個包含`3600`個`slot`的環形隊列(本質是個數組)
2. 任務集合，環上每一個`slot`是一個`Set`

同時，啟動一個`timer`，這個`timer`每隔`1s`，在上述環形隊列中移動一格，

有一個`Current Index`指針來標誌正在檢測的`slot`

- Task 結構中有兩個很重要的屬性:
	1. Cycle-Num: 當`Current Index`第幾圈掃描到這個`Slot`時，執行任務
	2. Task-Function: 需要執行的任務指針

- 假設當前`Current Index`指向第一格，當有延時消息到達之後，例如希望`3610`秒之後，觸發一個延時消息任務，只需
	1. 計算這個 Task 應該放在哪一個 slot，現在指向 1, 3610 秒之後，應該是第 11 格，所以這個 Task 應該放在第 11 個 slot 的 Set 中
	2. 計算這個 Task 的 Cycle-Num，由於環形隊列是 3600 格(每秒移動一格，正好一小時)，這個任務是 3610 秒後執行，所以應該繞 3610/3600=1 圈之後在執行，於是 Cycle-Num=1


- Curent Index 不停地移動，每秒移動到一個新的 slot，這個 slot 中對應的 Set，每個 Task 看 Cycle-Num 是不是 0:
	1. 如果不是 0，說明還需要多移動幾圈，將 Cycle-Num 減 1
	2. 如果是 0，說明馬上要執行這個 Task 了，取出 Task-Function 執行(可以用單獨的線程來執行 Task)，並把這個 Task 從 Set 中刪除

- 使用了`延時消息`方案之後，"訂單48小時後關閉評價"的需求，只需將在訂單關閉時，觸發一個48小時之後的延時消息即可:
	1. 不需要輪詢全部訂單，效率高
	2. 一個訂單，任務只執行一次
	3. 時效好，精確到秒(控制 timer 移動頻率可以控制精度)

# 總結:
環形隊列是一個實現"延時消息"的好方法，能解決很多業務問題，並減少很多低效的掃庫cron任務
