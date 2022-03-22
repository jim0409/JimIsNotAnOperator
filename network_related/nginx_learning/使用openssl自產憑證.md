# intro
常見的非對稱加密算法如下：
- RSA：由 RSA 公司發明，是一個支持變長密鑰的公共密鑰算法，需要加密的文件塊的長度也是可變的；
- ECC（Elliptic Curves Cryptography）：橢圓曲線密碼編碼學。

# RSA
### A. 根憑證 (Root CA)
### 建立根憑證用的私鑰，加上 -des3 幫私鑰加上密碼(PassPhrase)，才不會被拿去亂簽

> openssl genrsa -des3 -out RootCA.key 2048

(這邊會需要輸入私鑰使用的密碼)

### 變更資料可寫安全性(600)
> chmod 600 RootCA.key
(為了安全(?), 讓私鑰檔案只有自己可以讀寫)

### 產生根憑證的申請檔
> openssl req -new -key RootCA.key -out RootCA.req
```log
1 => 輸入剛剛建立私鑰時用的密碼 (password)
2 => 國家簡稱，台灣為 TW (TW)
3 => 州/省，依慣例填 Taiwan (TW)
4 => 城市，台北為 Taipei (TAIPEI)
5 => 組織名稱，請填上公司名稱 (BEST_COMPANY)
6 => 組織單位名稱，這個可以不用填 ()
7 => 一般名稱或公用名稱，如果是申請 Server 用的憑證，這邊要填寫網址，但目前是申請根憑證，不用填 ()
8 => E-mail，就填上負責人的 email 吧 (mailer@best.com)
9 => 不用填 ()
10 => 不用填 ()
```

### 簽發十年有效期根憑證!
> openssl x509 -req -days 3650 -sha256 -extensions v3_ca -signkey RootCA.key -in RootCA.req -out RootCA.crt

### 為了安全(?) 把申請檔砍掉!
> rm -f RootCA.req


### B. Server 憑證 (Server Certificate)
### 建立 Server 憑證用的私鑰
> openssl genrsa -out ServerCert.key 2048


### 產生 Server 憑證的申請檔
> openssl req -new -key ServerCert.key -out ServerCert.req

(這邊與產生根憑證申請檔時一樣要輸入資訊，基本上一樣，但 7 請千萬要填上實際使用的網址!，如果是要申請 Wildcard certificate，那網址請用 * 開頭，像是 *.test.com)


### 產生一組簽發憑證用的流水號檔案 (如果這個檔案已存在，可以不用再產生一次)
> echo 1000 > RootCA.srl


### 用根憑證私鑰簽發三年的 Server 憑證
> openssl x509 -req -days 1095 -sha256 -extensions v3_req -CA RootCA.crt -CAkey RootCA.key -CAserial RootCA.srl -CAcreateserial -in ServerCert.req -out ServerCert.crt

### create ECC certificate with `openssl` cli
```sh
# signed root crt
openssl genrsa -des3 -out RootCA.key 2048
chmod 600 RootCA.key
openssl req -new -key RootCA.key -out RootCA.req
openssl x509 -req -days 3650 -sha256 -extensions v3_ca -signkey RootCA.key -in RootCA.req -out RootCA.crt
# for security issue, remove root crt
rm -f RootCA.req

# create server side ssl request file
openssl req -new -key ServerCert.key -out ServerCert.req
# generate an uuid for this file
echo 1000 > RootCA.srl
# signed server crt
openssl x509 -req -days 1095 -sha256 -extensions v3_req -CA RootCA.crt -CAkey RootCA.key -CAserial RootCA.srl -CAcreateserial -in ServerCert.req -out ServerCert.crt
```


# ECC
ECC的主要優勢是它相比RSA加密演算法使用較小的密鑰長度並提供相當等級的安全性

ECC的另一個優勢是可以定義群之間的雙線性映射，基於Weil對或是Tate對；

雙線性映射已經在密碼學中發現了大量的應用，例如基於身份的加密。


### create ECC certificate with `openssl` cli
```sh
openssl ecparam -genkey -name prime256v1 -out key.pem
openssl req -new -sha256 -key key.pem -out csr.csr
openssl req -x509 -sha256 -days 365 -key key.pem -in csr.csr -out certificate.pem
openssl req -in csr.csr -text -noout | grep -i "Signature.*SHA256" && echo "All is well" || echo "This certificate will stop working in 2017! You must update OpenSSL to generate a widely-compatible certificate"
```

### ECC vs RSA
```
PKI Algorithm	RSA	ECC
Key Size Security: 280 @ 1024-bits	Security: 280 @160-bits
Security: 2112 @ 2048-bits	Security: 2112 @224-bits
Security: 2128 @ 3072-bits	Security: 2128 @ 256-bits
Security: 2:92 @ 7680-bits	Security: 2192 @386-bits
Security: 2256 @ 15360-bits	Security: 2256 @512-bits
安全基礎	大數因數分解	EC橢圖曲線上離散對數
優點	演算法容易說明,且同時可用做加解密	運算速度快,簽章長度較小
缺點	運算速度慢,簽章長度較大	理論較難理解,且實作技術較為複雜
```

# extension-refer:
- https://www.bear2little.net/wordpress/?p=401
- https://ithelp.ithome.com.tw/articles/10251031
- https://msol.io/blog/tech/create-a-self-signed-ecc-certificate/
- https://kknews.cc/zh-tw/news/agkaorv.html
- https://kknews.cc/zh-tw/code/q442exo.html

# generate ocsp certificate
- https://github.com/e-gov/mock-ocsp
```sh
git clone https://github.com/jim0409/mock-ocsp.git
cd mock-ocsp; docker-compose up -d
openssl req -x509 -newkey rsa:2048 -keyout conf/key.pem -out conf/cert.pem -days 3650 -nodes -subj '/CN=MOCK OCSP' -config conf/openssl.conf

# 產生ocsp憑證於 /conf 資料夾底下
```

# SSL-Lab
用來檢查憑證狀態的網站
> https://www.ssllabs.com/ssltest/index.html