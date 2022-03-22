# intro

最近工作上遇到不少需要使用`openssl`來排查證書

以及對應的相關開發工作，這邊提供筆記。紀錄一下相關的domain knowledge

# refer:
- 解釋常見的憑證副檔名關係(有openssl示例)
> https://blog.51cto.com/wushank/1915795

- tls 握手優化詳解
> https://imququ.com/post/optimize-tls-handshake.html#toc-4

- cloudflare介紹 Keyless SSL: The Nitty Gritty Technical Details
> https://blog.cloudflare.com/keyless-ssl-the-nitty-gritty-technical-details/

- 有關SSL的格式簡介(Certificate和Key可以存成多種格式，常見的有DER, PEM, PFX), 有講解比較詳細的 ssl key 產生方法!
```md
- DER: 將certificate 或 key 用`DER ASN.`編碼的原始格式, certificate就是依照`X.509`的方式編碼，key 則是又能分為`PKCS#1`和`PKCS#8`
- PEM: 把DER格式的 certificate 或 key 使用 `base64-encoded`編碼後在頭尾補上資料標明檔案類型
```
> http://jianiau.blogspot.com/2015/07/openssl-key-and-certificate-conversion.html