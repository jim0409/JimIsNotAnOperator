# 前言
kafka屬於consumer做pull的一種mq機制，所以在某些情境下有可能導致kafka記憶體洩漏

```
Sometimes a consumer that is stuck in a crash loop can build up ridiculous amounts of memory.

We spent a long time tracking one down that filled terabytes of information rather quickly,

turns out it submitted the crash log as a record. Double check the consumers and producers 

just in case it is something similar
```

# 記憶體洩漏情境
1. 不固定的使用者
> 在kafka-client做消費的時候會去mq拿取。頻繁的宣告以及製作消費者。解決辦法:固定一個消費者ID，讓所有人透過這個消費者ID來實現。

2. 三方套件的疏失
> 部分的套件有可能會因為在請求的時候夾帶一些不必要的請求標頭，導致生產訊息到消息隊列時，消息隊列製作不必要的拷貝。解決辦法:慎選比較好的插件，有官方的以官方為優先。

# refer:
- https://stackoverflow.com/questions/56528876/kafka-memory-leak#comment99648392_56532462
- https://config9.com/apps/apache-kafka/kafka-broker-memory-leak-triggered-by-many-consumers/
- https://blog.heroku.com/fixing-kafka-memory-leak#jvm-memory-a-recap


# real-case:
- https://github.com/confluentinc/confluent-kafka-dotnet/issues/1022
- https://github.com/confluentinc/confluent-kafka-python/issues/543

# kafka-架構摘要
- https://blog.csdn.net/u013573133/article/details/48142677
- https://blog.csdn.net/zz_1111/article/details/89844661
- https://blog.csdn.net/weixin_34318272/article/details/85885738
- https://blog.csdn.net/u013256816/article/details/54896952