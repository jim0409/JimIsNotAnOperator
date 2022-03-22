# 介紹
透過container創建一個mongodb的可視化UI

# 如何使用
1. 將`template.docker-compose.yml`複製一份為`docker-compose.yml`
2. 修改`docker-compose.yml`裡面的檔案內容
```
MONGO_DB_IP_ADDRESS: 改為要打開的mongodb伺服器的IP位址
MONGO_DB_EXPOSE_PORT: 設定為mongodb的外部開放port號，預設為27017
MONGO_DB_USER: 對應到的mongodb使用者
MONGO_DB_PASSWORD: 對應該mongodb使用者的密碼
```

# refer:
github專案
- https://github.com/mongo-express/mongo-express

docker hub
- https://hub.docker.com/_/mongo