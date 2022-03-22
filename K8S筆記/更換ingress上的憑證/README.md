# intro

承接nginx_in_k8s，介紹如何在k8s的ingress內部署憑證

# 事前準備
1. 創建憑證需求的`tls`(privateKey&fullChainCert)
> kubectl create secret tls testsecret-tls --cert=./ServerCert.crt --key=./ServerCert.key

2. 修改ingress.yml
> kubectl edit ingress testsecret-tls

3. 確認ingress.yml是否生效
> 打開瀏覽器，看鎖頭。檢查憑證是否正確~


# refer:
- https://kubernetes.io/docs/concepts/services-networking/ingress/#tls


# 補充1: 如何利用docker-compose驗證憑證是否合法
1. 將憑證放到ssl資料夾下，並且命名 ssl.key & ssl.crt
> cp ${your_path}/${your_cert}/ssl/ssl.crt; cp ${your_path}/${your_key}/ssl/ssl.key

2. 啟動`docker-compose`帶起`nginx server`
> docker-compose up -d

3. 更改`/etc/hosts`後訪問網頁，確認憑證是否生效



# 補充2: 如何用openssl生成SSL以及檢查憑證
### 創建一個CA
1. 建立跟憑證所用的私key
> openssl genrsa -des3 -out RootCA.key 2048

2. 變更資料可寫安全性(600)
> chmod 600 RootCA.key

3. 產生跟憑證的申請書
> openssl req -new -key RootCA.key -out RootCA.req

4. 簽發一張十年有效期限的憑證
> openssl x509 -req -days 3650 -sha256 -extensions v3_ca -signkey RootCA.key -in RootCA.req -out RootCA.crt

### 創建一個 Server Certificate
1. 建立SSL key
> openssl genrsa -out ServerCert.key 2048

2. 創建申請SSL Crt用的Req
> openssl req -new -key ServerCert.key -out ServerCert.req
(這邊與產生根憑證申請檔時一樣要輸入資訊，基本上一樣，但`Common Name (eg, fully qualified host name) `一定要填上實際使用的網址!如果是要申請 Wildcard certificate，那網址請用 * 開頭，像是 *.test.com)

3. 以剛剛製作出來的Req申請Crt
> openssl x509 -req -days 1095 -sha256 -extensions v3_req -CA RootCA.crt -CAkey RootCA.key -CAserial RootCA.srl -CAcreateserial -in ServerCert.req -out ServerCert.crt