# intro

工作上使用到 php

紀錄 php & php-fpm 安裝紀錄


# installation
1. 下載源代碼編譯 php 5.6.37
	1. 安裝 mcrypt (放在原生包下面)
	2. 安裝 igbinary-2.0.1
	3. 安裝 phpredis-2.2.7
2. 下載 nginx
	1. 配置 nginx.conf 做 fastCGI 轉發


# processing
1. 啟動 php-fpm -R (以 root 身份執行)
2. 啟動 nginx (以 root 身份執行)


# nfs for developer
1. 依據需求可以打開 docker-compose.yml 的 `volumes` 來掛載對應的 php 代碼源
```yml
# 以此專案為例
version: '3.7'
services:
    phpweb:
        image: phpweb
        container_name: phpweb
        build: .
        volumes:
          - ./php:/usr/share/nginx/php

# 使用 docker-compose up -d
# 開啟以後訪問網頁 http://127.0.0.1/info.php 可以看到對應資訊
```