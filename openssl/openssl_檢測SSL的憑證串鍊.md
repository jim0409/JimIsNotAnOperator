# cli
> openssl s_client -connect shazi.info:443
```log
...
Certificate chain
 0 s:/CN=shazi.info
   i:/C=US/O=Let's Encrypt/CN=Let's Encrypt Authority X3
 1 s:/C=US/O=Let's Encrypt/CN=Let's Encrypt Authority X3
   i:/O=Digital Signature Trust Co./CN=DST Root CA X3
...
```
一般 Certificate chain 會呈現 server(自身憑證) -> media(中繼憑證) -> root CA(根憑證)，這三者是串連在一起的

這張憑證是由兩張證書所組成，0 級是該 site 的證書，s 代表該證書的 subject，i 代表頒發該證書的 CA 資訊

> 正常的 Certificate chain 兩張證書 0 級的頒發 CA 應該要和 1 級的 subject 相同才對的起來，實際上證書可能有多個 Level 要看你的網域等級


例如 www.google.com 就會由三張證書組成 Certificate chain
```log
Certificate chain
0 s:/C=US/ST=California/L=Mountain View/O=Google Inc/CN=www.google.com
i:/C=US/O=Google Inc/CN=Google Internet Authority G2
1 s:/C=US/O=Google Inc/CN=Google Internet Authority G2
i:/C=US/O=GeoTrust Inc./CN=GeoTrust Global CA
2 s:/C=US/O=GeoTrust Inc./CN=GeoTrust Global CA
i:/C=US/O=Equifax/OU=Equifax Secure Certificate Authority
```
當中繼憑證沒有 import 的時候就會出現斷鍊，但是這一般在 internet 使用者無感，因為現在 Browser 已經很聰明可以去找到對應的 Certificate chain
可是如果你是使用 cURL 或是在沒有 internet 環境的網路，就無法透過網路去找到 Certificate chain。

# 如果用 OpenSSL 查看 PEM 憑證：
把 Server 的 Cert 憑證和中繼憑證 (Media) 合起來：
> cat server.crt media.pem > chain.pem

然後就可以用 openssl 把 Certificate chain 列出來。
```log
$ openssl crl2pkcs7 -nocrl -certfile chain.pem | openssl pkcs7 -print_certs -noout

subject=/OU=Domain Control Validated/OU=Gandi Standard SSL/CN=example.com
issuer=/C=FR/ST=Paris/L=Paris/O=Gandi/CN=Gandi Standard SSL CA 2

subject=/C=FR/ST=Paris/L=Paris/O=Gandi/CN=Gandi Standard SSL CA 2
issuer=/C=US/ST=New Jersey/L=Jersey City/O=The USERTRUST Network/CN=USERTrust RSA Certification Authority

subject=/C=US/ST=New Jersey/L=Jersey City/O=The USERTRUST Network/CN=USERTrust RSA Certification Authority
issuer=/C=SE/O=AddTrust AB/OU=AddTrust External TTP Network/CN=AddTrust External CA Root
```


# refer:
- https://shazi.info/openssl-檢測-ssl-的憑證串鍊-certificate-chain/