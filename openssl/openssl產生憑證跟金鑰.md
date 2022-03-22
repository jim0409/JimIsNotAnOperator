# intro
摘自 refer 的 `OpenSSL 操作筆記` - 檔案格式轉換

# 格式簡介
Certificate 和 key 可以存成多種格式，常見的有`DER`, `PEM`, `PFX`

### DER
將 certificate 或 key 用 DER ASN.1 編碼的原始格式， certificate 就是依照 X.509 的方式編碼，key則是又能分為`PKCS#1`和`PKCS#8`

## PEM
把 DER 格式的 certificate 或 key 使用 `base64-encoded` 編碼後在頭尾補上資料標明檔案類型

#### Certificate
```
-----BEGIN CERTIFICATE-----
-----END CERTIFICATE-----
```

#### RSA private key(PKCS#1)
```
-----BEGIN RSA PRIVATE KEY-----
-----END RSA PRIVATE KEY-----
```

#### RSA public key(PKCS#1)
```
-----BEGIN RSA PUBLIC KEY-----
-----END RSA PUBLIC KEY-----
```

#### RSA private key (PKCS#8, key 沒加密 )
```
-----BEGIN PRIVATE KEY-----
-----END PRIVATE KEY-----
```

#### RSA public key (PKCS#8)
```
-----BEGIN PUBLIC KEY-----
-----END PUBLIC KEY-----
```

#### RSA private key (PKCS#8, key 有加密 )
```
-----BEGIN ENCRYPTED PRIVATE KEY-----
-----END ENCRYPTED PRIVATE KEY-----
```

- PKCS#7
這個格式用來傳遞簽署過或加密的資料,檔案裡可以包含整個用到的 certificate chain

- PKCS#12 (PFX)
這個格式可以把 private key和整個 certificate chain 存成一個檔案

# 格式轉換
openssl 預設輸入輸出的格式都是`PEM`, 要轉換格式很簡單,搭配 `inform`, `outform` 參數就可以了

- Certificate PEM 轉 DER
> openssl x509 -in cert.pem -outform der -out cert.der

- Certificate DER 轉 PEM
> openssl x509 -inform der -in cert.der -outform der -out cert.pem

```md
`RSA key`的轉換比較多一些, 有 private/public key, PKCS#1/PKCS#8, DER/PEM, 以下只都是用 PEM 格式, 要換 DER 只要加入 inform, outform 參數就可以了
```


# 匯出 public key 指令
- 從 certificate 匯出
openssl x509 -in cert.pem -pubkey -noout > public.pem

- 從 private key 匯出
openssl rsa -in private.pem -pubout -out public.pem



# PKCS#1/PKCS#8 轉換
openssl 有多個指令會產生 private key,genpkey會產生PKCS#8格式genrsa會產生PKCS#1格式,
上面兩個匯出 public key的指令都是PKCS#8格式

Public key 格式轉換,主要是搭配 RSAPublicKey_in,RSAPublicKey_out, 這兩個參數, rsa command的 help沒有顯示這兩個參數,說明文件才有

- Public key: PKCS#8 -> PKCS#1
> openssl rsa -pubin -in public.pem -RSAPublicKey_out -out public_pkcs1.pem

- Public key: PKCS#1 -> PKCS#8
> openssl rsa  -RSAPublicKey_in -in public_pkcs1.pem  -out public_pkcs8.pem


也可以在從 private key 匯出時直接設定輸出格式
> openssl rsa -in private.pem -RSAPublicKey_out -out public_pkcs1.pem


#### Private key 格式轉換,主要是用pkcs8指令,搭配topk8參數作轉換,若不加密就再補上nocrypt
- Private key: PKCS#1 -> PKCS#8
> openssl pkcs8 -in private_pkcs1.pem -topk8 -nocrypt -out private_pkcs8.pem

- Private key: PKCS#8 -> PKCS#1
> openssl pkcs8 -in private_pkcs8.pem -nocrypt -out private_pkcs1.pem
用OpenSSL 0.9.8可以,之後的版本用pkcs8這個指令輸出都是PKCS#8,這指令只是用於0.9.8

> openssl rsa -in private_pkcs8.pem -out private_pkcs1.pem
用0.9.8之後的版本直接用rsa轉檔即可


#### 從 PKCS#7 匯出 certificate
目前最常遇到的是 DOCSIS secure upgrade 用的 Code File, 前面會有一段 DER 編碼的資料, 包含1～2張CVC
> openssl pkcs7 -in code.p7b -print_certs -out certs.pem

從 PKCS#12(PFS) 匯出 certificate 和 private key
> openssl pkcs12 -in key_cert.pfx -nodes -out key_cert.pem

打完指令會要求輸入 pfx file 的密碼,若上述指令沒加入nodes,會再要求輸入匯出的 private key 要用的密碼

#### 把 private key 和 certificate 以及 CA 打包成 PKCS#12
這功能我是用來製作 FreeRADIUS client 端,給 windows 用的懶人包,輸入的 private key (client.key), certificate (client.crt), certificate-chain(cert-chain.crt) 都是用 PEM 格式
> openssl pkcs12 -export -out client.p12 -inkey client.key -in client.crt -certfile cert-chain.crt
打完指令會要求輸入 pfx file 的密碼, 之後在 windows下直接開啟 client.p12 敲完密碼,下一步到底,憑證就會放到對的地方了


# refer:
- http://jianiau.blogspot.com/2015/07/openssl-key-and-certificate-conversion.html
- https://stackoverflow.com/questions/22743415/what-are-the-differences-between-pem-cer-and-der/22743616
