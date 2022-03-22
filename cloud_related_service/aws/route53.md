# intro
轉移godaddy帳號到此處

1. 在aws預建一個hostzone(托管區域)，確認是否有拿到對應的dns
```log
domain.name NS ns-xxx.awsdns-xx.org.
            NS ns-xxx.awsdns-xx.co.uk.
            NS ns-xxx.awsdns-xx.net.
            NS ns-xxx.awsdns-xx.conm.

doman.name SOA ns-xxx.awsdns-xx.org.
```
2. 創建一個dummay record

3. 在godaddy那邊變更dns
4. 將dns改指到aws


# refer:
- https://ithelp.ithome.com.tw/articles/10187206