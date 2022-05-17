# intro

透過 mycat 水平擴展 mysql

# 主從複製原理

![image-20200421100525819](https://cdn.jsdelivr.net/gh/baojingyu/ImageHosting@master/uPic/2020042201335420200421100526image-20200421100525819.png)

一共由三個線程完成
1. 主服務將數據的更新紀錄保存到二進制日誌 -- 主服務器進程
2. 從服務將主服務的二進制日誌複製到本地繼日誌 -- 從服務IO進程
3. 從服務讀取中繼日誌，更新本地數據 -- 從服務 SQL 進程


# refer:
- https://github.com/MyCATApache/Mycat-Server
- https://github.com/baojingyu/docker-mycat-mysql
- https://hub.docker.com/_/mysql
