# MQ是否能實現消息必達?
1. 任務、延遲消息都放在內存裡，萬一重啟怎麼辦
2. 能否保證訊息必達

<!-- 
1. 高效定時任務的觸發
2. 延遲消息的快速實現
-->


# 架構方向
MQ要想盡量消息必達，架構上有兩個核心設計點
1. 消息落地
2. 消息超時、重傳、確認


# MQ核心架構
![image](./pic/MQ-core.jpg)
MQ的核心架構可以分三塊
1. 發送方 -> 左側粉紅色部分
2. MQ核心集群 -> 中間藍色部分
3. 接收方 -> 右側黃色部份
粉色發送方又由兩部分構成：業務調用方與 `MQ-client-sender`
其中後者像前者提供了兩個核心API:
- SendMsg(bytes[] msg)
- SendCallback()
藍色MQ核心集群又分為四個部分: MQ-server, zk, db, 管理後台 web
黃色接收方也由兩個部分構成: 業務接收方與 `MQ-client-receiver`
其中後者想前者提供了兩個核心API:
- RecvCallback(bytes[] msg)
- SendAck()

MQ是一個系統間解耦的利器，他能夠很好的解除發佈訂閱者之間的耦合，將上下游的消息投遞姐偶成兩個部分
1. sender -> MQ
2. MQ -> receiver

# MQ 的消息可靠性
![image](./pic/MQ-flow.jpg)
- sender
1. MQ-client 將消息發送給 MQ-server (SendMsg)
2. MQ-server 將邀習落地，落地即為發送成功
3. MQ-server 將應答發送給 MQ-client (SendCallback)
- receiver
1. MQ-server 將消息發送給 MQ-client (RecvCallback)
2. MQ-client 回復應達給 MQ-server (SendAck)
3. MQ-server 收到 ack，將之前已經落地的消息刪除，完成消息的可靠投遞

## 如果消息丟了怎麼辦?
MQ消息投遞都可能出現丟失，為了降低丟失概率。MQ需要進行超時和重傳的機制

### sender 的超時與重傳
- sender 的 1, 2, 3 如果丟失或者超時，`MQ-client-sender`內的 timer 會重發消息，直到期望收到3
- 如果重傳 N 次還未收到，則 SendCallback 回調發送失敗
- 整個過程中 MQ-server 可能會收到同一條消息的多次發送

### receiver 的超時與重傳
- receiver 的 4, 5, 6 如果丟失或者超時，`MQ-server`內的 timer 會重發消息，直到收到 5 且成功執行 6
- 這個過程可能會重發很多次消息，一般採用指數退避的策略，先隔 x 秒重發，2x 秒重發，4x 秒重發
- 同理，過程中 MQ-client-receiver 也可能會收到同一條消息的多次重發

> MQ-client 與 MQ-server 如何進行消息去重複，如何進行架構冪等性設計不在此處探討

# 總結
MQ 是系統間的解耦利器，架構設計方向為
1. 消息收到先落地
2. 消息超時，重傳，確認保證消息必達
