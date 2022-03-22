# intro
使用 curl 來分析請求延遲因素

# key plan
curl -w 指令，可天過增加變量來分析網路請求
```bash
-w, --write-out <format>
             Make curl display information on stdout after a completed transfer. The format is a string that may contain plain text mixed with any number of variables. The  format
             can  be  specified  as  a literal "string", or you can have curl read the format from a file with "@filename" and to tell curl to read the format from stdin you write
             "@-".

             The variables present in the output format will be substituted by the value or text that curl thinks fit, as described below. All variables are specified  as  %{vari‐
             able_name} and to output a normal % you just write them as %%. You can output a newline by using \n, a carriage return with \r and a tab space with \t.
```
- 透過事先定義好腳本，可以把curl請求回傳的output打印出來 e.g.
1. time_namelookup: DNS 解析域名費時，把 `google.com` 轉換成 ip 所花費時間
2. time_connect: TCP 連線建立的時間(三次握手的時間)
3. time_appconnect: SSL/SSH 協議做server/client hello (connection/handshanke)
4. time_redirect: 從`開始`到`最後一個請求`的時間
5. time_pretransfer: 從`請求開始`到`響應`的時間
6. time_starttransfer: 從`請求開始`到`第一個byte傳輸`的時間
7. time_total: 這次請求花費的全部時間

# 設定 curl-format.txt 來拿到請求狀況
```log
➜  ~ cat curl-format.txt
    time_namelookup:  %{time_namelookup}\n
       time_connect:  %{time_connect}\n
    time_appconnect:  %{time_appconnect}\n
      time_redirect:  %{time_redirect}\n
   time_pretransfer:  %{time_pretransfer}\n
 time_starttransfer:  %{time_starttransfer}\n
                    ----------\n
         time_total:  %{time_total}\n
```


# 範例
1. http://demo.testfire.net
```log
➜  ~ curlrr http://demo.testfire.net
    time_namelookup:  0.163449
       time_connect:  0.218522
    time_appconnect:  0.000000
   time_pretransfer:  0.218575
      time_redirect:  0.000000
 time_starttransfer:  0.791314
                    ----------
         time_total:  0.791728
```
- DNS 查詢: 0.16 ms
- TCP 連接時間: pretransfer(0.21) - namelookup(0.16) = 0.05 ms
- 服務器處理時間: starttransfer(0.79) - pretransfer(0.21) = 0.58 ms
- 內容傳輸時間: total(0.7917) - starttransfer(0.7914) = 0.0003 ms

2. https://google.com
```log
➜  ~ curlrr https://google.com
    time_namelookup:  0.105916
       time_connect:  0.169319
    time_appconnect:  0.299737
   time_pretransfer:  0.299871
      time_redirect:  0.000000
 time_starttransfer:  0.376767
                    ----------
         time_total:  0.376941
```
- DNS 查詢: 0.10 ms
- TCP 連接時間: pretransfer(0.16) - namelookup(0.10) = 0.06 ms
- SSL 協議處理時間: time_appconnect(0.29) - time_connect(0.16) = 0.13 ms 
- 服務器處理時間: starttransfer(0.37) - pretransfer(0.29) = 0.08 ms
- 內容傳輸時間: total(0.3769) - starttransfer(0.3767) = 0.0002 ms

# refer:
- https://cizixs.com/categories/blog/