# intro
引用`https://ssorc.tw/42/openssl-指令/`網站內的常用`openssl`指令，方便未來查找使用

------

- 自產出 私密金鑰 (private key) 及 憑證 (crt) (365 天, 2048 bits)
> openssl req -new -sha256 -x509 -keyout server.key -out server.crt -days 365 -newkey rsa:2048 -nodes -subj '/C=TW/ST=Taiwan/L=Taipei/CN=ssorc.tw/emailAddress=cross@ssorc.tw'

- 產出 私密金鑰 (private key) 及 憑證要求 (certificate signing request = csr)
> openssl req -new -sha256 -keyout server.key -out server.csr -days 365 -newkey rsa:2048 -nodes -subj '/C=TW/ST=Taiwan/L=Taipei/CN=ssorc.tw/emailAddress=cross@ssorc.tw'

- 用繼有的 private key 產生憑證要求 (csr)
> openssl req -new -key server.key -out server.csr

- 簽署 csr 產生 crt
> openssl x509 -in server.csr -out server.crt -req -text -signkey server.key

- 用 CA 簽發
> openssl ca -policy policy_anything -out server.crt -infiles server.csr

- 檢查 csr 與 private key
> openssl req -in server.csr -noout -verify -key server.key

- 檢查憑證
> openssl verify server.crt

- 查看 csr 內容
> openssl req -in server.csr -noout -text
(參數說明: `-noout`: 不輸出 BEGIN CERTIFICATE REQUEST 字樣)

- 查看 csr 內容並檢查
> openssl req -in server.csr -noout -text -verify

- 查看 crt 內容
> openssl x509 -in server.crt -text
```其他參數
-issuer
-subject
-dates
```

- # Create CA certificate
```sh
openssl genrsa 2048 > ca-key.pem
openssl req -new -sha256 -x509 -nodes -days 3600 -key ca-key.pem -out ca-cert.pem -subj '/C=TW/ST=Taiwan/L=Taipei/CN=ca.ssorc.tw/emailAddress=cross@ssorc.tw'
```

- # Create server certificate, remove passphrase, and sign it
- # server-cert.pem = public key, server-key.pem = private key
```sh
openssl req -sha256 -newkey rsa:2048 -days 3600 -nodes -keyout server-key.pem -out server-req.pem -subj '/C=TW/ST=Taiwan/L=Taipei/CN=server.ssorc.tw/emailAddress=cross@ssorc.tw'
openssl rsa -in server-key.pem -out server-key.pem
openssl x509 -sha256 -req -in server-req.pem -days 3600 -CA ca-cert.pem -CAkey ca-key.pem -set_serial 01 -out server-cert.pem
```

- # Create client certificate, remove passphrase, and sign it
- # client-cert.pem = public key, client-key.pem = private key
```sh
openssl req -sha256 -newkey rsa:2048 -days 3600 -nodes -keyout client-key.pem -out client-req.pem -subj '/C=TW/ST=Taiwan/L=Taipei/CN=client.ssorc.tw/emailAddress=cross@ssorc.tw'
openssl rsa -in client-key.pem -out client-key.pem
openssl x509 -sha256 -req -in client-req.pem -days 3600 -CA ca-cert.pem -CAkey ca-key.pem -set_serial 01 -out client-cert.pem
```

- # verify them
> openssl verify -CAfile ca-cert.pem server-cert.pem client-cert.pem


# 文件加密、解密
- 明文文件（plain text） ：test.txt
- 密文文件（cipher text）：test.msg

```文件加密
echo "this is a test file" > test.txt
openssl smime -encrypt -in test.txt -out test.msg server.crt
```

```文件解密
openssl smime -decrypt -in test.msg -recip server.crt -inkey server.key
```

- 驗證簽章 (Verify Signature)
```
openssl smime -sign -inkey server.key -signer server.crt -in test.txt -out test.msg
openssl smime -verif -in test.msg -signer server.crt -out test2.txt -CAfile server.ca
``` 

- 測試 TLS
```
openssl s_client -CAfile server.ca -connect localhost:993
openssl s_client -connect localhost:25 -starttls smtp
openssl s_time -connect localhost:443
```

- Benchmark
```
openssl speed
openssl speed rsa
```

# refer:
- https://ssorc.tw/42/openssl-指令/
- http://www.madboa.com/geek/openssl/
- http://www.ascc.net/nl/91/1819/02.txt
- http://www.study-area.org/tips/certs/certs.html
- http://jianiau.blogspot.com/2015/07/openssl-key-and-certificate-conversion.html
